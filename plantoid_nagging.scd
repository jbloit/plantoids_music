fork{
	// launch sound
	(dur:1, strum: 0.1, degree: [0,4,7]).play;

	currentEnvironment.clear;

	// GLOBAL VARS

	~postOSC  = False;
	"naggingplants.scd".loadRelative(true, {"loaded synthdefs".postln});

	// ==========================================================
	//                                                        MUSIC TO LIGHT
	// ==========================================================
	~lightRemote = NetAddr("127.0.0.1", 8000);

	// call this when LDRs are triggered
	~ldrOnset = {|plantIndex=0, sensorIndex=0, velocity=0|
		~lightRemote.sendMsg("/music2light/ldrNote", plantIndex, sensorIndex, velocity);
		postf("LDR SEND OSC \n");
	};

	// background pattern events
	~patternEvent = {|plantIndex=0, velocity=0|
		// postf("BASS VELOCITY % \n", (velocity*255).asInt);
		~lightRemote.sendMsg("/music2light/patternNote", plantIndex, (velocity*255).asInt);
	};

	// P1 Synths
	// ---------------------------------- /

	//setup
	s.sync;
	Ndef(\droneplant1).play;
	Ndef(\plant2).play;
	Ndef(\plant3).play;

	s.volume = -15;

	/* =======================================
	SENSOR CALLBACKS : Plant 1
	=======================================*/


	~p1_flower_ambientLight = {
		|i=0, v=0|
		// postf("~p1_flower_ambientLight i:% v:% \n", i, v);


	};
	~boo0 = 0;
	// s.makeGui;
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
				"----->ONSET FLEX".postln;

				// postf("flex rand : %\n", ~p11_root.getSynchronous);

				if(~boo0==0,{
					Ndef(\plant1).play;
					~boo0=1;
					~boo0.postln;
				},
				//Ndef(\plant1).free;
					Ndef(\plant1).free;

				~boo0=0;
				~boo0.postln;
				);
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

			},
			2, {
				// "----->ONSET FLEX".postln;
				Ndef(\droneplant1).set(\amod,v);
				Ndef(\droneplant1).set(\amoda,v);
			},
		);
	};

	~p1_flower_temperature = {
		|i=0, v=0|
		v.postln;
		~tempoFactor = v + 0.8;
		TempoClock.tempo = ~tempoFactor;
		Ndef(\droneplant1).set(\pmod,v);

	};

	~p1_flower_humidity = {
		|i=0, v=0|
		// postf("~p1_flower_humidity i:% v:% \n", i, v);

		Ndef(\droneplant1).set(\freq,v);
		Ndef(\droneplant1).set(\fmod,v);
		Ndef(\droneplant1).set(\fmoda,v);


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
				switch(i,
					0, {Ndef(\plant1).set(\rmfreq,v)},
					1, {Ndef(\plant1).set(\rmphase,v)}
				)
			},
			2, {
				// "----->ONSET LIGHT".postln;
			},
		);
	};

	~p1_stem_light = {|i=0, v=0, state=0|

		//postf("~p1_stem_light i:% v:% \n", i, v);
		switch(state,
			-1, {
				// "----->OFFSET LIGHT".postln;
			},
			0, {
				//"----->OFF LIGHT".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;
				switch(i,
					0,{Ndef(\plant1).set(\del,v);},
					1,{Ndef(\plant1).set(\del2,v)},
					2,{Ndef(\plant1).set(\lit1,v)},
					3,{Ndef(\plant1).set(\lit2,v)},
					4,{Ndef(\plant1).set(\lit3,v)},
					5,{Ndef(\plant1).set(\lit4,v)},
					6,{Ndef(\plant1).set(\lit5,v)},
					7,{Ndef(\plant1).set(\a1,v)},
					8,{Ndef(\plant1).set(\a2,v)},
					9,{Ndef(\plant1).set(\a3,v)},
					10,{Ndef(\plant1).set(\a4,v)},
				)
			},
			2, {
				// "----->ONSET LIGHT".postln;

			},
		);
	};

	~p1_stem_sonar = {|i=0, v=0, state=0|

		var iv = ((v*i) / 4) + 0.01;

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
				switch(i,
					0, {Ndef(\plant1).set(\at,v)},
					1, {Ndef(\plant1).set(\dec,v)},
					2, {Ndef(\plant1).set(\sus,v)},
					3, {Ndef(\plant1).set(\rel,v)}

				);
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
				Ndef(\plant2).set(\lit3,v);
				Ndef(\plant2).set(\pitch,v);

				// "----->ONSET FLEX".postln;
				//	Synth(\thump, [\filter, v, \amp, v/2]);
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
				switch(i,
					0, {Ndef(\plant2).set(\roffset,v);
						Ndef(\plant2).set(\a1,v);
					},
					1, {Ndef(\plant2).set(\offset,v);
						Ndef(\plant2).set(\a2,v);

					}
				);

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

				switch(i,
					0,{Ndef(\plant2).set(\at,v)},
					1,{Ndef(\plant2).set(\dec,v)},
					2,{Ndef(\plant2).set(\sus,v)},
					3,{Ndef(\plant2).set(\rel,v)},
					4,{Ndef(\plant2).set(\del,v)},
				)

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
				//~p2_sonars[i].free;
			},
			0, {
				//"----->OFF SONAR".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;
				switch(i,
					0, {Ndef(\plant2).set(\pitch,v)},
					1, {Ndef(\plant2).set(\time,v)},
					2, {Ndef(\plant2).set(\lit1,v)},
					3, {Ndef(\plant2).set(\lit2,v)},

				);

			},
			2, {
				// "----->ONSET SONAR".postln;



			},
		);
	};


	/* =======================================
	SENSOR CALLBACKS : Plant 3
	=======================================*/
	~remote = NetAddr("127.0.0.1", 12345);
	~light = {|val=0| ~remote.sendMsg("/music2light/global/tempo", val); "LIGHTOSC".postln};




	~boo=0;
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
				Ndef(\plant3).set(\pitch,v);

				"----->ONSET FLEX".postln;

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
				switch(i,
					0,{Ndef(\plant3).set(\cutoff,v)},
					1,{Ndef(\plant3).set(\delay,v)},
				)
			},
			2, {
				// "----->ONSET LIGHT".postln;
				~tac.play;
				~ldrOnset.value(2, i, v);


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

				/*switch(i,
				0,{~p31_freq.value = v},
				1,{~p31_noise.value = v},
				2,{~p31_freq.value = v},
				3,{~p31_noise.value = v},
				4,{~p31_freq.value = v},
				)*/

				switch(i,
					0,{Ndef(\plant3).set(\amp1,v);
},
					1,{Ndef(\plant3).set(\amp2,v);
},
					2,{Ndef(\plant3).set(\amp3,v);
},
					3,{Ndef(\plant3).set(\amp4,v);
},
					4,{Ndef(\plant3).set(\amp5,v);
},
					4,{Ndef(\plant3).set(\amp6,v);
}

				)

			},
			2, {
				// "----->ONSET LIGHT".postln;
				~tic.play;
				~ldrOnset.value(2, i, v);
			},
		)
	};

	~p3_stem_sonar = {|i=0, v=0, state=0|
		// postf("~p3_stem_sonar i:% v:% \n", i, v);
		switch(state,
			-1, {
				// "----->OFFSET SONAR".postln;
				//~p3_sonars[i].free;
			},
			0, {
				//"----->OFF SONAR".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;
				//~p3_sonars[i].set(\amp, v);
			},
			2, {
				// "----->ONSET SONAR".postln;
				//~p3_sonars[i].free;
				//~p3_sonars[i]=Synth(\droneee, [freq: ~rootFreq*3/5*(i+1)]);

				switch(i,
					0, {Ndef(\plant3).set(\pitch,v);
},
					1, {Ndef(\plant3).set(\delay,v);}
				);
			},
		);
	};

	// manage the OSC parsing:
	"plantoids_parseOSC.scd".loadRelative(true, {"loaded parse OSC".postln});

};
