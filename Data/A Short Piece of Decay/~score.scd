
// This is a score for the Score program. A score consists of a number of sections, every section consists of a number of events.
// Every section runs its course and cannot be stopped.
// There is no general clock, as the sections are thought of as being triggered by a player when they decide.
// More documentation below the code.

~cueNames = nil;
~cueDescriptions = ["Mark A","Bar 32","2 bars before E","Mark F","Mark I","3 beats before K","Mark L","1 beat before M","Mark N","1 bar before O","Mark P","2 bars before R","Mark T","Mark V","1 bar before W","1 bar before X"];

~score = [
	[ // CUE 0
	(time: [0,00,0], type: \DiskPlayStart, desc: "Mark A Start", params: (
		file: "Audio/CUE 0.wav", lev: 1, att: 0.01, rel: 0.1, lp: 0)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
		file: "Audio/Instruments CUE 0.wav", lev: 1, att: 0.01, rel: 0.1, lp: 0)),
	(time: [0,58,0], type: \End)
	],
	[ // CUE 1
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 0, srcEvt: 0)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Bar 32", params: (		file: "Audio/CUE 1.wav", lev: 1, att: 0.01, rel: 0.1, lp: 0)),
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 0, srcEvt: 1)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
		file: "Audio/Instruments CUE 1.wav", lev: 1, att: 0.01, rel: 0.1, lp: 0)),
	(time: [0,32,0], type: \End)
	],
	[ // CUE 2
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 1, srcEvt: 1)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "2 bars before E", params: (		file: "Audio/CUE 2.wav", lev: 1, att: 0.01, rel: 2, lp: 0)),
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 1, srcEvt: 3)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
		file: "Audio/Instruments CUE 2.wav", lev: 1, att: 0.01, rel: 0.1, lp: 0)),
	(time: [0,03,7], type: \EffectOn, desc: "Mark E: delay on snare", params: (
		effect: "deciMate", in: [~input1,~input1], lev: 1, att: 0.1, rel: 2, levelCC:1)),
	(time: [0,03,7], type: \Control, desc: "set delay on", params: (
		srcSec: 2, srcEvt: 4, param: "delayOn", mode: "point", from: 1, to: 1, time: 1, wait: 0.01, repeats: 1)),
	(time: [0,39,0], type: \Control, desc: "fade out decimate", params: (
		srcSec: 2, srcEvt: 4, param: "lev", mode: "line", from: 1, to: 0, time: 4, wait: 0.01, repeats: 1)),
	(time: [0,43,0], type: \End)
	],
	[ // CUE 3
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 2, srcEvt: 1)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Mark F", params: (		file: "Audio/CUE 3.wav", lev: 1, att: 0.01, rel: 0.1, lp: 0)),
	(time: [0,00,0], type: \EffectOff, params: (srcSec: 2, srcEvt: 4)),
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 2, srcEvt: 3)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
		file: "Audio/Instruments CUE 3.wav", lev: 1, att: 0.01, rel: 0.1, lp: 0)),
	(time: [0,43,0], type: \End)
	],
	[ // CUE 4
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 3, srcEvt: 1)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Mark I", params: (		file: "Audio/CUE 4.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 3, srcEvt: 4)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
		file: "Audio/Instruments CUE 4.wav", lev: 1, att: 0.01, rel: 0.1, lp: 0)),
	(time: [0,29,0], type: \End)
	],
	[ // CUE 5
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 4, srcEvt: 1)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "3 beats before K", params: (		file: "Audio/CUE 5.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
	(time: [0,01,4], type: \EffectOn, desc: "Mark K: stutterdelay on block", params: (
		effect: "stutterDelay", in: [~input2,~input2], lev: 1, att: 0.1, rel: 2, levelCC:2)),
//	(time: [0,01,4], type: \EffectOn, desc: "decimate on block", params: (
//		effect: "deciMate", in: [~input2,~input2], lev: 1, att: 0.1, rel: 2, levelCC:1)),
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 4, srcEvt: 3)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
		file: "Audio/Instruments CUE 5.wav", lev: 1, att: 0.01, rel: 0.1, lp: 0)),
	(time: [0,30,0], type: \End)
	],
	[ // CUE 6
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 5, srcEvt: 1)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Mark L", params: (		file: "Audio/CUE 6.wav", lev: 1, att: 0.1, rel: 0.01, lp: 0)),
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 5, srcEvt: 4)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
		file: "Audio/Instruments CUE 6.wav", lev: 1, att: 0.01, rel: 0.1, lp: 0)),
	(time: [0,21,0], type: \End)
	],
	[ // CUE 7
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 6, srcEvt: 1)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "1 beat before M", params: (		file: "Audio/CUE 7.wav", lev: 1, att: 0.01, rel: 1, lp: 0)),
	(time: [0,00,0], type: \EffectOff, params: (srcSec: 5, srcEvt: 2)),
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 6, srcEvt: 3)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
		file: "Audio/Instruments CUE 7.wav", lev: 1, att: 0.01, rel: 0.1, lp: 0)),
	(time: [0,19,0], type: \End)
	],
	[ // CUE 8
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 7, srcEvt: 1)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Mark N", params: (		file: "Audio/CUE 8.wav", lev: 1, att: 0.01, rel: 0.1, lp: 0)),
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 7, srcEvt: 4)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
		file: "Audio/Instruments CUE 8.wav", lev: 1, att: 0.01, rel: 0.1, lp: 0)),
	(time: [0,58,0], type: \End)
	],
	[ // CUE 9
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 8, srcEvt: 1)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "1 bar before O", params: (		file: "Audio/CUE 9.wav", lev: 1, att: 0.01, rel: 0.1, lp: 0)),
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 8, srcEvt: 3)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
		file: "Audio/Instruments CUE 9.wav", lev: 1, att: 0.01, rel: 0.1, lp: 0)),
	(time: [0,16,0], type: \End)
	],
	[ // CUE 10
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 9, srcEvt: 1)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Mark P", params: (		file: "Audio/CUE 10.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 9, srcEvt: 3)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
		file: "Audio/Instruments CUE 10.wav", lev: 1, att: 0.01, rel: 0.1, lp: 0)),
	(time: [0,26,0], type: \End)
	],
	[ // CUE 11
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 10, srcEvt: 1)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "2 bars before R", params: (		file: "Audio/CUE 11.wav", lev: 1, att: 0.1, rel: 2, lp: 0)),
	(time: [0,00,0], type: \EffectOn, desc: "Mark R: decimate on block", params: (
		effect: "deciMate", in: [~input2,~input2], lev: 2, att: 0.1, rel: 2, levelCC:3)),
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 10, srcEvt: 3)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
		file: "Audio/Instruments CUE 11.wav", lev: 1, att: 0.01, rel: 0.1, lp: 0)),
	(time: [0,15,0], type: \Control, desc: "deciMate on block increase", params: (
		srcSec: 11, srcEvt: 2, param: "decfactor", mode: "line", from: 0.3, to: 0.5, time: 15, wait: 0.01, repeats: 1)),
	(time: [0,33,0], type: \End)
	],
	[ // CUE 12
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 11, srcEvt: 1)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Mark T", params: (		file: "Audio/CUE 12.wav", lev: 1, att: 0.01, rel: 1, lp: 0)),
	(time: [0,00,0], type: \Control, desc: "deciMate on block increase", params: (
		srcSec: 11, srcEvt: 2, param: "decfactor", mode: "line", from: 0.5, to: 0.6, time: 0.5, wait: 0.01, repeats: 1)),
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 11, srcEvt: 4)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
		file: "Audio/Instruments CUE 12.wav", lev: 1, att: 0.01, rel: 0.1, lp: 0)),
	(time: [0,24,0], type: \Control, desc: "fade out decimate", params: (
		srcSec: 11, srcEvt: 2, param: "lev", mode: "line", from: 2, to: 0, time: 4, wait: 0.1, repeats: 1)),
	(time: [0,28,0], type: \EffectOff, params: (srcSec: 11, srcEvt: 2)),
	(time: [1,11,0], type: \End)
	],
	[ // CUE 13
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 12, srcEvt: 1)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Mark V", params: (		file: "Audio/CUE 13.wav", lev: 1, att: 1, rel: 1, lp: 0)),
	(time: [0,00,0], type: \EffectOn, desc: "Mark V: pitchshift on snare", params: (
		effect: "pitchShift", in: [~input1,~input1], lev: 2, att: 0.1, rel: 0.01, levelCC:4)),
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 12, srcEvt: 4)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
		file: "Audio/Instruments CUE 13.wav", lev: 1, att: 0.01, rel: 0.1, lp: 0)),
	(time: [0,00,0], type: \Control, desc: "set pitch", params: (
		srcSec: 13, srcEvt: 2, param: "pitch", mode: "sine", from: 0.2, to: 0.5, time: 6, wait: 0.01, repeats: 15)),
	(time: [0,21,0], type: \End)
	],
	[ // CUE 14
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 13, srcEvt: 1)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "1 bar before W", params: (		file: "Audio/CUE 14.wav", lev: 1, att: 1, rel: 1, lp: 0)),
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 13, srcEvt: 4)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
		file: "Audio/Instruments CUE 14.wav", lev: 1, att: 0.01, rel: 0.1, lp: 0)),
	(time: [0,39,0], type: \End)
	],
	[ // CUE 15
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 14, srcEvt: 1)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "1 bar before X", params: (		file: "Audio/CUE 15.wav", lev: 1, att: 1, rel: 1, lp: 0)),
	(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 14, srcEvt: 3)),
	(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
		file: "Audio/Instruments CUE 15.wav", lev: 1, att: 0.01, rel: 0.1, lp: 0)),
	(time: [0,15,0], type: \Control, desc: "fade out pitchshift on snare", params: (
		srcSec: 13, srcEvt: 2, param: "lev", mode: "line", from: 2, to: 0, time: 12, wait: 0.1, repeats: 1)),
	(time: [0,57,0], type: \DiskPlayStop, params: (srcSec: 15, srcEvt: 3)),
	(time: [1,00,0], type: \EffectOff, params: (srcSec: 13, srcEvt: 2)),
	(time: [1,09,0], type: \DiskPlayStop, params: (srcSec: 15, srcEvt: 3)),
	(time: [1,12,0], type: \End)
	],
];


