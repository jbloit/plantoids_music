// Put sythdefs here

SynthDef(\kick, {
	arg out=0,tu = 1,amp=1,pitch=1;
	var env0, env1, env1m, sig;
	env0 =  EnvGen.ar(Env.new([0.5, 1, 0.3, 0], [0.01, 0.5, 0.26], [-4, -2, -4]), doneAction:2);
	env1 = EnvGen.ar(Env.new([120, 43, 29], [0.03, 0.29], [-4, -5]));
	env1m = env1.midicps;
	sig = LFPulse.ar(env1m*tu, 0, 0.5, 1, -0.5);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, env1m*1.5, env0);
	sig = sig + SinOsc.ar(env1m*tu, 0.5, env0*4);
	sig = sig * amp*0.3;
	sig = sig.clip2(1);
	Out.ar([0,1], sig);
}).add;

SynthDef(\lead1,{arg freq=432,amp=1,gate=1;
    var env= EnvGen.ar(Env.perc,gate,doneAction:2);
	var sig = SinOsc.ar(freq/440*432)*env*amp.linlin(0,1,0,0.25 );
	sig = Limiter.ar(LeakDC.ar(sig),0.9);
	Out.ar([0,1],sig*0.3);
}).add;


SynthDef(\lead2,{arg freq=432,amp=1,gate=1;
    var env= EnvGen.ar(Env.perc,gate,doneAction:2);
	var sig = LFSaw.ar(freq/440*432)*env*amp.linlin(0,1,0,0.25 );
	sig = BRF.ar(sig,freq+1000,0.1);
	sig = Limiter.ar(LeakDC.ar(sig),0.9);
	Out.ar([0,1],sig*0.3);
}).add;


SynthDef(\lead3,
{arg gate=1,freq=36,amp=1,out=0;
	var strike, env, noise, pitch, delayTime, detune,sig;
		var env2 = EnvGen.ar(Env.adsr(0.1,0.4,0.5,0.5),gate,doneAction:2);
		strike = SinOsc.ar(0.1);
	env = Decay2.ar(strike, 0.008, 0.04);
sig=Mix.ar(Array.fill(3, { arg i;
			detune = #[-0.05, 0, 0.04].at(i);
			delayTime = 1 / ((freq*432/440) + detune);
					noise = LFNoise2.ar(3000, env);
				CombL.ar(noise,
					delayTime,
					delayTime,
				1)
			}),
			(freq - 36)/27 - 1
		);
		Out.ar([0,1],sig*env2*0.0015*amp);
}).add;


SynthDef(\lead4,
{arg gate=1,freq=36,amp=1,out=0;
	var strike, env, noise, pitch, delayTime, detune,sig;
		var env2 = EnvGen.ar(Env.adsr(0.1,1,0.5,1),gate,doneAction:2);
		strike = SinOsc.ar(0.1);
	env = Decay2.ar(strike, 0.008, 0.04);
sig=
			Mix.ar(Array.fill(3, { arg i;
				detune = #[-0.05, 0, 0.04].at(i);
			delayTime = 1 / ((freq*432/440) + detune);
				noise = LFSaw.ar(freq*432/440, env);
				CombL.ar(noise,
					delayTime,
				1)
			}),
			(freq - 36)/27 - 1
		);
		Out.ar([0,1],sig*env2*0.02*amp);
}).add;



