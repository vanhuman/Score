/*
This is a score for the Score program. A score consists of a number of sections, every section consists of a number of events.
Every section runs its course and cannot be stopped.
There is no general clock, as the sections are thought of as being triggered by a player when they decide.
More documentation below the code.
*/

// set default volumes for main output in db
~volMain = 0;

~cueNames = ["Cue 1","Cue 3","Cue 5"];
~cueDescriptions =  ["Bowing", "Clips","Bolt/Nut"];

~score = [
	[ // CUE 1
		(time: [0,00,0], type: \DiskPlayStart, desc: "1 On-shore gas", params: (
			file: "Audio/1 On-shore gas.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [1,22,0], type: \End)
	],
	[ // CUE 3
		(time: [0,00,0], type: \DiskPlayStart, desc: "3 On-shore oil", params: (
			file: "Audio/3 On-shore oil.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 0, srcEvt: 0)),
		(time: [0,00,0], type: \EffectOn, desc: "3. Pitch -12 w/ vib", params: (
			effect: "pitchShiftVibrato", in: [~input1,~input1], lev: 1, att: 0.1, rel: 1, pitch: 0.5, levelCC:1)),
		(time: [0,00,0], type: \EffectOn, desc: "3. Pitch -12 w/ vib (contact)", params: (
			effect: "pitchShiftVibrato", in: [~input2,~input2], lev: 1, att: 0.1, rel: 1, pitch: 0.5, levelCC:2)),
		(time: [1,53,0], type: \End)
	],
	[ // CUE 5
		(time: [0,00,0], type: \DiskPlayStart, desc: "5 Tar sands", params: (
			file: "Audio/5 Tar sands.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 1, srcEvt: 0)),
		(time: [0,00,0], type: \EffectOn, desc: "5. Pitch +12 w/ var vib", params: (
			effect: "pitchShiftVibrato", in: [~input1,~input1], lev: 1, att: 0.1, rel: 1, pitch: 2, levelCC:3)),
		(time: [0,00,0], type: \EffectOn, desc: "5. Pitch +12 w/ var vib (contact)", params: (
			effect: "pitchShiftVibrato", in: [~input2,~input2], lev: 1, att: 0.1, rel: 1, pitch: 2, levelCC:4)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 1, srcEvt: 2)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 1, srcEvt: 3)),
		(time: [0,00,0.1], type: \Control, desc: "variable speed vibrato", params: (
			srcSec: 2, srcEvt: 2, param: "variableVibrato", mode: "point", from: 1, to: 1, time: 0.1, wait: 0.01, repeats: 1)),
		(time: [0,00,0.1], type: \Control, desc: "variable speed vibrato (contact)", params: (
			srcSec: 2, srcEvt: 3, param: "variableVibrato", mode: "point", from: 1, to: 1, time: 0.1, wait: 0.01, repeats: 1)),
		(time: [0,10,0], type: \Control, desc: "decrease pitch/vibrato level", params: (
			srcSec: 2, srcEvt: 2, param: "lev", mode: "line", from: 1, to: 0, time: 150, wait: 0.01, repeats: 1)),
		(time: [0,10,0], type: \Control, desc: "decrease pitch/vibrato level (contact)", params: (
			srcSec: 2, srcEvt: 3, param: "lev", mode: "line", from: 1, to: 0, time: 150, wait: 0.01, repeats: 1)),
		(time: [1,38,0], type: \End)
	],

];


/*
Events can be:
	MIDI: playing a MIDI file
	MControl: controlling pause & resume of a MIDI file as specified by section and event numbers
	DiskPlayStart: playing an audio file to a specified output channel with loop, attack and release parameters
	DiskPlayStop: stopping the playback of an DiskPlayStart event as specified by section and event numbers
				NOTE: Audio playback always has to be stopped, even if it's silent.
	BufRec: start recording in specified buffer with length parameter and input channel
	BufLoad: load an audio file into a buffer with a specified length
	BufPlayStart: start playback of a BufRec buffer as specified by section and event numbers
	BufPlayStop: stop playback of a BufPlayStart event as specified by section and event numbers
	EffectOn: starting an effect
	EffectOff: stopping an effect as specified by section and event numbers
	Control: send controller data to a DiskPlay, BufPlay or EffectOn event as specified by section and event numbers
	FunctionStart, FunctionStop: to start and stop a custom function
	End: dummy event used to indicate the end of a section, just for display purposes

MIDI
The MIDI event has parameter: file (path to the MIDI file)

MControl
	MControl has parameters srcSec and srcEvt (for source section and event numbers, counting from 0) and
		action ('pause' or 'resume')

DiskPlayStart and DiskPlayStop
	DiskPlayStart has parameters: file (path to an audio file), lev (output level), lp (0=no looping, 1=looping), att, rel (attack/release time in sec),
		out (index into ~mainOutBus array), mono (0=stereo, 1=mono playback)
	DiskPlayStop has parameters: srcSec and srcEvt (for DiskPlayStart source section and event numbers, counting from 0)

BufRec, BufLoad, BufPlayStart and BufPlayStop
	BufRec has parameters in (a pair of input channels [n,m] counting from 0), start (offset in buffer in sec),
		len (length of recording in sec) and gain (input gain in db)
	BufLoad has parameters: file (path to an audio file) and len (length of buffer in sec)
	BufPlayStart has parameters: srcSec and srcEvt (for BufRec or BufLoad source section and event numbers, counting from 0),
		lev (output level), start (offset in buffer in sec), att, rel (attack/release time in sec), mode (playback method: straight, phase, forwbackw),
		pitch (for pitch shift), panSpeed, panDepth (for panning)
		Params to control with a Control event: filterfreq (for lowpass filter), revmix, room (for reverb),
	BufPlayStop has parameters: srcSec and srcEvt (for BufPlayStart source section and event numbers, counting from 0)

EffectOn and EffectOff
	EffectOn has parameters: effect (effect name, see below), in (a pair of input channels [n,m] counting from 0), lev (for volume),
		att/rel (for attack/release in sec) / note: effect parameters can be changed with Control events
	EffectOff has parameters: srcSec and srcEvt (for EffectOn source section and event numbers, counting from 0)

FunctionStart and FunctionStop
	parameters: function name, param1 (input chan), param2 (mode: "ampFollow")
	parameters specifically for a mode:
		mode="ampFollow": triggers if the amplitude is in total 'maxTime' secs above the threshold of 'thresh' (scale 0-1))
		mode="freqTracking": triggers if the frequency is in total 'maxTime' secs in the range between 'freqFrom' and 'freqTo'

Control (can act on BufPlay, DiskPlay and EffectOn events)
	Control has parameters: srcSec and srcEvt (for source section and event numbers, counting from 0),
		param (the name of the parameter to control, see below), mode (sine, line, rand, point),
		from, to (start and end values for line, min and max values for sine and rand)
		time (how much time it takes in sec to go: from -> to), wait (step size in sec), repeates (number of repeats)
		Note: in case of mode "point", both param and to can be arrays (of the same size) to set multiple parameters

Effect names and parameters
	Note: every effect has parameters in (a pair of input channels [n,m] counting from 0), lev (for volume), att/rel (for attack/release in sec)
	Note: all effect parameters below are in the range 0-1
	deciMate / parameters: decfactor (decimate factor), samplerate, filterfreq (for lowpass filter)
	stutterDelay / parameter: delaytime
	multiTapReverb / parameters: filterfreq (lowpass filter of freeze), freeze (for mix drone/pulse freeze), mix (for mix Tap/Reverb/Freeze)
		note: a lev value 0.9 is full volume, when mix = 1, a lev value of 1 will trigger the freeze/hold
	ampPitchFollow / parameters: mix (for mix pitch/noise), pitch (for tuning sines)
	freeVerb / parameter: roomsize
	schroederRev / parameter: decay
	ampPerc / parameters: pitch (for pitch low sine), range (for range flutter), ring (for ring time low sine)
	pitchShift / parameter: pitch, dist

*/











