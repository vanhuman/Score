/*
This is a score for the Score program. A score consists of a number of sections, every section consists of a number of events.
Every section runs its course and cannot be stopped.
There is no general clock, as the sections are thought of as being triggered by a player when they decide.
More documentation below the code.
*/
~cueNames = ["Intro","Mark A","Mark B","Mark C","Mark D","Mark E","Mark F","Mark G","Mark H","Mark I","Mark J","Mark K","Mark L","Mark M","Mark N","Mark O"]; // length should be ~score.size
// ~cueNames = nil;
~cueDescriptions = nil; // length should be ~score.size

/*
Cues should start on the first count of a bar, and tempo changes can only be done on cue-change.
Format: [x,y] where x is the number of beats, y the division. The END cue should at least have one beat.
*/
~cueBars = [1,20,36,52,69,86,103,120,137,154,172,189,206,223,241,257,279]; // number of first bar for each cue
~barCounts = [ // counts per bar
	/* dummy to skip bar 0 */ 0,
	/* CUE 0 Intro 76 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],
	/* CUE 1 A 60 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[3,4],[3,4],[4,4],[4,4],[3,4],[4,4],[3,4],[3,4],[5,4],
	/* CUE 2 B 60 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[3,4],[3,4],[4,4],[4,4],[3,4],[4,4],[3,4],[3,4],[5,4],
	/* CUE 3 C 62 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[3,4],[3,4],[4,4],[4,4],[3,4],[4,4],[3,4],[3,4],[5,4],[2,4],
	/* CUE 4 D 67 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[3,4],[3,4],[4,4],[4,4],[3,4],[4,4],[3,4],[3,4],[6,4],[6,4],
	/* CUE 5 E 62 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[3,4],[3,4],[4,4],[4,4],[3,4],[4,4],[3,4],[3,4],[5,4],[2,4],
	/* CUE 6 F 65 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[3,4],[3,4],[4,4],[4,4],[3,4],[4,4],[3,4],[3,4],[5,4],[5,4],
	/* CUE 7 G 63 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[3,4],[3,4],[4,4],[4,4],[3,4],[4,4],[3,4],[3,4],[3,4],[5,4],
	/* CUE 8 H 65 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[3,4],[3,4],[4,4],[4,4],[3,4],[4,4],[3,4],[3,4],[5,4],[5,4],
	/* CUE 9 I 70 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[3,4],[3,4],[4,4],[4,4],[3,4],[4,4],[3,4],[3,4],[4,4],[4,4],[7,4],
	/* CUE 10 J 63 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[3,4],[3,4],[4,4],[4,4],[3,4],[4,4],[3,4],[3,4],[5,4],[3,4],
	/* CUE 11 K 64 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[3,4],[3,4],[4,4],[4,4],[3,4],[4,4],[3,4],[3,4],[3,4],[6,4],
	/* CUE 12 L 63 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[3,4],[3,4],[4,4],[4,4],[3,4],[4,4],[3,4],[3,4],[6,4],[2,4],
	/* CUE 13 M 68 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[3,4],[3,4],[4,4],[4,4],[3,4],[4,4],[3,4],[3,4],[5,4],[4,4],[4,4],
	/* CUE 14 N 61 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[3,4],[3,4],[4,4],[4,4],[3,4],[4,4],[3,4],[3,4],[6,4],
	/* CUE 15 O 85 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[3,4],[3,4],[4,4],[4,4],[3,4],[4,4],[3,4],[3,4],[5,4],[5,4],[4,4],[4,4],[4,4],[4,4],[4,4],
	/* CUE 16 END */ [1,4]
];
~cueTempi = [ // tempo per quarter note per cue
	48, 48, 48, 48, 48, 48, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50
];

