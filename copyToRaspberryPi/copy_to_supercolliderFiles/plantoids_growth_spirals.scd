fork{
	// launch sound
	(dur:1, strum: 0.1, degree: [0,4,7]).play;

	currentEnvironment.clear;

	// GLOBAL VARS

	~postOSC  = False;
	"plantoids_growth_spirals_synthdefs.scd".loadRelative(true, {"loaded synthdefs".postln});

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

	// P1 Synths
	// ---------------------------------- /


	~tempoFactor = 1; // factor of 60bpm
	TempoClock.tempo = ~tempoFactor;

	/* =======================================
	SENSOR CALLBACKS : Plant 1
	=======================================*/

	s.sync;


	s.volume = -15;
~stems_light1 = Bus.control(s,1);
~stems_light2 = Bus.control(s,1);
~stems_light3 = Bus.control(s,1);
~stems_light4 = Bus.control(s,1);

~stems_light5 = Bus.control(s,1);
~stems_light6 = Bus.control(s,1);
~stems_light7 = Bus.control(s,1);
~stems_light8 = Bus.control(s,1);

~stems_light9 = Bus.control(s,1);
~stems_light10 = Bus.control(s,1);
~stems_light11 = Bus.control(s,1);


~sonars21 = Bus.control(s,1);
~sonars22 = Bus.control(s,1);
~sonars23 = Bus.control(s,1);
~sonars24 = Bus.control(s,1);


~stems_light21 = Bus.control(s,1);
~stems_light22 = Bus.control(s,1);
~stems_light23 = Bus.control(s,1);
~stems_light24 = Bus.control(s,1);
~stems_light25 = Bus.control(s,1);

~sonars31 = Bus.control(s,1);
~sonars32 = Bus.control(s,1);

~leaves_light31 = Bus.control(s,1);
~leaves_light32 = Bus.control(s,1);



~stems_light31 = Bus.control(s,1);
~stems_light32 = Bus.control(s,1);
~stems_light33 = Bus.control(s,1);
~stems_light34 = Bus.control(s,1);
~stems_light35 = Bus.control(s,1);

	~mitraillette = Bus.control(s,1);

Pdef(\plant1,Pbind(\instrument,\plant1,\dur,Prand([1/8,1/4,1/2],inf),\freq1,~stems_light2.asMap,\freq2,~stems_light3.asMap,\freq3,~stems_light4.asMap,\amp,~stems_light1.asMap,\rel,~stems_light9.asMap));


Pdef(\plant11,Pbind(\instrument,\plant11,\dur,Prand([1/8,1/4,1/2],inf),\freq1,~stems_light6.asMap,\freq2,~stems_light7.asMap,\freq3,~stems_light8.asMap,\amp,~stems_light5.asMap,\rel,~stems_light10.asMap,\noise,~stems_light11.asMap));


	Pdef(\plant12,Pbind(\instrument,\plant12,\dur, 1/4,\tu,~mitraillette.asMap));

Pdef(\plant2,Pbind(\instrument,\plant2,\dur,Prand([1/8,1/4,1/8],inf),\isRest,Pseq([0.5,1],inf).coin.not,\freq,~stems_light22.asMap,\amp,~stems_light21.asMap)).play;

Pdef(\plant21,Pbind(\instrument,\plant21,\dur,Prand([1/8,1/4,1/8],inf),\amp,~stems_light23.asMap,\freq,~stems_light24.asMap,\noise,~stems_light25.asMap));


Pdef(\plant3,Pbind(\instrument,\plant3,\amp,~leaves_light31.asMap,\filter,~leaves_light32.asMap,\dur,Prand([1/8,1/8],inf),\isRest,Pseq([0.5,1],inf).coin.not,\freq,Prand([~stems_light31.asMap,~stems_light32.asMap,~stems_light33.asMap,~stems_light34.asMap,~stems_light35.asMap],inf))).play;

Pdef(\plant31,Pbind(\instrument,\plant31,\freq,~sonars31.asMap,\amp,~sonars32.asMap));

	Pdef(\plant1).play;
				Pdef(\plant11).play;
	Pdef(\plant2).play;
				Pdef(\plant21).play;
	Pdef(\plant3).play;
				Pdef(\plant31).play;

	/*
	~p1_wind;
	~p1_sonars= Array.newClear(4);
	~p1_quake;
	~bassModulation = 1;
	~percLevel = 0.5;
	~arpLevel = 0.5;
	~bassLevel = 0.5;


	~p11_freq1 = Bus.control(s,1);
	~p11_freq2 = Bus.control(s,1);
	~p11_freq3 = Bus.control(s,1);
	~p11_amp = Bus.control(s,1);
	~p11_rel = Bus.control(s,1);
	~p11_noise = Bus.control(s,1);

	~p11_freq1.value = 0.1;
	~p11_freq2.value = 0.1;
	~p11_freq3.value = 0.1;
	~p11_amp.value = 0.3;
	~p11_rel.value = 0.1;
	~p11_noise.value = 0.1;


	~p11_root = Bus.control(s,1);
	~p11_root.value = 0.3;


	~p11_scale = rrand(0.0, 1.0!10);

	Pdef(\plant11).quant =4;
	Pdef(\plant11,
		Pbind(\instrument,\plant11,
			\dur,Prand([1/8,1/4,1/2],inf),
			\factor1, ~p11_root.asMap,
			\factor2, Prand(~p11_scale, inf),
			\freq1, ~p11_freq1.asMap,
			\freq2,~p11_freq2.asMap,
			\freq3,~p11_freq3.asMap,
			\amp,~p11_amp.asMap,
			\rel,~p11_rel.asMap,
			\noise,~p11_noise.asMap)
	).play();
*/

	~drone = Synth(\droneplant1);



	~p1_flower_ambientLight = {
		|i=0, v=0|
		// postf("~p1_flower_ambientLight i:% v:% \n", i, v);

		/*~arpLevel = v;
		~bassLevel = v;
		~percLevel = 1 - v;
		*/
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
			//	Pdef(\plant1).play;
			//	Pdef(\plant11).play;
				/*~p11_root.value = rrand(0.0, 1.0).postln;
				~p11_scale = rrand(0.0, 1.0!10);
				// postf("flex rand : %\n", ~p11_root.getSynchronous);
				*/
			if(~boo0==0,{
				Pdef(\plant1).stop;
				Pdef(\plant12).play;

				~boo0=1;
				~boo0.postln;
				},
				Pdef(\plant1).play;
				Pdef(\plant12).stop;

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
				/*~p1_wind.set(\freqNorm, v);
				~p1_wind.set(\amp, v/5);
				*/
			},
			2, {
				// "----->ONSET FLEX".postln;
				/*
				~p1_wind.free;
				~p1_wind = Synth(\windBasic);
				*/
			},
		);
	};

	~p1_flower_temperature = {
		|i=0, v=0|
		v.postln;
		~tempoFactor = v + 0.8;
		TempoClock.tempo = ~tempoFactor;
	};

	~p1_flower_humidity = {
		|i=0, v=0|
		// postf("~p1_flower_humidity i:% v:% \n", i, v);
		/*~bassModulation = v*10;*/
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
/*				switch(i,
					0, {~p1_amp.value = v;},
					1, {~p11_amp.value = v;}
				)*/
			},
			2, {
				// "----->ONSET LIGHT".postln;
			},
		);
	};

	~p1_stem_light = {|i=0, v=0, state=0|

		// postf("~p1_stem_light i:% v:% \n", i, v);
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
					0,{~stems_light1.value = v},
					1,{~stems_light2.value = v},
					2,{~stems_light3.value = v},
					3,{~stems_light4.value = v},
					4,{~stems_light5.value = v},
					5,{~stems_light6.value = v},
					6,{~stems_light7.value = v},
					7,{~stems_light8.value = v},
					8,{~stems_light9.value = v},
					9,{~stems_light10.value = v},
					10,{~stems_light11.value = v;
						Pdef(\plant12).set(\dur,v);
					},
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

			},
			2, {
				// "----->ONSET SONAR".postln;
			/*	switch(i,
					0, {Synth(\plant1, [\freq1, iv, \freq2, v, \freq3, 1-v,\amp, v])},
					1, {Synth(\plant1, [\freq1, iv, \freq2, v, \freq3, 1-v,\amp, v])},
					2, {Synth(\plant1, [\freq1, iv, \freq2, v, \freq3, 1-v,\amp, v])},
					3, {Synth(\plant1, [\freq1, iv, \freq2, v, \freq3, 1-v,\amp, v])}
				);
*/

				switch(i,
					0,{~drone.set(\freq,v);
						~mitraillette.value=v;},
					1,{~drone.set(\fmod,v);
},
					2,{~drone.set(\fmoda,v);
},
					3,{~drone.set(\pmod,v);
						Pdef(\plant12).quant=0.25;
	Pdef(\plant12,Pbind(\instrument,\plant12,\dur, v,\tu,~mitraillette.asMap));

},
				)
			},
		);
	};

	/* =======================================
	SENSOR CALLBACKS : Plant 2
	=======================================*/
