
// GROWTH SYNTHDEFS


//plante1


SynthDef(\plant1,{arg freq1=0.5,freq2=0.5,freq3=0.5,freq4=0.8,amp=1,gate=1,rel=1;
	var env= EnvGen.ar(Env.perc(0.75,rel.linlin(0,1,0.1,2)),gate,doneAction:2);
	var envf= EnvGen.ar(Env([freq1.linlin(0,1,200,1200),freq2.linlin(0,1,20,150),freq3.linlin(0,1,30,400)],[0.01,1]));
    var sig = SinOsc.ar(envf)*env*amp.linlin(0,1,0,0.25);
	sig = Limiter.ar(LeakDC.ar(sig),0.9);
	Out.ar([0,1],sig);
}).add;


SynthDef(\plant11,{arg freq1=0.5,freq2=0.5,freq3=0.8,freq4=0.25,amp=1,gate=1,rel=1,noise=1;
	var env= EnvGen.ar(Env.perc(0.5,rel.linlin(0.25,0.6,0.7,1)),gate,doneAction:2);
	var envf= EnvGen.ar(Env([freq1.linlin(0,2,300,400),freq2.linlin(0.5,1,200,400),freq3.linlin(0,1,200,600)],[0.1,0.25]));
	var sig = WhiteNoise.ar(env*noise)+SinOsc.ar(envf)*env*amp.linlin(0.6,0.8,1,0.75);
	sig = Limiter.ar(LeakDC.ar(sig),0.9);
	Out.ar([0,1],sig);
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


SynthDef(\plant2,{arg freq1=0.5,freq2=0.5,freq3=0.5,freq4=0.8,amp=1,gate=1,rel=1;
	var env= EnvGen.ar(Env.perc(0.25,rel.linlin(0,1,0.1,2)),gate,doneAction:2);
	var envf= EnvGen.ar(Env([freq1.linlin(0,4,600,800),freq2.linlin(0,1,60,100),freq3.linlin(0.5,1,600,800)],[0.01,1]));
    var sig = SinOsc.ar(envf)*env*amp.linlin(0,1,0,0.25);
	sig = Limiter.ar(LeakDC.ar(sig),0.9);
	Out.ar([0,1],sig);
}).add;


SynthDef(\plant21,{arg freq1=0.5,freq2=0.5,freq3=0.8,freq4=0.25,amp=1,gate=1,rel=1,noise=1;
	var env= EnvGen.ar(Env.perc(0.01,rel.linlin(0.25,0.6,0.7,1)),gate,doneAction:2);
	var envf= EnvGen.ar(Env([freq1.linlin(0,4,200,300),freq2.linlin(0,1,60,100),freq3.linlin(0,1,200,400)],[0.1,0.25]));
	var sig = WhiteNoise.ar(env*noise)+SinOsc.ar(envf)*env*amp.linlin(0.6,0.8,1,0.75);
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

SynthDef(\plant3,{arg freq1=0.5,freq2=0.5,freq3=0.5,freq4=0.8,amp=1,gate=1,rel=1;
	var env= EnvGen.ar(Env.perc(0.01,rel.linlin(0.25,1,0.5,2)),gate,doneAction:2);
	var envf= EnvGen.ar(Env([freq1.linlin(0.5,2,800,1200),freq2.linlin(0,2,800,15000),freq3.linlin(0,1,200,800)], [0.01,1]));
    var sig = SinOsc.ar(envf)*env*amp.linlin(0,1,0,0.25);
	sig = Limiter.ar(LeakDC.ar(sig),0.9);
	Out.ar([0,1],sig);
}).add;


 SynthDef(\plant31,{arg freq1=0.6,freq2=0.5,freq3=0.2,freq4=0.25,amp=1,gate=1,rel=1,noise=1;
	var env= EnvGen.ar(Env.perc(0.01,rel.linlin(0.5,0.6,0.7,1)),gate,doneAction:2);
	var envf= EnvGen.ar(Env([freq1.linlin(0,2,200,400),freq2.linlin(0,2,200,600),freq3.linlin(0,2,600,800)],[0.1,0.25]));
	var sig = WhiteNoise.ar(env*noise)+SinOsc.ar(envf)*env*amp.linlin(0.6,0.8,1,0.75);
	sig = Limiter.ar(LeakDC.ar(sig),0.9);
	Out.ar([0,1],sig);
}).add;


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
