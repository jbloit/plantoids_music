
(
fork{
	// launch sound
	(dur:1, strum: 0.1, degree: [0,4,7]).play;

	currentEnvironment.clear;

	// GLOBAL VARS

	~postOSC  = False;
	"plantoids_synthdefs.scd".loadRelative(true, {"loaded synthdefs".postln});
	"plantoids_fern_patterns.scd".loadRelative(true, {"loaded pat".postln});

	// ==========================================================
	//														MUSIC TO LIGHT
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

	// P1 Synths
	// ---------------------------------- /

	~rootFreq = 99;

	~tempoVal = 1.0;
	~tempoFactor = ~tempoVal; // factor of 60bpm
	TempoClock.tempo = ~tempoFactor;

	/* =======================================
	SENSOR CALLBACKS : Plant 1
	=======================================*/

	s.sync;
	~p1_wind;
	~p1_sonars= Array.newClear(4);
	~p1_quake;
	~bassModulation = 1;
	~percLevel = 0.5;
	~arpLevel = 0.5;
	~bassLevel = 0.5;

	~printBassVelocity = {|vel=0|
		postf("---- bass velocity %\n", vel);
	};

	//////"init"
	Pdef(\chordpat).play;

	////


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
				~gen_notebank.();
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
		v.postln;
		~tempoFactor = v.linlin(0,1, 0.9,1.1)*~tempoVal;
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

	~stepchord_voices = 0!11;
	~p1_stem_light = {|i=0, v=0, state=0|
		switch(state,
			-1, {
				// "----->OFFSET LIGHT".postln;
				//"1".debug;

				~stepchord_voices[i] = 0;
			},
			0, {
				//"----->OFF LIGHT".postln;
				//"2".debug;
			},
			1, {
				//"----->CHANGE VALUE".postln;
				~stepchord_legato[i] = max(v,0.1);

				//"3".debug;
			},
			2, {
				// "----->ONSET LIGHT".postln;
				//"4".debug;
				~stepchord_voices[i] = 1
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
				
				//"jkj".debug(i);
				[
					{
						~bus[\lfofreq1].set(v.linexp(0,1,0.1,20));
					},
					{
						~bus[\lfofreq2].set(v.linexp(0,1,0.1,20));
					}
				].wrapAt(i).value;
			},
			2, {
				// "----->ONSET SONAR".postln;
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
		//postf("~p2_stem_light i:% v:% \n", i, v);
		switch(state,
			-1, {
				// "----->OFFSET LIGHT".postln;
			},
			0, {
				//"----->OFF LIGHT".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;
				~fernhi_rest[i] = v.round;
				if(i==3) {
					~fernhi_legato = max(v*4,0.2);
				}
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
				[
					{ ~bus[\fernhi_hpfac].set(v.linexp(0,1, 0.1,22)) },
					{ ~bus[\fernhi_hprq].set(v.linexp(0,1, 0.1,1)) },
					{ ~bus[\fernhi_rel].set(v.linlin(0,1, 0.1,1.4)) },
					//{ ~fernhat_ampfac = v.linlin(0,1, 0.5,1.4).debug("v")},
					{ ~fernhi_durfac = v.linexp(0,1, 1/2,1/12)},
				].wrapAt(i).value;
			},
			2, {
				 //"----->ONSET SONAR".postln;
				~fernhat_next = 1;
				~fernhat_ampfac = 2;
			},
		);
	};


	/* =======================================
	SENSOR CALLBACKS : Plant 3
	=======================================*/
	~remote = NetAddr("127.0.0.1", 12345);
	~light = {|val=0| ~remote.sendMsg("/music2light/global/tempo", val); "LIGHTOSC".postln};

	// ~light.value(1);
	// ~light.value(1);
	// ~light.value(1);

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
				~fernbass_lpftab[i] = v;
				~bus[\fernbass_lpf].value = ~fernbass_lpftab.collect({ arg a, b; a*( ( b+1 )/10 ) }).sum.linlin(0,2, 50,1500)
			},
			2, {
				// "----->ONSET LIGHT".postln;
			},
		)
	};

	~p3_stem_sonar = {|i=0, v=0, state=0|
		// postf("~p3_stem_sonar i:% v:% \n", i, v);
		switch(state,
			-1, {
				// "----->OFFSET SONAR".postln;
			},
			0, {
				//"----->OFF SONAR".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;
				if(i==0) {
					~fernbass_durfac = ( 1/(2**((0..3))) ).at(( v*3 ).round.asInteger)/2
				};
			},
			2, {
				// "----->ONSET SONAR".postln;
				~fernbass_next = 1;
				~fernhat_next = 1;
			},
		);
	};


	// manage the OSC parsing:
	"plantoids_parseOSC.scd".loadRelative(true, {"loaded parse OSC".postln});
	"sensorMapping_fern.scd".loadRelative(true, {"loaded parse OSC fern".postln});

};
)
