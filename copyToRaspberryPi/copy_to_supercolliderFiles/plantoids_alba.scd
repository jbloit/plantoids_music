fork{
	// launch sound
	(dur:1, strum: 0.1, degree: [0,4,7]).play;

	currentEnvironment.clear;

	// GLOBAL VARS
	~p1StemLDRsCount=11;

	// AUDIO GRAPH
	// =================== /
	~p1src= Group.new;
	~p1fx = Group.after(~p1src);
	~p1bus = Bus.audio(s, 2);

	~p2src= Group.new;
	~p2fx = Group.after(~p2src);
	~p2bus = Bus.audio(s, 2);

	~p3src= Group.new;
	~p3fx = Group.after(~p3src);
	~p3bus = Bus.audio(s, 2);

	~rootFreq = 99;

	SynthDef(\gain, {
		|in=0, out=0, amp=1|
		Out.ar(out, In.ar(in, 2) * amp);
	}).add;

	SynthDef(\reverb, {
		|in=0, out = 0, mix=0.8|
		var sig;
		sig = In.ar(in, 1);
		sig = FreeVerb.ar(sig, mix, 0.1)!2;
		Out.ar(out, sig);
	}).add;

	s.sync;
	Synth.new(\reverb, [\in, ~p1bus], ~p1fx);
	Synth.new(\reverb, [\in, ~p2bus], ~p2fx);
	Synth.new(\reverb, [\in, ~p3bus], ~p3fx);

	// P1 Synths
	// ---------------------------------- /
	SynthDef(\droneRoof, {
		|amp=1, out=0|
		var a, sig;
		a=Saw;
		sig = Splay.ar(Formant.ar(a.ar((5,7..15)*19)*99+199,a.ar((1,3..13)*29)*199+299,a.ar((3,5..11)*a.ar(3,2,3))*299+399))/3;
		Out.ar(out, sig*amp);
	}).add;

	// ---------------------------------- /
	SynthDef(\droneTables,{
		|amp=1, out=0|
		var a, sig;
		a = SinOsc;
		sig = a.ar(a.ar(1/[8,9])*4+[400,202],CombC.ar(InFeedback.ar([1,0]).lagud(a.ar(1/9)+1/88,a.ar(1/8)+1/99),1,0.08,9));
		Out.ar(out, sig*amp);
	}).add;
	// ---------------------------------- /


	SynthDef(\arp2notes,{
		var a, sig;
		a=LFPar;
		sig = BLowPass.ar(a.ar(Select.kr(a.kr(1/[3,4],0,64*a.kr(5)),(60..67).midicps)),a.kr(0.04)+5*500,a.kr(1/[5,6])+1.01);
		Out.ar(0, sig);
	}).add;

	// Synth(\arp2notes)

	// ---------------------------------- /
	SynthDef(\beatIked,{
		var a, sig,d,c;
		a=SinOsc;
		d=a.ar(12*a.ar(9))%1/4;
		c=Amplitude.ar(InFeedback.ar(0),d,d)+a.ar(d*d+[32.01,32]);
		sig = BBandPass.ar(a.ar(0,c*9,c));
		Out.ar(0, sig);}).add;
	// ---------------------------------- /

	// a SynthDef
	SynthDef(\beep,
		{ | out=0, freq = 4000, amp = 0.1, nharms = 10, pan = 0 |
			var audio = Blip.ar(freq, nharms, amp);
			var env = EnvGen.kr(Env.perc(0.01, 0.1), doneAction:2);
			Out.ar(out, Pan2.ar(audio, pan, env) );
	}).add;


	SynthDef(\drone_harshOctaves,
		{
			|out=0, amp=0.05, rootFreq=99|
			var sig, a, b;
			a=GrayNoise.ar;
			b=(1..9);
			sig = CombL.ar(a,1,b/Duty.ar(3,0,Dseq([0.5,1,2,3]*rootFreq,rootFreq)).lag3(1)).mean/2+Ringz.ar(a/rootFreq,b*rootFreq).mean!2;
			Out.ar(out, sig*amp);
	}).add;

	SynthDef(\sawpulse, { |out, freq = 99, gate = 0.5, plfofreq = 6, mw = 0, ffreq = 2000, rq = 0.3, freqlag = 0.05, amp = 1, pan=0|
		var sig, plfo, fcurve;
		plfo = SinOsc.kr(plfofreq, mul:mw, add:1);
		freq = Lag.kr(freq, freqlag) * plfo;
		fcurve = EnvGen.kr(Env.adsr(0, 0.3, 0.1, 20), gate);
		fcurve = (fcurve - 1).madd(0.7, 1) * ffreq;
		sig = Mix.ar([Pulse.ar(freq, 0.9), Saw.ar(freq*1.007)]);
		sig = RLPF.ar(sig, fcurve, rq)
		* EnvGen.kr(Env.adsr(0.04, 0.2, 0.6, 0.1), gate, doneAction: Done.freeSelf)
		* amp;
		Out.ar(out, sig ! 2)
	}).add;

	SynthDef(\kick1, {
		var snd;
		snd = DC.ar(0);
		snd = snd + (SinOsc.ar(XLine.ar(800, 400, 0.01)) * Env.perc(0.0005, 0.01).ar);
		snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), XLine.ar(800, 100, 0.01), 0.6) * Env.perc(0.001, 0.02).delay(0.001).ar);
		snd = snd + (SinOsc.ar(XLine.ar(172, 50, 0.01)) * Env.perc(0.0001, 0.3, 1, \lin).delay(0.005).ar(2));
		snd = snd.tanh;
		Out.ar(\out.kr(0), Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1)));
	}).add;

	SynthDef(\kick2, {
		var snd;
		snd = DC.ar(0);
		snd = snd + (HPF.ar(Hasher.ar(Sweep.ar), 1320) * Env.perc(0.003, 0.03).ar * 0.5);
		snd = snd + (SinOsc.ar(XLine.ar(750, 161, 0.02)) * Env.perc(0.0005, 0.02).ar);
		snd = snd + (SinOsc.ar(XLine.ar(167, 52, 0.04)) * Env.perc(0.0005, 0.3).ar(2));
		snd = snd.tanh;
		Out.ar(\out.kr(0), Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1)));
	}).add;

	SynthDef(\kick3, {
		var snd;
		snd = DC.ar(0);
		snd = snd + (SinOsc.ar(XLine.ar(1500, 800, 0.01)) * Env.perc(0.0005, 0.01, curve: \lin).ar);
		snd = snd + (BPF.ar(Impulse.ar(0) * SampleRate.ir / 48000, 6100, 1.0) * 3.dbamp);
		snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 300, 0.9) * Env.perc(0.001, 0.02).ar);
		snd = snd + (SinOsc.ar(XLine.ar(472, 60, 0.045)) * Env.perc(0.0001, 0.3, curve: \lin).delay(0.005).ar(2));
		snd = snd.tanh;
		Out.ar(\out.kr(0), Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1)));
	}).add;


	TempoClock.tempo = 1.45;

	/* =======================================
	SENSOR CALLBACKS : Plant 1
	=======================================*/

	s.sync;
	~p1_drone = Synth(\drone_harshOctaves);

	// ~p1_flower_ambientLight = {|i=0, v=0| postf("~p1_flower_ambientLight i:% v:% \n", i, v);};

	~p1_flower_flexQuake = {|i=0, v=0, state=0|
		// postf("~p1_flower_flexQuake i:% v:% \n", i, v);

		switch(state,
			-1, {},
			0, {},
			1, {},
			2, {"----->ONSET FLEX".postln;
				~rootFreq = ~rootFreq + 10;
				~p1_drone.set(\rootFreq, ~rootFreq);
			},
		);
	};

	// ~p1_flower_temperature = {|i=0, v=0| postf("~p1_flower_temperature i:% v:% \n", i, v);};

	// ~p1_flower_humidity = {|i=0, v=0| postf("~p1_flower_humidity i:% v:% \n", i, v);};

	// ~p1_leaves_light = {|i=0, v=0| postf("~p1_leaves_light i:% v:% \n", i, v);};

