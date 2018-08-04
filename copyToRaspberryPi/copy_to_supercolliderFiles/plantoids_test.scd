fork{
	// launch sound
	(dur:1, strum: 0.1, degree: [0,4,7]).play;

	currentEnvironment.clear;

	// GLOBAL VARS
	~p1StemLDRsCount=11;
	~samplesDir = thisProcess.nowExecutingPath.dirname +/+ "../soundfiles";
	~postOSC  = True;

	"plantoids_test_synthdefs.scd".loadRelative(true, {"loaded synthdefs".postln});

	// ==========================================================
	//                                                        MUSIC TO LIGHT
	// ==========================================================
	~lightRemote = NetAddr("127.0.0.1", 8000);

	// call this when LDRs are triggered
	~ldrOnset = {|plantIndex=0, sensorIndex=0, velocity=0|
		~lightRemote.sendMsg("/music2light/ldrNote", plantIndex, sensorIndex, velocity);
		postf("LDR SEND OSC \n");
	};

	// call this when notes are triggered from flex quake sensors

	// tempo change


	// root note change

	// background pattern events
	~patternEvent = {|plantIndex=0, velocity=0|
		// postf("BASS VELOCITY % \n", (velocity*255).asInt);
		~lightRemote.sendMsg("/music2light/patternNote", plantIndex, (velocity*255).asInt);
	};

    // ==========================================================
	//                                                       AUDIO GRAPH
	// ==========================================================
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

	~rootFreq = 99;





	~tempoFactor = 1; // factor of 60bpm
	TempoClock.tempo = ~tempoFactor;

	/* =======================================
	SENSOR CALLBACKS : Plant 1
	=======================================*/

	s.sync;
	~p1_wind;
	~p1_sonars= Array.newClear(4);
	~p1_quake;

	~percLevel = 0.5;
	~arpLevel = 0.5;


	Pdef(\arp1).quant= 4;
	Pdef(\arp2).quant= 4;
	Pdef(\arp3).quant= 4;
	Pdef(\arp1, PmonoArtic(\avlead,
		\freq, Pseq([100, 120, 400, 300], inf),
		\dur, 0.25,
		\legato, 0.2,
		\amp, Pfunc({~arpLevel})*Pseq([1, 1, 1, 0], inf)*Pseg(Pseq([0, 0.1], inf), 48),
		\pan, -0.3,
	));
	Pdef(\arp2, PmonoArtic(\avlead,
		\freq, Pseq([100, 120, 300, 50, 120, 300], inf)*2,
		\dur, 0.25,  //0.25= 1/4
		\legato, 0.2,
		\amp, Pfunc({~arpLevel})*Pseq([1, 1, 0], inf)*Pseg(Pseq([0, 0.1], inf), 44),
		\pan, 0.3,
	));
	Pdef(\arp3, PmonoArtic(\avlead,
		\freq, Pseq([100, 120, 300, 400, 120, 120, 120], inf)*2,
		\dur, 0.125,  //0.125= 1/8
		\legato, 0.2,
		\amp, Pfunc({~arpLevel})*Pseq([1, 0], inf)*0.1,
	));



	Pdef(\bd).quant= 4;
	Pdef(\bd, PmonoArtic(\avbd,
		\freq, 50,
		\dur, Pseq([1, 1, 1, 1, 1, 1, 2], inf),  //duration pattern - should add up to 8
		\legato, 0.1,
		\amp, Pfunc({~percLevel}),
	));

	Pdef(\hh).quant= 4;
	Pdef(\hh, PmonoArtic(\avhh,
		\dur, Pseq([0.25, 0.25, 0.5], inf),
		\legato, 0.1,
		\amp, Pseq([0.25, 1], inf)*Pfunc({~percLevel}),
		\pan, Pseq([0.3, 0, -0.3], inf),
	));

	~p1_flower_ambientLight = {
		|i=0, v=0|
		// postf("~p1_flower_ambientLight i:% v:% \n", i, v);
		~arpLevel = v;
		~bassLevel = v;
		~percLevel = 1 - v;
	};

	~p1_flower_flexQuake = {|i=0, v=0, state=0|
		// postf("~p1_flower_flexQuake i:% v:% \n", i, v);

		switch(state,
			-1, {
				// "----->OFFSET FLEX".postln;
			},
			0, {
				//"----->OFF FLEX".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;

			},
			2, {
				// "----->ONSET FLEX".postln;
				Synth(\thump, [\filter, v, \amp, v/2]);
			},
		);
	};

	~p1_flower_flexWind = {|i=0, v=0, state=0|
		// postf("~p1_flower_flexWind i:% v:% \n", i, v);

		switch(state,
			-1, {
				// "----->OFFSET FLEX".postln;
				~p1_wind.free;},
			0, {
				//"----->OFF FLEX".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;
				~p1_wind.set(\freqNorm, v);
				~p1_wind.set(\amp, v/5);
			},
			2, {
				// "----->ONSET FLEX".postln;
				~p1_wind.free;
				~p1_wind = Synth(\windBasic);
			},
		);
	};

	~p1_flower_temperature = {
		|i=0, v=0|
		// v.postln;
		~tempoFactor = v + 0.8;
		TempoClock.tempo = ~tempoFactor;
	};

	~p1_flower_humidity = {
		|i=0, v=0|
		// postf("~p1_flower_humidity i:% v:% \n", i, v);

	};

	~p1_leaves_light = {|i=0, v=0, state=0|
		// postf("~p1_leaves_light i:% v:% \n", i, v);
		switch(state,
			-1, {
				// "----->OFFSET LIGHT".postln;
			},
			0, {
				//"----->OFF LIGHT".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;
			},
			2, {
				// "----->ONSET LIGHT".postln;
				~tac.play;
				~ldrOnset.value(0, i, v);
			},
		);
	};

	~p1_stem_light = {|i=0, v=0, state=0|
		switch(state,
			-1, {
				// "----->OFFSET LIGHT".postln;
			},
			0, {
				//"----->OFF LIGHT".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;
			},
			2, {
				// "----->ONSET LIGHT".postln;
				~tic.play;
				~ldrOnset.value(0, i, v);
			},
		);
	};

	~p1_stem_sonar = {|i=0, v=0, state=0|
		// postf("~p1_stem_sonar i:% v:% \n", i, v);
		switch(state,
			-1, {
				// "----->OFFSET SONAR".postln;
				~p1_sonars[i].free;
			},
			0, {
				//"----->OFF SONAR".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;
				~p1_sonars[i].set(\amp, v);
			},
			2, {
				// "----->ONSET SONAR".postln;
				~p1_sonars[i].free;
				~p1_sonars[i]=Synth(\droneee, [freq: ~rootFreq*(i+1)]);
			},
		);
	};

	/* =======================================
	SENSOR CALLBACKS : Plant 2
	=======================================*/

	~p2_wind;
	~p2_sonars= Array.newClear(4);
	~p2_quake;

	~p2_flower_flexQuake = {
		|i=0, v=0, state=0|
		// postf("~p2_flower_flexQuake i:% v:% \n", i, v);
		switch(state,
			-1, {
				// "----->OFFSET FLEX".postln;
			},
			0, {
				//"----->OFF FLEX".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;
			},
			2, {
				// "----->ONSET FLEX".postln;
				Synth(\thump, [\filter, v, \amp, v/2]);
			},
		);
	};
	~p2_leaves_light = {|i=0, v=0, state=0|
		// postf("p2 leaves state=%\n", state);
		switch(state,
			-1, {
				// "----->OFFSET LIGHT".postln;
			},
			0, {
				//"----->OFF LIGHT".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;
			},
			2, {
				// "----->ONSET LIGHT".postln;
				~tac.play;
				~ldrOnset.value(1, i, v);
			},
		);
	};

	~p2_stem_light = {|i=0, v=0, state=0|
		postf("~p2_stem_light i:% v:% \n", i, v);
		switch(state,
			-1, {
				// "----->OFFSET LIGHT".postln;
			},
			0, {
				//"----->OFF LIGHT".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;
			},
			2, {
				// "----->ONSET LIGHT".postln;
				~tic.play;
				~ldrOnset.value(1, i, v);
			},
		);
	};
	~p2_stem_sonar = {|i=0, v=0, state=0|
		// postf("~p2_stem_sonar i:% v:% state: %\n", i, v, state);

		switch(state,
			-1, {
				// "----->OFFSET SONAR".postln;
				~p2_sonars[i].free;
			},
			0, {
				//"----->OFF SONAR".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;
				~p2_sonars[i].set(\amp, v);
			},
			2, {
				// "----->ONSET SONAR".postln;
				~p2_sonars[i].free;
				~p2_sonars[i]=Synth(\droneee, [freq: ~rootFreq*1.5*(i+1)]);
			},
		);
	};


	/* =======================================
	SENSOR CALLBACKS : Plant 3
	=======================================*/
	~remote = NetAddr("127.0.0.1", 12345);
	~light = {|val=0| ~remote.sendMsg("/music2light/global/tempo", val); "LIGHTOSC".postln};

	~bassLevel = 0.5;
	~bassModulation = 1;

	~transpose = 1.0;

	Pdef(\bass).quant= 4;
	Pdef(\bass, PmonoArtic(\avbass,
		// \freq, Pseq([100, 50, 50, 120], inf)*Pseq([Pseq([1], 64), Pseq([1.25], 64)], inf),  //transpose each 64*0.25/4= 4 bar
		\freq, Pseq([100, 50, 50, 120], inf) * Pfunc({~transpose}),
		\dur, 0.25,
		\mod, Pfunc({~bassModulation}),
		\rel, 0.3,
		\legato, 0.5,
		\amp, Pfunc({~bassLevel})*Pseq([0.5, 0.5, 0.5, 0.25], inf),
		\light, Pfunc({arg ev; ~patternEvent.value(0, ev[\amp])}),
		// \debug, Pfunc({arg ev; ~printBassVelocity.value(ev[\amp])}),
	)).play;

	// comment transformer [ 100, 50, 50, 120] en root*degreePattern*scale


	~p3_sonars= Array.newClear(4);

	~p3_flower_flexQuake = {|i=0, v=0, state=0|
		// postf("~p3_flower_flexQuake i:% v:% \n", i, v);
		switch(state,
			-1, {
				// "----->OFFSET FLEX".postln;
			},
			0, {
				//"----->OFF FLEX".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;

			},
			2, {
				// "----->ONSET FLEX".postln;
				Synth(\thump, [\filter, v, \amp, v/2]);
				~transpose = rrand(1.0, 2.0);
			},
		);

	};

	~p3_leaves_light = {|i=0, v=0, state=0|
		// postf("~p3_leaves_light i:% v:% \n", i, v);
		switch(state,
			-1, {
				// "----->OFFSET LIGHT".postln;
			},
			0, {
				//"----->OFF LIGHT".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;
				~bassModulation = v*10;
			},
			2, {
				// "----->ONSET LIGHT".postln;

			},
		)
	};

	~p3_flower_light = {
		|i=0, v=0, state=0|
		// postf("~p3_flower_light i:% v:% \n", i, v);
		switch(state,
			-1, {
				// "----->OFFSET LIGHT".postln;
			},
			0, {
				//"----->OFF LIGHT".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;
			},
			2, {
				// "----->ONSET LIGHT".postln;
				~tic.play;
				~ldrOnset.value(2, i, v);
			},
		)
	};

	~p3_stem_sonar = {|i=0, v=0, state=0|
		// postf("~p3_stem_sonar i:% v:% s: %\n", i, v, state);
		switch(state,
			-1, {
				// "----->OFFSET SONAR".postln;

			},
			0, {
				//"----->OFF SONAR".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;
				~p3_sonars[i].set(\amp, v);
			},
			2, {
				// "----->ONSET SONAR".postln;
				Synth(\avbassperc, [\freq, ~rootFreq*3/5*(i+1), \mod, 33]);
				// ~p3_sonars[i]=Synth(\droneee, [freq: ~rootFreq*3/5*(i+1)]);
			},
		);
	};


	// manage the OSC parsing:
	"plantoids_parseOSC.scd".loadRelative(true, {"loaded parse OSC".postln});

};