/*
	~p2_wind;
	~p2_sonars= Array.newClear(4);
	~p2_quake;


	~p21_freq = Bus.control(s,1);
	~p21_noise = Bus.control(s,1);
	~p21_amp = Bus.control(s,1);

	~p21_amp.value = 0.2;
	~p21_freq.value = 0.1;
	~p21_noise.value = 0.1;

	Pdef(\plante21).quant =4;
	Pdef(\plant21,
	Pbind(\instrument,\plant21,
		\dur,Prand([1/8,1/4,1/8],inf),
		\amp,~p21_amp.asMap,
		\freq,~p21_freq.asMap,
		\noise,~p21_freq.asMap)
	).play;
*/
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
				Pdef(\plant2).play;
				Pdef(\plant21).play;
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

				switch(i,
					0, {~p21_amp.value = v;},
					1, {~p2_amp.value = v;}
				);

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
			/*	switch(i,
					0,{~p21_freq.value = v},
					1,{~p11_noise.value = v},
					2,{~p21_freq.value = v},
					3,{~p11_noise.value = v},
					4,{~p21_freq.value = v},
				)*/

				switch(i,
					0,{~stems_light21.value = v},
					1,{~stems_light22.value = v},
					2,{~stems_light23.value = v},
					3,{~stems_light24.value = v},
					4,{~stems_light25.value = v},
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
				~p2_sonars[i].set(\amp, v);
			},
			2, {
				// "----->ONSET SONAR".postln;
			/*	switch(i,
					0, {Synth(\plant2, [\freq, v, \amp, v])},
					1, {Synth(\plant2, [\freq, v, \amp, v])},
					2, {Synth(\plant2, [\freq, v, \amp, v])},
					3, {Synth(\plant2, [\freq, v, \amp, v])},

				);
				*/

				switch(i,
					0,{~drone.set(\freq,v);
},
					1,{~drone.set(\fmod,v);
},
					2,{~drone.set(\fmoda,v);
},
					3,{~drone.set(\pmod,v);
				})
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

/*	~p3_sonars= Array.newClear(4);


	~p31_freq = Bus.control(s,1);
	~p31_noise = Bus.control(s,1);
	~p31_amp = Bus.control(s,1);

	~p31_amp.value = 0.2;
	~p31_freq.value = 0.1;
	~p31_noise.value = 0.1;
	*/
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
			//	Synth(\thump, [\filter, v, \amp, v/2]);

				if(~boo==0,{
				Pdef(\plant3).stop;
				~boo=1;
					~boo.postln;
				},
				Pdef(\plant3).play;
				~boo=0;
				~boo.postln;
				);
				Pdef(\plant31).play;

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
					0,{~leaves_light31.value = v.postln},
					1,{~leaves_light32.value = v.postln},
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
					0,{~stems_light31.value = v},
					1,{~stems_light32.value = v},
					2,{~stems_light33.value = v},
					3,{~stems_light34.value = v},
					4,{~stems_light35.value = v},
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
					0, {~sonars31.value = v;},
					1, {~sonars32.value = v;}
				);
			},
		);
	};

	// manage the OSC parsing:
	"plantoids_parseOSC.scd".loadRelative(true, {"loaded parse OSC".postln});

};
