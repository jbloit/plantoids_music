//// IDEE : Le Flex quake pourrait déclencher le pattern pdef.play

// sur RaspberryPi 3, utilise 22% CPU



~daylight = Bus.control(s,1);
~temperature = Bus.control(s,1);
~humidity = Bus.control(s,1);

~flexquake = Bus.control(s,1);
~flexwind = Bus.control(s,1);


//drone


Ndef(\dronesplantes, {|
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
	var mainsig = SinOsc.ar([freq, freq*2,freq*3]+SinOsc.ar([fmod, fmod*2, fmod*3], 0, [fmoda, fmoda*2, fmoda*3]),lfop,
lfoa);
	mainsig = FreeVerb.ar(mainsig,1,1)+mainsig;
	mainsig = Splay.ar(mainsig,lfospread, amp,lfocenter);
	mainsig = Limiter.ar(LeakDC.ar(mainsig),0.8);
	mainsig;
        }).play;


~sonars1 = Bus.control(s,1);
~sonars2 = Bus.control(s,1);
~sonars3 = Bus.control(s,1);
~sonars4 = Bus.control(s,1);

~leaves_light1 = Bus.control(s,1);
~leaves_light2 = Bus.control(s,1);


~drone = Synth(\droneplant1);
~drone.set(\freq,~sonars1.asMap);
~drone.set(\fmod,~sonars2.asMap);
~drone.set(\fmoda,~sonars3.asMap);
~drone.set(\pmod,~sonars4.asMap);


~drone.set(\amod, ~leaves_light1.asMap);
~drone.set(\amoda, ~leaves_light2.asMap);



Ndef(\dronesplantes).edit;

Ndef(\dronesplantes).clear;



//plante1

SynthDef(\plant1,{arg freq1=0.5,freq2=0.5,freq3=0.5,amp=1,gate=1,rel=1;
	var env= EnvGen.ar(Env.perc(0.01,rel.linlin(0,1,0.1,2)),gate,doneAction:2);
	var envf= EnvGen.ar(Env([freq1.linlin(0,1,200,15000),freq2.linlin(0,1,20,150),freq3.linlin(0,1,30,100)],[0.01,1]));
    var sig = SinOsc.ar(envf)*env*amp.linlin(0,1,0,0.25);
	sig = Limiter.ar(LeakDC.ar(sig),0.9);
	Out.ar([0,1],sig);
}).add;


SynthDef(\plant11,{arg freq1=0.5,freq2=0.5,freq3=0.5,amp=1,gate=1,rel=1,noise=1;
	var env= EnvGen.ar(Env.perc(0.01,rel.linlin(0,1,0.1,0.8)),gate,doneAction:2);
	var envf= EnvGen.ar(Env([freq1.linlin(0,1,200,5000),freq2.linlin(0,1,200,1500),freq3.linlin(0,1,100,300)],[0.01,0.25]));
	var sig = WhiteNoise.ar(env*noise)+SinOsc.ar(envf)*env*amp.linlin(0,1,0,0.25);
	sig = Limiter.ar(LeakDC.ar(sig),0.9);
	Out.ar([0,1],sig);
}).add;





~stems_light1 = Bus.control(s,1);
~stems_light2 = Bus.control(s,1);
~stems_light3 = Bus.control(s,1);
~stems_light4 = Bus.control(s,1);


~stems_light1.value = 0.2;
~stems_light2.value = 0.8;
~stems_light3.value = 0.9;
~stems_light4.value = 0.2;



~stems_light5 = Bus.control(s,1);
~stems_light6 = Bus.control(s,1);
~stems_light7 = Bus.control(s,1);
~stems_light8 = Bus.control(s,1);

//


~stems_light5.value = 0.3;
~stems_light6.value = 0.9;
~stems_light7.value = 0.1;
~stems_light8.value = 0.9;

///
~stems_light9 = Bus.control(s,1);
~stems_light10 = Bus.control(s,1);
~stems_light11 = Bus.control(s,1);


~stems_light9.value = 1;
~stems_light10.value = 0.1;
~stems_light11.value = 0.4;


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
).play;



// plante 2


SynthDef(\plant2,{arg freq=0.5,amp=1,gate=1;
    var env= EnvGen.ar(Env.perc,gate,doneAction:2);
	var sig = SinOsc.ar(freq.linlin(0,1,200,800))*env*amp.linlin(0,1,0,0.25 );
	sig = Limiter.ar(LeakDC.ar(sig),0.9);
	Out.ar([0,1],sig);
}).add;
SynthDef(\plant21,{arg freq=0.5,amp=1,gate=1,noise=1;
    var env= EnvGen.ar(Env.perc,gate,doneAction:2);
	var sig = WhiteNoise.ar(noise*env)+SinOsc.ar(freq.linlin(0,1,4000,12000))*env*amp.linlin(0,1,0,0.25);
    sig = Limiter.ar(LeakDC.ar(sig),0.9);
	Out.ar([0,1],sig);
}).add;

~flexquake = Bus.control(s,1);


~sonars21 = Bus.control(s,1);
~sonars22 = Bus.control(s,1);
~sonars23 = Bus.control(s,1);
~sonars24 = Bus.control(s,1);


~stems_light21 = Bus.control(s,1);
~stems_light22 = Bus.control(s,1);
~stems_light23 = Bus.control(s,1);
~stems_light24 = Bus.control(s,1);
~stems_light25 = Bus.control(s,1);



~sonars21.value = 0.1;
~sonars22.value = 0.3;
~sonars23.value = 0.4;
~sonars24.value = 0.1;

~stems_light21.value = 0.2; //amp
~stems_light22.value = 0.1; //freq
~stems_light23.value = 0.2; //amp
~stems_light24.value = 0.4; // freq
~stems_light25.value = 0.8; //noise


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
).play;


////
// plante 3

SynthDef(\plant3,{arg freq=0.5,amp=1,gate=1,filter=600;
    var env= EnvGen.ar(Env.perc,gate,doneAction:2);
	var envf  = EnvGen.ar(Env([10000,freq.linlin(0,1,30,49).midicps/440*432],[0.001]));
	var sig = LFSaw.ar(envf*2)*LFSaw.ar(envf)*env*amp.linlin(0,1,0,0.5);
	sig = BPF.ar(sig,filter.linlin(0,1,30,12000),1);
	Out.ar([0,1],sig);
}).add;

 SynthDef(\plant31,{arg freq=0.5,amp=1,gate=1;
    var env= EnvGen.ar(Env.perc,gate,doneAction:2);
	var note = (freq.linlin(0,1,200,2000)/440*432).cpsmidi;
	var sig = SinOsc.ar(Demand.ar(Impulse.ar(16),0,Dseq([note,note+2,note+3,note+4,note+5,note+6,note+7].midicps,inf)))*env*amp.linlin(0,1,0,0.4);
    Out.ar([0,1],sig);
}).add;




~sonars31 = Bus.control(s,1);
~sonars32 = Bus.control(s,1);
~sonars31.value= 0.1;
~sonars32.value = 0.1;
~leaves_light31 = Bus.control(s,1);
~leaves_light32 = Bus.control(s,1);

~leaves_light31.value = 0.2;
~leaves_light32.value = 0.1;

~stems_light31 = Bus.control(s,1);
~stems_light32 = Bus.control(s,1);
~stems_light33 = Bus.control(s,1);
~stems_light34 = Bus.control(s,1);
~stems_light35 = Bus.control(s,1);

~stems_light31.value = 0.1;
~stems_light32.value = 0.8;
~stems_light33.value = 0.9;
~stems_light34.value = 0.1;
~stems_light35.value = 0.2;

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
).play;
