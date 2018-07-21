
~faderMapper = SensorMaracas.new(0.1, 20);

SynthDef("kick", {
	arg out=0,tu = 1,amp=1;
	var env0, env1, env1m, sig;
	env0 =  EnvGen.ar(Env.new([0.5, 1, 0.3, 0], [0.01, 0.5, 0.26], [-4, -2, -4]), doneAction:2);
	env1 = EnvGen.ar(Env.new([120, 43, 29], [0.03, 0.29], [-4, -5]));
	env1m = env1.midicps;
	sig = LFPulse.ar(env1m*tu, 0, 0.5, 1, -0.5);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, env1m*1.5, env0);
	sig = sig + SinOsc.ar(env1m*tu, 0.5, env0*4);
	sig = sig * amp;
	sig = sig.clip2(1);
	Out.ar(out, sig!2);
}).send(s);


OSCdef(\lemurFader).free;
OSCdef(\lemurFader, {
	| msg, time, addr, port |
	var val, index, mapped, onsetState;

	val = msg[1];

	// postf("-->fader  v:%\n", val);
	onsetState = ~faderMapper.process(val);
	if ((onsetState==2),  {Synth(\kick)});
},'/Fader/x', n);