/*	~p1_stem_light = {|i=0, v=0|
		// postf("~p1_stem_light i:% v:% \n", i, v);
		Pdefn(("p1TonesDur"++i).asSymbol, (0.1 + v));
		Pdefn(("p1TonesAmp"++i).asSymbol, v/10);
	};*/

	// ~p1_stem_sonar = {|i=0, v=0| postf("~p1_stem_sonar i:% v:% \n", i, v);};

	/* =======================================
	SENSOR CALLBACKS : Plant 2
	=======================================*/

	~p2beep_dur = 1;
	Pdef(\p2beep,
		Pbind(\instrument, \beep,
			\dur, Pfunc({~p2beep_dur}),
			\freq, Pseq([4000], inf),
			\out, 0,
			\amp, 1,
			\group, ~p2src,
			\out, ~p2bus
	)).play;

	Pdef(\p2beepHi,
		Pbind(\instrument, \beep,
			\dur, 0.1,
			\freq, Pseq([5000], 3),
			\out, 0,
			\amp, 1,
			\group, ~p2src,
			\out, ~p2bus
	));

	// ~p2_flower_flexQuake = {|i=0, v=0| postf("~p2_flower_flexQuake i:% v:% \n", i, v);};
	~p2_leaves_light = {|i=0, v=0, state=0|
	};

	~p2_stem_light = {|i=0, v=0, state=0|
		postf("~p2_stem_light i:% v:% \n", i, v);
		switch(state,
			-1, {Pdef(\p2beepHi).stop},
			0, {},
			1, {},
			2, {Pdef(\p2beepHi).play;}
		);

	};
	// ~p2_stem_sonar = {|i=0, v=0| postf("~p2_stem_sonar i:% v:% \n", i, v);};


	/* =======================================
	SENSOR CALLBACKS : Plant 3
	=======================================*/
	~remote = NetAddr("127.0.0.1", 12345);
	~light = {|val=0| ~remote.sendMsg("/music2light/global/tempo", val); "LIGHTOSC".postln};

	~light.value(1);
	~light.value(1);
	~light.value(1);

	Pdef(\p3_arpsaw,
		PmonoArtic(\sawpulse,
			\dur, 1/4,
			\freq, Prand([0.5,1],inf) * Pfunc({~rootFreq}),
			\legato, 0.6,
			\amp, Pwhite(0.0, 0.1, inf),
			\out, 0,
			\group, ~p3src
	)).play;

	Pdef(\p3_kick,
		Pbind(
			\instrument, Prand([\kick1, \kick2, \kick3],inf),
			\dur, Prand([1/4, 2/4, 4/4, 5/4],inf),
			\amp, 0.2,
			\dummy, Pfunc({~remote.sendMsg("/music2light/3/perc", 1);})
	)).play;

	~p3_flower_flexQuake = {|i=0, v=0, state=0|

		// postf("~p3_flower_flexQuake i:% v:% \n", i, v);
		switch(state,
			-1, {},
			0, {},
			1, {},
			2, {"----> P3 FLEX ONSET".postln}
		);

	};

	~p3_leaves_light = {|i=0, v=0|
		postf("~p3_leaves_light i:% v:% \n", i, v);
	};

	~p3_flower_light = {
		|i=0, v=0, state=0|
		postf("~p3_flower_light i:% v:% \n", i, v);

	};
	// ~p3_stem_sonar = {|i=0, v=0| postf("~p3_stem_sonar i:% v:% \n", i, v);};


	// manage the OSC parsing:
	"plantoids_parseOSC.scd".loadRelative(true, {"loaded parse OSC".postln});

	// ~p1_orchParts = Array.newClear(~p1StemLDRsCount);
	// ~p1StemLDRsCount.do{|i|
	// 	Pbind(\dur, Pdefn(("p1TonesDur"++i).asSymbol, 0.12),
	// 		\sustain, 1,
	// 		\amp, Pdefn(("p1TonesAmp"++i).asSymbol, 0.01),
	// 		\x, Pdefn(\deg, 1) + 6.rand,
	// 		\degree, Pgauss(Pkey(\x), sin(Pkey(\x)+Ptime()%6/6e3)*9),
	// 		\pan, Pkey(\degree)-Pkey(\x)*9,
	// 		\group, ~p1src,
	// 		\out, ~p1bus
	// 	).play;
	// }




};
