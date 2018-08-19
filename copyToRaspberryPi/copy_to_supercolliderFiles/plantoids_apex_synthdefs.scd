// Put sythdefs here

// =========================================================
//                                                                            MELODIC
// =========================================================


SynthDef(\sawpulsimp, { |out, freq = 99, gate = 0.5,  amp = 1, pan=0, timbre=0|
	var sig, plfo, fcurve ;
	var plfofreq = 6, mw = 0, ffreq = 2000, rq = 0.3, freqlag = 0.05;
	ffreq = timbre.linexp(0, 1, 200, 8000);
	rq = timbre.linexp(0,1, 0.1, 1);
	plfo = SinOsc.kr(plfofreq, mul:mw, add:1);
	freq = Lag.kr(freq, freqlag) * plfo;
	fcurve = EnvGen.kr(Env.adsr(0, 0.3, 0.1, 20), gate);
	fcurve = (fcurve - 1).madd(0.7, 1) * ffreq;
	sig = Mix.ar([Pulse.ar(freq, 0.9), Saw.ar(freq*1.007)]);
	sig = RLPF.ar(sig, fcurve, rq)
	* EnvGen.kr(Env.adsr(0.04, 0.2, 0.6, 0.1), gate, doneAction:2)
	* amp;
	Out.ar(out, sig ! 2)
}).add;

SynthDef(\moogbass, {
	arg out = 0, pan = 0, freq = 440, amp = 0.8, gate = 1, cutoff = 1000, gain = 2.0, lagamount = 0.01, att = 0.001, dec = 0.3, sus = 0.9, rel = 0.2, chorus = 0.7;

	var osc, filter, env, filterenv, snd, chorusfx;

	osc = Mix(VarSaw.ar(
		freq: freq.lag(lagamount) * [1.0, 1.001, 2.0],
		iphase: Rand(0.0,1.0) ! 3,
		width: Rand(0.5,0.75) ! 3,
		mul: 0.5));

	filterenv = EnvGen.ar(
		envelope: Env.asr(0.2, 1, 0.2),
		gate: gate);

	filter =  MoogFF.ar(
		in: osc,
		freq: cutoff * (1.0 + (0.5 * filterenv)),
		gain: gain);

	env = EnvGen.ar(
		envelope: Env.adsr(0.001, 0.3, 0.9, 0.2, amp),
		gate: gate,
		doneAction: 2);

	snd = (0.7 * filter + (0.3 * filter.distort)) * env;

	chorusfx = Mix.fill(7, {

		var maxdelaytime = rrand(0.005, 0.02);
		DelayC.ar(
			in: snd,
			maxdelaytime: maxdelaytime,
			delaytime: LFNoise1.kr(
				freq: Rand(4.5, 10.5),
				mul: 0.25 * maxdelaytime,
				add: 0.75 * maxdelaytime)
		)
	});

	snd = snd + (chorusfx * chorus);

	Out.ar(out, Pan2.ar(snd, pan));

}).add;


// =========================================================
//                                                                            SAMPLER
// =========================================================

Buffer.freeAll;
//~samplesDir = thisProcess.nowExecutingPath.dirname +/+ "../soundfiles";

// ~samplesDir = thisProcess.nowExecutingPath.dirname +/+ "../soundfiles";

~samplesDir = "/home/jbloit/Dropbox/sounds/Battery 4 Factory Library/Samples/Drums"

~drumDirs = [
PathName.new(~samplesDir +/+ "Kick"),
PathName.new(~samplesDir +/+ "Clap"),
PathName.new(~samplesDir +/+ "HiHat"),
PathName.new(~samplesDir +/+ "Snare"),
PathName.new(~samplesDir +/+ "Wooden"),
PathName.new(~samplesDir +/+ "Hand Drum"),
PathName.new(~samplesDir +/+ "Metallic"),
PathName.new(~samplesDir +/+ "Shaker"),
PathName.new(~samplesDir +/+ "Tom"),
PathName.new(~samplesDir +/+ "Mallet Drum"),
];

SynthDef(\sampler, {
	|out=0, bufnum=0, amp=0.3, rate=1|
	var sig;
	sig = PlayBuf.ar(1, bufnum, rate * BufRateScale.kr(bufnum), doneAction:2);
	Out.ar(out, Pan2.ar(sig*amp, 0));
}).add;

Buffer.freeAll;
~percBuffers= Array.new;
~percBuffers.clear;
10.do({|i|
	i.postln;
	~percBuffers = ~percBuffers.add(Buffer.read(s, ~drumDirs[i].entries[rrand(0, 10)]
.fullPath));
});

//
~percBuffers[2].bufnum
Synth(\sampler,  [\bufnum, ~percBuffers[5].bufnum])
(
Pdef(\p3_0,
	Pbind(\instrument, \sampler,
		\dur, 1/4, \bufnum, Pfunc({rrand(0, 9)}))).play;
)



// =========================================================
//                                                                            PERC
// =========================================================