/*
To be able to run continuously and keep the beats in sync, the \End event's time should be calculated from the total of the beats for the cue
multiplied by 60 (for quarter notes) or 30 (for 8th notes) and divided by the tempo for the cue, MINUS 1 (because the system counts one extra sec after the \End event).
*/
~score = [
	[ // CUE 0
		(time: [0,00,0], type: \DiskPlayStart, desc: "Intro Start", params: (
			file: "Audio/01 Intro.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		// (time: [0,00,0], type: \functionStart, desc: "initSauer", params: (
		// func: 'initSauer')),
		(time: [1,34,0], type: \End)
	],
	[ // CUE 1
		(time: [0,00,0], type: \DiskPlayStart, desc: "A Start", params: (
			file: "Audio/02 A.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/02 A.wav", lev: 2.0, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 0, srcEvt: 0)),
		(time: [0,00,0], type: \MIDI, params: (file: "MIDI/A.mid")),
		(time: [1,14,0], type: \End)
	],
	[ // CUE 2
		(time: [0,00,0], type: \DiskPlayStart, desc: "B Start", params: (
			file: "Audio/03 B.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/03 B.wav", lev: 2.0, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 1, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 1, srcEvt: 1)),
		(time: [0,00,0], type: \MControl, params: (action: "stop", srcSec: 1, srcEvt: 3)),
		(time: [0,00,0], type: \MIDI, params: (file: "MIDI/B.mid")),
		(time: [1,14,0], type: \End)
	],
	[ // CUE 3
		(time: [0,00,0], type: \DiskPlayStart, desc: "C Start", params: (
			file: "Audio/04 C.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/04 C.wav", lev: 2.0, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 2, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 2, srcEvt: 1)),
		(time: [0,00,0], type: \MControl, params: (action: "stop", srcSec: 2, srcEvt: 5)),
		(time: [0,00,0], type: \MIDI, params: (file: "MIDI/C.mid")),
		(time: [1,16,5], type: \End)
	],
	[ // CUE 4
		(time: [0,00,0], type: \DiskPlayStart, desc: "D Start", params: (
			file: "Audio/05 D.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/05 D.wav", lev: 2.0, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 3, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 3, srcEvt: 1)),
		(time: [0,00,0], type: \MControl, params: (action: "stop", srcSec: 3, srcEvt: 5)),
		(time: [0,00,0], type: \MIDI, params: (file: "MIDI/D.mid")),
		(time: [1,22,7.5], type: \End)
	],
	[ // CUE 5
		(time: [0,00,0], type: \DiskPlayStart, desc: "E Start", params: (
			file: "Audio/06 E.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/06 E.wav", lev: 2.0, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 4, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 4, srcEvt: 1)),
		(time: [0,00,0], type: \MControl, params: (action: "stop", srcSec: 4, srcEvt: 5)),
		(time: [0,00,0], type: \MIDI, params: (file: "MIDI/E.mid")),
		(time: [1,16,5], type: \End)
	],
	[ // CUE 6
		(time: [0,00,0], type: \DiskPlayStart, desc: "F Start", params: (
			file: "Audio/07 F.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/07 F.wav", lev: 2.0, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 5, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 5, srcEvt: 1)),
		(time: [0,00,0], type: \MControl, params: (action: "stop", srcSec: 5, srcEvt: 5)),
		(time: [0,00,0], type: \MIDI, params: (file: "MIDI/F.mid")),
		(time: [1,17,0], type: \End)
	],
	[ // CUE 7
		(time: [0,00,0], type: \DiskPlayStart, desc: "G Start", params: (
			file: "Audio/08 G.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/08 G.wav", lev: 2.0, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 6, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 6, srcEvt: 1)),
		(time: [0,00,0], type: \MControl, params: (action: "stop", srcSec: 6, srcEvt: 5)),
		(time: [0,00,0], type: \MIDI, params: (file: "MIDI/G.mid")),
		(time: [1,14,6], type: \End)
	],
	[ // CUE 8
		(time: [0,00,0], type: \DiskPlayStart, desc: "H Start", params: (
			file: "Audio/09 H.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/09 H.wav", lev: 2.0, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 7, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 7, srcEvt: 1)),
		(time: [0,00,0], type: \MControl, params: (action: "stop", srcSec: 7, srcEvt: 5)),
		(time: [0,00,0], type: \MIDI, params: (file: "MIDI/H.mid")),
		(time: [1,17,0], type: \End)
	],
	[ // CUE 9
		(time: [0,00,0], type: \DiskPlayStart, desc: "I Start", params: (
			file: "Audio/10 I.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/10 I.wav", lev: 2.0, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 8, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 8, srcEvt: 1)),
		(time: [0,00,0], type: \MControl, params: (action: "stop", srcSec: 8, srcEvt: 5)),
		(time: [0,00,0], type: \MIDI, params: (file: "MIDI/I.mid")),
		(time: [1,23,0], type: \End)
	],
	[ // CUE 10
		(time: [0,00,0], type: \DiskPlayStart, desc: "J Start", params: (
			file: "Audio/11 J.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/11 J.wav", lev: 2.0, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 9, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 9, srcEvt: 1)),
		(time: [0,00,0], type: \MControl, params: (action: "stop", srcSec: 9, srcEvt: 5)),
		(time: [0,00,0], type: \MIDI, params: (file: "MIDI/J.mid")),
		(time: [1,14,6], type: \End)
	],
	[ // CUE 11
		(time: [0,00,0], type: \DiskPlayStart, desc: "K Start", params: (
			file: "Audio/12 K.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/12 K.wav", lev: 2.0, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 10, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 10, srcEvt: 1)),
		(time: [0,00,0], type: \MControl, params: (action: "stop", srcSec: 10, srcEvt: 5)),
		(time: [0,00,0], type: \MIDI, params: (file: "MIDI/K.mid")),
		(time: [1,15,8], type: \End)
	],
	[ // CUE 12
		(time: [0,00,0], type: \DiskPlayStart, desc: "L Start", params: (
			file: "Audio/13 L.wav", lev: 1, att: 0.1, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/13 L.wav", lev: 2.0, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 11, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 11, srcEvt: 1)),
		(time: [0,00,0], type: \MControl, params: (action: "stop", srcSec: 11, srcEvt: 5)),
		(time: [0,00,0], type: \MIDI, params: (file: "MIDI/L.mid")),
		(time: [1,14,6], type: \End)
	],
	[ // CUE 13
		(time: [0,00,0], type: \DiskPlayStart, desc: "M Start", params: (
			file: "Audio/14 M.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/14 M.wav", lev: 2.0, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 12, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 12, srcEvt: 1)),
		(time: [0,00,0], type: \MControl, params: (action: "stop", srcSec: 12, srcEvt: 5)),
		(time: [0,00,0], type: \MIDI, params: (file: "MIDI/M.mid")),
		(time: [1,20,6], type: \End)
	],
	[ // CUE 14
		(time: [0,00,0], type: \DiskPlayStart, desc: "N Start", params: (
			file: "Audio/15 N.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/15 N.wav", lev: 2.0, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 13, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 13, srcEvt: 1)),
		(time: [0,00,0], type: \MControl, params: (action: "stop", srcSec: 13, srcEvt: 5)),
		(time: [0,00,0], type: \MIDI, params: (file: "MIDI/N.mid")),
		(time: [1,12,2], type: \End)
	],
	[ // CUE 15
		(time: [0,00,0], type: \DiskPlayStart, desc: "O Start", params: (
			file: "Audio/16 O.wav", lev: 1, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/16 O.wav", lev: 2.0, att: 0.01, rel: 0.1, loop: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 14, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 14, srcEvt: 1)),
		(time: [0,00,0], type: \MControl, params: (action: "stop", srcSec: 14, srcEvt: 5)),
		(time: [0,00,0], type: \MIDI, params: (file: "MIDI/O.mid")),
		(time: [1,41,0], type: \End)
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
End: dummy event used to indicate the end of a section, just for display purposes

MIDI
The MIDI event has parameter: file (path to the MIDI file)

MControl
MControl has parameters srcSec and srcEvt (for source section and event numbers, counting from 0) and
action ('pause' or 'resume' or 'control')

DiskPlayStart and DiskPlayStop
DiskPlayStart has parameters: file (path to an audio file), loop (0=no looping, 1=looping), att, rel (attack/release time in sec)
DiskPlayStop has parameters: srcSec and srcEvt (for DiskPlayStart source section and event numbers, counting from 0)

BufRec, BufLoad, BufPlayStart and BufPlayStop
BufRec has parameters in (a pair of input channels [n,m] counting from 0), start (offset in buffer in sec) and
len (length of recording in sec)
BufLoad has parameters: file (path to an audio file) and len (length of buffer in sec)
BufPlayStart has parameters: srcSec and srcEvt (for BufRec or BufLoad source section and event numbers, counting from 0),
start (offset in buffer in sec), att, rel (attack/release time in sec), mode (playback method: straight, phase, forwbackw)
Params to control with a Control event: lev, filterfreq (for lowpass filter), revmix, room (for reverb), pitch (for pitch shift)
BufPlayStop has parameters: srcSec and srcEvt (for BufPlayStart source section and event numbers, counting from 0)

EffectOn and EffectOff
EffectOn has parameters: effect (effect name, see below), in (a pair of input channels [n,m] counting from 0), lev (for volume),
att/rel (for attack/release in sec) / note: effect parameters can be changed with Control events
EffectOff has parameters: srcSec and srcEvt (for EffectOn source section and event numbers, counting from 0)

FunctionStart and FunctionStop
only one parameter: the function name

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