// Events can be:
//	MIDI: playing a MIDI file
//	MControl: controlling pause & resume of a MIDI file as specified by section and event numbers
//	DiskPlayStart: playing an audio file to a specified output channel with loop, attack and release parameters
//	DiskPlayStop: stopping the playback of an DiskPlayStart event as specified by section and event numbers
//				NOTE: Audio playback always has to be stopped, even if it's silent.
//	BufRec: start recording in specified buffer with length parameter and input channel
//	BufLoad: load an audio file into a buffer with a specified length
//	BufPlayStart: start playback of a BufRec buffer as specified by section and event numbers
//	BufPlayStop: stop playback of a BufPlayStart event as specified by section and event numbers
//	EffectOn: starting an effect
//	EffectOff: stopping an effect as specified by section and event numbers
//	Control: send controller data to a DiskPlay, BufPlay or EffectOn event as specified by section and event numbers
//	End: dummy event used to indicate the end of a section, just for display purposes

// MIDI
// The MIDI event has parameter: file (path to the MIDI file)

// MControl
// 	MControl has parameters srcSec and srcEvt (for source section and event numbers, counting from 0) and
//		action ('pause' or 'resume')


// DiskPlayStart and DiskPlayStop
//	DiskPlayStart has parameters: file (path to an audio file), lp (0=no looping, 1=looping), att, rel (attack/release time in sec)
//	DiskPlayStop has parameters: srcSec and srcEvt (for DiskPlayStart source section and event numbers, counting from 0)

