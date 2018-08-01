	SynthDef(\windBasic, {
		|out=0, freqNorm=0.5, amp=0.1|
		var sig;
		sig = PinkNoise.ar();
		sig = LPF.ar(sig, ((freqNorm*2000) + 100)) * amp;
		Out.ar(out, sig!2);
	}).add;

	SynthDef(\droneee, { arg freq = 440, amp = 0.3, out = 0, phase = 0;
		var sig, env;
		env = EnvGen.kr(Env.sine(10),doneAction: 2);
		sig = LFPulse.ar(freq , 0.15);
		sig = RLPF.ar(sig,SinOsc.kr(0.3, 0, 200, 1500), 0.1);
		sig = FreeVerb.ar(sig, 0.5, 0.5, 0.5) * env;
		sig = Pan2.ar(sig, SinOsc.kr(1/10, phase),amp);

		Out.ar(out, sig);
	}).add;

	~tic = Buffer.read(s, ~samplesDir +/+ "tic.aif");
	~tac = Buffer.read(s, ~samplesDir +/+ "tac.aif");

	SynthDef(\thump,
		{
			|out=0, amp=0.6, filter=0.5|
			var nse, env, kic;
			env = Env.perc(0.05, 1, 1, -4);
			nse = BrownNoise.ar(2) + PinkNoise.ar(0.5)  * EnvGen.kr(env, doneAction: 2);

			nse = Mix.ar(BPF.ar(nse,[100,1200,80,40,20], mul:[1,0.2,1,1,1]));
			nse = LPF.ar(nse, (filter*900 + 100))! 2;
			Out.ar(out, nse*amp);

		};
	).add;


	// from RedFrik "techno" course
	SynthDef(\avbd, {|out= 0, amp= 0.1, freq= 60, pan= 0, atk= 0.001, rel= 0.1, mod= 0, cur= 0, gate= 1|
		var env= EnvGen.ar(Env.asr(atk, 1, rel, cur), gate, doneAction:2);
		var src= SinOsc.ar(freq*(2-env.lag3), 0.5pi, mod+1).tanh*amp;
		OffsetOut.ar(out, Pan2.ar(src*env, pan));
	}).add;
	SynthDef(\avhh, {|out= 0, amp= 0.1, pan= 0, atk= 0.001, rel= 0.1, cur= -5, mod= 0, gate= 1|
		var env= EnvGen.ar(Env.adsr(atk, atk, 0.5, rel, 1, cur), gate, doneAction:2);
		var src= RHPF.ar(ClipNoise.ar(amp), 1000, (10-mod).max(0.1))*LFTri.ar(1000);
		OffsetOut.ar(out, Pan2.ar(src*env, pan));
	}).add;
	SynthDef(\avbass, {|out= 0, amp= 0.1, freq= 100, pan= 0, atk= 0.01, rel= 0.2, cur= -4, mod= 0, gate= 1|
		var env= EnvGen.ar(Env.adsr(atk, atk, 0.75, rel, 1, cur), gate, doneAction:2);
		var src= BLowPass4.ar(Saw.ar(freq, amp), freq+(mod+1*100).min(900), 1-env+0.1);
		OffsetOut.ar(out, Pan2.ar(src*env, pan));
	}).add;
	SynthDef(\avlead, {|out= 0, amp= 0.1, freq= 500, pan= 0, atk= 0.01, rel= 0.1, cur= -4, gate= 1|
		var env= EnvGen.ar(Env.asr(atk, 1, rel, cur), gate, doneAction:2);
		var src= Pulse.ar(freq, 1-env.lag(1)*0.5, amp);
		OffsetOut.ar(out, Pan2.ar(src*env, pan));
	}).add;
	SynthDef(\avswop, {|out= 0, amp= 0.1, start= 5000, end= 500, mod= 0, pan= 0, atk= 0.01, rel= 4, cur= -4, gate= 1|
		var env= EnvGen.ar(Env.asr(atk, 1, rel, cur), gate, doneAction:2);
		var src= BPF.ar(WhiteNoise.ar(amp+SinOsc.ar(mod, 0.5pi, amp*0.25)), XLine.kr(start, end, 20), 2-env);
		OffsetOut.ar(out, Pan2.ar(src*env, pan+SinOsc.kr(0.1, 0, 0.3)));
	}).add;