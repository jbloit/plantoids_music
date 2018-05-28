fork{
	// launch sound
	(dur:1, strum: 0.1, degree: [0,4,7]).play;

	currentEnvironment.clear;

	~p1src= Group.new;
	~p1fx = Group.after(~p1src);
	~p1bus = Bus.audio(s, 2);

	~p1StemLDRsCount=11;

	// COMMON
	// =================== /
	SynthDef(\gain, {
		|in=0, out=0, amp=1|
		Out.ar(out, In.ar(in, 2) * amp);
	}).add;

	SynthDef(\reverb, {
		|in=0, out = 0|
		var sig;
		sig = In.ar(in, 1);
		sig = FreeVerb.ar(sig)!2;
		Out.ar(out, sig);
	}).add;

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


	SynthDef(\beatIked,{
		var a, sig,d,c;
		a=SinOsc;
		d=a.ar(12*a.ar(9))%1/4;
		c=Amplitude.ar(InFeedback.ar(0),d,d)+a.ar(d*d+[32.01,32]);
		sig = BBandPass.ar(a.ar(0,c*9,c));
		Out.ar(0, sig);}).add;


	SynthDef(\drone,
		{
			var sig1, sig2;
			//--tweet0009 ORCHESTRA TUNING DRONE
			{|i|
				Pbind(\dur,0.12
					,\sustain,1,
					\amp,0.01,
					\x, Pdefn(\deg, 1) + 6.rand,
					\degree, Pgauss(Pkey(\x), sin(Pkey(\x)+Ptime()%6/6e3)*9),
					\pan, Pkey(\degree)-Pkey(\x)*9,
					\out, 1,
			)}!6;
	});

	//--tweet0009 ORCHESTRA TUNING DRONE

	// ~p1_flower_ambientLight = {|i=0, v=0| postf("~p1_flower_ambientLight i:% v:% \n", i, v);};

	~p1_flower_flexQuake = {|i=0, v=0|
		// postf("~p1_flower_flexQuake i:% v:% \n", i, v);
		Pdefn(\deg, v*10);
	};

	// ~p1_flower_temperature = {|i=0, v=0| postf("~p1_flower_temperature i:% v:% \n", i, v);};

	// ~p1_flower_humidity = {|i=0, v=0| postf("~p1_flower_humidity i:% v:% \n", i, v);};

	// ~p1_leafs_light = {|i=0, v=0| postf("~p1_leafs_light i:% v:% \n", i, v);};

	~p1_stem_light = {|i=0, v=0|
		// postf("~p1_stem_light i:% v:% \n", i, v);
		Pdefn(("p1TonesDur"++i).asSymbol, (0.1 + v));
		Pdefn(("p1TonesAmp"++i).asSymbol, v/10);
	};

	// ~p1_stem_sonar = {|i=0, v=0| postf("~p1_stem_sonar i:% v:% \n", i, v);};

		// manage the OSC parsing:
	"plantoids_alba_parseOSC.scd".loadRelative(true, {"loaded parse OSC".postln});

	~p1_orchParts = Array.newClear(~p1StemLDRsCount);
	 ~p1StemLDRsCount.do{|i|
	 	Pbind(\dur, Pdefn(("p1TonesDur"++i).asSymbol, 0.12),
	 		\sustain, 1,
			\amp, Pdefn(("p1TonesAmp"++i).asSymbol, 0.01),
	 		\x, Pdefn(\deg, 1) + 6.rand,
	 		\degree, Pgauss(Pkey(\x), sin(Pkey(\x)+Ptime()%6/6e3)*9),
	 		\pan, Pkey(\degree)-Pkey(\x)*9,
	 		\out, 0,
	 	).play;
	 }
};
