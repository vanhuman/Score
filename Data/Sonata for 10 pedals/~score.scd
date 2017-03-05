
// This is a score for the Score program. A score consists of a number of sections, every section consists of a number of events.
// Every section runs its course and cannot be stopped.
// There is no general clock, as the sections are thought of as being triggered by a player when they decide.
// More documentation below the code.

~cueNames = nil;
~cueDescriptions = ["Sample 1", "Sample 2","Sample 3","Freeze","MIDI 1 + efx", "MIDI 2", "MIDI3", "MIDI 4","Freeze", "Snd + MIDI", "MIDI 5", "MIDI 6", "MIDI 7", "Harp samples", "End"];

~score = [
	[ // Cue 0 Sample 1
	(time: [0,00,0], type: \BufRec, desc: "Rec pedal 1/1", params: (
			in: [~input1,~input1], start: 0, len: 4
			)),
	(time: [0,04,0], type: \BufPlayStart, desc: "Play pedal 1/1", params: (
			mode: "straight", srcSec: 0, srcEvt: 0, start: 0, len: 4, lev: 1, att: 0.01, rel: 1, panDepth: 0.3, panSpeed: 0.2
			)),
	(time: [0,28,0], type: \Control, desc: "Pitch slowly faster", params: (
				srcSec: 0, srcEvt: 1, param: "pitch", mode: "line", from: 1, to: 2, time: 40, wait: 0.01, repeats: 1
			)),
	(time: [0,04,0], type: \Control, desc: "Crescendo p -> mp+ in 14 bars", params: ( // relative to the sample rec level
			srcSec: 0, srcEvt: 1, param: "lev", mode: "line", from: 1, to: 1.5, time: 40, wait: 0.1, repeats: 1
			)),
	(time: [1,06,0], type: \End) // 15 bars
	],
	[ // Cue 1 Sample 2
	(time: [0,00,0], type: \BufRec, desc: "Rec pedal 1/2", params: (
			in: [~input1,~input1], start: 0, len: 2
			)),
	(time: [0,02,0], type: \BufPlayStart, desc: "Play pedal 1/2", params: (
			mode: "straight", srcSec: 1, srcEvt: 0, start: 0, len: 2, lev: 1, att: 0.01, rel: 1, panDepth: 0.3, panSpeed: 0.4
			)),
	(time: [0,02,0], type: \Control, desc: "Pitch slowly faster", params: (
				srcSec: 0, srcEvt: 1, param: "pitch", mode: "line", from: 2, to: 4, time: 40, wait: 0.01, repeats: 1
			)),
	(time: [0,02,0], type: \Control, desc: "Pitch slowly faster", params: (
				srcSec: 1, srcEvt: 1, param: "pitch", mode: "line", from: 1, to: 2, time: 40, wait: 0.01, repeats: 1
			)),
	(time: [0,04,0], type: \Control, desc: "Crescendo p -> mp+ in 14 bars", params: ( // relative to the sample rec level
			srcSec: 0, srcEvt: 1, param: "lev", mode: "line", from: 1.5, to: 2, time: 40, wait: 0.1, repeats: 1
			)),
	(time: [0,02,0], type: \Control, desc: "Crescendo mp+ -> f in 14 bars", params: ( // relative to the sample rec level
			srcSec: 1, srcEvt: 1, param: "lev", mode: "line", from: 1, to: 1.5, time: 40, wait: 0.1, repeats: 1
			)),
	(time: [0,42,0], type: \End)
	],
	[ // Cue 2 Sample 3
	(time: [0,00,0], type: \BufRec, desc: "Rec pedal 1/4", params: (
			in: [~input1,~input1], start: 0, len: 1
			)),
	(time: [0,01,0], type: \BufPlayStart, desc: "Play pedal 1/4", params: (
			mode: "straight", srcSec: 2, srcEvt: 0, start: 0, len: 1, lev: 1, att: 0.01, rel: 1, panDepth: 0.4, panSpeed: 0.3
			)),
	(time: [0,30,0], type: \End)
	],
	[ // Cue 3 Freeze
	(time: [0,00,0], type: \BufPlayStop, params: (srcSec: 0, srcEvt: 1)),
	(time: [0,00,0], type: \BufPlayStop, params: (srcSec: 1, srcEvt: 1)),
	(time: [0,00,0], type: \BufPlayStop, params: (srcSec: 2, srcEvt: 1)),
	(time: [0,00,0], type: \EffectOn, desc: "multiTapReverb on pedal", params: (
			effect: "multiTapReverb", in: [~input1,~input1], lev: 0.9, att: 0.1, rel: 2, levelCC: 0
			)),
	(time: [0,00,0], type: \Control, desc: "Set dist level",  params: (
			srcSec: 3, srcEvt: 3, param: "dist", mode: "point", from: 2, to: 2, time: 1, wait: 0.01, repeats: 1
			)),
	(time: [0,00,1], type: \Control, desc: "Mix to freeze", params: (
			srcSec: 3, srcEvt: 3, param: "mix", mode: "point", from: 1, to: 1, time: 0.1, wait: 0.01, repeats: 1
			)),
	(time: [0,01,0], type: \Control, desc: "Level to full freeze",  params: (
			srcSec: 3, srcEvt: 3, param: "lev", mode: "point", from: 1, to: 1, time: 0.1, wait: 0.01, repeats: 1
			)),
	(time: [0,20,0], type: \Control, desc: "Decrescenco ff -> p",  params: (
			srcSec: 3, srcEvt: 3, param: "dist", mode: "line", from: 2.0, to: 0, time: 60, wait: 0.1, repeats: 1
			)),
	(time: [0,42,0], type: \Control, desc: "From pulse to static freeze in 8 bars",  params: (
			srcSec: 3, srcEvt: 3, param: "freeze", mode: "line", from: 0.5, to: 1, time: 32, wait: 0.1, repeats: 1
			)),
	(time: [1,50,0], type: \Control, desc: "Decrescendo lev freeze mf -> ppp",  params: (
			srcSec: 3, srcEvt: 3, param: "lev", mode: "line", from: 1, to: 0.8, time: 8, wait: 0.1, repeats: 1
			)),
	(time: [2,00,0], type: \End)
	],
	[ // Cue 4 MIDI 1 + efx
	(time: [0,00,0], type: \EffectOff, params: (srcSec: 3, srcEvt: 3)),
	(time: [0,00,0], type: \EffectOn, desc: "multiTapReverb on pedal", params: (
			effect: "multiTapReverb", in: [~input1,~input1], lev: 0.9, att: 0.1, rel: 2, levelCC: 1
			)),
	(time: [0,00,1], type: \Control, desc: "Mix to freeze", params: (
			srcSec: 4, srcEvt: 1, param: "mix", mode: "point", from: 1, to: 1, time: 0.1, wait: 0.01, repeats: 1
			)),
	(time: [0,00,1], type: \Control, desc: "From pulse to static freeze in 8 bars",  params: (
			srcSec: 4, srcEvt: 1, param: "freeze", mode: "point", from: 0.5, to: 1, time: 1, wait: 0.01, repeats: 1
			)),
	(time: [0,00,0], type: \EffectOn, desc: "freeVerb on pedal", params: (
			effect: "freeVerb", in: [~input1,~input1], lev: 0.6, att: 0.1, rel: 2, levelCC: 2
			)),
	(time: [0,00,0], type: \Control, desc: "Set roomsize", params: (
				srcSec: 4, srcEvt: 1, param: "roomsize", mode: "point", from: 0.9, to: 1, time: 0.1, wait: 0.01, repeats: 1
			)),
	(time: [0,00,0], type: \MIDI, params: (file: "MIDI/Disklavier 1.mid")),
// start new section (after try-out)
	(time: [0,00,1], type: \Control, desc: "Delay on",  params: (
			srcSec: 4, srcEvt: 1, param: "delayOn", mode: "point", from: 1, to: 1, time: 1, wait: 0.01, repeats: 1
			)),
	(time: [0,00,1], type: \Control, desc: "add bit distortion",  params: (
			srcSec: 4, srcEvt: 1, param: "dist", mode: "point", from: 0.2, to: 0.2, time: 5, wait: 0.01, repeats: 1
			)),
// end new section (after try-out)
	(time: [0,40,0], type: \End)
	],
	[ // Cue 5 MIDI 2
	(time: [0,00,0], type: \MIDI, params: (file: "MIDI/Disklavier 2.mid")),
	(time: [0,40,0], type: \End)
	],
	[ // Cue 6 MIDI 3
	(time: [0,00,0], type: \MIDI, params: (file: "MIDI/Disklavier 3.mid")),
	(time: [0,40,0], type: \End)
	],
	[ // Cue 7 MIDI 4
	(time: [0,00,0], type: \MIDI, params: (file: "MIDI/Disklavier 4.mid")),
	(time: [0,40,0], type: \End)
	],
	[ // Cue 8 Freeze + pause MIDI
	(time: [0,00,0], type: \MControl, params: (action: "pause", srcSec: 4, srcEvt: 6)),
	(time: [0,00,0], type: \MControl, params: (action: "pause", srcSec: 5, srcEvt: 0)),
	(time: [0,00,0], type: \MControl, params: (action: "pause", srcSec: 6, srcEvt: 0)),
	(time: [0,00,0], type: \MControl, params: (action: "pause", srcSec: 7, srcEvt: 0)),
	(time: [0,00,0], type: \EffectOn, desc: "multiTapReverb on pedal", params: (
			effect: "multiTapReverb", in: [~input1,~input1], lev: 0.9, att: 0.1, rel: 2, levelCC: 3
			)),
	(time: [0,00,0], type: \Control, desc: "Set dist level",  params: (
			srcSec: 8, srcEvt: 4, param: "dist", mode: "point", from: 0, to: 0, time: 1, wait: 0.01, repeats: 1
			)),
	(time: [0,00,0], type: \EffectOff, params: (srcSec: 4, srcEvt: 1)),
	(time: [0,00,0], type: \EffectOff, params: (srcSec: 4, srcEvt: 4)),
	(time: [0,00,1], type: \Control, desc: "Mix to freeze", params: (
			srcSec: 8, srcEvt: 4, param: "mix", mode: "point", from: 1, to: 1, time: 0.1, wait: 0.01, repeats: 1
			)),
	(time: [0,01,0], type: \Control, desc: "Level to full freeze",  params: (
			srcSec: 8, srcEvt: 4, param: "lev", mode: "point", from: 1, to: 1, time: 0.1, wait: 0.01, repeats: 1
			)),
	(time: [0,50,0], type: \Control, desc: "Increase dist level",  params: (
			srcSec: 8, srcEvt: 4, param: "dist", mode: "line", from: 0, to: 1, time: 60, wait: 0.1, repeats: 1
			)),
	(time: [0,36,0], type: \Control, desc: "From pulse to static freeze",  params: (
			srcSec: 8, srcEvt: 4, param: "freeze", mode: "line", from: 0.5, to: 1, time: 31, wait: 0.1, repeats: 1
			)),
	(time: [1,50,0], type: \End)
	],
	[ // Cue 9 Soundtrack + MIDI
	(time: [0,00,0], type: \EffectOn, desc: "multiTapReverb on Dis", params: (
			effect: "multiTapReverb", in: [~input2,~input2], lev: 0.9, att: 0.1, rel: 2, levelCC: 4
			)),
	(time: [0,00,1], type: \Control, desc: "Mix to freeze", params: (
			srcSec: 9, srcEvt: 0, param: "mix", mode: "point", from: 0.4, to: 0.4, time: 0.1, wait: 0.01, repeats: 1
			)),
	(time: [0,10,0], type: \MControl, params: (action: "resume", srcSec: 4, srcEvt: 6)),
	(time: [0,10,0], type: \MControl, params: (action: "resume", srcSec: 5, srcEvt: 0)),
	(time: [0,10,0], type: \MControl, params: (action: "resume", srcSec: 6, srcEvt: 0)),
	(time: [0,10,0], type: \MControl, params: (action: "resume", srcSec: 7, srcEvt: 0)),
	(time: [0,00,0], type: \BufLoad, desc: "Load pedaal 1/1", params: (file: "/Audio/pedaal_1.wav", len: 4)),
	(time: [0,00,0], type: \BufPlayStart, desc: "Play pedal 1/1", params: (
			mode: "straight", srcSec: 9, srcEvt: 6, start: 0, len: 4, lev: 1, att: 0.01, rel: 1, panDepth: 0.8, panSpeed: 1
			)),
	(time: [0,00,0], type: \Control, desc: "Pitch from +12 to +24", params: (
			srcSec: 9, srcEvt: 7, param: "pitch", mode: "line", from: 2, to: 4, time: 20, wait: 0.1, repeats: 1
			)),
	(time: [0,00,0], type: \BufLoad, desc: "Load pedaal 1/2", params: (file: "/Audio/pedaal_2.wav", len: 2)),
	(time: [0,00,0], type: \BufPlayStart, desc: "Play pedal 1/2", params: (
			mode: "straight", srcSec: 9, srcEvt: 9, start: 0, len: 2, lev: 1, att: 0.01, rel: 1, panDepth: 0.9, panSpeed: 1.2
			)),
	(time: [0,00,0], type: \Control, desc: "Pitch from 0 to +12", params: (
			srcSec: 9, srcEvt: 10, param: "pitch", mode: "line", from: 1, to: 2, time: 20, wait: 0.1, repeats: 1
			)),
	(time: [0,00,0], type: \BufLoad, desc: "Load pedaal 1/4", params: (file: "/Audio/pedaal_4.wav", len: 1)),
	(time: [0,00,0], type: \BufPlayStart, desc: "Play pedal 1/4", params: (
			mode: "straight", srcSec: 9, srcEvt: 12, start: 0, len: 1, lev: 1, att: 0.01, rel: 1, panDepth: 0.8, panSpeed: 1
			)),
	(time: [0,00,0], type: \Control, desc: "Pitch from -12 to 0", params: (
			srcSec: 9, srcEvt: 13, param: "pitch", mode: "line", from: 0.5, to: 1, time: 20, wait: 0.1, repeats: 1
			)),
	(time: [0,00,0], type: \BufPlayStart, desc: "Play pedal 1/1 B", params: (
			mode: "straight", srcSec: 9, srcEvt: 6, start: 0, len: 4, lev: 1, att: 0.01, rel: 1, panDepth: 0.8, panSpeed: 1, pitch: 0.5
			)),
	(time: [0,00,0], type: \Control, desc: "Pitch from +12 to +24", params: (
			srcSec: 9, srcEvt: 15, param: "pitch", mode: "line", from: 1, to: 2, time: 20, wait: 0.1, repeats: 1
			)),
	(time: [0,00,0], type: \BufPlayStart, desc: "Play pedal 1/2 B", params: (
			mode: "straight", srcSec: 9, srcEvt: 9, start: 0, len: 2, lev: 1, att: 0.01, rel: 1, panDepth: 0.9, panSpeed: 1.2, pitch: 0.5
			)),
	(time: [0,00,0], type: \Control, desc: "Pitch from 0 to +12", params: (
			srcSec: 9, srcEvt: 17, param: "pitch", mode: "line", from: 0.5, to: 1, time: 20, wait: 0.1, repeats: 1
			)),
	(time: [0,00,0], type: \BufPlayStart, desc: "Play pedal 1/4 B", params: (
			mode: "straight", srcSec: 9, srcEvt: 12, start: 0, len: 1, lev: 1, att: 0.01, rel: 1, panDepth: 0.8, panSpeed: 1, pitch: 0.5
			)),
	(time: [0,00,0], type: \Control, desc: "Pitch from -12 to 0", params: (
			srcSec: 9, srcEvt: 19, param: "pitch", mode: "line", from: 0.25, to: 0.5, time: 20, wait: 0.1, repeats: 1
			)),
	(time: [0,01,0], type: \Control, desc: "decrease dist level",  params: (
			srcSec: 8, srcEvt: 4, param: "dist", mode: "line", from: 1, to: 0, time: 10, wait: 0.1, repeats: 1
			)),
	(time: [0,12,0], type: \EffectOff, params: (srcSec: 8, srcEvt: 4)),
	(time: [0,14,0], type: \End)
	],
	[ // Cue 10 MIDI 5
	(time: [0,00,0], type: \MIDI, params: (file: "MIDI/Disklavier 5.mid")),
	(time: [0,00,0], type: \Control, desc: "Change length", params: (
			srcSec: 9, srcEvt: 7, param: "len", mode: "line", from: 4, to: 3.8, time: 10, wait: 0.01, repeats: 1
			)),
	(time: [0,06,0], type: \Control, desc: "Change length", params: (
			srcSec: 9, srcEvt: 10, param: "len", mode: "line", from: 2, to: 1.6, time: 8, wait: 0.01, repeats: 1
			)),
	(time: [0,12,0], type: \Control, desc: "Change length", params: (
			srcSec: 9, srcEvt: 13, param: "len", mode: "line", from: 1, to: 1.1, time: 8, wait: 0.01, repeats: 1
			)),
	(time: [0,40,0], type: \End)
	],
	[ // Cue 11 MIDI 6
	(time: [0,00,0], type: \MIDI, params: (file: "MIDI/Disklavier 6.mid")),
	(time: [0,3,0], type: \Control, desc: "Change length", params: (
			srcSec: 9, srcEvt: 7, param: "len", mode: "line", from: 3.8, to: 4.1, time: 8, wait: 0.01, repeats: 1
			)),
	(time: [0,8,0], type: \Control, desc: "Change length", params: (
			srcSec: 9, srcEvt: 10, param: "len", mode: "line", from: 1.7, to: 1.9, time: 8, wait: 0.01, repeats: 1
			)),
	(time: [0,12,0], type: \Control, desc: "Change length", params: (
			srcSec:9, srcEvt: 13, param: "len", mode: "line", from: 1.1, to: 0.8, time: 10, wait: 0.01, repeats: 1
			)),
	(time: [0,40,0], type: \End)
	],
	[ // Cue 12 MIDI 7
	(time: [0,00,0], type: \MIDI, params: (file: "MIDI/Disklavier 7.mid")),
// start new section (after try-out)
	(time: [0,00,0], type: \Control, desc: "Change length", params: (
			srcSec: 9, srcEvt: 7, param: "len", mode: "line", from: 4, to: 1, time: 40, wait: 0.01, repeats: 1
			)),
	(time: [0,06,0], type: \Control, desc: "Change length", params: (
			srcSec: 9, srcEvt: 10, param: "len", mode: "line", from: 2, to: 0.8, time: 45, wait: 0.01, repeats: 1
			)),
	(time: [0,12,0], type: \Control, desc: "Change length", params: (
			srcSec: 9, srcEvt: 13, param: "len", mode: "line", from: 1, to: 0.5, time: 48, wait: 0.01, repeats: 1
			)),
// end new section (after try-out)
	(time: [0,40,0], type: \End)
	],
	[ // Cue 13 Harp samples
	(time: [0,00,0], type: \BufLoad, desc: "Load harpComp", params: (file: "/Audio/harpComp.wav", len: 54)),
	(time: [0,00,0], type: \BufPlayStart, desc: "Play harpComp", params: (
			mode: "straight", srcSec: 13, srcEvt: 0, start: 0, len: 54, lev: 1.5, att: 0.01, rel: 1, panDepth: 0.9, panSpeed: 1.2
			)),
	(time: [0,00,0], type: \Control, desc: "Pitch line", params: (
			srcSec: 13, srcEvt: 1, param: "pitch", mode: "line", from: 1, to: 6, time: 1, wait: 0.1, repeats: 5
			)),
	(time: [0,05,0], type: \Control, desc: "Pitch line", params: (
			srcSec: 13, srcEvt: 1, param: "pitch", mode: "line", from: 1, to: 6, time: 0.5, wait: 0.1, repeats: 10
			)),
	(time: [0,10,0], type: \Control, desc: "Pitch line", params: (
			srcSec: 13, srcEvt: 1, param: "pitch", mode: "sine", from: 1, to: 6, time: 1, wait: 0.1, repeats: 10
			)),
	(time: [0,20,0], type: \Control, desc: "Pitch line", params: (
			srcSec: 13, srcEvt: 1, param: "pitch", mode: "sine", from: 1, to: 10, time: 0.4, wait: 0.1, repeats: 100
			)),
	(time: [0,12,0], type: \BufPlayStart, desc: "Play harpComp B", params: (
			mode: "straight", srcSec: 13, srcEvt: 0, start: 0, len: 30, lev: 1.5, att: 0.01, rel: 1, panDepth: 0.9, panSpeed: 3
			)),
	(time: [0,12,0], type: \Control, desc: "Pitch line", params: (
			srcSec: 13, srcEvt: 6, param: "pitch", mode: "sine", from: 1, to: 10, time: 0.4, wait: 0.1, repeats: 100
			)),
// start new section (after try-out)
	(time: [0,10,0], type: \Control, desc: "Change length", params: (
			srcSec: 9, srcEvt: 7, param: "len", mode: "sine", from: 1, to: 0.1, time: 3, wait: 0.01, repeats: 20
			)),
	(time: [0,10,0], type: \Control, desc: "Change length", params: (
			srcSec: 9, srcEvt: 10, param: "len", mode: "sine", from: 0.8, to: 0.09, time: 4, wait: 0.01, repeats: 15
			)),
	(time: [0,10,0], type: \Control, desc: "Change length", params: (
			srcSec: 9, srcEvt: 13, param: "len", mode: "sine", from: 0.5, to: 0.05, time: 5, wait: 0.01, repeats: 11
			)),
	(time: [0,00,0], type: \Control, desc: "Pitch increase", params: (
			srcSec: 9, srcEvt: 7, param: "pitch", mode: "line", from: 4, to: 10, time: 60, wait: 0.1, repeats: 1
			)),
	(time: [0,00,0], type: \Control, desc: "Pitch increase", params: (
			srcSec: 9, srcEvt: 10, param: "pitch", mode: "line", from: 2, to: 8, time: 60, wait: 0.1, repeats: 1
			)),
	(time: [0,00,0], type: \Control, desc: "Pitch increase", params: (
			srcSec: 9, srcEvt: 13, param: "pitch", mode: "line", from: 1, to: 13, time: 60, wait: 0.1, repeats: 1
			)),
// end new section (after try-out)
	(time: [0,60,0], type: \End)
	],
	[ // Cue 13 END
	(time: [0,00,0], type: \BufPlayStop, params: (srcSec: 13, srcEvt: 1)),
	(time: [0,00,0], type: \BufPlayStop, params: (srcSec: 13, srcEvt: 6)),
	(time: [0,00,0], type: \BufPlayStop, params: (srcSec: 9, srcEvt: 7)),
	(time: [0,00,0], type: \BufPlayStop, params: (srcSec: 9, srcEvt: 10)),
	(time: [0,00,0], type: \BufPlayStop, params: (srcSec: 9, srcEvt: 13)),
	(time: [0,00,0], type: \BufPlayStop, params: (srcSec: 9, srcEvt: 15)),
	(time: [0,00,0], type: \BufPlayStop, params: (srcSec: 9, srcEvt: 17)),
	(time: [0,00,0], type: \BufPlayStop, params: (srcSec: 9, srcEvt: 19)),
	(time: [0,00,0], type: \MControl, params: (action: "pause", srcSec: 4, srcEvt: 6)),
	(time: [0,00,0], type: \MControl, params: (action: "pause", srcSec: 5, srcEvt: 0)),
	(time: [0,00,0], type: \MControl, params: (action: "pause", srcSec: 6, srcEvt: 0)),
	(time: [0,00,0], type: \MControl, params: (action: "pause", srcSec: 7, srcEvt: 0)),
	(time: [0,00,0], type: \MControl, params: (action: "pause", srcSec: 10, srcEvt: 0)),
	(time: [0,00,0], type: \MControl, params: (action: "pause", srcSec: 11, srcEvt: 0)),
	(time: [0,00,0], type: \MControl, params: (action: "pause", srcSec: 12, srcEvt: 0)),
	(time: [0,10,0], type: \EffectOff, params: (srcSec: 9, srcEvt: 0)),
	(time: [1,00,0], type: \End)
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
// 	The MIDI event has parameter: file (path to the MIDI file)

// MControl
// 	MControl has parameters srcSec and srcEvt (for source section and event numbers, counting from 0) and
//		action ('pause' or 'resume')

// DiskPlayStart and DiskPlayStop
//	DiskPlayStart has parameters: file (path to an audio file), loop (0=no looping, 1=looping), att, rel (attack/release time in sec)
//	DiskPlayStop has parameters: srcSec and srcEvt (for DiskPlayStart source section and event numbers, counting from 0)

// BufRec, BufLoad, BufPlayStart and BufPlayStop
// 	BufRec has parameters in (a pair of input channels [n,m] counting from 0), start (offset in buffer in sec) and
//		len (length of recording in sec)
// 	BufLoad has parameters: file (path to an audio file) and len (length of buffer in sec)
// 	BufPlayStart has parameters: srcSec and srcEvt (for BufRec or BufLoad source section and event numbers, counting from 0),
//		start (offset in buffer in sec), att, rel (attack/release time in sec), mode (playback method: straight, phase, forwbackw),
//		lev, pitch, panDepth (equals position if speed = 0), panSpeed
//		Params to control with a Control event (aside from above ones): filterfreq (for lowpass filter), revmix, room (for reverb)
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
//	multiTapReverb / parameters: filterfreq (lowpass filter of freeze), freeze (for mix drone/pulse freeze), mix (for mix Tap/Reverb/Freeze),
//		dist (for distortion, 0=no boost)
//		note: a lev value 0.9 is full volume, when mix = 1, a lev value of 1 will trigger the freeze/hold
//	ampPitchFollow / parameters: mix (for mix pitch/noise), pitch (for tuning sines)
//	freeVerb / parameter: roomsize
//	schroederRev / parameter: decay
//	ampPerc / parameters: pitch (for pitch low sine), range (for range flutter), ring (for ring time low sine)
//	pitchShift / parameter: pitch, dist





















