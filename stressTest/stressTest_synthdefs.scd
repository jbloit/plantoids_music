SynthDef(\plant1,{arg freq1=0.5,freq2=0.5,freq3=0.5,freq4=0.8,amp=1,gate=1,rel=1;
	var env= EnvGen.ar(Env.perc(0.01,rel.linlin(0,1,0.1,2)),gate,doneAction:2);
	var envf= EnvGen.ar(Env([freq1.linlin(0,1,200,1500),freq2.linlin(0,1,20,150),freq3.linlin(0,1,30,100)],[0.01,1]));
    var sig = SinOsc.ar(envf)*env*amp.linlin(0,1,0,0.25);
	sig = Limiter.ar(LeakDC.ar(sig),0.9);
	Out.ar([0,1],sig);
}).add;

