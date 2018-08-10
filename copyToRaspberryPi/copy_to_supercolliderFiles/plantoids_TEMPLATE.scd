fork{
	// launch sound
	(dur:1, strum: 0.1, degree: [0,4,7]).play;

	currentEnvironment.clear;
	"plantoids_TEMPLATE_synthdefs.scd".loadRelative(true, {"loaded synthdefs".postln});

	// GLOBAL VARS
	~samplesDir = thisProcess.nowExecutingPath.dirname +/+ "../soundfiles";
	~postOSC  = false;
	~rootFreq = 99;
	~tempoFactor = 1; // factor of 60bpm
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

	s.sync;

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
				//"----->CHANGE VALUE".postln;

			},
			2, {
				// "----->ONSET FLEX".postln;
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
		// postf("~p1_stem_sonar i:% v:% \n", i, v);
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
	SENSOR CALLBACKS : Plant 2
	=======================================*/


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
			},
		);
	};


	// manage the OSC parsing:
	"plantoids_parseOSC.scd".loadRelative(true, {"loaded parse OSC".postln});

};
