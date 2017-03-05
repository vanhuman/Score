/*
This is a score for the Score program. A score consists of a number of sections, every section consists of a number of events.
Every section runs its course and cannot be stopped.
There is no general clock, as the sections are thought of as being triggered by a player when they decide.
More documentation below the code.
*/

~cueNames = ["Mark A","Mark B","Mark C","Mark D","Mark E","Mark F","Mark G","Mark H","Mark I","Mark J","Mark K","Mark L","Mark M","Mark N","Mark O","Mark P","Mark Q"]; // length should be ~score.size
// ~cueNames = nil;
~cueDescriptions =  ["Mark A","Mark B","Mark C","Mark D","Mark E","Mark F","Mark G","Mark H","Mark I","Mark J","Mark K","Mark L","Mark M","Mark N","Mark O","Mark P","Mark Q"]; // length should be ~score.size

/*
Cues should start on the first count of a bar, and tempo changes can only be done on cue-change.
Format: [x,y] where x is the number of beats, y the division. The END cue should at least have one beat.
*/
~cueBars = [1,19,51,70,90,102,126,142,166,190,214,222,250,290,329,339,358,367]; // number of first bar for each cue (incl the END)
~barCounts = [ // counts per bar
	/* dummy to skip bar 0 */ 0,
	/* CUE 0 A [72,4] 35 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],
	/* CUE 1 B [128,4] 63 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],
	/* CUE 2 C [76,4] 37 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],
	/* CUE 3 D [80,4] 39 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],
	/* CUE 4 E [48,4] 23 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],
	/* CUE 5 F [96,4] 47 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],
	/* CUE 6 G [106,8] 25,5 */ [7,8],[3,4],[7,8],[3,4],[7,8],[3,4],[7,8],[7,8],[7,8],[3,4],[7,8],[3,4],[7,8],[3,4],[7,8],[7,8],
	/* CUE 7 H [159,8] 38,75 */ [7,8],[3,4],[7,8],[3,4],[7,8],[3,4],[7,8],[7,8],[7,8],[3,4],[7,8],[3,4],[7,8],[3,4],[7,8],[7,8],[7,8],[3,4],[7,8],[3,4],[7,8],[3,4],[7,8],[7,8],
	/* CUE 8 I [159,8] 38,75 */ [7,8],[3,4],[7,8],[3,4],[7,8],[3,4],[7,8],[7,8],[7,8],[3,4],[7,8],[3,4],[7,8],[3,4],[7,8],[7,8],[7,8],[3,4],[7,8],[3,4],[7,8],[3,4],[7,8],[7,8],
	/* CUE 9 J [144,8] 35 */ [3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],
	/* CUE 10 K [48,8] 11 */ [3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],
	/* CUE 11 L [206,8] 50,5 */ [4,4],[4,4],[4,4],[4,4],[7,8],[7,8],[7,8],[7,8],[4,4],[4,4],[4,4],[4,4],[7,8],[7,8],[7,8],[7,8],[4,4],[4,4],[4,4],[4,4],[7,8],[7,8],[7,8],[7,8],[6,8],[7,8],[6,8],[7,8],
	/* CUE 12 M [204,8] 50 */ [5,8],[3,4],[5,8],[3,4],[5,8],[3,4],[5,8],[3,4],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],[5,8],
	/* CUE 13 N [126,4] 62 */ [3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[3,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[3,4],
	/* CUE 14 O [42,4] 20 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[6,4],
	/* CUE 15 P [76,4] 37 */ [4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],[4,4],
	/* CUE 16 Q [73,8] 17,25 */ [6,4],[3,4],[6,4],[3,4],[3,4],[7,8],[4,4],[4,4],[4,4],
	/* CUE 17 END */ [1,4]
];

~cueTempi = 120; // if only one tempo, no need to duplicate
// ~cueTempi = [ // tempo per quarter note per cue
// 	120,120,120,120,120,120,120,120,120,120,120,120,120,120,120,120,120
// ];

/*
To be able to run continuously and keep the beats in sync, the \End event's time should be calculated from the total of the beats for the cue multiplied by 60 (for quarter notes) or 30 (for 8th notes) and divided by the tempo for the cue, MINUS 1 (because the system counts one extra sec after the \End event).
*/
~score = [
	[ // CUE 0
		(time: [0,00,0], type: \DiskPlayStart, desc: "A Start", params: (
			file: "Audio/01 A.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,35,0], type: \End)
	],
	[ // CUE 1
		(time: [0,00,0], type: \DiskPlayStart, desc: "B Start", params: (
			file: "Audio/02 B.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/02 B.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 0, srcEvt: 0)),
		(time: [0,00,0], type: \EffectOn, desc: "Mark B: ring on Bcl", params: (
			effect: "ring", in: [~input1,~input1], lev: 1, att: 3, rel: 0.1, gain: 3, levelCC:1)),
		(time: [0,00,0], type: \EffectOn, desc: "Mark B: decimate on Bcl", params: (
		effect: "deciMate", in: [~input1,~input1], lev: 1, att: 5, rel: 0.1, gain: 3, levelCC:2)),
		(time: [0,00,0], type: \EffectOn, desc: "Mark B: pitchshift on Cbcl", params: (
		effect: "pitchShift", in: [~input2,~input2], lev: 1, att: 3, rel: 0.1, gain: 3, levelCC:3)),
		(time: [0,00,0], type: \EffectOn, desc: "Mark B: decimate on Cbcl", params: (
		effect: "deciMate", in: [~input2,~input2], lev: 1, att: 5, rel: 0.1, gain: 3, levelCC:4)),
		(time: [0,00,0], type: \Control, desc: "decfactor on Bcl", params: (
			srcSec: 1, srcEvt: 4, param: "decfactor", mode: "line", from: 0.3, to: 0.9, time: 1, wait: 0.01, repeats: 1)),
		(time: [0,00,0], type: \Control, desc: "gateVal on Bcl", params: (
			srcSec: 1, srcEvt: 4, param: "gateVal", mode: "point", from: 0.001, to: 0.001, time: 1, wait: 0.01, repeats: 1)),
		(time: [0,00,0], type: \Control, desc: "decfactor on Cbcl", params: (
			srcSec: 1, srcEvt: 6, param: "decfactor", mode: "point", from: 0.2, to: 0.2, time: 1, wait: 0.01, repeats: 1)),
		(time: [0,00,0], type: \Control, desc: "gateVal on Cbcl", params: (
			srcSec: 1, srcEvt: 6, param: "gateVal", mode: "point", from: 0.01, to: 0.01, time: 1, wait: 0.01, repeats: 1)),
		(time: [1,03,0], type: \End)
	],
	[ // CUE 2
		(time: [0,00,0], type: \DiskPlayStart, desc: "C Start", params: (
			file: "Audio/03 C.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/03 C.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 1, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 1, srcEvt: 1)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 1, srcEvt: 3)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 1, srcEvt: 4)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 1, srcEvt: 5)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 1, srcEvt: 6)),
		(time: [0,37,0], type: \End)
	],
	[ // CUE 3
		(time: [0,00,0], type: \DiskPlayStart, desc: "D Start", params: (
			file: "Audio/04 D.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/04 D.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 2, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 2, srcEvt: 1)),
		(time: [0,39,0], type: \End)
	],
	[ // CUE 4
		(time: [0,00,0], type: \DiskPlayStart, desc: "E Start", params: (
			file: "Audio/05 E.wav", lev: 1, att: 0.1, rel: 0.5, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/05 E.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 3, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 3, srcEvt: 1)),
		(time: [0,23,0], type: \End)
	],
	[ // CUE 5
		(time: [0,00,0], type: \DiskPlayStart, desc: "F Start", params: (
			file: "Audio/06 F.wav", lev: 1, att: 0.5, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/06 F.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 4, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 4, srcEvt: 1)),
		(time: [0,47,0], type: \End)
	],
	[ // CUE 6
		(time: [0,00,0], type: \DiskPlayStart, desc: "G Start", params: (
			file: "Audio/07 G.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/07 G.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 5, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 5, srcEvt: 1)),
		(time: [0,25,5], type: \End)
	],
	[ // CUE 7
		(time: [0,00,0], type: \DiskPlayStart, desc: "H Start", params: (
			file: "Audio/08 H.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/08 H.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 6, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 6, srcEvt: 1)),
		(time: [0,38,7.5], type: \End)
	],
	[ // CUE 8
		(time: [0,00,0], type: \DiskPlayStart, desc: "I Start", params: (
			file: "Audio/09 I.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/09 I.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 7, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 7, srcEvt: 1)),
		(time: [0,38,7.5], type: \End)
	],
	[ // CUE 9
		(time: [0,00,0], type: \DiskPlayStart, desc: "J Start", params: (
			file: "Audio/10 J.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/10 J.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 8, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 8, srcEvt: 1)),
		(time: [0,00,0], type: \EffectOn, desc: "Mark J: decimate on Bcl", params: (
			effect: "deciMate", in: [~input1,~input1], lev: 1, att: 0.1, rel: 0.1, gain: 3, levelCC:5)),
		(time: [0,00,0], type: \EffectOn, desc: "Mark J: ampPitchFoll on Bcl", params: (
			effect: "ampPitchFollow", in: [~input1,~input1], lev: 0.7, att: 0.1, rel: 0.1, gain: 3, levelCC:6)),
		(time: [0,00,0], type: \EffectOn, desc: "Mark J: decimate delay on Cbcl", params: (
			effect: "deciMate", in: [~input2,~input2], lev: 1, att: 0.1, rel: 2, gain: 9, levelCC:7)),
		(time: [0,00,0], type: \Control, desc: "decfactor on Bcl", params: (
			srcSec: 9, srcEvt: 4, param: "decfactor", mode: "point", from: 0.1, to: 0.1, time: 1, wait: 0.01, repeats: 1)),
		(time: [0,00,0], type: \Control, desc: "gateVal on Bcl", params: (
			srcSec: 9, srcEvt: 4, param: "gateVal", mode: "point", from: 0.001, to: 0.001, time: 1, wait: 0.01, repeats: 1)),
		(time: [0,00,0], type: \Control, desc: "gateVal on Cbcl", params: (
			srcSec: 9, srcEvt: 6, param: "gateVal", mode: "point", from: 0.001, to: 0.001, time: 1, wait: 0.01, repeats: 1)),
		(time: [0,00,0], type: \Control, desc: "set delay on Cbcl", params: (
			srcSec: 9, srcEvt: 6, param: "delayOn", mode: "point", from: 1, to: 1, time: 1, wait: 0.01, repeats: 1)),
		(time: [0,00,0], type: \Control, desc: "mix ampPitchFol on Cbcl", params: (
			srcSec: 9, srcEvt: 5, param: "mix", mode: "point", from: 0.5, to: 0.5, time: 1, wait: 0.01, repeats: 1)),
		(time: [0,01,0], type: \functionStart, desc: "generate text", params: (
			func: 'deliverLines')),
		(time: [0,31,0], type: \functionStop, desc: "generate text", params: (
			func: 'deliverLines', levelCC: 20)),
		(time: [0,35,0], type: \End)
	],
	[ // CUE 10
		(time: [0,00,0], type: \DiskPlayStart, desc: "K Start", params: (
			file: "Audio/11 K.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/11 K.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 9, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 9, srcEvt: 1)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 9, srcEvt: 4)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 9, srcEvt: 5)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 9, srcEvt: 6)),
		(time: [0,00,0], type: \functionStop, desc: "generate text", params: (
			func: 'deliverLines')),
		(time: [0,11,0], type: \End)
	],
	[ // CUE 11
		(time: [0,00,0], type: \DiskPlayStart, desc: "L Start", params: (
			file: "Audio/12 L.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/12 L.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 10, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 10, srcEvt: 1)),
		(time: [0,28,0], type: \EffectOn, desc: "Mark L: compression on Cbcl", params: (
			effect: "compression", in: [~input2,~input2], lev: 0, att: 0.1, rel: 0.1, gain: 3, levelCC:8)),
		(time: [0,29,0], type: \Control, desc: "Level compression on Cbcl", params: (
			srcSec: 11, srcEvt: 4, param: "lev", mode: "line", from: 0, to: 1, time: 5, wait: 0.01, repeats: 1)),
		(time: [0,50,5], type: \End)
	],
	[ // CUE 12
		(time: [0,00,0], type: \DiskPlayStart, desc: "M Start", params: (
			file: "Audio/13 M.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/13 M.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 11, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 11, srcEvt: 1)),
		(time: [0,15,0], type: \EffectOn, desc: "Mark M: compression on Bcl", params: (
			effect: "compression", in: [~input1,~input1], lev: 0, att: 0.1, rel: 0.1, gain: 3, levelCC:9)),
		(time: [0,16,0], type: \Control, desc: "Level compression on Bcl", params: (
			srcSec: 12, srcEvt: 4, param: "lev", mode: "line", from: 0, to: 1, time: 5, wait: 0.01, repeats: 1)),
		(time: [0,41,0], type: \Control, desc: "Level compression on Bcl", params: (
			srcSec: 11, srcEvt: 4, param: "lev", mode: "line", from: 1, to: 0, time: 5, wait: 0.01, repeats: 1)),
		(time: [0,41,0], type: \Control, desc: "Level compression on Cbcl", params: (
			srcSec: 12, srcEvt: 4, param: "lev", mode: "line", from: 1, to: 0, time: 5, wait: 0.01, repeats: 1)),
		(time: [0,50,0], type: \End)
	],
	[ // CUE 13
		(time: [0,00,0], type: \DiskPlayStart, desc: "N Start", params: (
			file: "Audio/14 N.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/14 N.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \EffectOn, desc: "Mark N: ring on Bcl", params: (
			effect: "ring", in: [~input1,~input1], lev: 0, att: 0.1, rel: 0.1, gain: 3, levelCC:10)),
		(time: [0,00,0], type: \Control, desc: "note on Bcl", params: (
			srcSec: 13, srcEvt: 2, param: "note", mode: "line", from: 110, to: 100, time: 0.1, wait: 0.01, repeats: 1)),
		(time: [0,00,0], type: \Control, desc: "mixNoise on Bcl", params: (
			srcSec: 13, srcEvt: 2, param: "mixNoise", mode: "point", from: 0, to: 0, time: 1, wait: 0.01, repeats: 1)),
		(time: [0,00,0], type: \Control, desc: "Level ring on Bcl", params: (
			srcSec: 13, srcEvt: 2, param: "lev", mode: "line", from: 0, to: 0.5, time: 1, wait: 0.01, repeats: 1)),
		(time: [0,00,0], type: \EffectOn, desc: "Mark N: pitchshift on Cbcl", params: (
			effect: "pitchShift", in: [~input2,~input2], lev: 1, att: 0.1, rel: 0.1, gain: -12, levelCC:11)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 12, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 12, srcEvt: 1)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 11, srcEvt: 4)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 12, srcEvt: 4)),
		(time: [0,12,0], type: \Control, desc: "level on Bcl", params: (
			srcSec: 13, srcEvt: 2, param: "lev", mode: "line", from: 0.5, to: 0, time: 30, wait: 0.01, repeats: 1)),
		(time: [1,02,0], type: \End)
	],
	[ // CUE 14
		(time: [0,00,0], type: \DiskPlayStart, desc: "O Start", params: (
			file: "Audio/15 O.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/15 O.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 13, srcEvt: 2)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 13, srcEvt: 6)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 13, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 13, srcEvt: 1)),
		(time: [0,20,0], type: \End)
	],
	[ // CUE 15
		(time: [0,00,0], type: \DiskPlayStart, desc: "P Start", params: (
			file: "Audio/16 P.wav", lev: 1, att: 0.1, rel: 0.5, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/16 P.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \EffectOn, desc: "Mark P: ring on Bcl", params: (
			effect: "ring", in: [~input1,~input1], lev: 0, att: 0.1, rel: 0.1, gain: 3, levelCC:12)),
		(time: [0,00,0], type: \Control, desc: "note on Bcl", params: (
			srcSec: 15, srcEvt: 2, param: "note", mode: "line", from: 110, to: 99, time: 0.1, wait: 0.01, repeats: 1)),
		(time: [0,00,0], type: \Control, desc: "mixNoise on Bcl", params: (
			srcSec: 15, srcEvt: 2, param: "mixNoise", mode: "point", from: 0, to: 0, time: 1, wait: 0.01, repeats: 1)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 14, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 14, srcEvt: 1)),
		(time: [0,03,0], type: \Control, desc: "level on Bcl", params: (
			srcSec: 15, srcEvt: 2, param: "lev", mode: "line", from: 0, to: 0.5, time: 1, wait: 0.01, repeats: 1)),
		(time: [0,30,0], type: \Control, desc: "level on Bcl", params: (
			srcSec: 15, srcEvt: 2, param: "lev", mode: "line", from: 0.5, to: 0, time: 7, wait: 0.01, repeats: 1)),
		(time: [0,37,0], type: \End)
	],
	[ // CUE 16
		(time: [0,00,0], type: \DiskPlayStart, desc: "Q Start", params: (
			file: "Audio/17 Q.wav", lev: 1, att: 0.5, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \DiskPlayStart, desc: "Instruments", params: (
			file: "Audio/Instruments/17 Q.wav", lev: 1, att: 0.1, rel: 0.1, lp: 0)),
		(time: [0,00,0], type: \EffectOff, params: (srcSec: 15, srcEvt: 2)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 15, srcEvt: 0)),
		(time: [0,00,0], type: \DiskPlayStop, params: (srcSec: 15, srcEvt: 1)),
		(time: [0,17,2.5], type: \End)
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
DiskPlayStart has parameters: file (path to an audio file), lev (output level), lp (0=no looping, 1=looping), att, rel (attack/release time in sec)
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
		att/rel (for attack/release in sec), gain (input gain in db) / note: effect parameters can be changed with Control events
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
	Note: every effect has parameters in (a pair of input channels [n,m] counting from 0), lev (for volume), att/rel (for attack/release in sec),
		gain (input gain in db)
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











