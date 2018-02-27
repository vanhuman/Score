// Part of Score.scd for multiple compositions / Robert van Heumen 2014/2015
(
Document.dir = "~/---data---/Audio/SC-2017";
("Document directory set to"+Document.dir+"\n").postln;

if(~pID.isNil, { ~pID = 4 }); // project ID, index into project event
~sRate = s.sampleRate;
~project = (
	name: [ // determines the path for the score file and audio/midi files
		"Sonata for 10 pedals",
		"A Short Piece of Decay",
		"FLoK",
		"MOROS",
		"Untitled For Anne",
		"Spill",
		"Spill 5 min"
	],
	title: ["Sonata for 10 pedals (2014)  |  Robert van Heumen & Lucas Wiegerink",
		"A Short Piece of Decay (2014)  |  Robert van Heumen", "First Law of Kipple (revised version 2014) | Robert van Heumen",
		"MOROS (2014)  |  Robert van Heumen", "Untitled For Anne (2015)  |  Robert van Heumen", "Spill (2015)  |  Robert van Heumen", "Spill (2016 revised 5' version)  |  Robert van Heumen"],
	scoreFile: [nil,nil,nil,nil,nil,"~score-2016.scd",nil],
	// scoreFile: [nil,nil,nil,nil,nil,"~score-original.scd","~score+intro.scd"],
	timeOutVal: [nil,3,3,3,3,30,20], 					// time out value for triggering next section; if nil then trigger button is enabled with a Trig event
	triggerEnableFactor: [0.75,0.2,0.1,0.1,0.1,0.1,0.1], 	// factor for position of generated trigger events along the timeline
	lenSliderPerSecond: [8,13,9.2,14.5,10,3,8], 			// length section time slider per second
	lenSliderPerSecondiPad: [6.2,10.3,10,10,10,10,10],
	triggerMethod: [[\CC66,\ARD_DIG12],[\CC41],[\ARD_DIG12],[],[],[\ARD_DIG12],[\ARD_DIG12]],
	// how triggers can be send: ARD_DIG12=Arduino AN1&2, CC41=MIDI CC 41
	mainOutCC: [nil,0,nil,nil,nil,nil,nil],				// MIDI controller for output level
	disableMIDI: [0,0,1,1,1,1,1],						// bypass all MIDI
	countBars: [0,0,1,1,0,0,0],							// set to 1 to display bars and beats
	beatBlink: [0,0,1,0,0,0,0],							// set to 1 to blink bar/beat display on every beat / if 0 then only on whole bars
	blinkTime: [0.2,0.2,0.2,0.2,0.2,0.2,0.2],			// time to blink
	clickTrack: [nil,nil,nil,nil,nil,nil,nil],					// set to the click track channel / if nil then no click track / only if countBars is 1
	playContinuous: [0,0,1,1,0,1,1], 					// set to 1 to have cues automatically start if the previous one is finished
	maxOutputChannels: [2,2,4,2,2,2,2],			// max number of channels in the audio files
	detailMode: [1,2,3,4,5,6,6],		// detail mode index for GUI: 1 = Sonata (iPad 1024 x 768), 2 = Black Pencil (no scroll max 16 cues),
	//		3 = FLoK (iPad), 4 = MOROS (iPad)
	soundCheck: ["pi.wav","pi.wav","pi.wav","pi.wav","pi.wav","pi.wav","pi.wav"], // audio files for soundcheck button on System window
	input1: [1,1,0,0,0,0,0], 	// Disklavier pedals, Snaredrum, ---, Bass Clarinet, Flute, Harp condensor pair, Harp condensor pair
	input2: [0,0,0,1,0,1,1], 	// Disklavier strings, Blockflute, ---, Contrabass Clarinet, ---, Harp contact, Harp contact
	input3: [0,0,0,0,0,0,0], 	// ---, ---, ---, ---, ---, ---
	input4: [0,0,0,0,0,0,0],  	// ---, ---, ---, ---, ---, ---

	// support for multichannel recording
	record: [0,0,0,0,0,0,0],					// 0=no recording started, no output to rec channels and no micThru synth, 1=recording
	recChans: [10,10,10,10,10,8,8], 	// total nbr of chans to record
	micThruFrom: [[0,1],[0,1],[0,1],[0,1],0,[0,1],[0,1]],
	// input channels that will be bounced back out, number or array - if nil, recording synth will not be started
	micThruTo: [4,4,4,4,4,2,2], 		// output channels the thru mics will be send to
	recSample: [6,6,6,6,6,4,4], 	// record output channel for sample play - set to nil if no recording required - set to 8 for MOTU internal
	recEfx: [8,8,8,8,8,6,6], 			// record output channel for effects - set to nil if no recording required - set to 8 for MOTU internal

	setupText: [
		"As its sound device the program will use a MOTU or (if not available) the default sound input/output device in the Mac OS System Settings \n\nOutput channels: 1 & 2 (on MOTU Main Out 1 & 2) (hard-panned left and right) \n\nInput channels: Disklavier strings on 1, Disklavier pedals (contact mic) on 2",
		"As its sound device the program will use a MOTU or (if not available) the default sound input/output device in the Mac OS System Settings \n\nOutput channels: 1 & 2 (on MOTU Main Out 1 & 2) (hard-panned left and right) \n\nInput channels: Blockflute on 1, Snaredrum on 2\n\nMIDI control:\n\n\tCC41 (channel 3) for cue triggering\n\tCC0 (any channel) for overall sound volume\n\tCC1 (any channel) for delay effect on snaredrum\n\tCC2 (any channel) for stutterdelay effect on blockflute\n\tCC3 (any channel) for decimate effect on blockflute\n\tCC4 (any channel) for pitchshift effect on snaredrum",
		"",
		"As its sound device the program will use a MOTU or (if not available) the default sound input/output device in the Mac OS System Settings \n\nOutput channels: 1 & 2 (on MOTU Main Out 1 & 2) (hard-panned left and right) \n\nInput channels: Bass Clarinet on 1, Contrabass Clarinet on 2\n\nPress the letter A on the keyboard to hear a tuning tone of (sounding) A",
		"As its sound device the program will use a MOTU or (if not available) the default sound input/output device in the Mac OS System Settings \n\nOutput channels: 1 & 2 (on MOTU Main Out 1 & 2) (hard-panned left and right) \n\nInput channels: Flute on 1",
		"As its sound device the program will use a MOTU or (if not available) the default sound input/output device in the Mac OS System Settings \n\nOutput channels: 1 & 2 (on MOTU Main Out 1 & 2) (hard-panned left and right) \n\nInput channels: Harp consensor on 1, Harp contact on 2",
		"As its sound device the program will use a MOTU or (if not available) the default sound input/output device in the Mac OS System Settings \n\nOutput channels: 1 & 2 (on MOTU Main Out 1 & 2) (hard-panned left and right) \n\nInput channels: Harp consensor on 1, Harp contact on 2"
	]
);

~cfg = (
	version: "4.2",
	detailMode: 1, 					// 0 = all details, 1 = project specific
	autoGui: 0, 						// 0 = OFF, 1 = ON
	// standAlone: 0, 				// set to 1 and it will cause the IDE to be hidden and the wControl window's close button to kill the IDE
	stereoPlayback: 0, 			// when 1 all sound is mixed down to 2 channels (only applicable for more than 2 channel playback)
	playInstruments: 0, 			// whether to play DiskPlay events with desc "Instruments"
	playSoundtrack: 1, 			// whether to play DiskPlay events
	barInitWait: 0,	 				// lag for bar count
	midiOutPort: 4,				// default MIDI out
	libraryBase: Document.dir++"Score/Data/",	// MIDI and audio files location
	// libraryBaseSO: String.scDir ++ "Score/Data/",			// MIDI and audio files location for standalone version
	alpha: 0.97,						// alpha value for window
	sectVerticalSpace: 45, 	// vertical space for section
	sectStart: 20, 					// start first section
	font: "Helvetica", 				// base font Geneva, Arial
	elementHeight: 18,			// heigth section gui elements
	eventHeight: 12,				// heigth section events
	recordingTail: 5, 				// delay for stopping recording
	ampPitchTrack: 0, 			// whether to show amp and pitch tracking window (for now only for Untitled For Anne)
	serverMeter: 0, 				// whether to show the meter window
	altOutputLevel: 0, 			// level for alternative output (for recording for example)

	project: ~project.name[~pID],
	title: ~project.title[~pID],
	scoreFile: ~project.scoreFile[~pID],
	timeOutVal: ~project.timeOutVal[~pID],
	triggerEnableFactor: ~project.triggerEnableFactor[~pID],
	input1: ~project.input1[~pID],
	input2: ~project.input2[~pID],
	input3: ~project.input3[~pID],
	input4: ~project.input4[~pID],
	record: ~project.record[~pID],
	recChans: ~project.recChans[~pID],
	recSample: ~project.recSample[~pID],
	recEfx: ~project.recEfx[~pID],
	micThruFrom: ~project.micThruFrom[~pID],
	micThruTo: ~project.micThruTo[~pID],
	setupText: ~project.setupText[~pID],
	lenSliderPerSecond: ~project.lenSliderPerSecond[~pID],
	lenSliderPerSecondiPad: ~project.lenSliderPerSecondiPad[~pID],
	triggerMethod: ~project.triggerMethod[~pID],
	mainOutCC: ~project.mainOutCC[~pID],
	disableMIDI: ~project.disableMIDI[~pID],
	countBars: ~project.countBars[~pID],
	beatBlink: ~project.beatBlink[~pID],
	blinkTime: ~project.blinkTime[~pID],
	clickTrack: ~project.clickTrack[~pID],
	playContinuous: ~project.playContinuous[~pID],
	maxOutputChannels: ~project.maxOutputChannels[~pID],
	soundCheck: ~project.soundCheck[~pID]
);
~spec = (
	volume: Env.new([0,0,1,12.dbamp],[0.01,0.74,0.25],[0,5,0]),
	filterfreq: ControlSpec.new(50,20000,\exp),
	pedalpitch: Env.new([1,1,4],[0.2,0.8],[\lin]),
	effectInGain: Env.new([0,0,1,12.dbamp],[0.01,0.74,0.25],[0,5,0]),
	sampleLevel: Env.new([0,0,1,12.dbamp],[0.01,0.74,0.25],[0,5,0]),
	efxLevel: Env.new([0,0,1,12.dbamp],[0.01,0.74,0.25],[0,5,0]),
	samplingInGain: Env.new([0,0,1,12.dbamp],[0.01,0.74,0.25],[0,5,0]),

	deciMateAmp: Env.new([0.01,0.01,0.1,0.1], [0.4,0.6], [\lin]),
	deciMateProb: Env.new([0.1,0.1,0.9], [0.8,0.2], [\lin]),
	deciMateMixDec: Env.new([1,1,0,0], [0.2,0.4,0.4], [\lin]),
	deciMateMixCross: Env.new([0,0,1,1,0], [0.2,0.2,0.2,0.4], [\lin]),
	deciMateMixDis: Env.new([0,0,1,1], [0.6,0.2,0.2], [\lin]),
	deciMateDec: Env.new([100,10000], [1], [\lin]),

	delayTime: ControlSpec.new(0.2,1,\lin),
	decay: Env.new([0.5,1.2], [1], [\lin]),
	freeVerbRoomSize: Env.new([0.5,1], [1], [\lin]),

	multiTapRevVol: Env.new([0,1,1], [0.9,0.1], [\lin]),
	multiTapRevMixTap: Env.new([1,1,0,0], [0.9,0.08,0.02], [\lin]),
	multiTapRevMixFreeze: Env.new([0,0,1,1], [0.9,0.08,0.02], [\lin]),
	multiTapRevDecay: Env.new([0,0,1,1], [0.5,0.3,0.2], [\lin]),
	multiTapRevFv: Env.new([0,0,1,1], [0.5,0.25,0.25], [\lin]),
	multiTapRevFF: Env.new([500,10000], [1], [\lin]),
	multiTapRevTap1: Env.new([1,1,0,0],[0.1,0.05,0.85],[\lin]),
	multiTapRevTap2: Env.new([0,0,1,1,0,0],[0.1,0.05,0.15,0.05,0.65],[\lin]),
	multiTapRevTap3: Env.new([0,0,1,1,0,0],[0.3,0.05,0.15,0.05,0.45],[\lin]),
	multiTapRevTap4: Env.new([0,0,1,1],[0.5,0.05,0.45],[\lin]),
	multiTapRevDist: Env.new([1,10],[1],[\lin]),

	ampPitchFolPitch: Env.new([0.1,1],[1],[\lin]),
	ampPitchFolMixPitch: Env.new([1,1,0,0],[0.25,0.5,0.25], [\lin]),
	ampPitchFolMixNoise: Env.new([0,0,1,1],[0.15,0.35,0.5], [\lin]),
	ampPitchFolFfHPF: Env.new([10000,10000,10],[0.75,0.25],[\lin,\exp]),
	ampPitchFolMulHPFefx: Env.new([10,10,1],[0.5,0.5], [\lin]),

	apcRing: Env.new([0.2,0.7,1.2],[0.5,0.5],[\lin]),

	freq: ControlSpec(100,3000), // range for AmpPitchTrack

	fsCutoff: Env.new([50,1500,1500,5000],[0.45,0.1,0.45],[\lin]),
	fsPitch: Env.new([0.9,1.1],[1],[\lin]),
	fsRes: Env.new([0.2,1,1,2],[0.45,0.1,0.45],[\lin]),
	fsLev: Env.new([50,100],[1],[\exp]),
	fsAmp2cutoff: Env.new([1,1,10],[0.1,0.9],[\exp]),

	tremoloTremSpeed: ControlSpec.new(0.3,0.01,\exp),
	tremoloVar0Mix: Env.new([0,0,1,1,0,0],[0.1,0.01,0.78,0.01,0.1],[\lin]),
	tremoloVar1Mix: Env.new([1,1,0,0],[0.1,0.01,0.89],[\lin]),
	tremoloVar2Mix: Env.new([0,0,1,1],[0.89,0.01,0.1],[\lin]),
);

~multiTapRevBufL = Buffer.alloc(s, ~sRate*3,1);
~multiTapRevBufR = Buffer.alloc(s, ~sRate*3,1);
)
