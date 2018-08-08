/// CONNIFER
// exponential growth of sweetly perfumed wood and leaf, no escape, lacklustre timber/
// composed by Thomas Desai A.K.A. ACOUSTIC DEVICES /

fork{
	// launch sound
	(dur:1, strum: 0.2, degree: [4,8,12,16]).play;

	currentEnvironment.clear;

	// GLOBAL VARS

	~postOSC = False;
	"plantoids_CONNIFER_synthdefs.scd".loadRelative(true, {"loaded synthdefs".postln});

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

	~tempoFactor = 1.25; // factor of 60bpm
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


	~p1hihat_ffreq = Bus.control(s,1);
	~p1hihat_rel = Bus.control(s,1);
	~p1hihat_amp = Bus.control(s,1);
	~p1kick_amp = Bus.control(s,1);
	~p1kick_rel = Bus.control(s,1);
	~p1kick_glissf = Bus.control(s,1);
	~p1snare_rel = Bus.control(s,1);



    Ppar([
		Pbind(
		\instrument, "plant1hihat",
		\dur, Pseq([Rest(1/4),1/4,1/2, 1/4], inf),
		\ffreq, 6000,
		\rel, 0.1,
		\amp, 0.2
	),
		Pbind(
		\instrument, "plant1kick",
		\dur, 1/2,
		\amp, 0.9,
		\rel, 0.04,
		\glissf, 0.99
	),
		Pbind(
		\instrument, "plant1snare",
		\dur, Prand([Rest(1/2), 1/4, 3/4], inf),
		\amp, 0.1,
		\rel, 0.1
	)
	]).play;


	~p1hihat_ffreq.value = 8000;
	~p1hihat_amp = 0.5;
	~p1kick_amp = 0.3;
	~p1kick_rel = 0.45;

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
				Synth(\plant1snare, [\rel, v, \amp, v*2]);
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


	~p21_att = Bus.control(s,1);
	~p21_pan = Bus.control(s,1);
	~p21_amp = Bus.control(s,1);

	~p21_amp.value = 0.4;
	~p21_att.value = 0.05;
	~p21_pan.value = 0;

	Pbind(
	\instrument, "plant21",
	\degree, Pwhite(0, 10),
	\dur, 0.25,
	\amp, Pwhite(0.06, 0.09),
	\numharm, Pwhite(10, 20),
	\att, 0.01,
	\rel, Pwhite(0.5, 0.8),
	\pan, Pwhite(-1, 1.0)
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

	Pbind(
	\instrument, "plant31",
	\degree, Pwhite(0, 10),
	\dur, Pseq([Rest(1/4),1/4,1/2,3/4], inf),
	\amp, Pwhite(0.01, 0.05),
	\numharm, Pwhite(10, 20),
	\att, 0.01,
	\rel, Pwhite(0.5, 0.8),
	\pan, Pwhite(-1, 1.0)
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