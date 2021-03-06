///FOXGLOVE - DIGITALIS
// slowly absence of being, conscious paralysis of the unconscious lifestyle  /
// composed by Thomas Desai A.K.A. ACOUSTIC DEVICES /
// muusique de journee qui perd ses sens planar pour recussiter la lune dans les catacs sous ASSAS /


// TO DO, bring up voice numbers (patterns etc) to p1-6, p2-6,  p3-10!




fork{
	// launch sound
	(dur:1, strum: 0.1, degree: [0,4,7]).play;

	currentEnvironment.clear;
	"plantoids_FOXGLOVE_synthdefs.scd".loadRelative(true, {"loaded synthdefs".postln});

	// GLOBAL VARS
	~samplesDir = thisProcess.nowExecutingPath.dirname +/+ "../soundfiles";
	~postOSC  = false;
	~root = 0;
	~tempoFactor = 0.6;

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
	~arpSteps = rrand(1,12!~stepsCount);

	~setStep = {|i, val|
		if (~arpSteps[i] > 0) {~arpSteps[i]=0} {~arpSteps[i]=val};
	};


	Pdef(\arp1,
		Pbind(\plant2,\plant2,
			\amp,Pseq([1],inf),
			\root,Pfunc({~root}),
			\octave, 3,
			\isRest,Pseq(~arpSteps,inf).coin.not,
			\degree,Prand(~degrees[3], inf),
			\dur,2,
			\scale,Pfunc({~scale})
	)).play;


	Pdef(\arp2,
		Pbind(\plant21,\plant21,
			\amp,Pseq([0.6],inf),
			\root,Pfunc({~root}),
			\octave, 4,
			\isRest,Pseq(~arpSteps,inf).coin.not,
			\degree,Prand(~degrees[4], inf),
			\dur, Pseq ([Rest (0),1],inf),
			\scale,Pfunc({~scale})
	)).play;


	Pdef(\arp3,
		Pbind(\plant21,\plant21,
			\amp,Pseq([0.6],inf),
			\root,Pfunc({~root}),
			\octave, Prand([3, 6,], inf),
			\isRest,Pseq(~arpSteps,inf).coin.not,
			\degree,Prand(~degrees[4], inf),
			\dur, Pseq ([Rest (0),1/4],inf),
			\scale,Pfunc({~scale})
	)).play;

	/* =======================================
	SENSOR CALLBACKS : Plant 1 (SMALL)
	=======================================*/

	// PERCS
	~p1_volume = 0.4;
	~p1_voicesCount = 6;// fix as 6! this must equal p2stemlight indexing
	~p1_amps = Array.fill(~p1_voicesCount, {0});
	~p1_timbres = Array.fill(~p1_voicesCount, {0});
	~p1_degrees = Array.fill(2, {0}); // 2 sonars control the degrees for all parts
	~p1_activeVoices = Array.fill(~p1_voicesCount, {0}); // monitor active voices, as an array of 1 or 0


	Pdef(\p1_0,
		Pbind(\instrument, \plant2hihat, \dur, Pseq( ~claves[0]/16, inf), \scale, ~scale, \degree, Pfunc({~p1_degrees[0]}), \root, Pfunc({~root}), \octave, 7, \timbre, Pfunc({~p1_timbres[0]}), \rel, 0.2,
	));

	Pdef(\p1_1,
		Pbind(\instrument, \plant2snare, \dur, Pseq( ~claves[1]/16, inf), \scale, ~scale, \degree, Pfunc({~p1_degrees[1]}), \root, Pfunc({~root}), \octave, 9, \timbre, Pfunc({~p1_timbres[1]}), \rel, 0.4,
	));

	Pdef(\p1_2,
		Pbind(\instrument, \plant2snare, \dur, Pseq( ~claves[2]/16, inf), \scale, ~scale, \degree, Pfunc({~p1_degrees[1]}), \root, Pfunc({~root}), \octave, 8, \timbre, Pfunc({~p1_timbres[2]}), \rel, 0.2,
	));

	Pdef(\p1_3,
		Pbind(\instrument, \plant2hihat, \dur, Pseq( ~claves[3]/16, inf), \scale, ~scale, \degree, Pfunc({~p1_degrees[0]}),\root, Pfunc({~root}), \octave, 9, \timbre, Pfunc({~p1_timbres[3]}), \rel, 0.2,
	));

	Pdef(\p1_4,
		Pbind(\instrument, \plant2snare, \dur, Pseq( ~claves[4]/16, inf), \scale, ~scale, \degree, Pfunc({~p1_degrees[0]}), \root, Pfunc({~root}), \octave, 3, \timbre, Pfunc({~p1_timbres[4]}), \rel, 0.5,
	));

	Pdef(\p1_5,
		Pbind(\instrument, \plant2snare, \dur, Pseq( ~claves[5]/4, inf), \scale, ~scale, \degree, Pfunc({~p1_degrees[1]}), \root, Pfunc({~root}), \octave, 2, \timbre, Pfunc({~p1_timbres[5]}), \rel, 0.08,
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
	~p2_voicesCount = 6;// fix as 6 !
	~p2_amps = Array.fill(~p2_voicesCount, {0});
	~p2_timbres = Array.fill(~p2_voicesCount, {0});
	~p2_degrees = Array.fill(2, {0}); // 2 sonars control the degrees for all parts
	~p2_activeVoices = Array.fill(~p2_voicesCount, {0}); // monitor active voices, as an array of 1 or 0

	// degree controlled by sonar 0 and 1 alternatively
	Pdef(\p2_0,
		Pbind(\instrument, \plant2, \dur, Pseq( ~claves[0]/16, inf), \scale, ~scale, \degree, Pfunc({~p2_degrees[0]}), \root, Pfunc({~root}), \octave, Prand([5, 7,], inf), \timbre, Pfunc({~p2_timbres[0]})
	)).play;

	Pdef(\p2_1,
		Pbind(\instrument, \plant2, \dur, Pseq( ~claves[1]/16, inf), \scale, ~scale, \degree, Pfunc({~p2_degrees[1]}), \root, Pfunc({~root}), \octave, 4, \timbre, Pfunc({~p2_timbres[1]})
	));

	Pdef(\p2_2,
		Pbind(\instrument, \plant2, \dur, Pseq( ~claves[2]/16, inf), \scale, ~scale, \degree, Pfunc({~p2_degrees[0]}), \root, Pfunc({~root}), \octave, Prand([3, 6,], inf), \timbre, Pfunc({~p2_timbres[2]})
	));

	Pdef(\p2_3,
		Pbind(\instrument, \plant21, \dur, Pseq( ~claves[3]/16, inf), \scale, ~scale, \degree, Pfunc({~p2_degrees[1]}), \root, Pfunc({~root}), \octave, 3, \timbre, Pfunc({~p2_timbres[3]})
	));

	Pdef(\p2_4,
		Pbind(\instrument, \plant21, \dur, Pseq( ~claves[4]/16, inf), \scale, ~scale, \degree, Pfunc({~p2_degrees[0]}), \root, Pfunc({~root}), \octave, Prand([3, 6,], inf), \timbre, Pfunc({~p2_timbres[4]})
	));

	Pdef(\p2_5,
		Pbind(\instrument, \plant21, \dur, Pseq( ~claves[5]/16, inf), \scale, ~scale, \degree, Pfunc({~p2_degrees[1]}), \root, Pfunc({~root}), \octave, 5, \timbre, Pfunc({~p2_timbres[5]})
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

	~p3_volume = 1;
	~p3_voicesCount = 10;// fix as 10!
	~p3_amps = Array.fill(~p3_voicesCount, {0});
	~p3_timbres = Array.fill(~p3_voicesCount, {0});
	~p3_degrees = Array.fill(4, {0}); // 4 sonars control the degrees for all parts
	~p3_activeVoices = Array.fill(~p3_voicesCount, {0}); // monitor active voices, as an array of 1 or 0


	// degree controlled by sonar 0, 1, 2, 3 alternatively
	Pdef(\p3_0,
		Pbind(\instrument, \plant31, \dur, Pseq( ~claves[0]/16, inf), \scale, ~scale, \degree, Pfunc({~p3_degrees[0]}), \root, Pfunc({~root}), \octave, 6, \timbre, Pfunc({~p3_timbres[0]})
	));

	Pdef(\p3_1,
		Pbind(\instrument, \plant31, \dur, Pseq( ~claves[1]/16, inf), \scale, ~scale, \degree, Pfunc({~p3_degrees[1]}), \root, Pfunc({~root}), \octave, 6, \timbre, Pfunc({~p3_timbres[1]})
	));

	Pdef(\p3_2,
		Pbind(\instrument, \plant31, \dur, Pseq( ~claves[2]/16, inf), \scale, ~scale, \degree, Pfunc({~p3_degrees[2]}), \root, Pfunc({~root}), \octave, 6, \timbre, Pfunc({~p3_timbres[2]})
	));

	Pdef(\p3_3,
		Pbind(\instrument, \plant3, \dur, Pseq( ~claves[3]/8, inf), \scale, ~scale, \degree, Pfunc({~p3_degrees[3]}), \root, Pfunc({~root}), \octave, Prand([5, 7,], inf), \timbre, Pfunc({~p3_timbres[3]})
	));

	Pdef(\p3_4,
		Pbind(\instrument, \plant31, \dur, Pseq( ~claves[4]/16, inf), \scale, ~scale, \degree, Pfunc({~p3_degrees[2]}), \root, Pfunc({~root}), \octave, 5, \timbre, Pfunc({~p3_timbres[4]})
	));

	Pdef(\p3_5,
		Pbind(\instrument, \plant31, \dur, Pseq( ~claves[5]/16, inf), \scale, ~scale, \degree, Pfunc({~p3_degrees[1]}), \root, Pfunc({~root}), \octave, 6, \timbre, Pfunc({~p3_timbres[5]})
	));

	Pdef(\p3_6,
		Pbind(\instrument, \plant31, \dur, Pseq( ~claves[6]/8, inf), \scale, ~scale, \degree, Pfunc({~p3_degrees[3]}), \root, Pfunc({~root}), \octave, Prand([3, 6,], inf), \timbre, Pfunc({~p3_timbres[6]})
	));

	Pdef(\p3_7,
		Pbind(\instrument, \plant3, \dur, Pseq( ~claves[7]/8, inf), \scale, ~scale, \degree, Pfunc({~p3_degrees[3]}), \root, Pfunc({~root}), \octave, Prand([2, 4,], inf), \timbre, Pfunc({~p3_timbres[7]})
	));

	Pdef(\p3_8,
		Pbind(\instrument, \plant31, \dur, Pseq( ~claves[8]/16, inf), \scale, ~scale, \degree, Pfunc({~p3_degrees[2]}), \root, Pfunc({~root}), \octave, Prand([3, 6,], inf), \timbre, Pfunc({~p3_timbres[8]})
	));

	Pdef(\p3_9,
		Pbind(\instrument, \plant31, \dur, Pseq( ~claves[9]/16, inf), \scale, ~scale, \degree, Pfunc({~p3_degrees[1]}), \root, Pfunc({~root}), \octave, 6, \timbre, Pfunc({~p3_timbres[9]})
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