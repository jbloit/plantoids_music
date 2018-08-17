fork{
	// launch sound
	(dur:1, strum: 0.1, degree: [0,4,7]).play;

	currentEnvironment.clear;
	"plantoids_TANGUY_synthdefs.scd".loadRelative(true, {"loaded synthdefs".postln});

	// GLOBAL VARS
	~samplesDir = thisProcess.nowExecutingPath.dirname +/+ "../soundfiles";
	~postOSC  = false;
	~root = 0;
	~tempoFactor = 0.5;

	TempoClock.tempo = ~tempoFactor;

	~scale = Scale.chromatic;

	// similar to the scales in Figure
	~degrees = [
		[0],
		[0, 7],
		[0, 7, 10],
		[0, 3, 7, 10],
		[0, 3, 5, 7, 10],
		[0, 1, 3, 5, 7, 10],
		[0, 1, 3, 5, 7, 8, 10]
	];

	// Similar to the rhythmic patterns in Figure (euclidian patterns?)
	~claves  = [
		[4, 4, 4, 4],
		[3, 3, 3, 3, 4],
		[3, 3, 2, 3, 3, 2],
		[2, 2, 3, 2, 2, 3, 2],
		[2, 2, 2, 2, 2, 2, 2, 2],
		[2, 2, 2, 1, 2, 2, 2, 1, 2],
		[2, 1, 2, 1, 2, 2, 1, 2, 1, 2],
		[1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1],
		[1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2],
		[1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1],
		[1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
	];

	/* =======================================
	BACKGROUND MUSIC LAYERS (IDLE STATE)
	=======================================*/



	// arpeggiator
	~stepsCount = 33;
	~arpSteps = rrand(0,12!~stepsCount);

	~setStep = {|i, val|
		if (~arpSteps[i] > 0) {~arpSteps[i]=0} {~arpSteps[i]=val};
	};

	Pdef(\arp1,
		Pbind(
	\instrument, \ambiant,
	\dur, Pwhite(1,2),
	\freq, ([62,65,69,72]-2),
	\fi, 1,
	\sus, 2,
	\fo, 1,
	\pan, 0,
	\amp, 0.8,
	)).play;



	/* =======================================
	SENSOR CALLBACKS : Plant 1 (SMALL)
	=======================================*/

	// PERCS
	~p1_volume = 0.6;
	~p1_voicesCount = 4;
	~p1_amps = Array.fill(~p1_voicesCount, {0});
	~p1_timbres = Array.fill(~p1_voicesCount, {0});
	~p1_degrees = Array.fill(2, {0}); // 2 sonars control the degrees for all parts
	~p1_activeVoices = Array.fill(~p1_voicesCount, {0}); // monitor active voices, as an array of 1 or 0


	Pdef(\p1_0,
		Pbind(\instrument, \multi,
	\dur, 17,
	\midinote, Pshuf([    // Here the chords are randomly selected in a collection of values.
		([62,65,69,72,79]-6),
		([62,65,69,72,79]-4),
		([62,65,69,72,79]-2),
		([62,65,69,72,79])
	],inf),
	\detune, Pseg(Pseq([0,10,10],inf),Pseq([120,inf],inf),[\sin,inf],inf),   // The detune value can create nice pitch effects. (Wait 2 minutes to hear complete change).
	\fi, 7,
	\sus,Pfunc({~root}),
	\fo, 7,
	\cfmin, 50*2,
	\cfmax, 50*50,
	\rqmin, 0.01,
	\rqmax, 0.5,
	\cfhzmin, 0.001,
	\cfhzmax, 0.03,
	\mix, Pfunc({~p1_timbres[1]}), // Mix and Room values control the reverb settings
	\room, 1,
	\pan, 0,
	\out, 0,
	\amp, 0.1,
	\degree, Pfunc({~p1_degrees[1]},
		)
	));

	Pdef(\p1_1,
			Pbind(\instrument, \multi,
	\dur, 12,
	\midinote, Pshuf([    // Here the chords are randomly selected in a collection of values.
		([62,65,69,72,79]-6),
		([62,65,69,72,79]-4),
		([62,65,69,72,79]-2),
		([62,65,69,72,79])
	],inf),
	\detune, Pseg(Pseq([0,10,10],inf),Pseq([120,inf],inf),[\sin,inf],inf),   // The detune value can create nice pitch effects. (Wait 2 minutes to hear complete change).
	\fi, 7,
	\sus,Pfunc({~root}),
	\fo, 5,
	\cfmin, 50*2,
	\cfmax, 50*50,
	\rqmin, 0.01,
	\rqmax, 0.5,
	\cfhzmin, 0.001,
	\cfhzmax, 0.03,
	\mix, Pfunc({~p1_timbres[1]}), // Mix and Room values control the reverb settings
	\room, 1,
	\pan, 0,
	\out, 0,
	\amp, 0.1,
	\degree, Pfunc({~p1_degrees[1]},
		)
		));

	Pdef(\p1_2,
			Pbind(\instrument, \multi,
	\dur, 14,
	\midinote, Pshuf([    // Here the chords are randomly selected in a collection of values.
		([62,65,69,72,79]-6),
		([62,65,69,72,79]-4),
		([62,65,69,72,79]-2),
		([62,65,69,72,79])
	],inf),
	\detune, Pseg(Pseq([0,10,10],inf),Pseq([120,inf],inf),[\sin,inf],inf),   // The detune value can create nice pitch effects. (Wait 2 minutes to hear complete change).
	\fi, 7,
	\sus,Pfunc({~root}),
	\fo, 3,
	\cfmin, 50*2,
	\cfmax, 50*50,
	\rqmin, 0.01,
	\rqmax, 0.5,
	\cfhzmin, 0.001,
	\cfhzmax, 0.03,
	\mix, Pfunc({~p1_timbres[1]}), // Mix and Room values control the reverb settings
	\room, 1,
	\pan, 0,
	\out, 0,
	\amp, 0.1,
	\degree, Pfunc({~p1_degrees[0]},
		)
			));


	Pdef(\p1_3,
			Pbind(\instrument, \multi,
	\dur, 21,
	\midinote, Pshuf([    // Here the chords are randomly selected in a collection of values.
		([62,65,69,72,79]-6),
		([62,65,69,72,79]-4),
		([62,65,69,72,79]-2),
		([62,65,69,72,79])
	],inf),
	\detune, Pseg(Pseq([0,10,10],inf),Pseq([120,inf],inf),[\sin,inf],inf),   // The detune value can create nice pitch effects. (Wait 2 minutes to hear complete change).
	\fi, 7,
	\sus,Pfunc({~root}),
	\fo, 7,
	\cfmin, 50*2,
	\cfmax, 50*50,
	\rqmin, 0.01,
	\rqmax, 0.5,
	\cfhzmin, 0.001,
	\cfhzmax, 0.03,
	\mix, Pfunc({~p1_timbres[1]}), // Mix and Room values control the reverb settings
	\room, 0.5,
	\pan, 0,
	\out, 0,
	\amp, 0.1,
	\degree, Pfunc({~p1_degrees[0]},
		)
		));



	// role: change sounds to be triggered
	~p1_sonarValues = Array.fill(2, {0});
	~p1_stem_sonar = {|i=0, v=0, state=0|
		// postf("~p1_stem_sonar i:% v:% state:%\n", i, v, state);
		switch(state,
			-1, {
				// "----->OFFSET SONAR".postln;
			},
			0, {
				//"----->OFF SONAR".postln;
			},
			1, {
				// "----->CHANGE VALUE".postln;
				~p1_sonarValues[i] = v;
			},
			2, {
				// "----->ONSET SONAR".postln;

			},
		);
	};

	// role trigger some instruments
	~p1_stem_light = {|i=0, v=0, state=0|
		switch(state,
			-1, {
				// "----->OFFSET LIGHT".postln;
				~p1_activeVoices[i] = 0;
				Pdef((\p1_++i).asSymbol).stop;
			},
			0, {
				//"----->OFF LIGHT".postln;
				~p1_activeVoices[i] = 0;
			},
			1, {
				//"----->ON LIGHT".postln;

				// normalize amp depending on the number of active voices for this plantoid
				var amp;
				~p1_activeVoices[i] = 1;
				amp = min(1, v * (1 / sum(~p1_activeVoices)));
				~p1_amps[i] = amp * ~p1_volume;

				// timbre doesn't need to be normalized
				~p1_timbres[i] = v;
			},
			2, {
				"----->ONSET LIGHT".postln;
				~p1_activeVoices[i] = 1;
				Pdef((\p1_++i).asSymbol).play(quant:1);
			},
		);
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

				// ~transpose = rrand(0,10).postln;
			},
		);
	};


	~p1_flower_temperature = {
		|i=0, v=0|
		// v.postln;
		// ~tempoFactor = v + 0.8;
		// TempoClock.tempo = ~tempoFactor;
	};

	~p1_flower_humidity = {
		|i=0, v=0|
		// postf("~p1_flower_humidity i:% v:% \n", i, v);

	};




	/* =======================================
	SENSOR CALLBACKS : Plant 2 (MEDIUM)
	=======================================*/

	// TODO:
	// - have a different synth for sonar 0 and 1
	// - pick another synth for sonar 0 on flex_0 onset
	// - pick another synth for sonar 1 on flex_1 onset

	~p2_volume = 0.7;
	~p2_voicesCount = 6;
	~p2_amps = Array.fill(~p2_voicesCount, {0});
	~p2_timbres = Array.fill(~p2_voicesCount, {0});
	~p2_degrees = Array.fill(2, {0}); // 2 sonars control the degrees for all parts
	~p2_activeVoices = Array.fill(~p2_voicesCount, {0}); // monitor active voices, as an array of 1 or 0

	// degree controlled by sonar 0 and 1 alternatively
	Pdef(\p2_0,
	Pbind(\instrument, \ambiant,
	\dur, Pwhite(1/2,4),
	\freq, ([62,65,69,72]-2),
	\fi, 1,
	\sus, 2,
	\fo, 1,
	\pan, 0,
	\amp, 0.8,
	\degree, Pfunc({~p2_degrees[1]}),
	\scale, ~scale,
	\timbre, Pfunc({~p2_timbres[1]}),
	\root, Pfunc ([~root]),
	)).play;

	Pdef(\p2_1,
		Pbind(\instrument, \ambiant,
	\dur, Pwhite(2,8),
	\freq, ([62,65,69,72]-2),
	\fi, 2,
	\sus, 4,
	\fo, 2,
	\pan, 0,
	\amp, 0.8,
	\degree, Pfunc({~p2_degrees[1]}),
	\scale, ~scale,
	\timbre, Pfunc({~p2_timbres[1]}),
	\root, Pfunc ([~root]),
	)).play;

	Pdef(\p2_2,
		Pbind(\instrument, \ambiant,
	\dur, Pwhite(1/4,1/2),
	\freq, ([62,65,69,72]-2),
	\fi, 2,
	\sus, 4,
	\fo, 2,
	\pan, 0,
	\amp, 0.8,
	\degree, Pfunc({~p2_degrees[1]}),
	\scale, ~scale,
	\timbre, Pfunc({~p2_timbres[1]}),
	\root, Pfunc ([~root]),
	));


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
				~root = rrand(-2, 2);
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
				~p2_degrees[i] = ~degrees[4][(v * 8).asInt];
			},
			2, {
				// "----->ONSET SONAR".postln;
			},
		);
	};
	~p2_stem_light = {|i=0, v=0, state=0|
		// postf("~p2_stem_light i:% v:% \n", i, v);
		switch(state,
			-1, {
				// "----->OFFSET LIGHT".postln;
				~p2_activeVoices[i] = 0;
				Pdef((\p2_++i).asSymbol).stop;
			},
			0, {
				//"----->OFF LIGHT".postln;
				~p2_activeVoices[i] = 0;
			},
			1, {
				//"----->ON LIGHT".postln;

				// normalize amp depending on the number of active voices for this plantoid
				var amp;
				~p2_activeVoices[i] = 1;
				amp = min(1, v * (1 / sum(~p2_activeVoices)));
				~p2_amps[i] = amp * ~p2_volume;

				// timbre doesn't need to be normalized
				~p2_timbres[i] = v;

			},
			2, {
				// "----->ONSET LIGHT".postln;
				~p2_activeVoices[i] = 1;
				Pdef((\p2_++i).asSymbol).play(quant:1);
			},
		);
	};



	/* =======================================
	SENSOR CALLBACKS : Plant 3 (BIG)
	=======================================*/

	// PLANT 3 = LEADS
	// TODO:
	// - have a different synth for sonar 0 , 1, 2, 3
	// - pick another synth for sonar 0  and 1 on flex_0 onset
	// - pick another synth for sonar 2 and 3 on flex_1 onset

	~p3_volume = 0.4;
	~p3_voicesCount = 4;
	~p3_amps = Array.fill(~p3_voicesCount, {0});
	~p3_timbres = Array.fill(~p3_voicesCount, {0});
	~p3_degrees = Array.fill(4, {0}); // 4 sonars control the degrees for all parts
	~p3_activeVoices = Array.fill(~p3_voicesCount, {0}); // monitor active voices, as an array of 1 or 0


	// degree controlled by sonar 0, 1, 2, 3 alternatively
	Pdef(\p3_0,
	Pbind (\instrument, \multi,
	\dur, Pseq( ~claves[1]/2, inf),
	\freq, Pseq([1,2,4],inf),  // Freq value is here controlling the speed of the pitches playing (try to change them !)
	\fi, Pwhite(3,8),
	\sus, Pwhite(0.25,1),
	\fo, 3,
	\detune, Pseg(Pseq([0,2,2],inf),Pseq([120,inf],inf),[\sin,inf],inf),  // Detune value creates some chaos in rythm (wait for changes)
	\cfmin, Prand((Scale.lydian.degrees+62).midicps,inf) * Prand([0.5,1,2,4,6],inf),  // This is a random collection of pitches taken from a lydian scale
	\cfmax, Pkey(\cfmin) * Pwhite(1.005, 1.009, inf),
	\rqmin, 0.005,
	\rqmax, 0.008,
	\cfhzmin, 0,
	\cfhzmax, 0,
	\mix, Pseg(Pseq([0.3,1,1],inf),Pseq([120,inf],inf),[\sin,inf],inf), // Changing mix and room values make the sound smoother and the attack of the notes played get less hearable (wait to hear changes)
	\room, Pseg(Pseq([0,1,1],inf),Pseq([120,inf],inf),[\sin,inf],inf),
	\pan, 0,
	\out, 0,
	\amp, 0.4,
	\degree, Pfunc({~p3_degrees[0,2]}),
	\scale, ~scale,
	\timbre, Pfunc({~p3_timbres[1]}),
	\root, Pfunc ([~root]),
	));

	Pdef(\p3_1,
	Pbind (\instrument, \multi,
	\dur, Pseq( ~claves[1]/2, inf),
	\freq, Pseq([1,2,4],inf),  // Freq value is here controlling the speed of the pitches playing (try to change them !)
	\fi, Pwhite(2,4),
	\sus, Pwhite(0.25,1),
	\fo, 3,
	\detune, Pseg(Pseq([0,2,2],inf),Pseq([120,inf],inf),[\sin,inf],inf),  // Detune value creates some chaos in rythm (wait for changes)
	\cfmin, Prand((Scale.lydian.degrees+62).midicps,inf) * Prand([0.5,1,2,4,6],inf),  // This is a random collection of pitches taken from a lydian scale
	\cfmax, Pkey(\cfmin) * Pwhite(1.005, 1.009, inf),
	\rqmin, 0.005,
	\rqmax, 0.008,
	\cfhzmin, 0,
	\cfhzmax, 0,
	\mix, Pseg(Pseq([0.3,1,1],inf),Pseq([120,inf],inf),[\sin,inf],inf), // Changing mix and room values make the sound smoother and the attack of the notes played get less hearable (wait to hear changes)
	\room, Pseg(Pseq([0,1,1],inf),Pseq([120,inf],inf),[\sin,inf],inf),
	\pan, 0,
	\out, 0,
	\amp, 0.4,
	\degree, Pfunc({~p3_degrees[0,2]}),
	\scale, ~scale,
	\timbre, Pfunc({~p3_timbres[1]}),
	\root, Pfunc ([~root]),
	));

	Pdef(\p3_2,
	Pbind (\instrument, \multi,
	\dur, Pseq( ~claves[1]/2, inf),
	\freq, Pseq([1,2,4],inf),  // Freq value is here controlling the speed of the pitches playing (try to change them !)
	\fi, Pwhite(2,4),
	\sus, Pwhite(0.25,1),
	\fo, 3,
	\detune, Pseg(Pseq([0,2,2],inf),Pseq([120,inf],inf),[\sin,inf],inf),  // Detune value creates some chaos in rythm (wait for changes)
	\cfmin, Prand((Scale.lydian.degrees+62).midicps,inf) * Prand([0.5,1,2,4,6],inf),  // This is a random collection of pitches taken from a lydian scale
	\cfmax, Pkey(\cfmin) * Pwhite(1.005, 1.009, inf),
	\rqmin, 0.005,
	\rqmax, 0.008,
	\cfhzmin, 0,
	\cfhzmax, 0,
	\mix, Pseg(Pseq([0.3,1,1],inf),Pseq([120,inf],inf),[\sin,inf],inf), // Changing mix and room values make the sound smoother and the attack of the notes played get less hearable (wait to hear changes)
	\room, Pseg(Pseq([0,1,1],inf),Pseq([120,inf],inf),[\sin,inf],inf),
	\pan, 0,
	\out, 0,
	\amp, 0.4,
	\degree, Pfunc({~p3_degrees[1,3]}),
	\scale, ~scale,
	\timbre, Pfunc({~p3_timbres[1]}),
	\root, Pfunc ([~root]),
	));

	Pdef(\p3_3,
	Pbind (\instrument, \multi,
	\dur, Pseq( ~claves[1]/2, inf),
	\freq, Pseq([1,2,4],inf),  // Freq value is here controlling the speed of the pitches playing (try to change them !)
	\fi, Pwhite(2,4),
	\sus, Pwhite(0.25,1),
	\fo, 3,
	\detune, Pseg(Pseq([0,2,2],inf),Pseq([120,inf],inf),[\sin,inf],inf),  // Detune value creates some chaos in rythm (wait for changes)
	\cfmin, Prand((Scale.lydian.degrees+62).midicps,inf) * Prand([0.5,1,2,4,6],inf),  // This is a random collection of pitches taken from a lydian scale
	\cfmax, Pkey(\cfmin) * Pwhite(1.005, 1.009, inf),
	\rqmin, 0.005,
	\rqmax, 0.008,
	\cfhzmin, 0,
	\cfhzmax, 0,
	\mix, Pseg(Pseq([0.3,1,1],inf),Pseq([120,inf],inf),[\sin,inf],inf), // Changing mix and room values make the sound smoother and the attack of the notes played get less hearable (wait to hear changes)
	\room, Pseg(Pseq([0,1,1],inf),Pseq([120,inf],inf),[\sin,inf],inf),
	\pan, 0,
	\out, 0,
	\amp, 0.4,
	\degree, Pfunc({~p3_degrees[1,3]}),
	\scale, ~scale,
	\timbre, Pfunc({~p3_timbres[1]}),
	\root, Pfunc ([~root]),
	));


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
				~arpSteps = rrand(0,12!~stepsCount);
			},
		);
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
				~p3_degrees[i] = ~degrees[4][(v * 8).asInt];
			},
			2, {
				// "----->ONSET SONAR".postln;

			},
		);
	};

	~p3_stem_light = {|i=0, v=0, state=0|
		// postf("~p3_stem_light i:% v:%, state: %\n", i, v, state);
		switch(state,
			-1, {
				// "----->OFFSET LIGHT".postln;
				~p3_activeVoices[i] = 0;
				Pdef((\p3_++i).asSymbol).stop;
			},
			0, {
				//"----->OFF LIGHT".postln;
				~p3_activeVoices[i] = 0;
			},
			1, {
				//"----->ON LIGHT".postln;

				// normalize amp depending on the number of active voices for this plantoid
				var amp;
				~p3_activeVoices[i] = 1;
				amp = min(1, v * (1 / sum(~p3_activeVoices)));
				~p3_amps[i] = amp * ~p3_volume;

				// timbre doesn't need to be normalized
				~p3_timbres[i] = v;

			},
			2, {
				// "----->ONSET LIGHT".postln;
				~p3_activeVoices[i] = 1;
				Pdef((\p3_++i).asSymbol).play(quant:1);
			},
		);
	};

	// manage the OSC parsing:
	"plantoids_parseOSC.scd".loadRelative(true, {"loaded parse OSC".postln});
};