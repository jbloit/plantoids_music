//Plinky version nocturne, j imaginais une monstre aimable (Plinky) sur du Ket avec des aventures improbables qui se deroule...
// Plinky de Julien Bloit, remix de Thomas Desai A.K.A ACOUSTIC DEVICES

fork{
	// launch sound
	(dur:1, strum: 0.1, degree: [0,4,7]).play;

	currentEnvironment.clear;
	"plantoids_plinky_synthdefs.scd".loadRelative(true, {"loaded synthdefs".postln});

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


	// background ongoing kick
	Pdef(\kick,Pbind(\instrument,\kick,\dur,1/4,\amp,Pseq([1,0.5,0.8],inf))).play;

	Pdef(\trippykick,Pbind(\instrument,\kick,\dur,1/4,\amp,Pseq([0.3,0.1,0.05, 0.01],inf))).play;

	// arpeggiator
	~stepsCount = 33;
	~arpSteps = rrand(0,12!~stepsCount);

	~setStep = {|i, val|
		if (~arpSteps[i] > 0) {~arpSteps[i]=0} {~arpSteps[i]=val};
	};


	Pdef(\arp1,
		Pbind(\instrument,\lead1,
			\amp,Pseq([1],inf),
			\root,Pfunc({~root}),
			\octave, 7,
			\isRest,Pseq(~arpSteps,inf).coin.not,
			\degree,Prand(~degrees[3], inf),
			\dur,2,
			\scale,Pfunc({~scale})
	)).play.quant(1);

	Pdef(\arp2,
		Pbind(\instrument,\lead1,
			\amp,Pseq([1],inf),
			\root,Pfunc({~root}),
			\octave, Prand([4, 6,], inf),
			\isRest,Pseq(~arpSteps,inf).coin.not,
			\degree,Prand(~degrees[3], inf),
			\dur, 1/4,
			\scale,Pfunc({~scale})
	)).play.quant(1);



	/* =======================================
	SENSOR CALLBACKS : Plant 1 (SMALL)
	=======================================*/

	// PERCS
	~p1_volume = 0.6;
	~p1_voicesCount = 6;
	~p1_amps = Array.fill(~p1_voicesCount, {0});
	~p1_timbres = Array.fill(~p1_voicesCount, {0});
	~p1_degrees = Array.fill(2, {0}); // 2 sonars control the degrees for all parts
	~p1_activeVoices = Array.fill(~p1_voicesCount, {0}); // monitor active voices, as an array of 1 or 0


	Pdef(\p1_0,
		Pbind(\instrument, \kickhi, \dur, Pseq( ~claves[0]/16, inf), \scale, ~scale, \degree, Pfunc({~p1_degrees[0]}), \root, Pfunc({~root}), \octave, 3, \timbre, Pfunc({~p1_timbres[0]})
	));

	Pdef(\p1_1,
		Pbind(\instrument, \snare808, \dur, Pseq( ~claves[1]/16, inf), \scale, ~scale, \degree, Pfunc({~p1_degrees[0]}), \root, Pfunc({~root}), \octave, 4, \timbre, Pfunc({~p1_timbres[1]})
	));

	Pdef(\p1_2,
		Pbind(\instrument, \hat909, \dur, Pseq( ~claves[2]/16, inf), \scale, ~scale, \degree, Pfunc({~p1_degrees[0]}), \root, Pfunc({~root}), \octave, 5, \timbre, Pfunc({~p1_timbres[2]})
	));


	Pdef(\p1_3,
		Pbind(\instrument, \kickhi, \dur, Pseq( ~claves[3]/4, inf), \scale, ~scale, \degree, Pfunc({~p1_degrees[1]}), \root, Pfunc({~root}), \octave, 6, \timbre, Pfunc({~p1_timbres[3]})
	));

	Pdef(\p1_4,
		Pbind(\instrument, \snare808, \dur, Pseq( ~claves[4]/16, inf), \scale, ~scale, \degree, Pfunc({~p1_degrees[1]}), \root, Pfunc({~root}), \octave, 7, \timbre, Pfunc({~p1_timbres[4]})
	));

	Pdef(\p1_5,
		Pbind(\instrument, \hat909, \dur, Pseq( ~claves[5]/8, inf), \scale, ~scale, \degree, Pfunc({~p1_degrees[1]}), \root, Pfunc({~root}), \octave, 8, \timbre, Pfunc({~p1_timbres[5]})
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

	~p2_volume = 0.9;
	~p2_voicesCount = 6;
	~p2_amps = Array.fill(~p2_voicesCount, {0});
	~p2_timbres = Array.fill(~p2_voicesCount, {0});
	~p2_degrees = Array.fill(2, {0}); // 2 sonars control the degrees for all parts
	~p2_activeVoices = Array.fill(~p2_voicesCount, {0}); // monitor active voices, as an array of 1 or 0

	// degree controlled by sonar 0 and 1 alternatively
	Pdef(\p2_0,
		Pbind(\instrument, \lead3, \dur, Pseq( ~claves[0]/8, inf), \scale, ~scale, \degree, Pfunc({~p2_degrees[0]}), \root, Pfunc({~root}), \octave, 7, \timbre, Pfunc({~p2_timbres[0]})
	));

	Pdef(\p2_1,
		Pbind(\instrument, \lead2, \dur, Pseq( ~claves[1]/16, inf), \scale, ~scale, \degree, Pfunc({~p2_degrees[1]}), \root, Pfunc({~root}), \octave, 3, \timbre, Pfunc({~p2_timbres[1]})
	));

	Pdef(\p2_2,
		Pbind(\instrument, \lead3, \dur, Pseq( ~claves[2]/16, inf), \scale, ~scale, \degree, Pfunc({~p2_degrees[0]}), \root, Pfunc({~root}), \octave, 4, \timbre, Pfunc({~p2_timbres[2]})
	));

	Pdef(\p2_3,
		Pbind(\instrument, \lead2, \dur, Pseq( ~claves[3]/16, inf), \scale, ~scale, \degree, Pfunc({~p2_degrees[1]}), \root, Pfunc({~root}), \octave, 5, \timbre, Pfunc({~p2_timbres[3]})
	));

	Pdef(\p2_4,
		Pbind(\instrument, \lead3, \dur, Pseq( ~claves[4]/4, inf), \scale, ~scale, \degree, Pfunc({~p2_degrees[0]}), \root, Pfunc({~root}), \octave, 3, \timbre, Pfunc({~p2_timbres[4]})
	));

	Pdef(\p2_5,
		Pbind(\instrument, \lead2, \dur, Pseq( ~claves[5]/16, inf), \scale, ~scale, \degree, Pfunc({~p2_degrees[1]}), \root, Pfunc({~root}), \octave, 8, \timbre, Pfunc({~p2_timbres[5]})
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

	~p3_volume = 0.8;
	~p3_voicesCount = 10;
	~p3_amps = Array.fill(~p3_voicesCount, {0});
	~p3_timbres = Array.fill(~p3_voicesCount, {0});
	~p3_degrees = Array.fill(4, {0}); // 4 sonars control the degrees for all parts
	~p3_activeVoices = Array.fill(~p3_voicesCount, {0}); // monitor active voices, as an array of 1 or 0


	// degree controlled by sonar 0, 1, 2, 3 alternatively
	Pdef(\p3_0,
		Pbind(\instrument, \avlead, \dur, Pseq( ~claves[0]/8, inf), \scale, ~scale, \degree, Pfunc({~p3_degrees[0]}), \root, Pfunc({~root}), \octave, 3, \timbre, Pfunc({~p3_timbres[0]})
	));

	Pdef(\p3_1,
		Pbind(\instrument, \sawpulsimp, \dur, Pseq( ~claves[1]/8, inf), \scale, ~scale, \degree, Pfunc({~p3_degrees[1]}), \root, Pfunc({~root}), \octave, 3, \timbre, Pfunc({~p3_timbres[1]})
	));

	Pdef(\p3_2,
		Pbind(\instrument, \sawpulsimp, \dur, Pseq( ~claves[2]/16, inf), \scale, ~scale, \degree, Pfunc({~p3_degrees[2]}), \root, Pfunc({~root}), \octave, 7, \timbre, Pfunc({~p3_timbres[2]})
	));

	Pdef(\p3_3,
		Pbind(\instrument, \moogbass, \dur, Pseq( ~claves[3]/8, inf), \scale, ~scale, \degree, Pfunc({~p3_degrees[3]}), \root, Pfunc({~root}), \octave, 4, \timbre, Pfunc({~p3_timbres[3]})
	));

	Pdef(\p3_4,
		Pbind(\instrument, \avlead, \dur, Pseq( ~claves[4]/4, inf), \scale, ~scale, \degree, Pfunc({~p3_degrees[0]}), \root, Pfunc({~root}), \octave, 6, \timbre, Pfunc({~p3_timbres[4]})
	));

	Pdef(\p3_5,
		Pbind(\instrument, \sawpulsimp, \dur, Pseq( ~claves[5]/16, inf), \scale, ~scale, \degree, Pfunc({~p3_degrees[1]}), \root, Pfunc({~root}), \octave, 6, \timbre, Pfunc({~p3_timbres[5]})
	));

	Pdef(\p3_6,
		Pbind(\instrument, \sawpulsimp, \dur, Pseq( ~claves[6]/16, inf), \scale, ~scale, \degree, Pfunc({~p3_degrees[2]}), \root, Pfunc({~root}), \octave, 5, \timbre, Pfunc({~p3_timbres[6]})
	));

	Pdef(\p3_7,
		Pbind(\instrument, \moogbass, \dur, Pseq( ~claves[7]/16, inf), \scale, ~scale, \degree, Pfunc({~p3_degrees[3]}), \root, Pfunc({~root}), \octave, 6, \timbre, Pfunc({~p3_timbres[7]})
	));

	Pdef(\p3_8,
		Pbind(\instrument, \avlead, \dur, Pseq( ~claves[8]/16, inf), \scale, ~scale, \degree, Pfunc({~p3_degrees[0]}), \root, Pfunc({~root}), \octave, 4, \timbre, Pfunc({~p3_timbres[8]})
	));

	Pdef(\p3_9,
		Pbind(\instrument, \sawpulsimp, \dur, Pseq( ~claves[9]/16, inf), \scale, ~scale, \degree, Pfunc({~p3_degrees[1]}), \root, Pfunc({~root}), \octave, 4, \timbre, Pfunc({~p3_timbres[9]})
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