fork{
	// launch sound
	(dur:1, strum: 0.1, degree: [0,4,7]).play;

	currentEnvironment.clear;
	"plantoids_plinky_synthdefs.scd".loadRelative(true, {"loaded synthdefs".postln});

	// GLOBAL VARS
	~samplesDir = thisProcess.nowExecutingPath.dirname +/+ "../soundfiles";
	~postOSC  = false;
	~rootFreq = 99;
	~tempoFactor = 300/60; // factor of 60bpm
	~scale = Scale.majorPentatonic;

	TempoClock.tempo = ~tempoFactor;


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



	/* =======================================
	SENSOR CALLBACKS : Plant 1
	=======================================*/

	// PLANT 1 = MELODIC LEADS

	~lead1_degree = 0;
	~lead2_degree = 0;
	~lead3_degree = 0;
	~lead4_degree = 0;
	~state_flex=(-1);
	~detune = 0;
	~transpose=0;
	Pdef(\lead1,
		Pbind(\instrument,\lead1,
			\amp,Pseq([1],inf),
			\degree, Pfunc({~lead1_degree+~detune}),
			\scale, Pfunc({~scale}),
			\root,Pfunc({~transpose}),
			\dur, 1,
		)
	).stop;

	Pdef(\lead2,
		Pbind(\instrument,\lead2,
			\amp,Pseq([1],inf),
			\degree, Pfunc({~lead2_degree+3+~detune}),
			\scale, Pfunc({~scale}),
			\root,Pfunc({~transpose}),
			\octave,4,
			\dur, 4,
		)
	).stop;

	Pdef(\lead3,
		Pbind(\instrument,\lead3,
			\amp,Pseq([1],inf),
			\degree, Pfunc({~lead3_degree+4+~detune}),
			\scale, Pfunc({~scale}),
			\root,Pfunc({~transpose}),
			\octave,3,
			\dur, 2,
		)
	).stop;

	Pdef(\lead4,
		Pbind(\instrument,\lead4,
			\amp,Pseq([1],inf),
			\degree, Pfunc({~lead4_degree-1+~detune}),
			\scale, Pfunc({~scale}),
			\root,Pfunc({~transpose}),
			\octave,4,
			\dur, 1,
		)
	).stop;

	~p1_flower_ambientLight = {
		|i=0, v=0|
		// postf("~p1_flower_ambientLight i:% v:% \n", i, v);
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
				// "----->CHANGE VALUE".postln;

			},
			2, {
				// "----->ONSET FLEX".postln;

				~transpose = rrand(0,10).postln;


			},
		);
	};

	~p1_flower_flexWind = {|i=0, v=0, state=0|
		// postf("~p1_flower_flexWind i:% v:% \n", i, v);

		switch(state,
			-1, {
				// "----->OFFSET FLEX".postln;

			},
			0, {
				//"----->OFF FLEX".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;
								~detune = v;


			},
			2, {
				// "----->ONSET FLEX".postln;
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
			},
		);
	};

	~p1_stem_sonar = {|i=0, v=0, state=0|
		// postf("~p1_stem_sonar i:% v:% state:%\n", i, v, state);
		switch(state,
			-1, {
				// "----->OFFSET SONAR".postln;

				switch(i,
					0, {Pdef(\lead1).stop;},
					1, {Pdef(\lead2).stop;},
					2, {Pdef(\lead3).stop;},
					3, {Pdef(\lead4).stop;},
				);

			},
			0, {
				//"----->OFF SONAR".postln;
			},
			1, {
				"----->CHANGE VALUE".postln;
				switch(i,
					0, {~lead1_degree = (v*15).asInt.postln;Pdef(\lead1).play;},
					1, {~lead2_degree = (v*15).asInt.postln;Pdef(\lead2).play;},
					2, {~lead3_degree = (v*15).asInt.postln;Pdef(\lead3).play;},
					3, {~lead4_degree = (v*15).asInt.postln;Pdef(\lead4).play;},
				);			},
			2, {
				// "----->ONSET SONAR".postln;
				switch(i,
					0, {},
					1, {},
					2, {},
					3, {},
				);			},
		);
	};

	/* =======================================
	SENSOR CALLBACKS : Plant 2
	=======================================*/

	// PLANT 2 = BASS ?

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
			},
		);
	};
	~p2_stem_sonar = {|i=0, v=0, state=0|
		// postf("~p2_stem_sonar i:% v:% state: %\n", i, v, state);

		switch(state,
			-1, {
				// "----->OFFSET SONAR".postln;
			},
			0, {
				//"----->OFF SONAR".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;
			},
			2, {
				// "----->ONSET SONAR".postln;
			},
		);
	};


	/* =======================================
	SENSOR CALLBACKS : Plant 3
	=======================================*/

	// PLANT 3 = PERC ?

	Pdef(\kick,Pbind(\instrument,\kick,\dur,1,\isRest,Pseq([1,1,0],inf).coin.not,\amp,Pseq([0.3,0.1,0],inf))).play(quant:4);

	Ndef(\reverb,{
		var in=InFeedback.ar(0,2);
		in=FreeVerb.ar(in);
		in
	}).play;


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
			},
			2, {
				// "----->ONSET SONAR".postln;
				switch(i,
					0, {if (v >0.6) {Synth(\snare)} {Synth(\hat)}; },
					1, {if (v>0.6) {Synth(\junglesnare)} {Synth(\kick808)}; },

				);

			},
		);
	};


	// manage the OSC parsing:
	"plantoids_parseOSC.scd".loadRelative(true, {"loaded parse OSC".postln});
	"plantoids_plinky_sensorMapping.scd".loadRelative(true, {"loaded parse OSC".postln});
};