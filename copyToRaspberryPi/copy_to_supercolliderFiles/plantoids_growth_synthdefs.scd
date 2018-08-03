
// GROWTH SYNTHDEFS


//plante1

SynthDef(\droneplant1, {|
	freq= 100,
	fmod= 0.11,
	fmoda= 1,
	pmod= 0.1,
	amod= 0.01,
	amoda=0.8,
     amp= 0.7|
	var lfoa = SinOsc.ar([amod, amod,amod], 0, [amoda, amoda, amoda]);
	var lfop =SinOsc.ar([pmod, pmod*2, pmod*3], 0, 2pi);
	var lfospread = SinOsc.ar(SinOsc.ar(SinOsc.ar(0.13, 0, 5, 6), 0, 8,
50), 0, 1, 1);
	var lfocenter = SinOsc.ar(1.2, 0, 0.6);
	var mainsig = SinOsc.ar([freq.linlin(0,1,209,20000), freq.linlin(0,1,209,20000)*2,freq.linlin(0,1,209,20000)*3]+SinOsc.ar([fmod.linlin(0,1,20,20000), fmod.linlin(0,1,20,20000)*2, fmod.linlin(0,1,20,20000)*3], 0, [fmoda, fmoda*2, fmoda*3]),lfop,
lfoa);
	mainsig = FreeVerb.ar(mainsig,1,1)+mainsig;
	mainsig = Splay.ar(mainsig,lfospread, amp,lfocenter);
	mainsig = Limiter.ar(LeakDC.ar(mainsig),0.8);
	mainsig;
	Out.ar(0,mainsig);
        }).add;



SynthDef(\plant1,{arg freq1=0.5,freq2=0.5,freq3=0.5,amp=1,gate=1,rel=1;
	var env= EnvGen.ar(Env.perc(0.01,rel.linlin(0,1,0.1,2)),gate,doneAction:2);
	var envf= EnvGen.ar(Env([freq1.linlin(0,1,200,15000),freq2.linlin(0,1,20,150),freq3.linlin(0,1,30,100)],[0.01,1]));
    var sig = SinOsc.ar(envf)*env*amp.linlin(0,1,0,0.25);
	sig = Limiter.ar(LeakDC.ar(sig),0.9);
	Out.ar([0,1],sig);
}).add;


SynthDef(\plant11,{arg freq1=0.5,freq2=0.5,freq3=0.5,amp=1,gate=1,rel=1,noise=1, factor1=1, factor2=1;
	var env= EnvGen.ar(Env.perc(0.01,rel.linlin(0,1,0.1,0.8)),gate,doneAction:2);
	var envf= EnvGen.ar(Env([freq1.linlin(0,1,200,5000),freq2.linlin(0,1,200,1500),freq3.linlin(0,1,100,300)]*factor1*factor2,[0.01,0.25]));
	var sig = WhiteNoise.ar(env*noise)+SinOsc.ar(envf)*env*amp.linlin(0,1,0,0.25);
	sig = Limiter.ar(LeakDC.ar(sig),0.9);
	Out.ar([0,1],sig);
}).add;


SynthDef(\plant12, {
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
	Out.ar(out, sig);
}).add;

/*
Pdef(\plant1,
	Pbind(\instrument,\plant1,
		\dur,Prand([1/8,1/4,1/2],inf),
		\freq1,~stems_light2.asMap,
		\freq2,~stems_light3.asMap,
		\freq3,~stems_light4.asMap,
		\amp,~stems_light1.asMap,
		\rel,~stems_light9.asMap)
).play;


Pdef(\plant11,
	Pbind(\instrument,\plant11,
		\dur,Prand([1/8,1/4,1/2],inf),
		\freq1,~stems_light6.asMap,
		\freq2,~stems_light7.asMap,
		\freq3,~stems_light8.asMap,
		\amp,~stems_light5.asMap,
		\rel,~stems_light10.asMap,
		\noise,~stems_light11.asMap)
).play;*/



// plante 2


SynthDef(\plant2,{arg freq=0.5,amp=1,gate=1;
    var env= EnvGen.ar(Env.perc,gate,doneAction:2);
	var sig = SinOsc.ar(freq.linlin(0,1,200,80))*env*amp.linlin(0,1,0,0.25 );
	sig = Limiter.ar(LeakDC.ar(sig),0.9);
	Out.ar([0,1],sig);
}).add;
SynthDef(\plant21,{arg freq=0.5,amp=1,gate=1,noise=1;
    var env= EnvGen.ar(Env.perc,gate,doneAction:2);
	var sig = WhiteNoise.ar(noise*env)+SinOsc.ar(freq.linlin(0,1,400,120))*env*amp.linlin(0,1,0,0.25);
    sig = Limiter.ar(LeakDC.ar(sig),0.9);
	Out.ar([0,1],sig);
}).add;


/*
Pdef(\plant2,
	Pbind(\instrument,\plant2,
		\dur,Prand([1/8,1/4,1/8],inf),
		\isRest,Pseq([0.5,1],inf).coin.not,
		\freq,~stems_light22.asMap,
		\amp,~stems_light21.asMap)
).play;

Pdef(\plant21,
	Pbind(\instrument,\plant21,
		\dur,Prand([1/8,1/4,1/8],inf),
		\amp,~stems_light23.asMap,
		\freq,~stems_light24.asMap,
		\noise,~stems_light25.asMap)
).play;*/


////
// plante 3

SynthDef(\plant3,{arg freq=0.5,amp=1,gate=1,filter=600;
    var env= EnvGen.ar(Env.perc,gate,doneAction:2);
	var envf  = EnvGen.ar(Env([10000,freq.linlin(0,1,30,49).midicps/440*432],[0.001]));
	var sig = LFSaw.ar(envf*2)*LFSaw.ar(envf)*env*amp.linlin(0,1,0,4);
	sig = BPF.ar(sig,filter.linlin(0,1,30,12000),1);
	Out.ar([0,1],sig);
}).add;

 SynthDef(\plant31,{arg freq=0.5,amp=1,gate=1;
    var env= EnvGen.ar(Env.perc,gate,doneAction:2);
	var note = (freq.linlin(0,1,200,2000)/440*432).cpsmidi;
	var sig = SinOsc.ar(Demand.ar(Impulse.ar(16),0,Dseq([note,note+2,note+3,note+4,note+5,note+6,note+7].midicps,inf)))*env*amp.linlin(0,1,0,0.4);
    Out.ar([0,1],sig);
}).add;



/*
Pdef(\plant31,
	Pbind(\instrument,\plant31,
		\freq,~sonars31.asMap,
		\amp,~sonars32.asMap)
).play;*/