// BufRec, BufLoad, BufPlayStart and BufPlayStop
// 	BufRec has parameters in (a pair of input channels [n,m] counting from 0), start (offset in buffer in sec) and
//		len (length of recording in sec)
// 	BufLoad has parameters: file (path to an audio file) and len (length of buffer in sec)
// 	BufPlayStart has parameters: srcSec and srcEvt (for BufRec or BufLoad source section and event numbers, counting from 0),
//		start (offset in buffer in sec), att, rel (attack/release time in sec), mode (playback method: straight, phase, forwbackw)
//		Params to control with a Control event: lev, filterfreq (for lowpass filter), revmix, room (for reverb), pitch (for pitch shift)
//	BufPlayStop has parameters: srcSec and srcEvt (for BufPlayStart source section and event numbers, counting from 0)

// EffectOn and EffectOff
//	EffectOn has parameters: effect (effect name, see below), in (a pair of input channels [n,m] counting from 0), lev (for volume),
//		att/rel (for attack/release in sec) / note: effect parameters can be changed with Control events
//	EffectOff has parameters: srcSec and srcEvt (for EffectOn source section and event numbers, counting from 0)

// Control (can act on BufPlay, DiskPlay and EffectOn events)
//	Control has parameters: srcSec and srcEvt (for source section and event numbers, counting from 0),
//		param (the name of the parameter to control, see below), mode (sine, line, rand, point),
//		from, to (start and end values for line, min and max values for sine and rand)
//		time (how much time it takes in sec to go: from -> to), wait (step size in sec), repeates (number of repeats)
//		Note: in case of mode "point", both param and to can be arrays (of the same size) to set multiple parameters

// Effect names and parameters
// 	Note: every effect has parameters in (a pair of input channels [n,m] counting from 0), lev (for volume), att/rel (for attack/release in sec)
//	Note: all effect parameters below are in the range 0-1
//	deciMate / parameters: decfactor (decimate factor), samplerate, filterfreq (for lowpass filter)
//	stutterDelay / parameter: delaytime
//	multiTapReverb / parameters: filterfreq (lowpass filter of freeze), freeze (for mix drone/pulse freeze), mix (for mix Tap/Reverb/Freeze)
//		note: a lev value 0.9 is full volume, when mix = 1, a lev value of 1 will trigger the freeze/hold
//	ampPitchFollow / parameters: mix (for mix pitch/noise), pitch (for tuning sines)
//	freeVerb / parameter: roomsize
//	schroederRev / parameter: decay
//	ampPerc / parameters: pitch (for pitch low sine), range (for range flutter), ring (for ring time low sine)
//	pitchShift / parameter: pitch, dist











