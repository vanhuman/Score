/*
This is a score for the Score program. A score consists of a number of sections, every section consists of a number of events.
Every section runs its course and cannot be stopped.
There is no general clock, as the sections are thought of as being triggered by a player when they decide.
More documentation below the code.
*/

// output busses: arrays of output channels
// currently only for DiskPlayStart events - specify index into these arrays for the 'out' argument, always send stereo to [channel, channel+1]
// ~mainOutBus = [0,2];
// ~subOutBus = [26,28]; // size should be same as ~mainOutBus
// ~efxOutBus = [34,36]; // size should not be greater as ~mainOutBus
// ~sampleOutBus = [42,44]; // size should not be greater as ~mainOutBus

// set default volumes for main output in db
~volMain = 0;

~cueNames = ["Cue -1", "Cue 0", "Cue 1","Cue 2","Cue 3","Cue 4","Cue 5","Cue 6","Cue 7"];
~cueDescriptions =  ["Voice intro", "Cleaning", "Bowing", "Flageolettes", "Clips", "Intermezzo", "Bolt/Nut", "Dampen Fuge", "Cleaning"  ];
~delayCueTrigger = 5; // this is the delay in seconds before a cue trigger (amp or pitch follow) function becomes active
~bleedOut = 0;  // index in ~mainOutBus
~bleedMono = 0; // 0=stereo, 1=mono

