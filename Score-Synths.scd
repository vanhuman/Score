// Part of Score.scd for multiple compositions / Robert van Heumen 2014/2015
(
// -------------------- SynthDefs / basic ----------------------

~mainOutBus.size.do { |count|
	SynthDef.new("mainOut"++count, {
		arg volBus, gate;
		var sig;
		sig = In.ar(~subOutBus[count],~cfg.maxOutputChannels); 				// input from subOutBus bus
		sig = sig * EnvGen.kr(Env.adsr(0,0,1,0),gate, doneAction: 2); 			// apply fade and envelope
		if((~cfg.stereoPlayback == 1) && (~cfg.maxOutputChannels > 2), {
			// mix sig down to 2 channels: even channels left and odd channels right
			sig = [ Mix.ar(sig.select({arg item, index; index.even})) , Mix.ar(sig.select({arg item, index; index.odd})) ]
		});
		Out.ar(~mainOutBus[count], In.kr(volBus,1) * sig);		// output to main bus
	}).add;
};
~efxOutBus.size.do { |count|
	SynthDef("efxOut"++count, { // bus to control volume effects before main volume
		arg volBus, gate;
		var sig;
		sig = In.ar(~efxOutBus[count],~cfg.maxOutputChannels); 						// input from efxOutBus bus
		sig = sig * EnvGen.kr(Env.adsr(0,0,1,0),gate, doneAction: 2); 				// apply fade and envelope
		Out.ar(~subOutBus[count], In.kr(volBus,1) * sig);									// output to subOutBus
		if(~cfg.recEfx.notNil && (~cfg.record == 1),
			{Out.ar(~cfg.recEfx, In.kr(volBus,1) * sig)});	// output to record bus
	}).add;
};
~sampleOutBus.size.do { |count|
	SynthDef("sampleOut"++count, { // bus to control volume sample playback before main volume
		arg volBus, gate;
		var sig;
		sig = In.ar(~sampleOutBus[count],~cfg.maxOutputChannels); 				// input from sampleOutBus bus
		sig = sig * EnvGen.kr(Env.adsr(0,0,1,0),gate, doneAction: 2); 				// apply fade and envelope
		Out.ar(~subOutBus[count], In.kr(volBus,1) * sig);									// output to subOutBus
		if(~cfg.recSample.notNil && (~cfg.record == 1),
			{Out.ar(~cfg.recSample, In.kr(volBus,1) * sig)});	// output to record bus
	}).add;
};

if(~cfg.micThruFrom.notNil && (~cfg.record == 1), {
	SynthDef(\micThru, { // sending mic input signal thru for recording
		Out.ar(~cfg.micThruTo, SoundIn.ar(~cfg.micThruFrom));
	}).add;
});

SynthDef(\sine440, {  // tuning synth
	arg gate = 1;
	var sig;
	sig = SinOsc.ar(440, mul: 0.4) + SinOsc.ar(220, mul: 0.2) + SinOsc.ar(880, mul: 0.2);
	sig = sig * EnvGen.kr(Env.asr(0.01,1,0.1), gate, doneAction: 2);
	Out.ar(0,0.3*sig.dup);
}).add;

// synths for click track
SynthDef(\hihat, {arg out = 0, amp = 0.5, att = 0.01, rel = 0.2, ffreq = 6000, pan = 0;
	var snd = WhiteNoise.ar(amp);
	var env = Env.perc(att, rel).kr(doneAction: 2);
	snd = HPF.ar(snd * env, ffreq);
	Out.ar(out, Pan2.ar(snd, pan));
}).add;
SynthDef(\snare, {arg out = 0, amp = 0.2, sinfreq = 180, att = 0.01, rel = 0.2, ffreq = 2000, pan = 0;
	var snd1 = WhiteNoise.ar(amp);
	var snd2 = SinOsc.ar(sinfreq,0,amp);
	var env = EnvGen.kr(Env.perc(att, rel), doneAction: 2);
	var sum = HPF.ar(snd1 * env, ffreq)+(snd2*env);
	Out.ar(out, Pan2.ar(sum, pan));
}).add;

// Buffer playback synths
SynthDef.new(\bufPlayStraight, {
	arg gate, buf, start, len, filterfreq = 1, lev, att = 0.1, rel = 0.1, revmix = 0, room = 0.9, pitch = 1,
	pedalBus, panDepth = 0, panSpeed = 0, out = 0;
	var sig, trig, panVal, panMod;
	panMod = min(panSpeed.ceil,1);
	panVal = (panMod * LFNoise1.ar(panSpeed).range(panDepth.neg,panDepth)) + ((1 - panMod) * panDepth);
	//	Poll.kr(Impulse.kr(4),panVal);
	trig = Impulse.kr(pitch/len);
	sig = PlayBufCF.ar(2, buf, trigger: trig, startPos: start*~sRate, rate: pitch);
	sig = FreeVerb2.ar(sig[0], sig[1], revmix, room, 0.5);
	sig = RLPF.ar(sig, ~spec.filterfreq.map(filterfreq), 0.5);
	sig = BRF.ar(sig,110,0.5); // filter out 110Hz
	sig = Balance2.ar(sig[0],sig[1], panVal);
	sig = sig * EnvGen.kr(Env.adsr(att,0,1,rel), gate, doneAction: 2);
	Out.ar(out, lev * sig);
}).add;

SynthDef.new(\bufPlayPitchControl, {
	arg gate, buf, start, len, filterfreq = 1, lev, att = 0.1, rel = 0.1, revmix = 0, room = 0.9, pitch = 1,
	pedalBus, panDepth = 0, panSpeed = 0, out = 0;
	var sig, trig, pedalPitchVal = 1, panVal, panMod;
	pedalPitchVal = IEnvGen.kr(~spec.pedalpitch, In.kr(pedalBus,1));
	panMod = min(panSpeed.ceil,1);
	panVal = (panMod * LFNoise1.ar(panSpeed).range(panDepth.neg,panDepth)) + ((1 - panMod) * panDepth);
	trig = Impulse.kr((pitch*pedalPitchVal)/len);
	sig = PlayBufCF.ar(2, buf, trigger: trig, startPos: start*~sRate, rate: pitch*pedalPitchVal);
	sig = FreeVerb2.ar(sig[0], sig[1], revmix, room, 0.5);
	sig = RLPF.ar(sig, ~spec.filterfreq.map(filterfreq), 0.5);
	sig = BRF.ar(sig,110,0.5); // filter out 110Hz
	sig = Balance2.ar(sig[0],sig[1], panVal);
	sig = sig * EnvGen.kr(Env.adsr(att,0,1,rel), gate, doneAction: 2);
	Out.ar(out, lev * sig);
}).add;

SynthDef.new(\bufPlayPhase, {
	arg gate, buf, start, len, filterfreq = 1, lev, att = 0.1, rel = 0.1, revmix = 0, room = 0.9, pitch = 1,
	pedalBus, panDepth = 0, panSpeed = 0, out = 0;
	var sig, sigL, sigR, trigL, trigR, panVal, panMod;
	panMod = min(panSpeed.ceil,1);
	panVal = (panMod * LFNoise1.ar(panSpeed).range(panDepth.neg,panDepth)) + ((1 - panMod) * panDepth);
	trigL = Impulse.kr(pitch/len);
	trigR = Impulse.kr(pitch/(len+0.09));
	sigL = Mix.ar(PlayBufCF.ar(2, buf, rate: pitch*LFNoise1.kr(0.4).range(0.9,1.1), trigger: trigL, startPos: start*~sRate));
	sigR = Mix.ar(PlayBufCF.ar(2, buf, rate: pitch*LFNoise1.kr(0.2).range(0.93,1.05), trigger: trigR, startPos: (start+0.05)*~sRate));
	sigL = FreeVerb.ar(sigL, revmix, room, 0.5);
	sigR = FreeVerb.ar(sigR, revmix, room, 0.5);
	sig = [sigL, sigR];
	sig = RLPF.ar(sig, ~spec.filterfreq.map(filterfreq), 0.5);
	sig = BRF.ar(sig,110,0.5); // filter out 110Hz
	sig = Balance2.ar(sig[0],sig[1], panVal);
	sig = sig * EnvGen.kr(Env.adsr(att,0,1,rel), gate, doneAction: 2);
	Out.ar(out, lev * sig);
}).add;

SynthDef.new(\bufPlayForwbackw, {
	arg gate, buf, start, len, filterfreq = 1, lev, att = 0.1, rel = 0.1, revmix = 0, room = 0.9, pitch = 1,
	pedalBus, panDepth = 0, panSpeed = 0, out = 0;
	var sig, trig, panVal, panMod;
	panMod = min(panSpeed.ceil,1);
	panVal = (panMod * LFNoise1.ar(panSpeed).range(panDepth.neg,panDepth)) + ((1 - panMod) * panDepth);
	trig = Impulse.kr(pitch/len);
	//	filterfreq = filterfreq * LFNoise1.kr(1).range(0.5,1);
	sig = PlayBufAlt.ar(2, buf, trigger: trig, startPos: start, rate: pitch);
	sig = FreeVerb2.ar(sig[0], sig[1], revmix, room, 0.5);
	sig = RLPF.ar(sig, ~spec.filterfreq.map(filterfreq), 0.5);
	sig = BRF.ar(sig,110,0.5); // filter out 110Hz
	sig = Balance2.ar(sig[0],sig[1], panVal);
	sig = sig * EnvGen.kr(Env.adsr(att,0,1,rel), gate, doneAction: 2);
	Out.ar(out, lev * sig);
}).add;

SynthDef.new(\bufPlayKeypex, {
	arg gate, buf, start, len, filterfreq = 1, lev, att = 0.1, rel = 0.1, revmix = 0, room = 0.9, pitch = 1,
	pedalBus, panDepth = 0, panSpeed = 0, out = 0, filterfreq2 = 0;
	var sig, trig, panVal, panMod;
	panMod = min(panSpeed.ceil,1);
	panVal = (panMod * LFNoise1.ar(panSpeed).range(panDepth.neg,panDepth)) + ((1 - panMod) * panDepth);
	trig = Impulse.kr(pitch/len);
	sig = PlayBufAlt.ar(2, buf, trigger: trig, startPos: start, rate: pitch);
	sig = FreeVerb2.ar(sig[0], sig[1], revmix, room, 0.5);
	sig = RLPF.ar(sig, ~spec.filterfreq.map(filterfreq), 0.5);
	sig = RHPF.ar(sig, ~spec.filterfreq.map(filterfreq2), 0.5);
	sig = BRF.ar(sig,110,0.5); // filter out 110Hz
	sig = Balance2.ar(sig[0],sig[1], panVal);
	sig = sig * EnvGen.kr(
		Env.new([0,1,1,0,0],[0.05,1,0.05,0.7] * LFNoise0.kr(10).range(0.002,0.03),[\sin,\lin,\sin,\lin]).circle
	);
	sig = sig * EnvGen.kr(Env.adsr(att,0,1,rel), gate, doneAction: 2);
	Out.ar(out, lev * sig);
}).add;

SynthDef.new(\bufPlayWarp, {
	arg gate, buf, start, len, filterfreq = 1, lev, att = 0.1, rel = 0.1, revmix = 0, room = 0.9, pitch = 1,
	pedalBus, panDepth = 0, panSpeed = 0, out = 0;
	var sig, trig, panVal, panMod, pointer;
	panMod = min(panSpeed.ceil,1);
	panVal = (panMod * LFNoise1.ar(panSpeed).range(panDepth.neg,panDepth)) + ((1 - panMod) * panDepth);
	trig = Impulse.kr(pitch/len);
	pointer = Phasor.ar(0, 1*SampleDur.ir/BufDur.ir(buf));
	sig = Warp1.ar(2, buf, pointer, pitch, 0.3, -1, 16, 0.5, 4);
	sig = FreeVerb2.ar(sig[0], sig[1], revmix, room, 0.5);
	sig = RLPF.ar(sig, ~spec.filterfreq.map(filterfreq), 0.5);
	sig = BRF.ar(sig,110,0.5); // filter out 110Hz
	sig = Balance2.ar(sig[0],sig[1], panVal);
	sig = sig * EnvGen.kr(
		Env.new([0,1,1,0,0],[0.05,1,0.05,0.7] * LFNoise0.kr(2).range(0.03,0.04),[\sin,\lin,\sin,\lin]).circle
	);
	sig = sig * EnvGen.kr(Env.adsr(att,0,1,rel), gate, doneAction: 2);
	Out.ar(out, lev * sig);
}).add;

SynthDef(\bufRec, {
	arg gate, buf, inChan1, inChan2, start, len, gainBus;
	RecordBuf.ar(In.kr(gainBus,1) * SoundIn.ar([inChan1,inChan2]), buf, start, loop: 0) * EnvGen.kr(Env.linen(0,len,0), gate, doneAction: 2);
}).add;

// -------------------- SynthDefs / effects ----------------------

// All effects have parameters lev (volume), inChan1/inChan2 (input channel), att/rel (attack and release in secs)

SynthDef.new(\deciMate,	{ // control: decfactor for decimate factor, samplerate, filterfreq for RLPF
	arg gate, lev, att = 0.1, rel = 0.1, inChan1, inChan2, decfactor = 0.3, filterfreq = 0.7,
	samplerate = 0.7, delayOn = 0, gateVal = 0, effectInGainBus, out = 0;
	var sig, ampVal = 0.01, probVal = 0.3, mixDecVal, mixCrossVal, mixDisVal, samplerateVal = 10000, effectInGainVal = 1, ampl;

	effectInGainVal = IEnvGen.kr(~spec.effectInGain,In.kr(effectInGainBus,1));

	sig = effectInGainVal * SoundIn.ar([inChan1,inChan2]);
	// sig = gain.dbamp * SoundIn.ar([inChan1,inChan2]);
	ampVal = IEnvGen.kr(~spec.deciMateAmp, decfactor);
	probVal = IEnvGen.kr(~spec.deciMateProb, decfactor);
	mixDecVal = IEnvGen.kr(~spec.deciMateMixDec, decfactor);
	mixCrossVal = IEnvGen.kr(~spec.deciMateMixCross, decfactor);
	mixDisVal = IEnvGen.kr(~spec.deciMateMixDis, decfactor);
	samplerateVal = IEnvGen.kr(~spec.deciMateDec, samplerate);

	ampl = Amplitude.ar(sig, 0.001, 0.5);

	sig = Decimator.ar(sig,rate: samplerateVal, bits: 8);
	sig = (mixDecVal * sig) +
	// adds feedback in silences/range amp 0.1 - 0.01 smooth 0.9 - 0.1
	(mixCrossVal * CrossoverDistortion.ar(sig,amp: ampVal,smooth: 0.5)) +
	(mixDisVal * Disintegrator.ar(sig,probability: probVal));

	sig = RLPF.ar(sig, ~spec.filterfreq.map(filterfreq),0.5);
	sig = AllpassC.ar(sig, 4,SinOsc.kr(60/130).range(0.23,0.115), 2, delayOn, (1 - delayOn) * sig);
	sig = Gate.ar(sig, ampl - gateVal);
	sig = sig * EnvGen.kr(Env.adsr(att,0,1,rel), gate, doneAction: 2);
	Out.ar(out,sig * lev);
}).add;

SynthDef.new(\stutterDelay, { // control: delaytime
	arg gate,  lev, att = 0.1, rel = 0.1, inChan1, inChan2, delaytime = 1, decimateLevel = 0, effectInGainBus, out = 0;
	var sig, sigL, sigR, delaytimeVal, effectInGainVal = 1;

	delaytimeVal = ~spec.delayTime.map(delaytime);
	effectInGainVal = IEnvGen.kr(~spec.effectInGain,In.kr(effectInGainBus,1));

	sig = effectInGainVal * SoundIn.ar([inChan1,inChan2]);
	// sig = gain.dbamp * SoundIn.ar([inChan1,inChan2]);
	sig = ( (1 - decimateLevel) * sig ) + ( decimateLevel * Decimator.ar(sig,rate: 7000, bits: 8) );
	sigL = AllpassC.ar(sig[0], 10, // alt: CombC
		LFNoise0.ar(LFNoise0.ar(8).range(0.5,10)).range(0.03,0.4) * delaytimeVal,
		LFNoise0.ar(0.3).range(1,12)
	);
	sigR = AllpassC.ar(sig[1], 10, // alt: CombC
		LFNoise0.ar(LFNoise0.ar(10).range(0.5,10)).range(0.01,0.2) * delaytimeVal,
		LFNoise0.ar(0.5).range(0.5,10)
	);
	sig = [sigL, sigR] * EnvGen.kr(Env.adsr(att,0,1,rel), gate, doneAction: 2);
	Out.ar(out,sig * lev);
}).add;

SynthDef.new(\multiTapReverb, { 	// control: filterfreq for LPF, freeze for mix F1/F2, mix for Tap/Freeverb/Freeze
	// lev 0.9 is full, when mix = 1, lev value 1 will trigger the freeze/hold
	arg gate, lev = 0.9, att = 0.1, rel = 0.1, inChan1, inChan2, mix = 0, filterfreq = 0.7, freeze = 0.5, dist = 0,
	effectInGainBus, delayOn = 0, out = 0;
	var sig, mixFreezeVal, mixTapVal, distVal, effectInGainVal = 1;
	var sigT, decayBusVal, sigTL, sigTR, mixFvVal = 1, tapVal1, tapVal2, tapVal3, tapVal4; // tap delay - SR
	var in, localL, localR, sigF, sigF1, sigF2, local, envLPF, envLPF2, hold, ffVal; // freeze
	var pulseLen, pulse, pulseTrig; // pulse freeze

	mixFreezeVal = IEnvGen.kr(~spec.multiTapRevMixFreeze, mix);
	mixTapVal = IEnvGen.kr(~spec.multiTapRevMixTap, mix);
	decayBusVal = IEnvGen.kr(~spec.multiTapRevDecay, mix);
	distVal = IEnvGen.kr(~spec.multiTapRevDist, dist);
	effectInGainVal = IEnvGen.kr(~spec.effectInGain,In.kr(effectInGainBus,1));

	in = effectInGainVal * SoundIn.ar([inChan1,inChan2]);
	// in = gain.dbamp * SoundIn.ar([inChan1,inChan2]);

	// tap delay --------------------------------

	mixFvVal = IEnvGen.kr(~spec.multiTapRevFv, mix);
	tapVal1 = IEnvGen.kr(~spec.multiTapRevTap1, mix);
	tapVal2 = IEnvGen.kr(~spec.multiTapRevTap2, mix);
	tapVal3 = IEnvGen.kr(~spec.multiTapRevTap3, mix);
	tapVal4 = IEnvGen.kr(~spec.multiTapRevTap4, mix);

	SendTrig.kr(Impulse.kr(4),1,mixFvVal);

	sigT = in;
	sigTL =
	(tapVal4*MultiTap.ar([0.1, 0.15, 0.7], [1,0.7,0.3], sigT[0], bufnum: ~multiTapRevBufL)) +
	(tapVal3*MultiTap.ar([0.2, 0.28, 0.6, 1.4], [1,0.8,0.9,0.7], sigT[0], bufnum: ~multiTapRevBufL)) +
	(tapVal2*MultiTap.ar([0.3, 0.43, 1, 1.9], [1,0.7,0.8, 0.3], sigT[0], bufnum: ~multiTapRevBufL)) +
	(tapVal1*MultiTap.ar([0.4, 0.7, 0.8, 1, 2], [1,0.7,1, 0.9, 0.6], sigT[0], bufnum: ~multiTapRevBufL))
	;
	sigTR =
	(tapVal4*MultiTap.ar([0.09, 0.21, 0.8], [0.9,0.8,0.4], sigT[1], bufnum: ~multiTapRevBufR)) +
	(tapVal3*MultiTap.ar([0.22, 0.4, 0.5, 1], [0.9,0.8,1, 0.4], sigT[1], bufnum: ~multiTapRevBufR)) +
	(tapVal2*MultiTap.ar([0.29, 0.5, 0.7, 1.3], [0.9,0.8,1, 0.4], sigT[1], bufnum: ~multiTapRevBufR)) +
	(tapVal1*MultiTap.ar([0.32, 0.65, 0.8, 1.2, 2.1], [0.9,0.8,0.9,1,0.7], sigT[1], bufnum: ~multiTapRevBufR))
	;
	sigTL = Pan2.ar(sigTL, LFNoise1.ar(2));
	sigTR = Pan2.ar(sigTR, LFNoise1.ar(1.5));

	sigT = ((1 - mixFvVal) * [sigTL,sigTR]) +
	(mixFvVal * FreeVerb2.ar(sigTL, sigTR, 1, decayBusVal * LFNoise1.kr(0.5).range(0.8,1), 0.5)); // mix room damping
	sigT = 0.5 * sigT;

	// freeze --------------------------------

	hold = lev;
	ffVal = IEnvGen.kr(~spec.multiTapRevFF, filterfreq);

	// feedback
	local = LocalIn.ar(2);
	localL = (max(hold,0.1) * local[0]) + (in[0] * (1 - hold)); // switch input feedback loop between in and local
	localR = (max(hold,0.1) * local[1]) + (in[1] * (1 - hold));
	20.do{
		localL = AllpassC.ar(localL,0.05,Rand(0.001,0.05),Rand(1,3));
		localR = AllpassC.ar(localR,0.05,Rand(0.001,0.05),Rand(1,3));
	};
	LocalOut.ar([localL,localR]*hold);

	// set LPF filter
	envLPF = LFNoise1.ar(0.5).range(500,ffVal);
	envLPF2 = LFNoise1.ar(0.2).range(300,1000);

	// percussive pulse for freeze2
	pulseLen = SinOsc.ar(0.02).range(1.1,1.25);
	pulseTrig = Impulse.ar(pulseLen);
	pulse = EnvGen.ar(Env.linen(0.02,0,pulseLen-0.1,1,\lin).range(0.2,1), gate: pulseTrig, doneAction: 0);

	// sig processing to send out
	sigF = [localL,localR];

	sigF1 = LPF.ar(sigF, envLPF);

	sigF2 = sigF * pulse * SinOsc.ar(0.1).range(0.7,1.5); // add short term and long term pulse
	sigF2 = LPF.ar(sigF2, envLPF2);

	sigF = ((freeze * sigF1) + (2 * (1-freeze) * sigF2)) * EnvGen.kr(Env.adsr(0.01,0,1,5), gate, doneAction: 2);
	sigF = HPF.ar(sigF, 50);
	sigF = sigF * distVal; // apply distortion

	// combine tap & freeze --------------------------------
	sig = (sigF * mixFreezeVal) + (sigT * mixTapVal);
	sig = sig + (delayOn * 0.3 * AllpassC.ar(in, 4,SinOsc.kr(60/130).range(0.23,0.115), 4));
	sig = sig * EnvGen.kr(Env.adsr(att,0,1,rel), gate, doneAction: 2);
	Out.ar(out, sig * lev);
}
).add;

SynthDef.new(\ampPitchFollow, { // control: mix for mix amp/pitch/noise, pitch for tuning sines
	arg gate, lev, att = 0.1, rel = 0.1, inChan1, inChan2, mix = 0.5, pitch = 1, effectInGainBus, out = 0;
	var sig, sigL, sigR, pitchVal, effectInGainVal = 1;
	var sigNoise, sigNoiseL, sigNoiseR, ratioL, ratioR, mixValNoise;
	var sigPitch, sigPitchL, sigPitchR, freqL, hasFreqL, ampL, freqR, hasFreqR, ampR, mixValPitch;

	mixValNoise = IEnvGen.kr(~spec.ampPitchFolMixNoise, mix);
	mixValPitch = IEnvGen.kr(~spec.ampPitchFolMixPitch, mix);
	pitchVal = IEnvGen.kr(~spec.ampPitchFolPitch, pitch);
	effectInGainVal = IEnvGen.kr(~spec.effectInGain,In.kr(effectInGainBus,1));

	sig = effectInGainVal * SoundIn.ar([inChan1,inChan2]);
	// sig = gain.dbamp * SoundIn.ar([inChan1,inChan2]);
	sigL = sig[0]; sigR = sig[1];

	// amplitude following
	ratioL = SinOsc.ar(0.15).range(0.5,1);
	ratioR = SinOsc.ar(0.1).range(0.5,1);
	sigNoiseL = ((ratioL * WhiteNoise.ar()) + ((1 - ratioL) * 3 * BrownNoise.ar())) * Amplitude.ar(sigL, 0.01, 0.01);
	sigNoiseL = Gate.ar(sigNoiseL, Amplitude.kr(sigL, 0.01, 0.01, add: -0.001));
	sigNoiseR = ((ratioR * WhiteNoise.ar()) + ((1 - ratioR) * 3 * BrownNoise.ar())) * Amplitude.ar(sigR, 0.01, 0.01);
	sigNoiseR = Gate.ar(sigNoiseR, Amplitude.kr(sigR, 0.01, 0.01, add: -0.001));
	sigNoise = [sigNoiseL, sigNoiseR];

	sigNoise = RHPF.ar(sigNoise, IEnvGen.kr(~spec.ampPitchFolFfHPF, mix), 0.5, IEnvGen.kr(~spec.ampPitchFolMulHPFefx, mix));

	// pitch following
	ampL = thresh(Amplitude.kr(sigL, 0.05, 0.05), 0.01);
	# freqL, hasFreqL = Pitch.kr(sigL, ampThreshold: 0.05, median: 7, initFreq: 1000);
	ampR = thresh(Amplitude.kr(sigR, 0.05, 0.05), 0.01);
	# freqR, hasFreqR = Pitch.kr(sigR, ampThreshold: 0.05, median: 7, initFreq: 1000);
	sigPitchL = Mix.new(SinOsc.ar(freqL * [10,12,13,15,17] * pitchVal * LFNoise1.ar(5).range(0.8,1), mul: ampL));
	sigPitchR = Mix.new(SinOsc.ar(freqR * [9,10,11,12,14,16] * pitchVal * LFNoise1.ar(4).range(0.9,1.1), mul: ampR));
	sigPitch = [sigPitchL, sigPitchR];

	sig = (sigNoise * mixValNoise) + (sigPitch * mixValPitch);
	sig = sig * EnvGen.kr(Env.adsr(att,0,1,rel), gate, doneAction: 2);
	Out.ar(out,sig * lev);
}).add;

SynthDef.new(\freeVerb, { // control: roomsize
	arg gate, lev, att = 0.1, rel = 0.1, inChan1, inChan2, roomsize = 0.5, effectInGainBus, out = 0;
	var sig, roomsizeVal, effectInGainVal = 1;

	roomsizeVal = IEnvGen.kr(~spec.freeVerbRoomSize, roomsize);
	effectInGainVal = IEnvGen.kr(~spec.effectInGain,In.kr(effectInGainBus,1));

	// Freeverb
	// sig = gain.dbamp * SoundIn.ar([inChan1,inChan2]);
	sig = effectInGainVal * SoundIn.ar([inChan1,inChan2]);
	//	sig = FreeVerb2.ar(sig[0], sig[1], 1, roomsizeVal, LFNoise1.kr(0.5).range(0.5,1), mul: 0.5); // mix room damping
	sig = FreeVerb2.ar(sig[0], sig[1], 1, roomsizeVal, 1, mul: 0.5); // mix room damping
	sig = sig * EnvGen.kr(Env.adsr(att,0,1,rel), gate, doneAction: 2);
	Out.ar(out,sig * lev);
}).add;

SynthDef.new(\schroederRev, { // control: decay
	arg gate, lev, att = 0.1, rel = 0.1, inChan1, inChan2, decay = 0.5, pan = 1, effectInGainBus, out = 0;
	var in, sig, sigSlap, decayVal, mixVal, delrd, deltimes, effectInGainVal = 1, slapBuf = LocalBuf(~sRate*1,2);

	decayVal = IEnvGen.kr(~spec.decay, decay);
	effectInGainVal = IEnvGen.kr(~spec.effectInGain,In.kr(effectInGainBus,1));

	// in = gain.dbamp * SoundIn.ar([inChan1,inChan2]);
	in = effectInGainVal * SoundIn.ar([inChan1,inChan2]);
	delrd = LocalIn.ar(4);
	sig = in + delrd[[0,1]];
	sig = [sig[0]+sig[1], sig[0]-sig[1], delrd[2]+delrd[3], delrd[2]-delrd[3]];
	sig = [sig[0]+sig[2], sig[1]+sig[3], sig[0]-sig[2], sig[1]-sig[3]];
	sig = sig * [0.4, 0.37, 0.333, 0.3] * decayVal;
	deltimes =  [101, 143, 165, 177] * 0.001 - ControlDur.ir;
	sig = DelayC.ar(sig, deltimes, deltimes);
	LocalOut.ar(sig);
	sig = sig * EnvGen.kr(Env.adsr(att,0,1,rel), gate, doneAction: 2);
	sigSlap = MultiTap.ar( [0.1], [0.5], in, bufnum: slapBuf );
	sig = ( pan * [Mix.ar(sig),Mix.ar(sigSlap)] ) + ( (1-pan) * sig );
	// sig = Balance2.ar(sig[0], sig[1], pan);
	Out.ar(out, [sig[0],sig[1]] * lev);
}).add;

SynthDef.new(\ampPerc, { // control: pitch (for low sine), range (for noise flutter), ring (for ring time low sine)
	arg gate, lev, att = 0.1, rel = 0.1, inChan1, inChan2, pitch = 0.5, range = 1, ring = 0.5, effectInGainBus, out = 0;
	var sig, in, ampl1, freq1, ampl2, freq2, effectInGainVal = 1;
	var pitchVal, rangeVal, ringVal;

	ringVal = IEnvGen.kr(~spec.apcRing, ring);
	effectInGainVal = IEnvGen.kr(~spec.effectInGain,In.kr(effectInGainBus,1));

	in = effectInGainVal * SoundIn.ar([inChan1,inChan2]);
	// in = gain.dbamp * SoundIn.ar([inChan1,inChan2]);
	ampl1 = Amplitude.ar(in, 0.001, 0.2);
	ampl2 = Amplitude.ar(in, 0.001, ringVal);
	freq1 = LFNoise1.ar(10).range(1000,1000 + (500*range));
	freq2 = LFNoise1.ar(0.55).range(45,55) + (pitch * 30);

	sig =
	(BPF.ar(WhiteNoise.ar(mul: 3),[freq1,2*freq1],0.3) * ampl1) +
	(SinOsc.ar([freq2,freq2], mul: 5) * ampl2);

	sig = Gate.ar(sig, ampl2 - 0.001);
	sig = Limiter.ar(sig,0.95,0.01);
	sig = sig * EnvGen.kr(Env.adsr(att,0,1,rel), gate, doneAction: 2);
	Out.ar(out,sig * lev);
}).add;

SynthDef.new(\pitchShift, {
	arg gate, lev, att = 0.1, rel = 0.1, inChan1, inChan2, pitch = 0.5, dist = 2, effectInGainBus, out = 0;
	var sig, in, effectInGainVal = 1;

	effectInGainVal = IEnvGen.kr(~spec.effectInGain,In.kr(effectInGainBus,1));
	pitch = max(0.05,min(4,pitch));

	in = effectInGainVal * SoundIn.ar([inChan1,inChan2]);
	// in = gain.dbamp * SoundIn.ar([inChan1,inChan2]);
	sig = PitchShift.ar(in, 0.1, pitch, 0.1, 0.01) + PitchShift.ar(in, 0.1, pitch/2, 0.1, 0.01);
	sig = dist * sig * EnvGen.kr(Env.adsr(att,0,1,rel), gate, doneAction: 2);
	Out.ar(out,sig * lev * effectInGainVal);
}).add;

SynthDef(\tankReverb, {
	arg gate, lev = 0.2, att = 0.1, rel = 0.1, inChan1, inChan2, room = 10, rev = 2, damp = 0.5, inputbw = 1, out = 0,
	spread = 15, dry = 0, early = 2, tail = 2, maxroom = 500, effectInGainBus;
	var sig, in, effectInGainVal = 1;

	effectInGainVal = IEnvGen.kr(~spec.effectInGain,In.kr(effectInGainBus,1));

	in = effectInGainVal * SoundIn.ar([inChan1,inChan2]);
	// in = gain.dbamp * SoundIn.ar([inChan1,inChan2]);
	sig  = GVerb.ar(in, room, rev, damp, inputbw, spread, dry, early, tail, maxroom);
	sig = sig * EnvGen.kr(Env.adsr(att,0,1,rel), gate, doneAction: 2);
	Out.ar(out,sig * lev);
}).add;

SynthDef.new(\ring, {
	arg gate, lev, att = 0.1, rel = 0.1, inChan1, inChan2, note = 110 /* 62+48 */, mixNoise = 1, effectInGainBus, out = 0;
	var sig, in, ampl, effectInGainVal = 1, freq;

	freq = note.midicps;
	effectInGainVal = IEnvGen.kr(~spec.effectInGain,In.kr(effectInGainBus,1));

	in = effectInGainVal * SoundIn.ar([inChan1,inChan2]);
	// in = gain.dbamp * SoundIn.ar([inChan1,inChan2]);
	ampl = Amplitude.ar(in, 0.001, 0.5);
	sig =
	RHPF.ar(PitchShift.ar(in, 0.2, 4, 0.2, 0.1), freq, 0.2, mul: 50) * ampl +
	(BPF.ar(WhiteNoise.ar(mul: 1),[freq,freq*1.3],0.3) * ampl * mixNoise) +
	(SinOsc.ar([freq*2,freq], mul: 1) * ampl * SinOsc.ar(10).range(0,1));

	// sig = FreeVerb2.ar(sig[0], sig[1], 0.5, 2);
	sig = sig * EnvGen.kr(Env.adsr(att,0,1,rel), gate, doneAction: 2);
	Out.ar(out,sig * lev);
}).add;

SynthDef(\compression, {
	arg gate, lev, att = 0.1, rel = 0.1, inChan1, inChan2, effectInGainBus, out = 0;
	var sig, in, effectInGainVal = 1;

	effectInGainVal = IEnvGen.kr(~spec.effectInGain,In.kr(effectInGainBus,1));

	in = effectInGainVal * SoundIn.ar([inChan1,inChan2]);
	// in = gain.dbamp * SoundIn.ar([inChan1,inChan2]);
	sig = Compander.ar(in, in, thresh: 0.9, slopeBelow: 1, slopeAbove: 1/3, mul: 1)
	* EnvGen.kr(Env.adsr(0.01,0,1,0.01), gate, doneAction: 2);

	Out.ar(out,sig * lev);
}).add;

SynthDef(\dubDelay, {
	arg gate, lev, att = 0.1, rel = 0.1, inChan1, inChan2, feedback = 0.5, effectInGainBus, out = 0;
	var in, sig, local, sigOut, amp, effectInGainVal = 1;

	effectInGainVal = IEnvGen.kr(~spec.effectInGain,In.kr(effectInGainBus,1));

	// in = gain.dbamp * SoundIn.ar([inChan1,inChan2]);
	in = effectInGainVal * SoundIn.ar([inChan1,inChan2]);

	amp = Amplitude.kr(in);
	sig = in * (amp > 0.02); // noise gate
	local = LocalIn.ar(2) * feedback;
	local = OnePole.ar(local, 0.4);
	local = OnePole.ar(local, -0.08);
	local = Rotate2.ar(local[0], local[1], 0.2);
	local = DelayN.ar(local, 1, LFNoise1.kr(0.3).range(0.3,0.4));
	LocalOut.ar((local + sig).softclip);

	sigOut = BRF.ar(local,110,0.5);
	sigOut = sigOut * EnvGen.kr(Env.adsr(att,0,1,rel), gate, doneAction: 2);

	Out.ar(out, sigOut * lev);
}).add;

SynthDef.new(\bocAmpMod3, {
	arg gate, lev, att = 0.1, rel = 0.1, inChan1, inChan2, cutoff = 0.7, res = 0.5, pitch = 0.5, freqLag = 0.5, effectInGainBus, out = 0;
	var in, sig, freq, amp, hasFreq, cutoffVal, resVal, pitchVal, effectInGainVal = 1, levVal;

	// in = gain.dbamp * SoundIn.ar(inChan1);
	in = effectInGainVal * SoundIn.ar(inChan1);
	amp = Amplitude.kr(in);
	# freq, hasFreq = Pitch.kr(in);
	amp = Lag.kr(amp,0.5);
	freq = Lag.kr(freq, freqLag);

	effectInGainVal = IEnvGen.kr(~spec.effectInGain,In.kr(effectInGainBus,1));
	cutoffVal = IEnvGen.kr(~spec.fsCutoff, cutoff) * IEnvGen.kr(~spec.fsAmp2cutoff, amp);
	resVal = IEnvGen.kr(~spec.fsRes, res);
	pitchVal = IEnvGen.kr(~spec.fsPitch, pitch);
	levVal = IEnvGen.kr(~spec.fsLev, lev);

	freq = [freq,freq/2] * pitchVal;
	sig = RLPF.ar(
		Saw.ar(SinOsc.ar(3)*3.01 + (freq + (8.midicps/128))) *
		Saw.ar(SinOsc.ar(3)*3.03 + (freq + (5.midicps/128))) *
		Saw.ar(SinOsc.ar(3)*3 + (freq - (3.midicps/128))),
	cutoffVal, resVal);
	sig = RLPF.ar(sig, cutoffVal, resVal);
	sig = sig * EnvGen.kr(Env.new([0,0,1],[0.5,0.5]), gate); // to avoid a boom when starting
	sig = Pan2.ar(sig[0],LFNoise1.ar(1).range(-0.8,0.8)) + (0.5*Pan2.ar(sig[1],LFNoise1.ar(1.1).range(-0.8,0.8)));
	sig = 50 * sig * EnvGen.kr(Env.adsr(att,0,1,rel), gate, doneAction: 2);

	Out.ar(out, sig * lev * amp);
}).add;

SynthDef(\tremolo,  { // control: tremSpeed for speed tremolo, keypex variation by default
	arg gate, lev, att = 0.1, rel = 0.1, inChan1, inChan2, tremSpeed = 1, effectInGainBus, out = 0;
	var sig,  tremSpeedVariation0, tremSpeedVariation1, tremSpeedVariation2, tremVar0Mix, tremVar1Mix, tremVar2Mix, effectInGainVal = 1;

	effectInGainVal = IEnvGen.kr(~spec.effectInGain,In.kr(effectInGainBus,1));
	// sig = gain.dbamp * SoundIn.ar([inChan1,inChan2]);
	sig = effectInGainVal * SoundIn.ar([inChan1,inChan2]);

	tremVar0Mix = IEnvGen.kr(~spec.tremoloVar0Mix, tremSpeed);
	tremVar1Mix = IEnvGen.kr(~spec.tremoloVar1Mix, tremSpeed);
	tremVar2Mix = IEnvGen.kr(~spec.tremoloVar2Mix, tremSpeed);
	tremSpeedVariation1 = LFNoise1.kr(2).range(0,0.5);
	tremSpeedVariation2 = LFNoise0.kr(10).range(0.2,3);
	tremSpeed = (tremVar1Mix * ~spec.tremoloTremSpeed.map(tremSpeed) * tremSpeedVariation1) +
	(tremVar2Mix * ~spec.tremoloTremSpeed.map(tremSpeed) * tremSpeedVariation2) +
	(tremVar0Mix * ~spec.tremoloTremSpeed.map(tremSpeed));

	sig = sig * EnvGen.kr(
		Env.new([0,1,1,0,0],[0.05,1,0.05,0.7]*tremSpeed,[\sin,\lin,\sin,\lin]).circle
	);

	sig = sig * EnvGen.kr(Env.adsr(att,0,1,rel), gate, doneAction: 2);
	Out.ar(out, sig * lev);
}).add;

SynthDef.new(\pitchShiftVibrato, {
	arg gate, lev, att = 0.1, rel = 0.1, inChan1, inChan2, pitch = 1, downOctaveMix = 0, variableVibrato = 0, effectInGainBus, out = 0;
	var sig, in, vibratoSpeed, effectInGainVal = 1;

	effectInGainVal = IEnvGen.kr(~spec.effectInGain,In.kr(effectInGainBus,1));
	vibratoSpeed = ( (1-variableVibrato) * 10 ) + ( variableVibrato * LFNoise1.kr(2).range(5,25) );
	in = effectInGainVal * SoundIn.ar([inChan1,inChan2]);
	// in = gain.dbamp * SoundIn.ar([inChan1,inChan2]);

	sig = PitchShift.ar(in, 0.2, pitch, 0, 0.1)
	+ PitchShift.ar(in, 0.2, pitch/2, 0, 0.1, downOctaveMix);
	sig = Vibrato.ar(sig, vibratoSpeed, 2);

	sig = sig * EnvGen.kr(Env.adsr(att,0,1,rel), gate, doneAction: 2);
	Out.ar(out, sig * lev);
}).add;

// -------------------- SynthDefs / amplitude & pitch tracking ----------------------

SynthDef(\listener, {
	arg inChan = 0, ampFollowBus;
	var in, amp, freq, hasFreq, ampLagged;
	in = SoundIn.ar(inChan) * IEnvGen.kr(~spec.effectInGain, In.kr(ampFollowBus, 1));
	amp = Amplitude.kr(in);
	# freq, hasFreq = Pitch.kr(in);
	ampLagged = Lag.kr(amp, 3);
	amp = Lag.kr(amp,0.1);
	freq = Lag.kr(freq, 0.3);
	// freq.poll;
	SendReply.kr(Impulse.kr(20), "/listener", [amp,freq,hasFreq,ampLagged]);
}).add;
)