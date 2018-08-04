
Ndef(\droneplant1, {|
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
        });

//daylight , temperature , humidty
Spec.add(\amp, #[0, 1, \lin]);
Spec.add(\roffset, #[0, 1, \lin]);
Spec.add(\offset, #[0, 1, \lin]);

//flex quake, flex wind
Spec.add(\pitch, #[0, 1, \lin]);
Spec.add(\time, #[0, 1, \lin]);

//sonars
Spec.add(\at, #[0, 1, \lin]);
Spec.add(\dec, #[0, 1, \lin]);
Spec.add(\sus, #[0, 1, \lin]);
Spec.add(\rel, #[0, 1, \lin]);

// leaves lights
Spec.add(\rmfreq, #[0, 1, \lin]);
Spec.add(\rmphase, #[0, 1, \lin]);

// stems light
Spec.add(\del, #[0, 1, \lin]);
Spec.add(\del2, #[0, 1, \lin]);
Spec.add(\lit1, #[0, 1, \lin]);
Spec.add(\lit2, #[0, 1, \lin]);
Spec.add(\lit3, #[0, 1, \lin]);
Spec.add(\lit4, #[0, 1, \lin]);
Spec.add(\lit5, #[0, 1, \lin]);
Spec.add(\a1, #[0, 1, \lin]);
Spec.add(\a2, #[0, 1, \lin]);
Spec.add(\a3, #[0, 1, \lin]);
Spec.add(\a4, #[0, 1, \lin]);



Ndef(\plant1,{arg
	amp=0.25,roffset=400,at=0.01,dec=1,sus=0.01,rel=1,del=0.02,del2=0.02,
	pitch=1,time=2 , offset=200,lit1=10000,lit2=100,lit3=10000,lit4=100,lit5=50,a1=0.001,a2=0.1,a3=0.01,a4=0.001,rmfreq=10000,rmphase=0;
	var env = EnvGen.ar(Env([lit1.linlin(0,1,100,20000),lit2.linlin(0,1,30,20000),lit3.linlin(0,1,50,10000),lit4.linlin(0,1,70,10000),lit5.linlin(0,1,100,10000)],[a1.linlin(0,1,0.001,1),a2.linlin(0,1,1,3),a3.linlin(0,1,1,3),a4.linlin(0,1,1,3)]*time).circle);
	var sig = SinOsc.ar(SinOsc.kr(env,0,[pitch.linlin(0,1,0.1,4),pitch.linlin(0,1,0.1,4)+roffset.linlin(0,1,20,8000)]+offset.linlin(0,1,0.1,4000),env*[pitch.linlin(0,1,0.1,4),pitch.linlin(0,1,0.1,4)]),0,EnvGen.ar(Env([0,1,1,0],[at.linlin(0,1,0,10),dec.linlin(0,1,0.1,5),sus.linlin(0,1,0.1,5),rel.linlin(0,1,0.1,5)]*time).circle))*SinOsc.ar(rmfreq.linexp(0,1,20,20000),rmphase.linlin(0,1,0.001,3),1);
	sig = sig+ CombL.ar(sig,0.1,del.linlin(0,1,0.01,0.1))/2;
	sig = sig+ CombL.ar(sig,0.1,del2.linlin(0,1,0.01,0.1))/2;
	sig  = sig*amp;
	sig = Limiter.ar(sig,0.9);
	sig;
});


//daylight from plant 1
Spec.add(\amp, #[0, 1, \lin]);
//humdity
Spec.add(\roffset, #[0, 1, \lin]);


//flex quake,
Spec.add(\offset, #[0, 1, \lin]);

//sonars
Spec.add(\at, #[0, 1, \lin]);
Spec.add(\dec, #[0, 1, \lin]);
Spec.add(\sus, #[0, 1, \lin]);
Spec.add(\rel, #[0, 1, \lin]);

// leaves lights
Spec.add(\pitch, #[0, 1, \lin]);
Spec.add(\time, #[0, 1, \lin]);

// stems light
Spec.add(\lit1, #[0, 1, \lin]);
Spec.add(\lit2, #[0, 1, \lin]);
Spec.add(\lit3, #[0, 1, \lin]);
Spec.add(\a1, #[0, 1, \lin]);
Spec.add(\a2, #[0, 1, \lin]);



Ndef(\plant2,{arg
	amp=0.25,roffset=400,at=0.01,dec=1,sus=0.01,rel=1,del=0.02,
	pitch=1,time=2 , offset=200,lit1=10000,lit2=100,lit3=10000,a1=0.001,a2=0.1;
	var env = EnvGen.ar(Env([lit1.linlin(0,1,100,20000),lit2.linlin(0,1,30,20000),lit3.linlin(0,1,50,10000)],[a1.linlin(0,1,0.001,1),a2.linlin(0,1,0.001,3)].mirror*time).circle);
	var sig = SinOsc.ar(SinOsc.kr(env,0,[pitch.linlin(0,1,0.1,4),pitch.linlin(0,1,0.1,4)+roffset.linlin(0,1,20,8000)]+offset.linlin(0,1,0.1,4000),env*[pitch.linlin(0,1,0.1,4),pitch.linlin(0,1,0.1,4)]),0,EnvGen.ar(Env([0,1,1,0],[at.linlin(0,1,0,10),dec.linlin(0,1,0.1,5),sus.linlin(0,1,0.1,5),rel.linlin(0,1,0.1,5)]*time).circle));
	sig  = sig*amp;
	sig = HPF.ar(sig,1700);
	sig = FreeVerb.ar(sig,1,0.4);
	sig = Limiter.ar(sig,0.5);

	sig;
});
/*
Ndef(\plant2).set(\amp,v);
Ndef(\plant2).set(\roffset,v);
Ndef(\plant2).set(\at,v);
Ndef(\plant2).set(\dec,v);
Ndef(\plant2).set(\sus,v);
Ndef(\plant2).set(\rel,v);
Ndef(\plant2).set(\del,v);
Ndef(\plant2).set(\pitch,v);
Ndef(\plant2).set(\time,v);
Ndef(\plant2).set(\offset,v);
Ndef(\plant2).set(\lit1,v);
Ndef(\plant2).set(\lit2,v);
Ndef(\plant2).set(\lit3,v);
Ndef(\plant2).set(\a1,v);
Ndef(\plant2).set(\a2,v);
*/

Ndef(\plant3,{arg amp=1, speed = 0.5,pitch =1,amp1=1,amp2=1,amp3=1,amp4=1,amp5=1,amp6=1,cutoff=1,delay=1;
	var time = speed.linlin(0,1,0,4);
	var env = EnvGen.ar(Env([0,1,0,0],[0.01,1,0.01]*time).circle);
	var env2 = EnvGen.ar(Env([0,0,0,1],2*[1,0.01,0.01]*time).circle);
	var env3 = EnvGen.ar(Env([0,0,0,1],[1,0.01,0.01]*time/8).circle);
	var env4 = EnvGen.ar(Env([0,1,0,0],[0.01,1,0.01]*time/4).circle);
var env5 = EnvGen.ar(Env([0,0,0,1],8*[1,0.01,0.01]*time).circle);
	var sig = SinOsc.ar(EnvGen.ar(Env([10000,50,30]*pitch.linlin(0,1,0.75,2),[0.01,1.01]*time).circle),0,env)*amp1.linlin(0,1,0,0.5);
	var sig2 =WhiteNoise.ar(env2)*amp2.linlin(0,1,0,0.5);
	var sig3 =HPF.ar(WhiteNoise.ar(env3),6000*pitch)*amp3.linlin(0,1,0,0.5);
	var sig4 = SinOsc.ar(EnvGen.ar(Env([1000,170,300]*pitch.linlin(0,1,0.75,2),[0.01,1.01]*time/32).circle),0,env4/2)*amp4.linlin(0,1,0,0.5);
	var sig5 =WhiteNoise.ar(env5)*amp5.linlin(0,1,0,0.5);
	var sig6 = SinOsc.ar(EnvGen.ar(Env([10000,700,3000]*pitch.linlin(0,1,0.75,2),[0.01,1.01]*time/16).circle),0,env4/2)*amp6.linlin(0,1,0,0.5);

	var lpf = LPF.ar(sig+sig2+sig3+sig4+sig5+sig6,cutoff.linexp(0,1,150,15000));
	var del = CombC.ar(lpf,0.2,delay.linlin(0,1,0.1,0.01));
	var master = del * amp.linlin(0,1,0,0.5);
	master = Limiter.ar(master.linlin(0,1,0,0.5),0.9)*4;

	master!2;
});

Ndef(\plant3).set(\amp,1);