~score = [
	[ // CUE -1
		(time: [0,00,0], type: \DiskPlayStart, desc: "-1 Voice Intro", params: (
			file: "Audio/-1 Voice Intro.wav", lev: -48.dbamp, att: 0.01, rel: 0.1, lp: 1)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "bleed: -1 Voice Intro", params: (
			file: "Audio/bleed/-1 Voice Intro.wav", lev: -48.dbamp, att: 0.01, rel: 0.1, lp: 1, out: ~bleedOut, mono: ~bleedMono)),
		(time: [0,00,0], type: \Control, desc: "Level Voice Intro", params: (
			srcSec: 0, srcEvt: 0, param: "lev", mode: "line", from: -48.dbamp, to: -15.dbamp, time: 45, wait: 0.01, repeats: 1)),
		(time: [0,00,0], type: \Control, desc: "bleed: Level Voice Intro", params: (
			srcSec: 0, srcEvt: 1, param: "lev", mode: "line", from: -48.dbamp, to: -15.dbamp, time: 45, wait: 0.01, repeats: 1)),
		(time: [5,00,0], type: \End)
	],
	[ // CUE 0
		(time: [0,00,0], type: \DiskPlayStart, desc: "0 Introduction", params: (
			file: "Audio/0 Introduction-ToWhomThisPower.wav", lev: 1, att: 0.1, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "bleed: 0 Introduction", params: (
			file: "Audio/bleed/0 Introduction-ToWhomThisPower.wav", lev: 1, att: 0.1, rel: 0.1, loop: 0, out: ~bleedOut, mono: ~bleedMono)),
		(time: [0,01,0], type: \EffectOn, desc: "0.Tremolo/Keypex", params: (
		effect: "tremolo", in: [~input1,~input1], lev: 1, att: 1, rel: 1, levelCC:1)),
		(time: [0,01,0], type: \EffectOn, desc: "0. Tremolo/Keypex (contact)", params: (
		effect: "tremolo", in: [~input2,~input2], lev: 1, att: 1, rel: 1, levelCC:2)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 0, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 0, srcEvt: 1)),
		(time: [1,31,0], type: \End) // kortere versie meteen harp
	],
	[ // CUE 1
		(time: [0,00,0], type: \DiskPlayStart, desc: "1 On-shore gas", params: (
			file: "Audio/1 On-shore gas.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "bleed: 1 On-shore gas", params: (
			file: "Audio/bleed/1 On-shore gas.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0, out: ~bleedOut, mono: ~bleedMono)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 1, srcEvt: 2)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 1, srcEvt: 3)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 1, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 1, srcEvt: 1)),
		(time: [3,01,0], type: \End)
	],
	[ // CUE 2
		(time: [0,00,0], type: \DiskPlayStart, desc: "2 Off-shore gas", params: (
			file: "Audio/2 Off-shore gas-ToWhomThisPower.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "bleed: 2 Off-shore gas", params: (
			file: "Audio/bleed/2 Off-shore gas-ToWhomThisPower.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0, out: ~bleedOut, mono: ~bleedMono)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 2, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 2, srcEvt: 1)),
		(time: [0,01,0], type: \EffectOn, desc: "2. MultiTapReverb", params: (
			effect: "multiTapReverb", in: [~input1,~input1], lev: 1, att: 0.1, rel: 1, levelCC: 3 )),
		(time: [0,01,0], type: \EffectOn, desc: "2. MultiTapReverb (contact)", params: (
			effect: "multiTapReverb", in: [~input2,~input2], lev: 1, att: 0.1, rel: 1, levelCC: 4 )),
		(time: [2,11,0], type: \End)
	],
	[ // CUE 3
		(time: [0,00,0], type: \DiskPlayStart, desc: "3 On-shore oil", params: (
			file: "Audio/3 On-shore oil.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "bleed: 3 On-shore oil", params: (
			file: "Audio/bleed/3 On-shore oil.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0, out: ~bleedOut, mono: ~bleedMono)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 3, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 3, srcEvt: 1)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 3, srcEvt: 4)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 3, srcEvt: 5)),
		(time: [0,01,0], type: \EffectOn, desc: "3. Pitch -12 w/ vib", params: (
			effect: "pitchShiftVibrato", in: [~input1,~input1], lev: 1, att: 0.1, rel: 1, pitch: 0.5, levelCC:5)),
		(time: [0,01,0], type: \EffectOn, desc: "3. Pitch -12 w/ vib (contact)", params: (
			effect: "pitchShiftVibrato", in: [~input2,~input2], lev: 1, att: 0.1, rel: 1, pitch: 0.5, levelCC:6)),
		(time: [2,32,0], type: \End)
	],
	[ // CUE 4
		(time: [0,00,0], type: \DiskPlayStart, desc: "4 Intermezzo", params: (
			file: "Audio/4 Intermezzo.wav", lev: 3.dbamp, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "bleed: 4 Intermezzo", params: (
			file: "Audio/bleed/4 Intermezzo.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0, out: ~bleedOut, mono: ~bleedMono)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 4, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 4, srcEvt: 1)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 4, srcEvt: 6)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 4, srcEvt: 7)),
		(time: [1,10,0], type: \End)
	],
	[ // CUE 5
		(time: [0,00,0], type: \DiskPlayStart, desc: "5 Tar sands", params: (
			file: "Audio/5 Tar sands-ToWhomThisPower.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "bleed: 5 Tar sands", params: (
			file: "Audio/bleed/5 Tar sands-ToWhomThisPower.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0, out: ~bleedOut, mono: ~bleedMono)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 5, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 5, srcEvt: 1)),
		(time: [0,00,0], type: \EffectOn, desc: "5. Pitch +12 w/ var vib", params: (
			effect: "pitchShiftVibrato", in: [~input1,~input1], lev: 1, att: 0.1, rel: 1, pitch: 2, levelCC:7)),
		(time: [0,00,0], type: \EffectOn, desc: "5. Pitch +12 w/ var vib (contact)", params: (
			effect: "pitchShiftVibrato", in: [~input2,~input2], lev: 1, att: 0.1, rel: 1, pitch: 2, levelCC:8)),
		(time: [0,00,0.1], type: \Control, desc: "variable speed vibrato", params: (
			srcSec: 6, srcEvt: 4, param: "variableVibrato", mode: "point", from: 1, to: 1, time: 0.1, wait: 0.01, repeats: 1)),
		(time: [0,00,0.1], type: \Control, desc: "variable speed vibrato (contact)", params: (
			srcSec: 6, srcEvt: 5, param: "variableVibrato", mode: "point", from: 1, to: 1, time: 0.1, wait: 0.01, repeats: 1)),
		(time: [0,10,0], type: \Control, desc: "decrease pitch/vibrato level", params: (
			srcSec: 6, srcEvt: 4, param: "lev", mode: "line", from: 1, to: 0, time: 150, wait: 0.01, repeats: 1)),
		(time: [0,10,0], type: \Control, desc: "decrease pitch/vibrato level (contact)", params: (
			srcSec: 6, srcEvt: 5, param: "lev", mode: "line", from: 1, to: 0, time: 150, wait: 0.01, repeats: 1)),
		(time: [2,30,0], type: \End)
	],
	[ // CUE 6
		(time: [0,00,0], type: \DiskPlayStart, desc: "6 Mining", params: (
			file: "Audio/6 Mining-ToWhomThisPower.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "bleed: 6 Mining", params: (
			file: "Audio/bleed/6 Mining-ToWhomThisPower.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0, out: ~bleedOut, mono: ~bleedMono)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 6, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 6, srcEvt: 1)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 6, srcEvt: 4)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 6, srcEvt: 5)),
		(time: [0,01,0], type: \EffectOn, desc: "6. SchroederReverb", params: (
		effect: "schroederRev", in: [~input1,~input1], lev: 1, att: 0.1, rel: 1, levelCC:9)),
		(time: [0,01,0], type: \EffectOn, desc: "6. SchroederReverb (contact)", params: (
			effect: "schroederRev", in: [~input2,~input2], lev: 1, att: 0.1, rel: 1, levelCC:10)),
		(time: [2,34,0], type: \End)
	],
	[ // CUE 7
		(time: [0,00,0], type: \DiskPlayStart, desc: "7 Coda", params: (
			file: "Audio/7 Coda.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "bleed: 7 Coda", params: (
			file: "Audio/bleed/7 Coda.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0, out: ~bleedOut, mono: ~bleedMono)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 7, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 7, srcEvt: 1)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 7, srcEvt: 6)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 7, srcEvt: 7)),
		(time: [0,01,0], type: \EffectOn, desc: "7. Pitch -12 w/ vib", params: (
			effect: "pitchShiftVibrato", in: [~input1,~input1], lev: 1, att: 0.1, rel: 1, pitch: 0.5, levelCC:11)),
		(time: [0,01,0], type: \EffectOn, desc: "7. Pitch -12 w/ vib (contact)", params: (
			effect: "pitchShiftVibrato", in: [~input2,~input2], lev: 1, att: 0.1, rel: 1, pitch: 0.5, levelCC:12)),
		(time: [2,25,0], type: \End)
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











