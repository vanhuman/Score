// Score for multiple compositions / Robert van Heumen 2014/2015/2017
// Tested with SC 3.8
// Dependencies: Score-Config.scd & Score-Synths.scd
(
s.waitForBoot({

	// -------------------- variables ----------------------

	var srcTypes = [\BufPlayStart,\BufPlayStop,\DiskPlayStop,\EffectOff,\Control,\MControl]; // types of events with a srcSec en srcEvt
	var color  = (actCue: Color.blue.alpha_(0.5), actCueTxt: Color.white, nextCue: Color.green.alpha_(0.5), nextCueTxt: Color.black,
		backGr: Color(0.5,0.5,0.5,0.5));
	var screenHeight = Window.screenBounds.height, screenWidth = Window.screenBounds.width;

	// Logic variables
	var cuedSection = 0, activeSection = -1;
	var fileLevels, scoreLength, scoreProc, scoreBuf, effectInGainBus, effectInGainBusLabel, effectInGains, ampFollowBus, ampFollowBusLabel, ampFollowInGains; // arrays with data per section
	var activeSectionTask, runSection, controlTask;
	var samplingInGain = 0, sampleLevel = 0, efxLevel = 0;
	var mainOutSynth, volBus = Bus.control(s,1), efxOutSynth, volEfxBus = Bus.control(s,1), sampleOutSynth, volSampleBus = Bus.control(s,1), micThruSynth;
	var samplingInGainBus = Bus.control(s,1);
	var efxGroup = Group.new(), sampleGroup = Group.new(efxGroup, \addAfter), subOutGroup = Group.new(sampleGroup, \addAfter);
	var mainOutGroup = Group.new(subOutGroup, \addAfter), funcGroup = Group.new();
	var fPlayMidi, fEffect, fNextSection, fControl, fStopAll, fStatus2Display, fBufferRead, fMControl,fKeyDown;
	var runFuncs = (), systemRunning = 0;

	// GUI variables
	var eventYpos, sectionShift = 0, sectionShiftNew = 0, sectionShiftTotal = 0;
	var wScore, bScore, bScoreDesc, bStopAll, bMidiMonitor, sTime, nCount, fromPos, bEvent, bEventTime, corrupt = 0, tStatus1, sVolume, lVolume, dCueSect, bActSectTrig, uCanvas, tStatus2, uStatus, lCueSect, lEffectInGain, sEffectInGain, bEffectInGain, wSystem, effectInGainAvail = 0, effectInGainCount = 0, lActSect, tActSect, lTrigger, cTrigger, vTrigger = true, cPlayInstr, lPlayInstr, bLevelsSave, bLevelsReload, bEffectInGainsReset, lLevelsUnsaved, tEffectHeader, sSamplingInGain, tSamplingHeader, lAmpFollowHeader, ampFollowAvail = 0, ampFollowCount = 0, sAmpFollow, lAmpFollow, bCueDesc;
	var sDeciMateMainLevel, wControl, lDeciMateMainLevel, lDeciMate2MainLevel, sDeciMate2MainLevel;
	var fBarCount, tBarCount, tBar, tBeat, lBar, tHeader, tHeaderBack, tLines, wSetupText, tSetupText, tSetupHeader, tRunning;
	var sSampleLevel, lSampleLevel, sEfxLevel, lEfxLevel, bSoundCheck, soundCheckSynth;
	var tListener, bListener, sListener, cTouchOSCsending, lTouchOSCsending, touchOSCsending = 0, caTouchOSCsending;
	var lNetaddrIP, lNetaddrPort, tNetaddrIP, tNetaddrPort;
	var cRecord, lRecord;

	// Control variables
	var midiEventPresent = 0, midiPorts, midiOut, dMidiOut, midiDeviceAvailable = 0;
	var ardSms, serialPort, ardTask, trigTimeOut = 0, ardDig1, ardDig1Avail = 0, ardDig2, ardDig2Avail = 0;
	var ardAna1, ardAna1Max = 750, ardAna1Min = 3, ardAna1prev = 0;
	var ardAna2, ardAna2Max = 750, ardAna2Min = 3, ardAna2prev = 0;
	var pedalBus = Bus.control(s,1), effectInGainDefaultBus = Bus.control(s,1), sine440;
	var netaddrTouchOSC = NetAddr("169.254.0.6", 9000);  	// to device running TouchOSC
	var wAmpPitch, freqLabel, freqSlider, freqText, ampLabel, ampSlider, ampText, bAmpPitch, msFreq, freqBandsLabel, bFreqReset, freqBandsSelectedLabel, tLowThreshold, tLowThresholdText, lowThresholdLabel;
	var freqLow = 100; // lowest frequency in freq bands window
	var listenerCheat = 0, tListenerCheat, tListenerTest;

	var oblique = ["Abandon normal instruments","Accept advice","Accretion","Allow an easement (an easement is the abandonment of a stricture)","Always first steps","Are there sections? Consider transitions","Ask people to work against their better judgement","Ask your body","Be dirty","Be extravagant","Be less critical more often","Breathe more deeply","Change nothing and continue with immaculate consistency","Courage!","Cut a vital connection","Decorate, decorate","Define an area as 'safe' and use it as an anchor","Destroy - nothing - the most important thing","Discard an axiom","Disciplined self-indulgence","Disconnect from desire","Discover the recipes you are using and abandon them","Distorting time","Do nothing for as long as possible","Do something boring","Do the words need changing?","Do we need holes?","Don't be afraid of things because they're easy to do","Don't be frightened of cliches","Don't be frightened to display your talents","Don't break the silence","Don't stress one thing more than another","Emphasize differences","Emphasize the flaws","Faced with a choice do both","Gardening, not architecture","Give the game away","Give way to your worst impulse","Go outside. Shut the door.","Go to an extreme, move back to a more comfortable place","Honour thy error as a hidden intention","How would you have done it?","Humanize something free of error","In total darkness or in a very large room, very quietly","Is it finished?","Is there something missing?","Just carry on","Listen to the quiet voice","Look at the order in which you do things","Look closely at the most embarrassing details and amplify them","Make a blank valuable by putting it in an exquisite frame","Make a sudden, destructive unpredictable action; incorporate","Make an exhaustive list of everything you might do and do the last thing on the list","Make it more sensual","Make something implied more definite (reinforce, duplicate)","Not building a wall but making a brick","Once the search is in progress, something will be found","Only a part, not the whole","Only one element of each kind","Overtly resist change","Question the heroic approach","Remember those quiet evenings","Remove ambiguities and convert to specifics","Remove specifics and convert to ambiguities","Repetition is a form of change","Retrace your steps","Reverse","Short circuit","Simple subtraction","Simply a matter of work","Slow preparation, fast execution","State the problem in words as clearly as possible","Take a break","Take away the elements in order of apparent non importance","The inconsistency principle","The most important thing is the thing most easily forgotten","Think - inside the work - outside the work","Tidy up","Towards the insignificant","Trust in the you of now","Try faking it!","Turn it upside down","Use 'unqualified' people","Use an old idea","Use an unacceptable colour","Use filters","Voice nagging suspicions","Water","What are you really thinking about just now? Incorporate","What mistakes did you make last time?","What to increase? What to reduce?","What to maintain?","What would your closest friend do?","What wouldn't you do?","When is it for?","Where's the edge? Where does the frame start?","Which elements can be grouped?","Which frame would make this look right?","Who should be doing this job? How would they do it?","Work at a different speed","Would anybody want it?","You are an engineer","You don't have to be ashamed of using your own ideas"];

	// -------------------- configuration ----------------------

	("Load extensions from folder:\n" + thisProcess.platform.systemExtensionDir + "\n").postln;
	("Load Config and Synths from folder:\n" + thisProcess.nowExecutingPath.dirname + "\n").postln;

	"Score-Config.scd".loadRelative();
	// override input busses from general startup file
	if(~inputChannel1.notNil, { ~cfg.input1 = ~inputChannel1 - 1; ("Input Channel 1 is now" + ~cfg.input1 + "\n").postln; });
	if(~inputChannel2.notNil, { ~cfg.input2 = ~inputChannel2 - 1; ("Input Channel 2 is now" + ~cfg.input2 + "\n").postln; });

	// special for To Whom this Power
	// case
	// {~pID==4} {~cfg.detailMode = 1; "Set detailMode to 1 for Untitled".postln;} // Untitled
	// {~pID==5} {~cfg.detailMode = 0; "Set detailMode to 0 for SPILL".postln;} // SPILL
	// ;

	// standalone version
	// if(~cfg.standAlone == 1, {
	// 	thisProcess.platform.recordingsDir = "~/Desktop".standardizePath;
	// 	~cfg.libraryBase = ~cfg.libraryBaseSO;
	// 	"\n### Standalone version".postln;}, {"\n### SC version".postln;}
	// );

	eventYpos = ~cfg.sectStart - 17;
	~lowThreshold = -40; // set default low threshold
	fileLevels = ~cfg.libraryBase++~cfg.project++"/Levels.scd";
	if(File.exists(fileLevels) == false,{
		var fileTemp;
		fileTemp = File(fileLevels,"w");
		fileTemp.close;
	});
	if(~cfg.detailMode > 0, {~cfg.detailMode = ~project.detailMode[~pID]});

	// load score
	if(~cfg.scoreFile.isNil, {~cfg.scoreFile = "~score.scd"});
	("Reading score file:\n"+~cfg.libraryBase++~cfg.project++"/"++~cfg.scoreFile++"\n").postln;
	~score = nil; ~cueNames = nil; ~cueDescriptions = nil;
	~input1 = ~cfg.input1; ~input2 = ~cfg.input2; ~input3 = ~cfg.input3; ~input4 = ~cfg.input4;
	~mainOutBus = [0]; ~subOutBus = [26]; ~efxOutBus = [34]; ~sampleOutBus = [42]; ~volMain = 0;
	// override input busses from general startup file
	if(~outputChannel.notNil, { ~mainOutBus = [~outputChannel - 1]; ("Output Channels are now" +  ~outputChannel ++ "+" ++ (~outputChannel+1) + "\n").postln; });
	(~cfg.libraryBase++~cfg.project++"/"++~cfg.scoreFile).load();

	mainOutSynth = Array.newClear(~mainOutBus.size);
	efxOutSynth = Array.newClear(~efxOutBus.size);
	sampleOutSynth = Array.newClear(~sampleOutBus.size);
	s.recChannels_(~cfg.recChans); ("Number of recording channels set to" + s.recChannels).postln;

	("\n### Project:" + ~cfg.project).postln;

	// initialize arrays
	scoreProc = List.new(0); 				// processes
	scoreBuf = List.new(0);				// buffers
	controlTask = List.new(0);				// control tasks
	bEvent = List.new(0);				// event buttons
	effectInGainBus = Array.newClear(127);		// level control busses for effects per midi cc number
	effectInGainBusLabel = Array.newClear(127);	// level control labels for effects per midi cc number
	lEffectInGain = Array.newClear(127);			// effect level labels per midi cc number
	sEffectInGain = Array.newClear(127);		// effect level sliders per midi cc number
	bEffectInGain = Array.newClear(127);		// effect test buttons per midi cc number
	ampFollowBus = Array.newClear(127);
	ampFollowBusLabel = Array.newClear(127);
	lAmpFollow = Array.newClear(127);
	sAmpFollow = Array.newClear(127);
	bScore = Array.newClear(~score.size);	// score start buttons
	bScoreDesc = Array.newClear(~score.size);	// score section descriptions
	sTime = Array.newClear(~score.size);	// time sliders
	nCount = Array.newClear(~score.size);	// time number boxes
	fromPos = Array.series(~score.size,0,0);	// from positions for sliders
	scoreLength = Array.newClear(~score.size); // length of the sections in seconds

	// check output busses
	if( (~subOutBus.size != ~mainOutBus.size) || (~efxOutBus.size > ~mainOutBus.size) || (~sampleOutBus.size > ~mainOutBus.size), {
		corrupt = 1;
		~mainOutBus = [0];
		~subOutBus = [26];
		~efxOutBus = [34];
		~sampleOutBus = [42];
		("\n### CORRUPT: outBus sizes discrepancy / reset to default").postln;
	});

	// check cue names and descriptions
	if((~cueNames.size < ~score.size) && ~cueNames.notNil,
		{corrupt = 1; ~cueNames = nil; ("\n### CORRUPT: length ~cueNames").postln;});
	if((~cueDescriptions.size != ~score.size) && ~cueDescriptions.notNil,
		{corrupt = 1; ("\n### CORRUPT: length ~cueDescriptions").postln;});

	// default cueNames
	if(~cueNames.isNil, {
		~cueNames = Array.series(~score.size+1,0,1);
		~cueNames = ~cueNames.collect({arg item, index; if(index==~score.size, {"End"}, {"Cue"+item})});
		},{
			// add END to cueNames
			~cueNames = ~cueNames.add("End");
	});
	if(~cueDescriptions.isNil, {~cueDescriptions = []});

	// expand ~cueTempi if not an array
	if(~cueTempi.isArray == false, {~cueTempi = ~cueTempi.dup(~score.size+1)});

	// detailModes
	if(~cfg.detailMode==1, { // Sonata iPad 1024 x 768
		~cfg.elementHeight = 38;
		~cfg.sectVerticalSpace = 70;
		~cfg.lenSliderPerSecond = ~cfg.lenSliderPerSecondiPad;
	});
	if(~cfg.detailMode==2, { // Black Pencil no scroll
		~cfg.elementHeight = 23;
		~cfg.sectVerticalSpace = 35;
		~cfg.lenSliderPerSecond = ~cfg.lenSliderPerSecondiPad;
	});
	if( (~cfg.detailMode==5) || (~cfg.detailMode==3), { // FLoK & Untitled for Anne
		color  = (actCue: Color.new255(37,137,70), actCueTxt: Color.white, nextCue: Color.new255(0,0,135), nextCueTxt: Color.white, backGr: Color(0.5,0.5,0.5,0.5));
	});

	// loop through sections to initialize arrays and make some checks
	~score.size.do({arg sec;
		var secTime = 0, trigEventPresent = 0;

		// add list entry per section
		scoreProc.add(List.new(0));
		scoreBuf.add(List.new(0));
		bEvent.add(List.new(0));
		controlTask.add(List.new(0));

		// loop through events per section
		~score[sec].size.do({arg evt;
			// keep track of time to set length of section
			secTime = max(secTime, (~score[sec][evt].time[0]*60) + ~score[sec][evt].time[1] + (~score[sec][evt].time[2]/10));

			// add list entry per event
			scoreProc[sec].add(nil);
			scoreBuf[sec].add(nil);
			bEvent[sec].add(nil);
			controlTask[sec].add(nil);

			// allocate buffers
			if((~score[sec][evt].type == \BufRec) || (~score[sec][evt].type == \BufLoad), {
				scoreBuf[sec][evt] = Buffer.alloc(s, (~score[sec][evt].params.len) * ~sRate, 2);
			});

			// if MIDI effects level control then create bus
			if(~score[sec][evt].type == \EffectOn, {
				if(~score[sec][evt].params.levelCC.notNil, {
					effectInGainBus[~score[sec][evt].params.levelCC] = Bus.control(s,1);
					effectInGainBus[~score[sec][evt].params.levelCC].set(0.5);
					effectInGainAvail = 1;
					if(effectInGainBusLabel[~score[sec][evt].params.levelCC].isNil,
						{effectInGainBusLabel[~score[sec][evt].params.levelCC] = ~score[sec][evt].desc});
				});
				if(~score[sec][evt].params.out.isNil, {~score[sec][evt].params.out = 0});
				if(~score[sec][evt].params.pitch.isNil, {~score[sec][evt].params.pitch = 0.5});
			});

			// check presence of MIDI event
			if(~score[sec][evt].type == \MIDI, {midiEventPresent = 1});

			// check presence of Trig event
			if(~score[sec][evt].type == \Trig, {trigEventPresent = 1});

			// check playBuf mode
			if(~score[sec][evt].type == \BufPlayStart, {
				if(~score[sec][evt].params.pitch.isNil, {~score[sec][evt].params.pitch = 1});
				if(~score[sec][evt].params.panDepth.isNil, {~score[sec][evt].params.panDepth = 0});
				if(~score[sec][evt].params.panSpeed.isNil, {~score[sec][evt].params.panSpeed = 0});
				if(~score[sec][evt].params.revmix.isNil, {~score[sec][evt].params.revmix = 0});
				if(~score[sec][evt].params.room.isNil, {~score[sec][evt].params.room = 0.9});
				if(~score[sec][evt].params.mode == "", {~score[sec][evt].params.mode = "straight"});
				if(~score[sec][evt].params.mode.isNil, {~score[sec][evt].params.put(\mode,"straight")});
				if(~score[sec][evt].params.out.isNil, {~score[sec][evt].params.out = 0});
			});

			// check DiskPlayStart mode
			if(~score[sec][evt].type == \DiskPlayStart,{
				if(~score[sec][evt].params.out.isNil, {~score[sec][evt].params.out = 0});
				if(~score[sec][evt].params.mono.isNil, {~score[sec][evt].params.mono = 0});
				if(~score[sec][evt].params.lp.isNil, {~score[sec][evt].params.lp = 0});
			});

			// check function mode
			if(~score[sec][evt].type == \functionStart, {
				if(~score[sec][evt].params.id.isNil, {~score[sec][evt].params.id = 1});
				if(~score[sec][evt].params.ampMode.isNil, {~score[sec][evt].params.ampMode = "over"});
				if(~score[sec][evt].params.levelCC.notNil, {
					ampFollowBus[~score[sec][evt].params.levelCC] = Bus.control(s,1);
					ampFollowBus[~score[sec][evt].params.levelCC].set(0.5);
					ampFollowAvail = 1;
					if(ampFollowBusLabel[~score[sec][evt].params.levelCC].isNil,
						{ampFollowBusLabel[~score[sec][evt].params.levelCC] = ~score[sec][evt].desc});
				});
			});

			// check score integrity
			if([\BufPlayStart,\BufPlayStop,\DiskPlayStop,\EffectOff,\Control].includes(~score[sec][evt].type), {
				if( ~score[sec][evt].params.srcSec < ~score.size,  {
					if( ~score[sec][evt].params.srcEvt < ~score[~score[sec][evt].params.srcSec].size, {

						case
						{~score[sec][evt].type == \BufPlayStart}
						{if((~score[~score[sec][evt].params.srcSec][~score[sec][evt].params.srcEvt].type != \BufRec) &&
							(~score[~score[sec][evt].params.srcSec][~score[sec][evt].params.srcEvt].type != \BufLoad), {
								(corrupt = 1; "\n### CORRUPT EVENT: section"+sec+"event"+evt+"(BufPlayStart)").postln;})}
						{~score[sec][evt].type == \BufPlayStop}
						{if(~score[~score[sec][evt].params.srcSec][~score[sec][evt].params.srcEvt].type != \BufPlayStart, {
							(corrupt = 1; "\n### CORRUPT EVENT: section"+sec+"event"+evt+"(BufPlay-Stop)").postln;})}
						{~score[sec][evt].type == \DiskPlayStop}
						{if(~score[~score[sec][evt].params.srcSec][~score[sec][evt].params.srcEvt].type != \DiskPlayStart, {
							(corrupt = 1; "\n### CORRUPT EVENT: section"+sec+"event"+evt+"(DiskPlay-Stop)").postln;})}
						{~score[sec][evt].type == \EffectOff}
						{if(~score[~score[sec][evt].params.srcSec][~score[sec][evt].params.srcEvt].type != \EffectOn, {
							(corrupt = 1; "\n### CORRUPT EVENT: section"+sec+"event"+evt+"(EffectOff)").postln;})}
						{~score[sec][evt].type == \Control}
						{if([\BufPlayStart,\DiskPlayStart,\EffectOn].includes(~score[~score[sec][evt].params.srcSec][~score[sec][evt].params.srcEvt].type) == false, {
							(corrupt = 1; "\n### CORRUPT EVENT: section"+sec+"event"+evt+"(Control)").postln;})}
						; // case

					}, { corrupt = 1; ("\n### CORRUPT EVENT: section"+sec+"event"+evt+"(Evt number out of range)").postln } );
				}, { corrupt = 1; ("\n### CORRUPT EVENT: section"+sec+"event"+evt+"(Sec number out of range)").postln } );
			});
		});

		// set section length
		scoreLength[sec] = secTime;

		// if no Trig event present, create one, but only if nu timeOutVal is set
		if((trigEventPresent ==0) && (~cfg.timeOutVal.isNil), {
			~score[sec] = ~score[sec].add((
				time: [((secTime*~cfg.triggerEnableFactor)/60).floor,((secTime*~cfg.triggerEnableFactor)%60).floor,0],
				type: \Trig,
				desc: "Enable trigger button"));
			scoreProc[sec].add(nil);
			scoreBuf[sec].add(nil);
			bEvent[sec].add(nil);
			controlTask[sec].add(nil);
		});
	});
	// message if score correct
	if(corrupt == 0, {"\n### Score checked, integrity OK.".postln;});

	// -------------------- SynthDefs ----------------------

	"Score-Synths.scd".loadRelative();
	s.sync;

	// -------------------- Arduino polling ----------------------

	if(~cfg.triggerMethod.includes(\ARD_DIG12), { // only connect Arduino if specified in project

		"\nTrying to connect Arduino...".postln;
		("Serial Devices:\n" + SerialPort.devices).postln;
		serialPort = SerialPort.devices.detect{|x| x.contains("tty.usb")};
		if(serialPort.notNil, {
			("Connected to serial port" + serialPort ++ ".").postln;
			ardSms = ArduinoSMS(serialPort, 115200);
			ardSms.action = { | ... msg |
				//		msg.postln;
				ardAna1 = min(1, max(0, (msg[0] - ardAna1Min )) / ardAna1Max);
				if(ardAna1 != ardAna1prev, {
					ardAna1prev = ardAna1;
					pedalBus.set(ardAna1);
					// ("Analog1:"+ardAna1).postln;
				});
				ardAna2 = min(1, max(0, (msg[1] - ardAna2Min )) / ardAna2Max);
				if(ardAna2 != ardAna2prev, {
					ardAna2prev = ardAna2;
					// ("Analog2:"+ardAna2).postln;
				});
				if(vTrigger==true, { // only if checkbox checked
					ardDig1 = msg[2];
					case
					{ardDig1 == 0 && ardDig1Avail == 0} {ardDig1Avail = 1} // sense availability of input 1
					{ardDig1 == 1 && ardDig1Avail == 1}
					{{bActSectTrig.valueAction_(1)}.defer()} // move to next section
					;
					ardDig2 = msg[3];
					case
					{ardDig2 == 0 && ardDig2Avail == 0} {ardDig2Avail = 1} // sense availability of input 2
					{ardDig2 == 1 && ardDig2Avail == 1}
					{{bActSectTrig.valueAction_(1)}.defer()} // move to next section
					;
				});
			};
			ardTask = Task({
				inf.do { ardSms.send($r);  0.05.wait; } // where $r is the Char r
			}).start;
		},
		{"No serial port found with name matching 'tty.usbmodem'.".postln}
		);

	}, {
		"\nBypassing all serial devices...".postln;
	});

	// -------------------- MIDI ----------------------

	if(~cfg.disableMIDI == 0, {

		MIDIIn.connectAll;

		// MIDI responder for trigger
		MIDIdef.cc(\scoreCC, {|value, num, chan|
			["CC", num,value, chan].postln;
			// triggers
			if((num == 66) && (value == 127) && (~cfg.triggerMethod.includes(\CC66)), { // for Sonata
				{bActSectTrig.valueAction_(1)}.defer(); // move to next section
			});
			if((num == 41) && (value == 127) && (chan==(3-1)) && (vTrigger==true) && (~cfg.triggerMethod.includes(\CC41)), { // for Black Pencil
				{bActSectTrig.valueAction_(1)}.defer(); // move to next section
			});
			// main output level control
			if(~cfg.mainOutCC.notNil, {
				if(num == ~cfg.mainOutCC, {
					{sVolume.valueAction_(value/127)}.defer();
				});
			});
			// effect input gain control
			effectInGainBus.size.do {arg cc;
				if((effectInGainBus[cc].notNil) && (cc==num),
					{if(wSystem.isClosed==false,
						{ {sEffectInGain[cc].valueAction_(value/127)}.defer },
						{effectInGainBus[cc].set(value/127)}
				)});
			};
			// ampFollow input gain control
			ampFollowBus.size.do {arg cc;
				if((ampFollowBus[cc].notNil) && (cc==num),
					{if(wSystem.isClosed==false,
						{ {sAmpFollow[cc].valueAction_(value/127)}.defer },
						{ampFollowBus[cc].set(value/127)}
				)});
			};
		}).fix;
		MIDIdef.noteOn(\scoreNoteOn, { |src,chan,note,value|
			//	["NON", src,chan,note,value].postln;
			// triggers
			if((note == 60) && (value > 0) && (~cfg.triggerMethod.includes(\NON60)), {
				{bActSectTrig.valueAction_(1)}.defer(); // move to next section
			});
		}).fix;

		// if MIDI events present then init MIDI out
		if(midiEventPresent == 1, {
			if(MIDIClient.initialized == false, {MIDIClient.init});
			if(MIDIClient.sources.size > 0, {
				midiPorts = MIDIClient.destinations.collect({ |x| (x.device++":"+x.name) });
				if(~cfg.midiOutPort >= midiPorts.size, {~cfg.midiOutPort = 0});
				midiOut = MIDIOut(~cfg.midiOutPort);
				midiDeviceAvailable = 1;
				("\nMIDI out set to"+midiPorts[~cfg.midiOutPort]).postln;
				midiPorts = midiPorts.insert(0,"--- MIDI output port ---");
			},
			{
				~cfg.midiOutPort = 0;
				midiDeviceAvailable = 0;
				midiPorts = [];
				"\n### ERROR: no MIDI device available".postln;
			});
		});

	}, { "\nMIDI disabled".postln } );

	// -------------------- functions ----------------------

	// function to display event information
	fStatus2Display = {
		arg object, string;
		tStatus2.visible = true;
		tStatus2.string = string.replace("\n","");
	};

	// function to play MIDI files
	fPlayMidi = {
		arg midiFilePath, midiChan;
		var midiPlayer, midiFile;
		if(midiDeviceAvailable == 1, {
			if(midiChan.isNil, {midiChan = 0});
			midiFile = SimpleMIDIFile.read(~cfg.libraryBase++~cfg.project++"/"++midiFilePath);
			("\nPlaying MIDI file" + midiFilePath).postln;
			midiPlayer = (midiFile.p2(amp:1, useTrackChan: true) <> (type: \midi, midiout: midiOut, chan: midiChan)).play;
			// see MIDIplayer code for explanation on MIDI channels
			},
			{
				"\n### ERROR: no MIDI file playing because no MIDI device is available".postln;
		});
		midiPlayer
	};

	// function to pause and resume MIDI file playing
	fMControl = {
		arg action, srcSec, srcEvt;
		("\n" ++ action.firstToUpper + "MIDI file" + ~score[srcSec][srcEvt].params.file).postln;
		case
		{action == "pause"} {if(scoreProc[srcSec][srcEvt].notNil, {scoreProc[srcSec][srcEvt].pause})}
		{action == "resume"} {if(scoreProc[srcSec][srcEvt].notNil, {scoreProc[srcSec][srcEvt].resume})}
		{action == "stop"} {if(scoreProc[srcSec][srcEvt].notNil, {scoreProc[srcSec][srcEvt].stop})}
		;
	};

	// start/stop effect
	fEffect = {
		arg sec, evt, effect, in, lev, att, rel, pitch;
		var effectSynth;
		("\nEffect" + effect + "ON").postln;
		// ~score[sec][evt].params.out.postln;
		if(~score[sec][evt].params.levelCC.notNil, { ("CC:" + ~score[sec][evt].params.levelCC).postln }, {"No CC".postln});
		effectSynth = Synth(effect, [\gate,1, \inChan1, in[0], \inChan2, in[1], \lev, lev, \att, att, \rel, rel, \pitch, pitch,
			\effectInGainBus, if(~score[sec][evt].params.levelCC.notNil,
				{effectInGainBus[~score[sec][evt].params.levelCC].index}, {effectInGainDefaultBus.index})	,
			\out, if(~score[sec][evt].params.out < ~efxOutBus.size,
				{~efxOutBus[~score[sec][evt].params.out]}, {~efxOutBus[0]})
			],
			target: efxGroup);
		if(~cfg.autoGui == 1, {effectSynth.autogui(specs: (\lev: [0,7]))});
		effectSynth
	};

	// starting next section
	fNextSection = {
		// stop current section
		if(activeSection != -1, {bScore[activeSection].valueAction_(0)});
		// go to next section
		if(cuedSection < bScore.size, {
			activeSection = cuedSection;
			sTime[cuedSection].valueAction_(0);
			bScore[cuedSection].valueAction_(2);
			},{
			"\nNo more cues to run".postln;
			fStopAll.value();
			activeSection = -1;
		});
	};

	// sending control data to processes
	fControl = {
		// specify process, parameter, from/to values 0..1, time (secs), wait, mode (line, sine, rand) and number of repeats
		arg sec, evt, srcSec, srcEvt, param, from, to, time, wait, mode, repeats;
		var diff = (from-to).abs, sign = (to-from).sign, freq = 1/wait, step = diff/(time*freq), value;
		("\nControl on section"+srcSec+"and event"+srcEvt+[param, from, to, time, wait, mode, repeats]).postln;
		case
		{mode == "point"}
		{
			// if param is a string (i.e. not an array) convert it and the to value into an array
			if(param.isString, {param = [param]; to = [to]});
			param.size.do({arg i;
				// send slightly different values first, this seems necessary in some cases
				scoreProc[srcSec][srcEvt].set(param[i],max(0,to[i]-0.01));
				{scoreProc[srcSec][srcEvt].set(param[i],min(1,to[i]+0.01))}.defer(0.1);
				{scoreProc[srcSec][srcEvt].set(param[i],to[i])}.defer(0.2);
			});
			("\nEND Control on section"+srcSec+"and event"+srcEvt+[param, from, to, time, wait, mode, repeats]).postln;
		}
		{mode == "line"}
		{
			controlTask[sec][evt] = Task.new({
				repeats.do({
					((time*freq)+1).do({arg count;
						value = from+(sign*step*count);
						scoreProc[srcSec][srcEvt].set(param,value);
						wait.wait;
					});
				});
				("\nEND Control on section"+srcSec+"and event"+srcEvt+[param, from, to, time, wait, mode, repeats]).postln;
			}).start;
		}
		{mode == "rand"}
		{
			controlTask[sec][evt] = Task.new({
				repeats.do({
					((time*freq)+1).do({arg count;
						value = round(rrand(from,to),0.01);
						scoreProc[srcSec][srcEvt].set(param,value);
						wait.wait;
					});
				});
				("\nEND Control on section"+srcSec+"and event"+srcEvt+[param, from, to, time, wait, mode, repeats]).postln;
			}).start;
		}
		{mode == "sine"}
		{
			controlTask[sec][evt] = Task.new({
				repeats.do({
					((time*freq)+1).do({arg count;
						value = (if(sign==1,{from},{to})) + (diff * (0.5 + (0.5 * sin(2pi * (count/(time*freq))))));
						scoreProc[srcSec][srcEvt].set(param,value);
						wait.wait;
						value.postln;
					});
				});
				("\nEND Control on section"+srcSec+"and event"+srcEvt+[param, from, to, time, wait, mode, repeats]).postln;
			}).start;
		}
		;
	};

	// stop all processes
	fStopAll = {
		arg forced = 0, onClose = 0;
		if(systemRunning == 1, {
			{ s.stopRecording }.defer(~cfg.recordingTail);
			systemRunning = 0;
		});
		sine440.free; sine440 = nil;
		tListenerTest.stop; tListenerCheat.stop;
		~score.size.do({arg sec;
			~score[sec].size.do({arg evt;
				if(scoreProc[sec][evt].notNil, {
					case
					{~score[sec][evt].type == \MIDI}
					{scoreProc[sec][evt].stop}
					{~score[sec][evt].type == \DiskPlayStart}
					{scoreProc[sec][evt].remove}
					{~score[sec][evt].type == \BufPlayStart}
					{scoreProc[sec][evt].set(\gate,0)}
					{~score[sec][evt].type == \EffectOn}
					{scoreProc[sec][evt].set(\gate,0)}
					{~score[sec][evt].type == \functionStart}
					{runFuncs[~score[sec][evt].params.func].value("stop")}
					; // case
					scoreProc[sec][evt] = nil;
				});
				if(controlTask[sec][evt].notNil, {
					controlTask[sec][evt].stop;
					controlTask[sec][evt] = nil;
				});
			});
		});
		if(forced == 0, {
			"\nAll processes stopped".postln;
			},{
				efxGroup.free; sampleGroup.free; funcGroup.free;
				"\nAll processes stopped (forced)".postln;
				efxGroup = Group.new(); sampleGroup = Group.new(efxGroup, \addAfter); funcGroup = Group.new();
		});
		if(onClose == 0, { // don't if we're closing the window
			// reset GUI
			~score.size.do {arg i;
				sTime[i].valueAction_(0);
			};
			trigTimeOut = 0;
			bActSectTrig.enabled_(true);
		});
	};

	// buffer reading
	fBufferRead = {
		arg sampleFilePath, buffer;
		var tempFile;
		sampleFilePath = ~cfg.libraryBase++~cfg.project++"/"++sampleFilePath;

		("\nReading sample" + sampleFilePath + "into buffer").postln;
		tempFile = SoundFile.new;
		if(tempFile.openRead(sampleFilePath),
			{
				// prepare for loading mono samples
				if( tempFile.numChannels == 1, {m = 0;}, {m = 1;});
				// the actual read of the buffer
				buffer.readChannel(sampleFilePath, channels: [0,m]);
				tempFile.close;
			},
			{("Soundfile" + sampleFilePath + "not found.").postln});
	};

	// function to use within a Routine later to run sections
	runSection = {
		var sec, minutes, seconds;
		var startTime = SystemClock.seconds;
		var actDesc = "", nextDesc = "";
		sec = activeSection;

		if(~cueNames.notNil, {actDesc = ~cueNames[sec]; nextDesc = ~cueNames[(sec+1)%~cueNames.size]});
		if(~cueDescriptions.size > 0 , {actDesc = ~cueDescriptions[sec]; nextDesc = ~cueDescriptions[(sec+1)%~cueDescriptions.size]});
		("\n\t\t\t\t    ###  Cue"+sec+"("++actDesc++") started").postln;
		("\t\t\t\t    ###  Next: Cue"+((sec+1)%~score.size)+"("++nextDesc++")").postln;

		forBy(fromPos[sec], scoreLength[sec], 1, { arg count;
			// ("Time:"+count.asTimeStringHM).postln;
			minutes = (count/60).floor; seconds = count%60;
			// reposition slider
			{sTime[sec].valueAction_(count/scoreLength[sec])}.defer();

			// loop through score and check which event needs to be started
			~score[sec].size.do({arg evt;
				if((~score[sec][evt].time[0] == minutes) && (~score[sec][evt].time[1] == seconds), {
					{
						case
						{~score[sec][evt].type == \MIDI}
						{scoreProc[sec][evt] = fPlayMidi.value(~score[sec][evt].params.file, ~score[sec][evt].params.chan)}
						{~score[sec][evt].type == \MControl}
						{fMControl.value(~score[sec][evt].params.action,
							~score[sec][evt].params.srcSec, ~score[sec][evt].params.srcEvt)}
						{(~score[sec][evt].type == \DiskPlayStart) && (~cfg.playSoundtrack == 1) &&
							((~score[sec][evt].desc != "Instruments") || (~cfg.playInstruments == 1))}
						{
							scoreProc[sec][evt] = DiskPlayer.new(s,
								~cfg.libraryBase++~cfg.project++"/"++~score[sec][evt].params.file,
								if(~score[sec][evt].params.out < ~sampleOutBus.size,
									{~sampleOutBus[~score[sec][evt].params.out]},
									{~sampleOutBus[0]}),
								sampleGroup,
								~score[sec][evt].params.lp,
								~score[sec][evt].params.att,
								~score[sec][evt].params.rel,
								~score[sec][evt].params.lev,
								mono: ~score[sec][evt].params.mono
							);
							scoreProc[sec][evt].start(altOutLev: ~cfg.altOutputLevel);
						}
						{~score[sec][evt].type == \DiskPlayStop}
						{
							if(scoreProc[~score[sec][evt].params.srcSec][~score[sec][evt].params.srcEvt].notNil, {
								scoreProc[~score[sec][evt].params.srcSec][~score[sec][evt].params.srcEvt].remove;
								scoreProc[~score[sec][evt].params.srcSec][~score[sec][evt].params.srcEvt] = nil
							});
						}
						{~score[sec][evt].type == \EffectOn}
						{scoreProc[sec][evt] = fEffect.value(sec, evt,
							~score[sec][evt].params.effect, ~score[sec][evt].params.in, ~score[sec][evt].params.lev,
							~score[sec][evt].params.att, ~score[sec][evt].params.rel, ~score[sec][evt].params.pitch
						)}
						{~score[sec][evt].type == \EffectOff}
						{
							"\nEffect OFF".postln;
							if(scoreProc[~score[sec][evt].params.srcSec][~score[sec][evt].params.srcEvt].notNil, {
								scoreProc[~score[sec][evt].params.srcSec][~score[sec][evt].params.srcEvt].set(\gate,0);
								scoreProc[~score[sec][evt].params.srcSec][~score[sec][evt].params.srcEvt] = nil
							});
						}
						{~score[sec][evt].type == \BufRec}
						{
							"\nStarting buffer recording".postln;
							scoreProc[sec][evt] = Synth(\bufRec, [\gate,1, \buf, scoreBuf[sec][evt],
								\inChan1, ~score[sec][evt].params.in[0], \inChan2, ~score[sec][evt].params.in[1],
								\start, ~score[sec][evt].params.start, \len, ~score[sec][evt].params.len,
								\gainBus, samplingInGainBus.index], target: sampleGroup);
						}
						{~score[sec][evt].type == \BufLoad}
						{
							"\nStarting buffer load".postln;
							fBufferRead.value(~score[sec][evt].params.file, scoreBuf[sec][evt]);
						}
						{~score[sec][evt].type == \BufPlayStart}
						{
							"\nStarting buffer playback".postln;
							scoreProc[sec][evt] = Synth("bufPlay"++~score[sec][evt].params.mode.firstToUpper, [\gate,1,
								\buf, scoreBuf[~score[sec][evt].params.srcSec][~score[sec][evt].params.srcEvt],
								\start, ~score[sec][evt].params.start, \pitch, ~score[sec][evt].params.pitch,
								\len, ~score[sec][evt].params.len, \lev, ~score[sec][evt].params.lev,
								\att, ~score[sec][evt].params.att, \rel, ~score[sec][evt].params.rel,
								\panDepth, ~score[sec][evt].params.panDepth, \panSpeed, ~score[sec][evt].params.panSpeed,
								\revmix, ~score[sec][evt].params.revmix, \room, ~score[sec][evt].params.room,
								\pedalBus, pedalBus.index,
								\out, if(~score[sec][evt].params.out < ~sampleOutBus.size,
									{~sampleOutBus[~score[sec][evt].params.out]}, {~sampleOutBus[0]})
							], target: sampleGroup);
							if(~cfg.autoGui == 1, {scoreProc[sec][evt].autogui});
						}
						{~score[sec][evt].type == \BufPlayStop}
						{
							"\nStopping buffer playback".postln;
							if(scoreProc[~score[sec][evt].params.srcSec][~score[sec][evt].params.srcEvt].notNil, {
								scoreProc[~score[sec][evt].params.srcSec][~score[sec][evt].params.srcEvt].set(\gate,0);
								scoreProc[~score[sec][evt].params.srcSec][~score[sec][evt].params.srcEvt] = nil
							});
						}
						{~score[sec][evt].type == \Control}
						{fControl.value(sec, evt, ~score[sec][evt].params.srcSec, ~score[sec][evt].params.srcEvt,
							~score[sec][evt].params.param, ~score[sec][evt].params.from,
							~score[sec][evt].params.to, ~score[sec][evt].params.time, ~score[sec][evt].params.wait,
							~score[sec][evt].params.mode, ~score[sec][evt].params.repeats
						)}
						{~score[sec][evt].type == \Trig}
						{
							trigTimeOut = 0;
							bActSectTrig.enabled_(true);
						}
						{~score[sec][evt].type == \functionStart}
						{
							("\nStarting function" + ~score[sec][evt].params.func).postln;
							scoreProc[sec][evt] = runFuncs[~score[sec][evt].params.func].value("start", sec, evt,
								~score[sec][evt].params.in, ~score[sec][evt].params.mode, ~score[sec][evt].params.maxTime,
								~score[sec][evt].params.thresh,~score[sec][evt].params.freqFrom,~score[sec][evt].params.freqTo,
								~score[sec][evt].params.ampMode);
						}
						{~score[sec][evt].type == \functionStop}
						{
							("\nStopping function" + ~score[sec][evt].params.func).postln;
							runFuncs[~score[sec][evt].params.func].value("stop");
						}
						; // case
					}.defer(~score[sec][evt].time[2]/10) // defer by the number of dec seconds div 10
				});
			});

			// one more second down
			1.wait;
		});
		// wait rest-time
		("\nRest time cue"+sec++":"+(scoreLength[sec] - (scoreLength[sec].floor))).postln;
		(scoreLength[sec] - (scoreLength[sec].floor)).wait;
		("\nCue"+sec+"finished after"+(SystemClock.seconds-startTime)+"seconds").postln;
		{
			// if last section stop cue, reset activeSection and stop all
			if(sec == (~score.size-1), {
				bScore[sec].valueAction_(0);
				activeSection = -1;
				fStopAll.value()
			}, { // if not last section trigger next one if configured to do so
					if(~cfg.playContinuous == 1,
						{
							bActSectTrig.valueAction_(1)
						},
						{
							if(~cfg.countBars == 1, {fBarCount.value(action: "stop")})
						}
					);
			});
		}.defer();
	};

	// keyDownAction actions
	fKeyDown = {
		arg keycode, modifiers;
		// keycode.postln;
		// Esc stops sound output
		if((keycode == 53), {
			fStopAll.value(forced: 1);
			if((activeSection > -1) && (activeSection <= ~score.size), {bScore[activeSection].valueAction_(0)});
		});
		// T trigger to move to next section
		if((keycode == 17), { bActSectTrig.valueAction_(1) });
		// page down to select next cue
		if((keycode == 125), { if(dCueSect.enabled == true, {dCueSect.valueAction_(min(~score.size,dCueSect.value+1)) });
		});
		// page up to select previous cue
		if((keycode == 126), { if(dCueSect.enabled == true, {dCueSect.valueAction_(max(0,dCueSect.value-1))}) });
		// M to show meter
		if((keycode == 46), { s.meter });
		// A to play tuning A
		if((keycode == 0) && (modifiers == 0), { if(sine440.isNil, {sine440 = Synth(\sine440)}, {sine440.set(\gate, 0); sine440 = nil}) });
		// frequency follower cheat
		if( (keycode==8) && modifiers.isAlt, {
			tListenerCheat = Task({
				listenerCheat = 1; "Cheating started".postln;
				rrand(3.0,4.0).wait;
				listenerCheat = 0; "Cheating stopped".postln;
			}).start;
		});
		// test OSC reception
		if( (keycode==31) && modifiers.isAlt, {
			"Testing OSC messaging: the progress bar on the iPhone running TouchOSC should be moving now".postln;
			tListenerTest = Task({
				300.do { |i|
					netaddrTouchOSC.sendMsg("/1/fader1", (i+1) / 300);
					0.1.wait;
				};
				netaddrTouchOSC.sendMsg("/1/fader1", 0);
			}).start;
		});
		// Apple Q
		if(modifiers.isCmd && (keycode == 12), { 0.exit; "EXIT".postln; });
	};

	// function to display bar count
	fBarCount = {
		arg startBar = 1, tempo = 48, action = "start";
		var bar = startBar, beat = 1;

		if(action == "start", {
			tBarCount = Task({
				~cfg.barInitWait.wait;
				inf.do { arg i;
					// ["bar",bar,"beat",beat].postln;
					~cfg.blinkTime = min(~cfg.blinkTime, (4/~barCounts[bar][1])*60/tempo);
					if(~cfg.clickTrack.notNil, {
						if(beat==1, {Synth(\snare, [\out,~cfg.clickTrack])}, {Synth(\hihat, [\out, ~cfg.clickTrack])});
					});
					tBar.states_([[bar.asString]]);
					tBeat.states_([[beat.asString]]);
					// blink ON
					if(beat==1,
						{tBar.background_(color.actCue).stringColor_(Color.white)},
						{if(~cfg.beatBlink==1, {tBeat.background_(color.actCue).stringColor_(Color.white)})}
					);
					~cfg.blinkTime.wait;
					// blink OFF
					if(beat==1,
						{tBar.background_(Color.white).stringColor_(Color.black)},
						{if(~cfg.beatBlink==1, {tBeat.background_(Color.white).stringColor_(Color.black)})}
					);
					(((4/~barCounts[bar][1])*60/tempo) - ~cfg.blinkTime).wait;
					if(beat == ~barCounts[bar][0], {beat = 0; bar = bar + 1});
					beat = beat + 1;
				};
			}).start;
			},{
				tBarCount.stop;
		})
	};

	// this function outputs random combinations of words to a TextView or the postwindow / used in MOROS
	runFuncs.deliverLines = {
		arg action = "start";
		var words1 = ["sore", "distressed", "dust", "deadly", "conflict", "were", "folk", "sudden", "hand", "Blessed", "One", "swept", "dust-pall", "aside",  "Gods", "saw", "deadly", "Fates", "hurling", "charging", "lines", "together", "unending", "wrestle", "locked","grim", "conflict", "saw", "never", "ceased", "Ares", "hideous", "slaughter", "saw", "earth", "crimsoned", "round", "rushing", "streams", "blood", "saw",  "dark", "Destruction", "gloated", "scene"], words2 = ["with", "and", "the", "with", "all", "a", "the", "and", "the", "the",  "the", "in", "the",  "of",  "from",  "the",  "with", "of", "that", "the"], words3 = ["then", "some", "where", "where", "over"];
		var words1Len = words1.size, words2Len = words2.size, words3Len = words3.size, line1, line2, line3, line4, lineIndex, chosenLine, savedLine = "sore and distressed", chosenWait, savedWait = 1.2;

		if(action=="start", {
			runFuncs.deliverLinesTask = Task({
				if(tLines.notNil, { {tLines.string = "\n [start exclamating text in 2 seconds]"}.defer() },{ "[start exclamating text in 2 seconds]".postln });
				2.wait;
				inf.do{
					line1 = words1[rrand(0,words1Len-1)] + words1[rrand(0,words1Len-1)];
					line2 = words1[rrand(0,words1Len-1)] + words2[rrand(0,words2Len-1)] + words1[rrand(0,words1Len-1)];
					line3 = words3[rrand(0,words3Len-1)] + words1[rrand(0,words1Len-1)] + words2[rrand(0,words2Len-1)] + words1[rrand(0,words1Len-1)];
					line4 = words3[rrand(0,words3Len-1)] + words1[rrand(0,words1Len-1)] + words2[rrand(0,words2Len-1)] + words1[rrand(0,words1Len-1)] + words1[rrand(0,words1Len-1)];
					lineIndex = [0,1,2,3,4].wchoose([0.1,0.2,0.3,0.3,0.1]);
					chosenLine = [line1,line2,line3,line4,savedLine][lineIndex];
					if(tLines.notNil, { {tLines.string = "\n " ++ chosenLine}.defer() },{ chosenLine.postln });
					chosenWait = [0.8,1.2,1.8,2.3,savedWait][lineIndex] * rrand(0.8,1.2);
					chosenWait.wait;
					if(tLines.notNil, { {tLines.string = ""}.defer() });
					0.1.wait;
					savedLine = chosenLine;
					savedWait = chosenWait;
				};
			}).play;
			"Task DeliverLines started".postln;
		});

		if(action=="stop", {
				runFuncs.deliverLinesTask.stop;
				if(tLines.notNil, { {tLines.string = ""}.defer(1) });
			}
		);

		"Return something to populate scoreProc[sec][evt]";
	};

	// this function measures the time the specified input signal is above a specified threshold or the freq is within a range
	// and advances the cue if a specified time limit is reached - used in Untitled for Anne
	runFuncs.listener = {
		arg action = "start", sec, evt, inChan = 0, mode = "ampFollow", maxTime = 2, threshold, freqFrom = 10, freqTo = 20000, ampMode = "over", justTrack = 0;
		var totalTime = 0, amp = 0, dur = 0.01, freq = 0, hasFreq = 0, ampLagged = 0;

		if(threshold.isNil, {threshold = ~lowThreshold.dbamp});

		if(action == "start", {
			// start Synth to follow amplitude/frequency
			if(runFuncs.listenerSynth.isNil, {
				("Input channel"+inChan).postln;
				runFuncs.listenerSynth = Synth(\listener, [\inChan, inChan,
					\ampFollowBus, if(~score[sec][evt].params.levelCC.notNil,
						{ampFollowBus[~score[sec][evt].params.levelCC].index}, {effectInGainDefaultBus.index})
				], target: funcGroup)
			});

			if(justTrack == 0, { // don't do this if we're just tracking through the button on the AmpPitchTrack window
				if(sListener.notNil, {sListener.string =
					case
					{mode=="ampFollow"} {"amplitude"+(if(ampMode=="over", {">"},{"<"}))+threshold.ampdb.round(0.1)+"db"}
					{mode=="freqFollow"} {"frequency"+freqFrom++"-"++freqTo+"Hz"}
					++"\ntotal time"+maxTime+"sec"});

				case
				{mode == "ampFollow"}
				{
					// start Task to measure time with amp above threshold
					listenerCheat = 0; // just switch cheating off to be sure
					runFuncs.listenerTask = Task({
						if(touchOSCsending==1, {netaddrTouchOSC.sendMsg("/1/fader1", 0)});
						inf.do {
							dur.wait;
							if( (  (amp>threshold) && (ampMode=="over") ) || ( (amp<threshold) && (ampMode=="silent") ) || ( listenerCheat==1 ), {
								totalTime = totalTime+dur;
								// Send OSC to TouchOSC
								if(touchOSCsending==1, {netaddrTouchOSC.sendMsg("/1/fader1", (totalTime / maxTime))});
								// update GUI
								if(bListener.notNil,
									{bListener.value = 1; {bListener.value = 0}.defer(0.3)},
									{"Listener: amplitude threshold reached".postln});
								if(sListener.notNil, {sListener.value = totalTime / maxTime}, {("TotalTime"+totalTime+"of"+maxTime).postln});
							});
							// totalTime.postln;
							if(totalTime>maxTime, {
								"Time limit reached".postln;
								runFuncs[\listener].value("stop");
								if(touchOSCsending==1, {netaddrTouchOSC.sendMsg("/1/fader1", 0)});
								{ fNextSection.value() }.defer();
							});
						}
					}).start;
				}
				{mode == "freqFollow"}
				{
					// start Task to measure time with freq in range
					listenerCheat = 0; // just switch cheating off to be sure
					runFuncs.listenerTask = Task({
						if(touchOSCsending==1, {netaddrTouchOSC.sendMsg("/1/fader1", 0)});
						inf.do {
							dur.wait;
							if( ( (freqFrom<freq) && (freq<freqTo) && (hasFreq==1) ) || ( listenerCheat == 1 ), {
								totalTime = totalTime+dur;
								// Send OSC to TouchOSC
								if(touchOSCsending==1, {netaddrTouchOSC.sendMsg("/1/fader1", (totalTime / maxTime))});
								// update GUI
								if(bListener.notNil, {bListener.value = 1; {bListener.value = 0}.defer(0.3)}, {"Listener: frequency in range".postln});
								if(sListener.notNil, {sListener.value = totalTime / maxTime}, {("TotalTime"+totalTime+"of"+maxTime).postln});
							});
							// totalTime.postln;
							if(totalTime>maxTime, {
								"Time limit reached".postln;
								runFuncs[\listener].value("stop");
								if(touchOSCsending==1, {netaddrTouchOSC.sendMsg("/1/fader1", 0)});
								{ fNextSection.value() }.defer();
							});
						}
					}).start;
				}
				;
			});

			// start OSC responder to track
			OSCdef(\scoreListener, { |msg|
				amp = msg[3]; freq = msg[4].round(1); hasFreq = msg[5]; ampLagged = msg[6];
				// [amp.ampdb.round(0.1), freq, hasFreq].postln;
				if(wAmpPitch.notNil, { // update Tracking Window GUI
					freqSlider.valueAction_(~spec.freq.unmap(freq));
					{ freqText.states_([[freq.asString, Color.black, Color.white]]) }.defer();
					ampSlider.valueAction_(amp.curvelin(curve:6));
					{ ampText.states_([[amp.ampdb.round(1).asString, Color.black, Color.white]]) }.defer();
					// update multisliderview
					{
						if(freq > freqLow, {
							msFreq.index = ((freq-freqLow) / 25).floor;
							if(hasFreq == 1, {msFreq.currentvalue = msFreq.currentvalue + 0.01});
						});
					}.defer();
				});
			}, "/listener");
		});

		if(action == "stop", {
			// reset GUI
			if(bListener.notNil, {bListener.value = 0});
			if(sListener.notNil, {sListener.value = 0; sListener.string = ""});
			// stop Synth to follow amplitude
			runFuncs.listenerSynth.free;
			runFuncs.listenerSynth = nil;
			// stop Task
			runFuncs.listenerTask.stop;
			// remove OSC responder to track hits
			OSCdef(\scoreListener).free;
		});

		"Return something to populate scoreProc[sec][evt]";
	};

	// -------------------- GUI ----------------------

	wControl = (Window("Score System" + /*~cfg.version +*/ " | " + ~cfg.title,Rect(40,screenHeight-170,1200,105), resizable: true)
		.background_(Color.grey(0.8)).alpha_(~cfg.alpha));

	wScore = (Window("Cues", Rect(40,screenHeight-775,1200,600), resizable: false, scroll: (if(~cfg.detailMode==2,{false},{true})))
		.background_(Color.grey(0.7)).alpha_(~cfg.alpha).acceptsMouseOver_(true));
	wScore.view.background_(Color.grey(0.8));

	wSystem = (Window("System", Rect(20,260,650,200), resizable: false)
		.background_(Color.grey(0.8)).alpha_(~cfg.alpha)
		.onClose_({~wSystemAvail = nil})
	);

	// -------------------- Control Window ----------------------

	lActSect = (StaticText(wControl, Rect(20,20,60,40))
		.canFocus_(false)
		.font_(Font(~cfg.font,20))
		.string_("Now:") );

	tActSect = (SmoothButton(wControl, Rect(80,10,130,60))
		.radius_(2)
		.border_(1)
		.font_(Font(~cfg.font,30))
		.stringColor_(color.actCueTxt)
		.canFocus_(false)
		.background_(color.actCue)
		.states_([["---"]]) );

	lCueSect = (StaticText(wControl, Rect(240,20,60,40))
		.canFocus_(false)
		.font_(Font(~cfg.font,20))
		.string_("Next:") );

	dCueSect = (PopUpMenu(wControl, Rect(300,10,130,60))
		.font_(Font(~cfg.font,30))
		// .canFocus_(false)
		.background_(color.nextCue)
		.stringColor_(color.nextCueTxt)
		.items_(~cueNames)
		.value_(cuedSection)
		.keyDownAction_({false})
		.action_({
			cuedSection = dCueSect.value;
			if((cuedSection < ~score.size) && ((cuedSection != activeSection) || (bScore[activeSection].value == 0)),
				{bScore[cuedSection].value_(1)});
			~score.size.do({arg i;
				if((i != cuedSection) && ((i != activeSection) || (bScore[activeSection].value == 1)),
					{bScore[i].value_(0)});
			});
			// display bars/beats if applicable
			if(~cfg.countBars == 1, {tBar.states_([[~cueBars[cuedSection].asString]]); tBeat.states_([["--"]]);});
			// display description if applicable
			if(bCueDesc.notNil, {
				if(~cueDescriptions.size > cuedSection, { bCueDesc.string = ~cueDescriptions[cuedSection] } )
			});
			["activeSection:",activeSection,"cuedSection:",cuedSection].postln;
	}) );

	if(~cfg.countBars == 1, {
		lCueSect.bounds_(Rect(520,20,60,40));
		dCueSect.bounds_(Rect(580,10,130,60));
		lBar = (StaticText(wControl, Rect(230,20,120,40))
			.canFocus_(false)
			.font_(Font(~cfg.font,20))
			.string_("Bar & beat:") );
		tBar = (SmoothButton(wControl, Rect(340,10,80,60))
			.radius_(2)
			.border_(1)
			.font_(Font(~cfg.font,40))
			.stringColor_(Color.black)
			.canFocus_(false)
			.background_(Color.white)
			.states_([["--"]])
		);
		tBeat = (SmoothButton(wControl, Rect(420,10,80,60))
			.radius_(2)
			.border_(1)
			.font_(Font(~cfg.font,30))
			.stringColor_(Color.black)
			.canFocus_(false)
			.background_(Color.white)
			.states_([["--"]])
		);
	}, { // if not counting bars, show message that we're running
		tRunning = (SmoothButton(wControl, Rect(650,10,80,60))
			.radius_(2)
			.border_(1)
			.font_(Font(~cfg.font,12))
			.stringColor_(Color.black)
			.canFocus_(false)
			.background_(Color.white)
			.states_([["System \n\nStopped"], ["System \n\nRunning", Color.white, Color.red]])
		);
	});

	bActSectTrig = (SmoothButton(wControl,Rect(760,10,80,18))
		.canFocus_(false)
		.radius_(2)
		.border_(1)
		.states_([["Trigger (T)"]])
		.background_(color.backGr)
		.font_(Font(~cfg.font,12))
		.action_({
			if(trigTimeOut == 0, { // if we're not in the time-out period
				{fNextSection.value()}.defer(); // move to next section
				trigTimeOut = 1;
				// bActSectTrig.setProperty(\enabled,false);
				bActSectTrig.enabled_(false);
				// time-out
				if(~cfg.timeOutVal.notNil, { // only schedule enabling if timeOutVal is set
					{trigTimeOut = 0; bActSectTrig.enabled_(true);}.defer(~cfg.timeOutVal);
				});
			});
	}) );

	bStopAll = (SmoothButton(wControl,Rect(760,32,80,18))
		.canFocus_(false)
		.radius_(2)
		.border_(1)
		.states_([["Stop (esc)"]])
		.font_(Font(~cfg.font,12))
		.background_(color.backGr)
		.action_({
			fStopAll.value();
			if(activeSection > -1, {bScore[activeSection].valueAction_(0)});
	}) );

	cPlayInstr = (CheckBox(wControl, Rect(890,32,16,16))
		.canFocus_(false)
		.background_(Color.white)
		.value_(~cfg.playInstruments == 1)
		.action_({~cfg.playInstruments = if(cPlayInstr.value,{1},{0})}));
	lPlayInstr = (StaticText(wControl, Rect(910,32,200,18))
		.canFocus_(false)
		.font_(Font(~cfg.font,10))
		.string_("Play Instrumental Parts") );

	cTrigger = (CheckBox(wControl, Rect(1035,32,16,16))
		.canFocus_(false)
		.background_(Color.white)
		.value_(vTrigger)
		.action_({ vTrigger = cTrigger.value }));
	lTrigger = (StaticText(wControl, Rect(1055,32,200,18))
		.canFocus_(false)
		.font_(Font(~cfg.font,10))
		.string_("Ext trig act"+~cfg.triggerMethod) );

	lVolume = (StaticText(wControl, Rect(890,10,100,18))
		.canFocus_(false)
		.font_(Font(~cfg.font,10))
		.string_("Output"+ if(~cfg.mainOutCC.notNil,{"(CC"++~cfg.mainOutCC++")"},{"level"})));
	sVolume = (SmoothSlider(wControl, Rect(960,10,220,18))
		.canFocus_(false)
		.hilightColor_(color.nextCue)
		.stringColor_(color.nextCueTxt)
		.align_(\left)
		.font_(Font(~cfg.font,10))
		.action_({
			var value = ~spec.volume.at(sVolume.value);
			volBus.set(value);
			sVolume.string = "  " + round(value.ampdb,0.1) + "db  ";
	}) );

	// cRecord = (CheckBox(wControl, Rect(890,48,30,30))
	// 	.value_(~cfg.record==1)
	// 	.action_({
	// 		~cfg.record = if(cRecord.value, {1},{0});
	// 		if(~cfg.record == 1, {("Recording enabled to folder"+thisProcess.platform.recordingsDir).postln}, {"Recording disabled".postln});
	// 	})
	// );
	lRecord = (StaticText(wControl, Rect(890,54,150,25)).canFocus_(false)
		.align_(\middle).visible_(~cfg.detailMode==0)
		.font_(Font(~cfg.font,20)).string_("!! REC"+if(~cfg.record==1,{"ON"},{"OFF"})+"!!").stringColor_(Color.red)
	);

	if(midiEventPresent == 1, {
		bMidiMonitor = (SmoothButton(wControl, Rect(760,54,80,18))
			.canFocus_(false)
			.radius_(2)
			.border_(1)
			.font_(Font(~cfg.font,12))
			.states_([["MIDI monitor"]])
			.background_(color.backGr)
			.action_({
				"osascript -e 'tell application \"Midi Monitor\" to activate'".unixCmd;
		}) );

		dMidiOut = (PopUpMenu(wControl, Rect(1000,54,180,18))
			.canFocus_(false)
			.font_(Font(~cfg.font,10))
			.background_(Color.white)
			.background_(color.backGr)
			.items_(midiPorts)
			.value_(~cfg.midiOutPort+1)
			.action_({
				if(dMidiOut.value > 0, {midiOut = MIDIOut(dMidiOut.value-1).latency_(0.01)});
		}) );
	});

	// status bar
	uStatus = (UserView(wControl, Rect(0, wControl.bounds.height-20, wControl.bounds.width, 40))
		.background_(Color.grey.alpha_(0.1)).canFocus_(false) );

	// score integrity message
	tStatus1 = (StaticText(wControl,Rect(wControl.bounds.width-300,wControl.bounds.height-18,280,~cfg.elementHeight))
		.align_(\right).canFocus_(false) );
	tStatus1.string = "[" + if(~cfg.stereoPlayback == 1, {"Stereo"},{"Multichannel"}) + "playback ]";
	if(corrupt==1,{
		tStatus1.string_("[ Score corrupt / check post window for details ]").stringColor_(Color.red).font_(Font(~cfg.font,10));
		},{
		tStatus1.font_(Font(~cfg.font,10)).string_(tStatus1.string + "[ Score integrity OK ]");
	});

	// event display
	tStatus2 = (StaticText(wControl, Rect(20,wControl.bounds.height-18, 1000,~cfg.elementHeight))
		.string_("").font_(Font(~cfg.font,10)).visible_(false) );

	// canvas to hide status message when not hovering over event button
	uCanvas = (UserView(wScore, Rect(0,0,wScore.bounds.width-20,wScore.bounds.height))
		.mouseOverAction_({ tStatus2.string_("").visible_(false)}) );

	// -------------------- Score Window ----------------------

	// section elements
	~score.size.do({arg sec;
		bEventTime = List.new(0);
		sectionShift = sectionShiftNew;
		sectionShiftTotal = sectionShiftTotal + sectionShiftNew;
		sectionShiftNew = 0;
		//	["sectionShift",sectionShift, sectionShiftTotal].postln;
		bScore[sec] = (SmoothButton(wScore, Rect(20,~cfg.sectStart+(sec*~cfg.sectVerticalSpace)+sectionShiftTotal,100,~cfg.elementHeight))
			.canFocus_(false)
			.font_(Font(~cfg.font,12))
			.radius_(2)
			.border_(1)
			.states_([[~cueNames[sec],Color.black, Color.white],[~cueNames[sec]+"next",Color.black, color.nextCue],
				[~cueNames[sec]+"runs",Color.white, color.actCue]])
			.action_({
				// cue is stopped
				if(bScore[sec].value == 0,{
					// enable other start buttons, sliders and numberboxes
					~score.size.do({arg i;
						sTime[i].setProperty(\enabled, true);
						if(i != sec, {bScore[i].enabled_(true)});
					});
					nCount[sec].background_(Color.white).stringColor_(Color.black);
					dCueSect.enabled_(true);
					tActSect.states = [["---"]];
					trigTimeOut = 0;
					bActSectTrig.enabled_(true);
					if(~cfg.countBars==1, {
						tBar.background_(Color.white).stringColor_(Color.black); tBeat.background_(Color.white).stringColor_(Color.black)});
					// stop task
					activeSectionTask.stop;
					// stop barCount
					if(~cfg.countBars == 1,
						{fBarCount.value(action: "stop")},
						{tRunning.value = 0}
					);
				});
				// when this cue is armed, disarm other cues and select cue as next
				if(bScore[sec].value == 1,{
					dCueSect.valueAction_(sec);
				});
				// cue is triggered
				if(bScore[sec].value == 2,{
					// recording
					if( (systemRunning == 0) && (~cfg.record==1), {
						systemRunning = 1;
						("RECORDING"+~cfg.recChans+"channels ############################\n").warn;
						s.record(thisProcess.platform.recordingsDir++"/Score_"++~cfg.project++
							Date.getDate.format("_%y%m%d_%H%M%S.")++s.recHeaderFormat.toLower);
					});
					// disable other start buttons, sliders and numberboxs
					~score.size.do({arg i;
						sTime[i].setProperty(\enabled, false);
						if(i != sec, {bScore[i].enabled_(false)});
					});
					nCount[sec].background_(color.actCue).stringColor_(Color.white);
					dCueSect.enabled_(false);
					activeSection = sec;
					dCueSect.valueAction = sec+1;
					tActSect.states = [[~cueNames[activeSection]]];
					// run task
					activeSectionTask = Task(runSection).start;
					// run barCount or display 'running'
					if(~cfg.countBars == 1,
						{fBarCount.value(~cueBars[sec],~cueTempi[sec])},
						{tRunning.value = 1}
					);
					// auto scroll
					if(~cfg.detailMode!=2, {
						if(~cfg.sectStart+(sec*~cfg.sectVerticalSpace)+sectionShiftTotal > 500,
							{wScore.view.visibleOrigin = Point(20,(sec*~cfg.sectVerticalSpace))},
							{wScore.view.visibleOrigin = Point(20,0)});
					});
				});
			})
		);
		bScoreDesc[sec] = (SmoothButton(wScore, Rect(20, ~cfg.sectStart+(sec*~cfg.sectVerticalSpace)+sectionShiftTotal+~cfg.elementHeight,100,~cfg.elementHeight))
			.canFocus_(false)
			.font_(Font(~cfg.font,10))
			.radius_(2)
			.border_(0)
			.states_([[if(~cueDescriptions[sec].notNil,{~cueDescriptions[sec]},{""})]]) );

		sTime[sec] = (SmoothSlider(wScore, Rect(140,~cfg.sectStart+(sec*~cfg.sectVerticalSpace)+sectionShiftTotal, ~cfg.lenSliderPerSecond*scoreLength[sec],~cfg.elementHeight))
			.canFocus_(false)
			.step_(1/scoreLength[sec])
			.hilightColor_(color.actCue)
			.background_(color.backGr)
			.action_({
				fromPos[sec] = round(sTime[sec].value * scoreLength[sec], 1);
				nCount[sec].value = fromPos[sec].asTimeStringHM;
		}) );

		~score[sec].size.do({arg evt;  // display Event buttons

			// only if type is END or ~cfg.detailMode = 0 (show all details)
			if( (~score[sec][evt].type == \End) || (~cfg.detailMode == 0), {

				eventYpos = ~cfg.sectStart - ~cfg.eventHeight;
				// for every event already at this number of secs add eventHeight to the eventYpos
				bEventTime.size.do({arg i;
					if(bEventTime[i] == ((~score[sec][evt].time[0]*60) + ~score[sec][evt].time[1]),
						{eventYpos = eventYpos + ~cfg.eventHeight});
				});
				// remember to shift next section if necessary
				if(eventYpos != (~cfg.sectStart - ~cfg.eventHeight ), {
					sectionShiftNew = max(sectionShiftNew, eventYpos - (~cfg.sectStart - ~cfg.eventHeight) - 25);
				});

				// define button for event
				bEvent[sec][evt] = (SmoothButton(wScore, Rect(
							140+((~cfg.lenSliderPerSecond) * ((~score[sec][evt].time[0]*60) + ~score[sec][evt].time[1] + (~score[sec][evt].time[2]/10))),
							eventYpos+(sec*~cfg.sectVerticalSpace)+sectionShiftTotal + (if(~score[sec][evt].type == \End,{~cfg.elementHeight},{0})),
							if(~score[sec][evt].type==\End,{40},{24}),
							~cfg.eventHeight
							))
					.canFocus_(false)
					.font_(Font(~cfg.font,10))
					.radius_(2)
					.border_(if(~score[sec][evt].type==\End,{0},{1}))
					.mouseOverAction_({
						bEvent[sec][evt].valueAction_(1);
					})
					.action_({
						if(~score[sec][evt].type != \End, {
							fStatus2Display.value(bEvent[sec][evt],
								"Cue"+sec+"Event"+evt+"at"+
								((~score[sec][evt].time[0]*60)+~score[sec][evt].time[1]+(~score[sec][evt].time[2]/10)).asTimeStringHM
								++" -- "++~score[sec][evt].type
								++if(~score[sec][evt].desc.notNil, {": '"++~score[sec][evt].desc++"'"},{""})
								++if(srcTypes.includes(~score[sec][evt].type), // if has source
									{" (source: ["++~score[sec][evt].params.srcSec++","++~score[sec][evt].params.srcEvt++"] '"
										++~score[~score[sec][evt].params.srcSec][~score[sec][evt].params.srcEvt].desc++"')"},
									{""})
								++" -- "
								++~score[sec][evt].params)
						});
					})
					.states_((case
						{~score[sec][evt].type==\MIDI}{[["MID",Color.black, Color.white]]}
						{~score[sec][evt].type==\MControl}{[["MCT",Color.black, Color.white]]}
						{~score[sec][evt].type==\BufPlayStart}{[["BP+",Color.white, Color.new255(100,100,255)]]}
						{~score[sec][evt].type==\BufPlayStop}{[["BP--",Color.white, Color.new255(100,100,255)]]}
						{~score[sec][evt].type==\DiskPlayStart}{[["DP+",Color.black, Color.new255(100,255,100)]]}
						{~score[sec][evt].type==\DiskPlayStop}{[["DP--",Color.black, Color.new255(100,255,100)]]}
						{~score[sec][evt].type==\BufRec}{[["BR",Color.black, Color.new255(255,50,50)]]}
						{~score[sec][evt].type==\BufLoad}{[["BL",Color.black, Color.new255(255,100,100)]]}
						{~score[sec][evt].type==\EffectOn}{[["E+",Color.white, Color.grey]]}
						{~score[sec][evt].type==\EffectOff}{[["E--",Color.white, Color.grey]]}
						{~score[sec][evt].type==\Control}{[["CT"++subStr(~score[sec][evt].params.mode,0,0).firstToUpper,
							Color.black, Color.new255(200,200,200)]]}
						{~score[sec][evt].type==\End}{[[
							((~score[sec][evt].time[0]*60) + ~score[sec][evt].time[1] + (~score[sec][evt].time[2]/10)).asTimeStringHM(0.1),
							Color.black.alpha_(0.5), Color.grey.alpha_(0.01)]]}
						{~score[sec][evt].type==\Trig}{[["TRG",Color.white, Color.grey(0.3)]]}
						{~score[sec][evt].type==\functionStart}{[["FU+",Color.white, Color.grey(0.1)]]}
						{~score[sec][evt].type==\functionStop}{[["FU-",Color.white, Color.grey(0.1)]]}
						;))
				);
				// record time of this event
				bEventTime.add((~score[sec][evt].time[0]*60) + ~score[sec][evt].time[1]);

			}); // only if type is END or ~cfg.showEvents = true

		}); // display Event buttons
		nCount[sec] = (RoundNumberBox(wScore, Rect(1120, ~cfg.sectStart+(sec*~cfg.sectVerticalSpace)+sectionShiftTotal, 44,~cfg.elementHeight))
			.radius_(2)
			.canFocus_(false)
			.value_(0.asTimeStringHM)
			.font_(Font(~cfg.font,15))
		);
	});

	// set height to last cue
	uCanvas.bounds_(Rect(uCanvas.bounds.left,uCanvas.bounds.top,uCanvas.bounds.width,bScore[~score.size-1].bounds.top + 70));

	// -------------------- Adjustments per project ----------------------

	w = Window("dummy").front; w.close; // since the first window is hidden as result of a bug

	// ("detailmode"+~cfg.detailMode).postln;
	// in various detail modes rearrange window
	if((~cfg.detailMode==1) || (~cfg.detailMode==2), { // iPad or no scroll
		wScore.bounds_(Rect(40,screenHeight-755,1016,600));
		wControl.bounds_(Rect(40,screenHeight-130,1016,80));
		bActSectTrig.bounds_(Rect(250,10,130,60)).font_(Font(~cfg.font,22));
		bStopAll.bounds_(Rect(390,10,130,60)).font_(Font(~cfg.font,22));
		if(midiEventPresent == 1, {
			bMidiMonitor.bounds_(Rect(550,10,100,18)).font_(Font(~cfg.font,10));
			dMidiOut.bounds_(Rect(740,32,240,18));
		});
		lVolume.bounds_(Rect(670,10,110,18));
		sVolume.bounds_(Rect(740,10,240,18));
		uCanvas.bounds_(Rect(uCanvas.bounds.left,uCanvas.bounds.top,wScore.bounds.width-200,wScore.bounds.height));
		uStatus.visible_(false); cPlayInstr.visible = false; lPlayInstr.visible = false;

		if(~cfg.detailMode==1, { // Sonata (iPad)
			lActSect.visible = false; tActSect.visible = false; lTrigger.visible = false; cTrigger.visible = false;
			lCueSect.bounds = Rect(20,lCueSect.bounds.top,lCueSect.bounds.width,lCueSect.bounds.height);
			dCueSect.bounds = Rect(80,dCueSect.bounds.top,dCueSect.bounds.width,dCueSect.bounds.height);
			~score.size.do {arg sec;
				bScore[sec].font_(Font(~cfg.font,16));
				bScoreDesc[sec]
				.font_(Font(~cfg.font,15))
				.bounds_(Rect(bScoreDesc[sec].bounds.left,bScoreDesc[sec].bounds.top - 6,
				bScoreDesc[sec].bounds.width, bScoreDesc[sec].bounds.height));
				sTime[sec]
				.knobSize_(0.15);
				nCount[sec]
				.font_(Font(~cfg.font,20))
				.radius_(3)
				.bounds_(Rect(nCount[sec].bounds.left - 200, nCount[sec].bounds.top,
				nCount[sec].bounds.width + 13,nCount[sec].bounds.height));
			};
		});
		if(~cfg.detailMode==2, { // Black Pencil (no scroll max 16 cues)
			// hide next cue dropdown and label
			lCueSect.visible = false; dCueSect.visible = false;
			lTrigger.bounds = Rect(700, lTrigger.bounds.top, lTrigger.bounds.width, lTrigger.bounds.height);
			cTrigger.bounds = Rect(670, cTrigger.bounds.top, cTrigger.bounds.width, cTrigger.bounds.height);
			// adjust cue list
			~score.size.do {arg sec;
				bScore[sec].font_(Font(~cfg.font,12));
				bScoreDesc[sec].visible_(false);
				sTime[sec]
				.knobSize_(0.15);
				nCount[sec]
				.font_(Font(~cfg.font,16))
				.radius_(3)
				.bounds_(Rect(nCount[sec].bounds.left - 180, nCount[sec].bounds.top,
				nCount[sec].bounds.width + 4,nCount[sec].bounds.height));
			};
		});
	});
	if(~cfg.detailMode==3, { // FLoK
		uStatus.visible = false; tStatus1.visible = false; lTrigger.visible = false; cTrigger.visible = false;
		wControl.bounds_(Rect(40,screenHeight-780,1016,700)).background_(Color.grey(0.99).alpha_(0.8));
		bActSectTrig.bounds_(Rect(30,570,130,40)).font_(Font(~cfg.font,22));
		bStopAll.bounds_(Rect(170,570,130,40)).font_(Font(~cfg.font,22));
		cPlayInstr.bounds_(Rect(400,570,25,40));
		lPlayInstr.bounds_(Rect(420,570,200,40)).font_(Font(~cfg.font,16));
		lVolume.bounds_(Rect(650,570,110,40)).font_(Font(~cfg.font,16));
		sVolume.bounds_(Rect(746,570,240,40)).font_(Font(~cfg.font,20));
		if(midiEventPresent == 1, {
			bMidiMonitor.bounds_(Rect(420,620,130,40)).font_(Font(~cfg.font,16));
			dMidiOut.bounds_(Rect(746,620,240,40)).font_(Font(~cfg.font,20));
		});
		lActSect.bounds_(Rect(30,215,100,75)).font_(Font(~cfg.font,40));
		tActSect.bounds_(Rect(150,200,210,100)).font_(Font(~cfg.font,50));
		lBar.bounds_(Rect(406,215,300,75)).font_(Font(~cfg.font,40));
		tBar.bounds_(Rect(626,200,180,100)).font_(Font(~cfg.font,70));
		tBeat.bounds_(Rect(806,200,180,100)).font_(Font(~cfg.font,50));
		lCueSect.bounds_(Rect(30,375,100,75)).font_(Font(~cfg.font,40));
		dCueSect.bounds_(Rect(150,360,210,100)).font_(Font(~cfg.font,50));
		tHeaderBack = (UserView(wControl,Rect(0,0,wControl.bounds.width,150))
			.drawFunc = {
				15.do{|i|
					Pen.color = Color.grey(rrand(0,0.1),rrand(0.8,1));
					Pen.lineDash = FloatArray[rrand(1,4),rrand(8,14)];
					Pen.width = rrand(1,3);
					Pen.addRect(
						Rect((tHeaderBack.bounds.width + 4).rand - (tHeaderBack.bounds.width + 4).rand,
							(tHeaderBack.bounds.height).rand, (tHeaderBack.bounds.width + 4).rand, 1)
					);
					Pen.perform(\stroke);
			} }
		);
		tHeader = (StaticText(wControl,Rect(20,30,945,85)).font_(Font("3D Noise",80)).string_(" The First Law of Kipple")
		);
	});
	if(~cfg.detailMode==4, { // MOROS
		uStatus.visible = false; tStatus1.visible = false; lTrigger.visible = false; cTrigger.visible = false;
		wControl.bounds_(Rect(40,screenHeight-780,1016,700)).background_(Color.grey(0.95).alpha_(0.8));
		bActSectTrig.bounds_(Rect(30,620,130,40)).font_(Font(~cfg.font,22));
		bStopAll.bounds_(Rect(170,620,130,40)).font_(Font(~cfg.font,22));
		cPlayInstr.bounds_(Rect(400,620,25,40));
		lPlayInstr.bounds_(Rect(420,620,200,40)).font_(Font(~cfg.font,16));
		lVolume.bounds_(Rect(650,620,110,40)).font_(Font(~cfg.font,16));
		sVolume.bounds_(Rect(746,620,240,40)).font_(Font(~cfg.font,20));
		lActSect.bounds_(Rect(30,55,100,75)).font_(Font(~cfg.font,40));
		tActSect.bounds_(Rect(150,40,210,100)).font_(Font(~cfg.font,50));
		lBar.bounds_(Rect(406,55,300,75)).font_(Font(~cfg.font,40));
		tBar.bounds_(Rect(626,40,180,100)).font_(Font(~cfg.font,70));
		tBeat.bounds_(Rect(806,40,180,100)).font_(Font(~cfg.font,50));
		lCueSect.bounds_(Rect(30,215,100,75)).font_(Font(~cfg.font,40));
		dCueSect.bounds_(Rect(150,200,210,100)).font_(Font(~cfg.font,50));
		tLines = (TextView(wControl, Rect(60,360,900,170)).canFocus_(false).string_("").font_(Font(~cfg.font, 50)));
	});

	if(~cfg.detailMode==5, { // Untitled for Anne
		uStatus.visible = false; tStatus1.visible = false; lTrigger.visible = false; cTrigger.visible = false;
		lPlayInstr.visible = false; cPlayInstr.visible = false;
		wControl.bounds_(Rect(40,screenHeight-780,1016,700)).background_(Color.grey(0.99).alpha_(1));
		bActSectTrig.bounds_(Rect(30,620,130,40)).font_(Font(~cfg.font,22));
		bStopAll.bounds_(Rect(170,620,130,40)).font_(Font(~cfg.font,22));
		tRunning.bounds_(Rect(886,500,100,100 )).font_(Font(~cfg.font,20));
		lVolume.bounds_(Rect(670,615,110,20)).font_(Font(~cfg.font,12));
		sVolume.bounds_(Rect(746,615,240,20)).font_(Font(~cfg.font,12));
		// lRecord.bounds_(Rect(670,645,80,18)).font_(Font(~cfg.font,12));
		// cRecord.bounds_(Rect(746,639,30,30));
		// cPlayInstr.bounds_(Rect(400,620,25,40));
		// lPlayInstr.bounds_(Rect(420,620,200,40)).font_(Font(~cfg.font,16));
		lActSect.bounds_(Rect(30,215,100,75)).font_(Font(~cfg.font,40));
		tActSect.bounds_(Rect(150,200,210,100)).font_(Font(~cfg.font,50));
		lCueSect.bounds_(Rect(30,375,100,75)).font_(Font(~cfg.font,40));
		dCueSect.bounds_(Rect(150,360,210,100)).font_(Font(~cfg.font,50));
		tHeaderBack = (UserView(wControl,Rect(0,0,wControl.bounds.width,150))
			.drawFunc = {
				15.do{|i|
					Pen.color = Color.grey(rrand(0,0.1),rrand(0.8,1));
					// Pen.lineDash = FloatArray[rrand(1,4),rrand(8,14)];
					Pen.width = rrand(0.1,0.3);
					Pen.addRect(
						Rect((tHeaderBack.bounds.width + 4).rand - (tHeaderBack.bounds.width + 4).rand,
							(tHeaderBack.bounds.height).rand, (tHeaderBack.bounds.width + 4).rand, 1)
					);
					Pen.perform(\stroke);
			} }
		);
		tHeader = (StaticText(wControl,Rect(20,0,945,150)).font_(Font("Bickham Script Pro",120)).string_("Untitled For Anne") );
		tListener = (StaticText(wControl,Rect(420,215,150,75)).canFocus_(false).string_("Listener").font_(Font(~cfg.font, 30)) );
		bListener = (SmoothButton(wControl,Rect(550,220,60,60)).canFocus_(false).border_(1).radius_(2)
			.states_([["",Color.white,Color.white],["",Color.white,color.actCue]])
		);
		sListener = (SmoothSlider(wControl,Rect(625,220,350,60)).canFocus_(false).border_(0.5)
			.knobSize_(0.1)
			.borderColor_(Color.gray(0.1))
			.background_(Color.white)
			.hilightColor_(Color.grey.alpha_(0.4))
			.stringColor_(color.nextCue)
			.font_(Font(~cfg.font,20))
		);
		bCueDesc = (StaticText(wControl, Rect(150,450,300,75))
			.canFocus_(false).font_(Font(~cfg.font,20)).string_("description")
		);
		lTouchOSCsending = (StaticText(wControl, Rect(355,615,150,18)).canFocus_(false)
			.align_(\middle)
			.font_(Font(~cfg.font,12)).string_("Sending data to TouchOSC")
		);
		cTouchOSCsending = (CheckBox(wControl, Rect(510,608,30,30))
			.value_(touchOSCsending==1)
			.action_({
				touchOSCsending = if(cTouchOSCsending.value, {1},{0});
				if(touchOSCsending == 1, {"Sending data to TouchOSC".postln}, {"NOT sending data to TouchOSC".postln});
			})
		);
		lNetaddrIP = (StaticText(wControl, Rect(355,635,130,18)).canFocus_(false)
			.align_(\middle)
			.font_(Font(~cfg.font,12)).string_("TouchOSC Local IP")
		);
		tNetaddrIP = (TextField(wControl, Rect(510,635,90,15))
			.string_(netaddrTouchOSC.ip).font_(Font(~cfg.font,12))
			.action_({
				netaddrTouchOSC.disconnect;
				netaddrTouchOSC = NetAddr(tNetaddrIP.value, tNetaddrPort.value);
				("OSC connection created with IP/port:"+tNetaddrIP.value+tNetaddrPort.value).postln;
				wControl.view.focus;
			})
		);
		lNetaddrPort = (StaticText(wControl, Rect(355,655,150,18)).canFocus_(false)
			.align_(\middle)
			.font_(Font(~cfg.font,12)).string_("TouchOSC Incoming Port")
		);
		tNetaddrPort = (TextField(wControl, Rect(510,655,50,15))
			.string_(netaddrTouchOSC.port).font_(Font(~cfg.font,12))
			.action_({
				netaddrTouchOSC.disconnect;
				netaddrTouchOSC = NetAddr(tNetaddrIP.value, tNetaddrPort.value);
				("OSC connection created with IP/port:"+tNetaddrIP.value+tNetaddrPort.value).postln;
				wControl.view.focus;
			})
		);

		// AmpPitchTracking
		if(~cfg.ampPitchTrack == 1, {
			wAmpPitch = (Window.new("AmpPitchTracking", Rect(50,100,1150,720))
				.background_(Color.grey(0.8)).alpha_(~cfg.alpha)
				.onClose_({ wAmpPitch = nil })
			);
			freqLabel = StaticText(wAmpPitch, Rect(20,20,140,60)).string_("Frequency").font_(Font(~cfg.font,29));
			freqText = (SmoothButton(wAmpPitch,Rect(20,90,140,60)).border_(0.1).radius_(0.2).canFocus_(false).font_(Font(~cfg.font,47))
				.states_([["", Color.black, Color.white]]));
			freqSlider = (SmoothSlider(wAmpPitch, Rect(20,160,140,350)).canFocus_(false).knobSize_(0.05)
				.hilightColor_(Color.grey(0.6)).background_(Color.white)
			);
			ampLabel = StaticText(wAmpPitch, Rect(200,20,140,60)).string_("Amplitude").font_(Font(~cfg.font,29));
			ampText = (SmoothButton(wAmpPitch,Rect(200,90,140,60)).border_(0.1).radius_(0.2).canFocus_(false).font_(Font(~cfg.font,47))
				.states_([["", Color.black, Color.white]]) );
			ampSlider = (SmoothSlider(wAmpPitch, Rect(200,160,140,350)).canFocus_(false).knobSize_(0.05)
				.hilightColor_(Color.grey(0.6)).background_(Color.white)
				.action_({ { if(ampSlider.value>0.9, { ampLabel.background_(Color.red) }, {  ampLabel.background_(Color.grey(0.8)) }) }.defer() })
			);
			bAmpPitch = (SmoothButton(wAmpPitch, Rect(20, 530, 320, 40))
				.border_(1).radius_(2).canFocus_(false).font_(~cfg.font, 20)
				.states_([["Start Tracking Manually", Color.black, Color.white], ["Stop Tracking Manually", Color.black, Color.red]])
				.action_({
					if(bAmpPitch.value == 1,
						{ runFuncs[\listener].value("start", 0,0, ~input1, "ampFollow", 2, 0.1, 10, 20000, justTrack: 1) },
						{ runFuncs[\listener].value("stop") })
				})
			);
			lowThresholdLabel = StaticText(wAmpPitch, Rect(200,580,160,40)).string_("Silence Threshold").font_(Font(~cfg.font,18));
			tLowThreshold = (SmoothNumberBox(wAmpPitch, Rect(200,620,145,60)).border_(1).radius_(2)
				.align_(\center)
				.clipLo_(0.0.ampdb)
				.clipHi_(1.0.ampdb)
				.value_(~lowThreshold)
				.allowedChars_("-.1234567890")
				.font_(Font(~cfg.font,45))
				.action_({
					~lowThreshold = tLowThreshold.value;
					("New Silence Threshold is" + ~lowThreshold).postln;
				})
			);
			tLowThresholdText = (StaticText(wAmpPitch, Rect(200,685,160,25))
				.string_("Scroll or Enter a number in db").font_(Font(~cfg.font,10.5)));
			freqBandsLabel = StaticText(wAmpPitch, Rect(400,20,700,60)).string_("Frequency Bands").font_(Font(~cfg.font,29));
			msFreq = (MultiSliderView(wAmpPitch, Rect(400, 90, 725, 420))  // 100 - 3000 Hz
				.background_(Color.grey(0.9))
				.size_(120)
				.indexThumbSize_(5)
				.valueThumbSize_(5)
				.isFilled_(true)
				.strokeColor_(Color.red)
				.gap_(1)
				.canFocus_(false)
				.fillColor_(Color.red)
				.action_({
					freqBandsSelectedLabel.string_("Selected Frequency Band:" +
						[freqLow + (msFreq.index * 25), freqLow + 25 + (msFreq.index * 25)]);
				})
			);
			bFreqReset = (SmoothButton(wAmpPitch, Rect(400, 530, 320, 40))
				.border_(1).radius_(2).canFocus_(false).font_(~cfg.font, 20)
				.states_([["Reset frequency bands", Color.black, Color.white]])
				.action_({
					msFreq.value = 0.dup(120);
				})
			);
			freqBandsSelectedLabel = (StaticText(wAmpPitch, Rect(750,520,700,60))
				.string_("[ Click on a band to see the range ]").font_(Font(~cfg.font,12)));
			wAmpPitch.front; ~wAmpPitchAvail = 1;
			wAmpPitch.onClose = {~wAmpPitchAvail = nil};
		});
	});

	// -------------------- System Window ----------------------

	lLevelsUnsaved = (StaticText(wSystem, Rect(0,0,0,0)).canFocus_(false)
		.font_(Font(~cfg.font,10))
		.stringColor_(Color.red)
		.string_("")
	);

	// Levels saved values
	if(File.exists(fileLevels),{
		var fileTemp;
		fileTemp = File(fileLevels,"r");
		effectInGains = fileTemp.getLine(200).asString.split($,);
		("\nEffectInGains found:" + effectInGains).postln;
		samplingInGain = fileTemp.getLine(200).asString;
		("\nSamplingInGain found:" + samplingInGain).postln;
		ampFollowInGains = fileTemp.getLine(200).asString.split($,);
		("\nAmpFollowInGains found:" + ampFollowInGains).postln;
		sampleLevel = fileTemp.getLine(200).asString;
		("\nSampleLevel found:" + sampleLevel).postln;
		efxLevel = fileTemp.getLine(200).asString;
		("\nEfxLevel found:" + efxLevel).postln;
		fileTemp.close;
	});

	// Effect Control faders
	if(effectInGainAvail == 1, {
		tEffectHeader = (StaticText(wSystem, Rect(260,10,300,40)).canFocus_(false).align_(\right)
			.string_("Effects Input Gain").font_(Font(~cfg.font, 18)) );
	});
	effectInGainBus.size.do {arg cc;
		if(effectInGainBus[cc].notNil, {
			lEffectInGain[cc] = (StaticText(wSystem, Rect(20,60+(effectInGainCount*30),220,20)).align_(\right)
				.font_(Font(~cfg.font,12)).string_(effectInGainBusLabel[cc]++ if(~cfg.disableMIDI == 0, { " (CC"++cc++")" }, {""}) )
			);
			sEffectInGain[cc] = (SmoothSlider(wSystem,Rect(260,60+(effectInGainCount*30),300,20)).canFocus_(false).align_(\left)
				.hilightColor_(color.nextCue).stringColor_(color.nextCueTxt)
				.font_(Font(~cfg.font,12)).string_("  " + ~spec.effectInGain.at(0.5).ampdb + "db  ")
				.action_({
					var val = sEffectInGain[cc].value;
					sEffectInGain[cc].string = "  " + round(~spec.effectInGain.at(val).ampdb,0.1) + "db  ";
					effectInGainBus[cc].set(val);
					// [cc, round(~spec.effectInGain.at(val).ampdb,0.1)].postln;
					lLevelsUnsaved.string_("Unsaved Changes");
				})
			);
			// assign saved levels
			if(effectInGains.size > effectInGainCount, {
				var val = effectInGains[effectInGainCount].asFloat;
				sEffectInGain[cc].valueAction_(~spec.effectInGain.asSpec.unmap(val.dbamp)).string_("  " + round(val,0.1) + "db  ");
			}, {
				sEffectInGain[cc].valueAction_(~spec.effectInGain.asSpec.unmap(0.dbamp)).string_("   0 db  ");
			});

			// test button
			~score.size.do({arg sec;
				~score[sec].size.do({arg evt;
					if(~score[sec][evt].type == \EffectOn, {
						if(~score[sec][evt].params.levelCC.notNil && (~score[sec][evt].params.levelCC==cc), {
							// ~score[sec][evt].params.effect.postln;
							bEffectInGain[cc] = (SmoothButton(wSystem,Rect(570,60+(effectInGainCount*30),30,20)).canFocus_(false)
								.font_(Font(~cfg.font,12)).border_(1).radius_(2)
								.states_([ ["test",Color.black,Color.white], ["test",Color.white,Color.black] ])
								.action_({ |button|
									if(button.value==1, {
										scoreProc[sec][evt] = fEffect.value(sec, evt,
											~score[sec][evt].params.effect, ~score[sec][evt].params.in, ~score[sec][evt].params.lev,
											~score[sec][evt].params.att, ~score[sec][evt].params.rel,
											~score[sec][evt].params.pitch
									)},{
										"\nEffect OFF".postln;
										if(scoreProc[sec][evt].notNil, {
											scoreProc[sec][evt].set(\gate,0);
											scoreProc[sec][evt] = nil
										});
									})
								})
							);
						});
					});
				})
			});
			effectInGainCount = effectInGainCount + 1; // update number of sliders count
		});
	};

	// sampling gain fader
	tSamplingHeader = (StaticText(wSystem, Rect(260, if(effectInGainAvail==1, {60},{10})+(effectInGainCount*30),300,40)).canFocus_(false).align_(\right)
		.string_("Live Sampling Input Gain").font_(Font(~cfg.font, 18))
	);
	sSamplingInGain = (SmoothSlider(wSystem,Rect(260,if(effectInGainAvail==1, {100},{60})+(effectInGainCount*30),300,20)).canFocus_(false).align_(\left)
		.hilightColor_(color.nextCue).stringColor_(color.nextCueTxt)
		.font_(Font(~cfg.font,12))
		.action_({
			var val = ~spec.samplingInGain.at(sSamplingInGain.value);
			sSamplingInGain.string = "  " + round(val.ampdb,0.1) + "db  ";
			samplingInGainBus.set(val);
			lLevelsUnsaved.string_("Unsaved Changes");
	}) );

	// ampfollow gain fader(s)
	if(ampFollowAvail == 1, {
		lAmpFollowHeader = (StaticText(wSystem, Rect(260,130+(effectInGainCount*30),300,40)).canFocus_(false).align_(\right)
			.string_("Amp Follow & Freq Track Input Gain").font_(Font(~cfg.font, 18)) );
	});
	ampFollowBus.size.do {arg cc;
		if(ampFollowBus[cc].notNil, {
			lAmpFollow[cc] = (StaticText(wSystem, Rect(20,170+(effectInGainCount*30)+(ampFollowCount*30),220,20)).align_(\right)
				.font_(Font(~cfg.font,12)).string_(ampFollowBusLabel[cc]++ if(~cfg.disableMIDI == 0, {" (CC"++cc++")"} , {""})  )
			);
			sAmpFollow[cc] = (SmoothSlider(wSystem,Rect(260,170+(effectInGainCount*30)+(ampFollowCount*30), 300,20)).canFocus_(false).align_(\left)
				.hilightColor_(color.nextCue).stringColor_(color.nextCueTxt)
				.font_(Font(~cfg.font,12)).string_("  " + ~spec.effectInGain.at(0.5).ampdb + "db  ")
				.action_({
					var val = sAmpFollow[cc].value;
					sAmpFollow[cc].string = "  " + round(~spec.effectInGain.at(val).ampdb,0.1) + "db  ";
					ampFollowBus[cc].set(val);
					lLevelsUnsaved.string_("Unsaved Changes");
				})
			);
			// assign saved levels
			if(ampFollowInGains.size > ampFollowCount, {
				var val = ampFollowInGains[ampFollowCount].asFloat;
				sAmpFollow[cc].valueAction_(~spec.effectInGain.asSpec.unmap(val.dbamp)).string_("  " + round(val,0.1) + "db  ");
			}, {
				sAmpFollow[cc].valueAction_(~spec.effectInGain.asSpec.unmap(0.dbamp)).string_("   0 db  ");
			});
			ampFollowCount = ampFollowCount + 1; // update number of sliders count
		});
	};

		// Levels save/reload buttons
	bLevelsSave = (SmoothButton(wSystem, Rect(350,175+(effectInGainCount*30)+(ampFollowCount*30), 100,18)).canFocus_(false).radius_(2).border_(1)
		.background_(color.backGr)
		.font_(Font(~cfg.font,10))
		.states_([["Save levels"]])
		.action_({
			var fileTemp, count=0;
			fileTemp = File(fileLevels,"w+");
			// save effects levels
			effectInGains = Array.newClear(effectInGainBus.size);
			effectInGainBus.size.do {arg cc;
				if(effectInGainBus[cc].notNil, {
					fileTemp.write(~spec.effectInGain.at(sEffectInGain[cc].value).ampdb.asString);
					fileTemp.write(",");
					effectInGains[count] = ~spec.effectInGain.at(sEffectInGain[cc].value).ampdb.asString;
					count = count+1;
				});
			};
			fileTemp.write("\n");
			// save sampling input gain
			fileTemp.write(~spec.samplingInGain.at(sSamplingInGain.value).ampdb.asString);
			samplingInGain = ~spec.samplingInGain.at(sSamplingInGain.value).ampdb;
			fileTemp.write("\n");
			// save ampfollow levels
			count = 0;
			ampFollowInGains = Array.newClear(ampFollowCount);
			ampFollowBus.size.do {arg cc;
				if(ampFollowBus[cc].notNil, {
					fileTemp.write(~spec.effectInGain.at(sAmpFollow[cc].value).ampdb.asString);
					fileTemp.write(",");
					ampFollowInGains[count] = ~spec.effectInGain.at(sAmpFollow[cc].value).ampdb.asString;
					count = count+1;
				});
			};
			fileTemp.write("\n");
			// save sample output level
			fileTemp.write(~spec.sampleLevel.at(sSampleLevel.value).ampdb.asString);
			sampleLevel = ~spec.sampleLevel.at(sSampleLevel.value).ampdb.asString;
			fileTemp.write("\n");
			// save efx output level
			fileTemp.write(~spec.efxLevel.at(sEfxLevel.value).ampdb.asString);
			efxLevel = ~spec.efxLevel.at(sEfxLevel.value).ampdb.asString;
			"\nLevels saved".postln;
			fileTemp.close;
			lLevelsUnsaved.string_("");
	}) );

	bLevelsReload = (SmoothButton(wSystem, Rect(460,175+(effectInGainCount*30)+(ampFollowCount*30), 100,18)).canFocus_(false).radius_(2).border_(1)
		.background_(color.backGr)
		.font_(Font(~cfg.font,10))
		.states_([["Reload levels"]])
		.action_({
			var val, count=0;
			// assign saved levels
			effectInGainBus.size.do {arg cc;
				if(effectInGainBus[cc].notNil, {
					val = effectInGains[count].asFloat;
					sEffectInGain[cc].valueAction_(~spec.effectInGain.asSpec.unmap(val.dbamp)).string_("  " + round(val,0.1) + "db  ");
					count = count+1;
			}) };
			sSamplingInGain.valueAction_(~spec.samplingInGain.asSpec.unmap(samplingInGain.asFloat.dbamp));
			sSampleLevel.valueAction_(~spec.sampleLevel.asSpec.unmap(sampleLevel.asFloat.dbamp));
			sEfxLevel.valueAction_(~spec.efxLevel.asSpec.unmap(efxLevel.asFloat.dbamp));
			count = 0;
			ampFollowBus.size.do {arg cc;
				if(ampFollowBus[cc].notNil, {
					val = ampFollowInGains[count].asFloat;
					sAmpFollow[cc].valueAction_(~spec.effectInGain.asSpec.unmap(val.dbamp)).string_("  " + round(val,0.1) + "db  ");
					count = count+1;
			}) };
			lLevelsUnsaved.string_("");
	}) );

	lLevelsUnsaved.bounds_(Rect(360,200+(effectInGainCount*30)+(ampFollowCount*30),100,18));

	// System controls and text
	tSetupHeader = (StaticText(wSystem, Rect(650,10,400,40)).canFocus_(false)
		.string_("Output Levels").font_(Font(~cfg.font, 18))
	);
	lSampleLevel = (StaticText(wSystem, Rect(650,60,170,20)).align_(\left)
		.font_(Font(~cfg.font,12)).string_("Tracks & sample output level")
	);
	sSampleLevel = (SmoothSlider(wSystem,Rect(820,60,300,20)).canFocus_(false).align_(\left)
		.hilightColor_(color.nextCue).stringColor_(color.nextCueTxt)
		.font_(Font(~cfg.font,12))
		.action_({
			var value = ~spec.sampleLevel.at(sSampleLevel.value);
			sSampleLevel.string = "  " + round(value.ampdb,0.1) + "db  ";
			volSampleBus.set(value);
			lLevelsUnsaved.string_("Unsaved Changes");
	}) );
	bSoundCheck = (SmoothButton(wSystem,Rect(1130,60,30,20)).canFocus_(false)
		.font_(Font(~cfg.font,12))
		.border_(1).radius_(2)
		.states_([ ["test",Color.black,Color.white], ["stop",Color.white,Color.black] ])
		.action_({ |button|
			if(button.value == 1, {
				soundCheckSynth = DiskPlayer.new(s, ~cfg.libraryBase++~cfg.soundCheck,
					~sampleOutBus[0], sampleGroup, 1).start(altOutLev: ~cfg.altOutputLevel);
			},{
				soundCheckSynth.remove;
		}) })
	);

	lEfxLevel = (StaticText(wSystem, Rect(650,90,170,20)).align_(\left)
		.font_(Font(~cfg.font,12)).string_("Effects output level")
	);
	sEfxLevel = (SmoothSlider(wSystem,Rect(820,90,300,20)).canFocus_(false).align_(\left)
		.hilightColor_(color.nextCue).stringColor_(color.nextCueTxt)
		.font_(Font(~cfg.font,12))
		.action_({
			var value = ~spec.efxLevel.at(sEfxLevel.value);
			sEfxLevel.string = "  " + round(value.ampdb,0.1) + "db  ";
			volEfxBus.set(value);
			lLevelsUnsaved.string_("Unsaved Changes");
	}) );

	// System setup text
	if(~cfg.setupText != "", {
		var temp1 = "Factual input channels (~input1 through ~input4:" + [~cfg.input1,~cfg.input2,~cfg.input3,~cfg.input4];
		var temp2 = "Factual output channels (~mainOutBus):" + ~mainOutBus;
		tSetupText = (StaticText(wSystem, Rect(650,150,500,300)).canFocus_(false).align_(\topLeft)
			.font_(Font(~cfg.font, 12)).string_(
				~cfg.setupText + "\n\n\n\n" ++ ~cfg.title ++
				"\n\n\n\nOblique Strategy: " ++ oblique[oblique.size.rand] ++
				"\n\n\n\nThe Nitty Gritty:\n" ++ temp1 ++
				"\n" ++ temp2 ++
				"\nKeyboard shortcuts: \n\tM: show mixer window \n\tAlt-C: cheat listener function (if available) \n\tAlt-O: test listener OSC send (if available)"
			)
		);
	});

	// set size of wSystem
	if(~cfg.setupText=="", {
		wSystem.bounds_(Rect(20,260,650,230+(effectInGainCount*30)+(ampFollowCount*30)));
		}, {
		wSystem.bounds_(Rect(20,260,1200,240+max(250,(effectInGainCount*30)+(ampFollowCount*30))));
	});


	// -------------------- initialize ----------------------

	pedalBus.set(0);
	effectInGainDefaultBus.set(~spec.effectInGain.asSpec.unmap(0.dbamp));
	~mainOutBus.size.do { |count|
		mainOutSynth[count] = Synth("mainOut"++count, [\gate, 1, \volBus, volBus.index], target: mainOutGroup);
	};
	~efxOutBus.size.do { |count|
		efxOutSynth[count] = Synth("efxOut"++count, [\gate, 1, \volBus, volEfxBus.index], target: subOutGroup);
	};
	~sampleOutBus.size.do { |count|
		sampleOutSynth[count] = Synth("sampleOut"++count, [\gate, 1, \volBus, volSampleBus.index], target: subOutGroup);
	};

	sVolume.valueAction_(if(~volMain.notNil,
		{~spec.volume.asSpec.unmap(~volMain.dbamp)},{~spec.volume.asSpec.unmap(0.dbamp)}));
	sSampleLevel.valueAction_(~spec.sampleLevel.asSpec.unmap(sampleLevel.asFloat.dbamp));
	sEfxLevel.valueAction_(~spec.efxLevel.asSpec.unmap(efxLevel.asFloat.dbamp));
	sSamplingInGain.valueAction_(~spec.samplingInGain.asSpec.unmap(samplingInGain.asFloat.dbamp));
	lLevelsUnsaved.string_("");

	if(~cfg.micThruFrom.notNil && (~cfg.record == 1), { micThruSynth = Synth(\micThru, target: mainOutGroup) });

	// -------------------- Starting it all up ----------------------

	wScore.view.keyDownAction_({
		arg view, char, modifiers, unicode, keycode;
		fKeyDown.value(keycode, modifiers);
	});
	wControl.view.keyDownAction_({
		arg view, char, modifiers, unicode, keycode;
		fKeyDown.value(keycode, modifiers);
		// letter f -> fullscreen
		if((keycode == 3) && (modifiers == 0),{
			if(wControl.fullScreen==0, {wControl.fullScreen}, {wControl.endFullScreen});
		});
	});
	wSystem.view.keyDownAction_({
		arg view, char, modifiers, unicode, keycode;
		fKeyDown.value(keycode, modifiers);
	});

	wScore.onClose = {
		~wScoreAvail = nil;
		mainOutGroup.free; subOutGroup.free; efxGroup.free; sampleGroup.free; funcGroup.free;
		scoreBuf.size.do({arg sec;
			scoreBuf[sec].size.do({arg evt;
				if(scoreBuf[sec][evt].notNil, {scoreBuf[sec][evt].free; scoreBuf[sec][evt] = nil;}); // clean up buffers
				controlTask[sec][evt].stop; // stop control tasks
			});
		});
		// free buffers
		~multiTapRevBufL.free; ~multiTapRevBufR.free;
		// stop Tasks
		activeSectionTask.stop;
		tBarCount.stop;
		// stop all processes
		fStopAll.value(onClose: 1);
		// Arduino polling
		ardTask.stop;
		if((ardSms != nil), {ardSms.close;});
		// responders
		OSCdef.freeAll;
		// clean up control window
		if(~wControlAvail.notNil, {wControl.close});
		if(~wMeterAvail.notNil, {~wMeter.close});
	};
	wControl.onClose = {
		~wControlAvail = nil;
		if(~wScoreAvail.notNil, {wScore.close});
		if(~wSystemAvail.notNil, {wSystem.close});
		if(~wAmpPitchAvail.notNil, {wAmpPitch.close});
		// if(~cfg.standAlone == 1, {
		// 	"osascript -e 'tell application \"SuperCollider 3.6.6\" to quit'".unixCmd;
		// });
		// exit for Stand Alone
		// 0.exit; "EXIT".postln;
	};

	if(~cfg.serverMeter == 1, { ServerMeter(s, xPos: 20, yPos: 50, numGainedChans: 0) });
	if((effectInGainAvail == 1) || (~cfg.setupText != ""), {wSystem.front; ~wSystemAvail = 1});
	wControl.front; ~wControlAvail = 1;
	wScore.front; ~wScoreAvail = 1;
	if((~cfg.detailMode==3) || (~cfg.detailMode==4) || (~cfg.detailMode==5), {wScore.visible_(false)});

	dCueSect.value_(1); // first set value something else
	dCueSect.valueAction_(0); // then we're sure valueAction actually does the action

	// hide IDE
	// if(~cfg.standAlone == 1, {"osascript -e 'tell application \"System Events\" to set visible of process \"SuperCollider\" to false'".unixCmd});

});
)






