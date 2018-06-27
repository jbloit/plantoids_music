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

	SynthDef(\wind, {|amp=0.2, out=0, modFreq=0.1, fFreq = 1348, fRq = 0.5|
		var src, mod;
		mod = {LFNoise2.ar(modFreq).range(0, 1)}!6;
		src = WhiteNoise.ar(mod.lagud(1, 4));
		src = RLPF.ar(src, fFreq.lag(1), fRq);
		Out.ar(out, Splay.ar(src*amp););
	}).add;


	// var samplePath = thisProcess.nowExecutingPath.dirname +/+ "Samples/HiHats1.hihat2.wav";

	TempoClock.tempo = 1.45;

	/* =======================================
	SENSOR CALLBACKS : Plant 1
	=======================================*/

	s.sync;
	~p1_wind;

	// ~p1_flower_ambientLight = {|i=0, v=0| postf("~p1_flower_ambientLight i:% v:% \n", i, v);};


	~p1_flower_flexWind = {|i=0, v=0, state=0|
		// postf("~p1_flower_flexWind i:% v:% \n", i, v);

		switch(state,
			-1, {
				"----->OFFSET FLEX".postln;
				~p1_wind.free;},
			0, {
				//"----->OFF FLEX".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;
				~p1_wind.set(\fRq, v);
				~p1_wind.set(\amp, v/5);
			},
			2, {
				"----->ONSET FLEX".postln;
				~p1_wind.free;
				~p1_wind = Synth(\wind);
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

};
