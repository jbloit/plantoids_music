
// FOXGLOVE SYNTHDEFS


//plante1


SynthDef(\plant1,{arg freq1=0.5,freq2=0.5,freq3=0.5,freq4=0.8,amp=0,gate=1,rel=1;
	var env= EnvGen.ar(Env.perc(0.75,rel.linlin(0,1,0.1,2)),gate,doneAction:2);
	var envf= EnvGen.ar(Env([freq1.linlin(0,1,200,1200),freq2.linlin(0,1,20,150),freq3.linlin(0,1,30,400)],[0.01,1]));
    var sig = SinOsc.ar(envf)*env*amp.linlin(0,1,0,0.25);
	sig = Limiter.ar(LeakDC.ar(sig),0.9);
	Out.ar([0,1],sig);
}).add;


SynthDef(\plant11,{arg freq1=0.5,freq2=0.5,freq3=0.8,freq4=0.25,amp=0,gate=1,rel=1,noise=1;
	var env= EnvGen.ar(Env.perc(0.5,rel.linlin(0.25,0.6,0.7,1)),gate,doneAction:2);
	var envf= EnvGen.ar(Env([freq1.linlin(0,2,300,400),freq2.linlin(0.5,1,200,400),freq3.linlin(0,1,200,600)],[0.1,0.25]));
	var sig = WhiteNoise.ar(env*noise)+SinOsc.ar(envf)*env*amp.linlin(0.6,0.8,1,0.75);
	sig = Limiter.ar(LeakDC.ar(sig),0.9);
	Out.ar([0,1],sig);
}).add;


SynthDef(\plant1hihat, {arg out = 0, amp = 0.5, att = 0.01, rel = 0.2, ffreq = 6000, pan = 0;
	var snd = WhiteNoise.ar(amp);
	var env = Env.perc(att, rel).kr(doneAction: 2);
	snd = HPF.ar(snd * env, ffreq);
	Out.ar(out, Pan2.ar(snd, pan));
}).add;

SynthDef(\plant1snare, {arg out = 0, amp = 0.05, sinfreq = 180, att = 0.01, rel = 0.2, ffreq = 1000, pan = 0;
	var snd1 = WhiteNoise.ar(amp);
	var snd2 = SinOsc.ar(sinfreq,0,amp);
	var env = EnvGen.kr(Env.perc(att, rel), doneAction: 2);
	var sum = HPF.ar(snd1 * env, ffreq)+(snd2*env);
	Out.ar(out, Pan2.ar(sum, pan));
}).add;

SynthDef(\plant1kick, {arg out = 0, amp = 0.3, sinfreq = 60, glissf = 0.9, att = 0.1, rel = 0.45, pan = 0;
	var gliss = XLine.kr(sinfreq, sinfreq*glissf, rel);
	var snd = SinOsc.ar(gliss);
	var env = EnvGen.kr(Env.perc(att, rel), doneAction: 2);
	snd = snd * env * amp;
	Out.ar(out, Pan2.ar(snd, pan));
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


SynthDef(\plant2,{ arg out = 0, freq = 660, amp = 0.4, pan = 0.5;
    var env, snd;
	env = Env.perc(level: amp).kr(doneAction: 2);
	snd = Pulse.ar(freq, 0.25, 0.5);
	snd = snd * env;
	Out.ar(out, Pan2.ar(snd, pan));
}).add;


SynthDef(\plant21,{ arg out = 0, freq = 220, amp = 0.2, pan = 0;
    var env, snd;
	env = Env.perc(level: amp).kr(doneAction: 2);
	snd = Pulse.ar(freq, 0.25, 0.5);
	snd = snd * env;
	Out.ar(out, Pan2.ar(snd, pan));
}).add;


SynthDef(\plant2hihat, {arg out = 0, amp = 0.5, att = 0.01, rel = 0.2, ffreq = 6000, pan = 0;
	var snd = WhiteNoise.ar(amp);
	var env = Env.perc(att, rel).kr(doneAction: 2);
	snd = HPF.ar(snd * env, ffreq);
	Out.ar(out, Pan2.ar(snd, pan));
}).add;

SynthDef(\plant2snare, {arg out = 0, amp = 0.05, sinfreq = 180, att = 0.01, rel = 0.2, ffreq = 1000, pan = 0;
	var snd1 = WhiteNoise.ar(amp);
	var snd2 = SinOsc.ar(sinfreq,0,amp);
	var env = EnvGen.kr(Env.perc(att, rel), doneAction: 2);
	var sum = HPF.ar(snd1 * env, ffreq)+(snd2*env);
	Out.ar(out, Pan2.ar(sum, pan));
}).add;

SynthDef(\plant2kick, {arg out = 0, amp = 0.3, sinfreq = 90, glissf = 0.9, att = 0.3, rel = 0.45, pan = 0;
	var gliss = XLine.kr(sinfreq, sinfreq*glissf, rel);
	var snd = SinOsc.ar(gliss);
	var env = EnvGen.kr(Env.perc(att, rel), doneAction: 2);
	snd = snd * env * amp;
	Out.ar(out, Pan2.ar(snd, pan));
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

SynthDef(\plant3,{ arg out=0, freq=440, amp=0.01, pan=0, gate=0.3;
    var z;
    z = LPF.ar(
            Mix.new(VarSaw.ar(freq + [0, Rand(-0.4,0.0), Rand(0.0,0.4)], 0, 0.3)),
            XLine.kr(Rand(4000,5000), Rand(2500,3200), 1)
        ) * Linen.kr(gate, 0.01, 0.7, 0.3, 2);
    OffsetOut.ar(out, Pan2.ar(z, pan, amp));
}).add;



SynthDef(\plant31,{
arg freq = 666, tone = 8, art = 1, amp = 1.5, pan = 0;
var env, out, mod;

env = Env.perc(0, art);
mod = 5 + (1/IRand(2, 6));

out = PMOsc.ar(freq, mod*freq,
	pmindex: EnvGen.kr(env, timeScale: art, levelScale: tone),
	mul: EnvGen.kr(env, timeScale: art, levelScale: 0.3));

out = Pan2.ar(out, pan);

out = out * EnvGen.kr(env, timeScale: 1.3*art,
	levelScale: Rand(0.1, 0.5), doneAction:2);
Out.ar(0, out*amp); //Out.ar(bus, out);

}).add;



// moogbass with thanks to Mitchell Sigman at the University of Sussex.


/*
Pdef(\plant3,
	Pbind(\instrument, \plant3,
		\amp, ~leaves_light31.asMap,
		\filter, ~leaves_light32.asMap,
		\dur, Prand([1/8,1/8],inf),
		\isRest, Pseq([0.5,1],inf).coin.not,  \freq,Prand([~stems_light31.asMap,~stems_light32.asMap,~stems_light33.asMap,~stems_light34.asMap,~stems_light35.asMap],inf)
)).play;

Pdef(\plant31,
	Pbind(\instrument,\plant31,
		\freq,~sonars31.asMap,
		\amp,~sonars32.asMap)
).play;*/
