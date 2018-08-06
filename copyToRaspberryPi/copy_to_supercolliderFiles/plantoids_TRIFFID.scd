/// TRIFFIDS
//triffids raving in the craven desert, frenzied exaltation and basking in ecstatic half-light /
// composed by Thomas Desai A.K.A. ACOUSTIC DEVICES /

fork{
	// launch sound
	(dur:1, strum: 0.2, degree: [4,8,12,16]).play;

	currentEnvironment.clear;

	// GLOBAL VARS

	~postOSC = False;
	"plantoids_TRIFFID_synthdefs.scd".loadRelative(true, {"loaded synthdefs".postln});

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

	~rootFreq = 40;

	~tempoFactor = 1.2; // factor of 60bpm
	TempoClock.tempo = ~tempoFactor;

	/* =======================================
	SENSOR CALLBACKS : Plant 1
	=======================================*/

	s.sync;
	~p1_wind;
	~p1_sonars= Array.newClear(4);
	~p1_quake;
	~bassModulation = 0.7;
	~percLevel = 0.8;
	~arpLevel = 0.4;
	~bassLevel = 0.6;


	~p11_freq1 = Bus.control(s,1);
	~p11_freq2 = Bus.control(s,1);
	~p11_freq3 = Bus.control(s,1);
	~p11_amp = Bus.control(s,1);
	~p11_rel = Bus.control(s,1);
	~p11_noise = Bus.control(s,1);

	~p11_freq1.value = 0.4;
	~p11_freq2.value = 0.2;
	~p11_freq3.value = 0.8;
	~p11_amp.value = 0.7;
	~p11_rel.value = 0.25;
	~p11_noise.value = 0.4;

	Pdef(\plant11).quant =4;
	Pdef(\plant11,
		Pbind(\instrument,\plant11,
			\dur,Prand([1,1/4,1/2,1/4],inf),
			\freq1,~p11_freq1.asMap,
			\freq2,~p11_freq2.asMap,
			\freq3,~p11_freq3.asMap,
			\amp,~p11_amp.asMap,
			\rel,~p11_rel.asMap,
			\noise,~p11_noise.asMap)
	).play();


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
				~p1_wind.set(\freqNorm, v*0.8);
				~p1_wind.set(\amp, v/2);
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
		v.postln;
		~tempoFactor = v + 0.8;
		TempoClock.tempo = ~tempoFactor;
	};

	~p1_flower_humidity = {
		|i=0, v=0|
		// postf("~p1_flower_humidity i:% v:% \n", i, v);
		~bassModulation = v*5;
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
					0,{~p11_freq1.value = v},
					1,{~p11_freq2.value = v},
					2,{~p11_freq3.value = v},
					3,{~p11_rel.value = v},
					4,{~p11_noise.value = v},
					5,{~p11_freq1.value = v},
					6,{~p11_freq2.value = v},
					7,{~p11_freq3.value = v},
					8,{~p11_rel.value = v},
					9,{~p11_noise.value = v},
					10,{~p11_freq1.value = v},
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
				switch(i,
					0, {Synth(\plant1, [\freq1, iv, \freq2, v, \freq3, 1-v,\amp, v])},
					1, {Synth(\plant1, [\freq1, iv, \freq2, v, \freq3, 1-v,\amp, v])},
					2, {Synth(\plant1, [\freq1, iv, \freq2, v, \freq3, 1-v,\amp, v])},
					3, {Synth(\plant1, [\freq1, iv, \freq2, v, \freq3, 1-v,\amp, v])}
				);
			},
		);
	};

	/* =======================================
	SENSOR CALLBACKS : Plant 2
	=======================================*/

	~p2_wind;
	~p2_sonars= Array.newClear(4);
	~p2_quake;


	~p21_freq = Bus.control(s,1);
	~p21_noise = Bus.control(s,1);
	~p21_amp = Bus.control(s,1);

	~p21_amp.value = 0.4;
	~p21_freq.value = 0.4;
	~p21_noise.value = 0.1;

	Pdef(\plant21).quant =2;
	Pdef(\plant21,
	Pbind(\instrument,\plant21,
		\dur,Prand([1/4,1/4,1/4],inf),
		\amp,~p21_amp.asMap,
		\freq,~p21_freq.asMap,
		\noise,~p21_freq.asMap)
).play;

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
				switch(i,
					0,{~p21_freq.value = v},
					1,{~p21_amp.value = v*0.001},
					2,{~p21_freq.value = v},
					3,{~p21_noise.value = v},
					4,{~p21_noise.value = v},
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
				switch(i,
					0, {Synth(\plant2, [\freq, v, \amp, v])},
					1, {Synth(\plant2, [\freq, v, \amp, v])},
				);
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

	~p3_wind;
	~p3_sonars= Array.newClear(4);
	~p3_quake;


	~p31_freq = Bus.control(s,1);
	~p31_noise = Bus.control(s,1);
	~p31_amp = Bus.control(s,1);

	~p31_amp.value = 0.25;
	~p31_freq.value = 0.3;
	~p31_noise.value = 0.4;

	Pdef(\plant31).quant =8;
	Pdef(\plant31,
	Pbind(\instrument,\plant31,
		\dur,Prand([1/4,0.0001,0.75],inf),
		\amp,~p31_amp.asMap,
		\freq,~p31_freq.asMap,
		\noise,~p31_freq.asMap)
).play;



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
				~p3_sonars[i].free;
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
				~p3_sonars[i].free;
				~p3_sonars[i]=Synth(\plant31, [freq: ~rootFreq*4/5*(i+1)]);
			},
		);
	};


	// manage the OSC parsing:
	"plantoids_parseOSC.scd".loadRelative(true, {"loaded parse OSC".postln});

};