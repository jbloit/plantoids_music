SynthDef(\snaretuned2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var pop, popAmp, popFreq;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

	popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
	popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
	pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(410) * 0.4 ))) * popAmp;
	env1 = EnvGen.kr(Env([1840,1010,1831,1000],[0.01,0.04,0.4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	env2 = EnvGen.kr(Env([411,150,245],[0.01,0.7],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	env3 = EnvGen.kr(Env([411,150,245],[0.01,0.7],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	sig = pop + ( sig/2 );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.01,0.9)) + LPF.ar(WhiteNoise.ar(0.1), env3);
	sig = ( pop/2 ) + ( sig );
	sig = BPF.ar(sig, [130,220], 0.1).mean + sig; // eq

	// tonal component
	sig2 = SinOsc.ar([180, 330]*1.2).sum;
	sig3 = LFTri.ar(111);
	sig3 = FreqShift.ar(sig3, [175, 224]*1.3).sum;
	sig4 = sig2 + sig3 / 48;

	sig = sig + sig4 / 1.2;
	sig = HPF.ar(sig, env2);
	sig = sig * SinOsc.ar(1000);
	sig = sig * EnvGen.kr(Env([0,1,0],[0.01,0.1]), 1, doneAction:2);
	sig = sig * 2;
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;

SynthDef("kick", {
	arg out=0,tu = 1,amp=0.1;
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

// Example of a music callback
~p1_flower_sonar = {|i=0, v=0, state=0|
	// postf("~p1_flower_sonar i:% v:% \n", i, v);

	switch(state,
		-1, {
			"----->OFFSET SONAR".postln;
		},
		0, {
			"----->OFF SONAR".postln;
		},
		1, {
			"----->CHANGE SONAR".postln;

		},
		2, {
			"----->ONSET SONAR".postln;
			switch(i,
				0, {Synth(\kick)},
				1, {Synth(\snaretuned2)});
		},
	);
};

// the mappers directly map the sensor values to the music callbacks
~faderMapper=SensorMaracas.new(thresh:0.1, filterOrder:10, musicCallback: ~p1_flower_sonar, noteIndex:0, quant:1/8);
~faderMapper2=SensorKey.new(thresh:0.5, musicCallback: ~p1_flower_sonar, noteIndex:1, quant:1/4);


OSCdef(\lemurFader).free;
OSCdef(\lemurFader, {
	| msg, time, addr, port |
	var val, index, mapped, onsetState;

	val = msg[1];

	// postf("-->fader  v:%\n", val);
	onsetState = ~faderMapper.process(val);

},'/Fader/x', n);

OSCdef(\lemurFader2).free;
OSCdef(\lemurFader2, {
	| msg, time, addr, port |
	var val, index, mapped, onsetState;

	val = msg[1];

	// postf("-->fader  v:%\n", val);
	~faderMapper2.process(val);

},'/Fader2/x', n);


TempoClock.default.tempo;


