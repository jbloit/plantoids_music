SynthDef(\droneee, { arg freq = 440, amp = 0.3, outbus = 0, phase = 0;
	var out, env;
	env = EnvGen.kr(Env.sine(10),doneAction: 2);
	out = LFPulse.ar(freq , 0.15);
	out = RLPF.ar(out,SinOsc.kr(0.3, 0, 200, 1500), 0.1);
	out = FreeVerb.ar(out, 0.5, 0.5, 0.5) * env;
	out = Pan2.ar(out, SinOsc.kr(1/10, phase),amp);

    Out.ar(outbus, out);
}).add;

Synth(\droneee)
