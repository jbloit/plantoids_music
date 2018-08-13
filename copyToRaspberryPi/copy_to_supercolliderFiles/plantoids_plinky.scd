fork{
	// launch sound
	(dur:1, strum: 0.1, degree: [0,4,7]).play;

	currentEnvironment.clear;
	"plantoids_plinky_synthdefs.scd".loadRelative(true, {"loaded synthdefs".postln});

	// GLOBAL VARS
	~samplesDir = thisProcess.nowExecutingPath.dirname +/+ "../soundfiles";
	~postOSC  = false;
	~rootFreq = 99;
	~tempoFactor = 1;
	~scale = Scale.majorPentatonic;

	TempoClock.tempo = ~tempoFactor;


	/* =======================================
	SENSOR CALLBACKS : Plant 1 (SMALL)
	=======================================*/

	// PERCS


	// background ongoing kick
	Pdef(\kick,Pbind(\instrument,\kick,\dur,1/4,\isRest,Pseq([1,1,0],inf).coin.not,\amp,Pseq([0.3,0.1,0],inf))).play(quant:4);

	~lead1_degree = 0;
	~lead2_degree = 0;
	~lead3_degree = 0;
	~lead4_degree = 0;
	~state_flex=(-1);
	~detune = 0;
	~transpose=0;

	// arpeggiator
	~stepsCount = 33;

	~arpSteps = rrand(0,12!~stepsCount);

	~setStep = {|i, val|
		if (~arpSteps[i] > 0) {~arpSteps[i]=0} {~arpSteps[i]=val};
	};

	Pdef(\arp1,
		Pbind(\instrument,\lead1,
			\amp,Pseq([1],inf),
			\root,Pfunc({~transpose}),
			\isRest,Pseq(~arpSteps,inf).coin.not,
			\degree,Pseq(~arpSteps,inf),
			\dur,1/4,
			\scale,Pfunc({~scale})
	)).play.quant(~stepsCount);

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
			},
			0, {
				//"----->OFF LIGHT".postln;
			},
			1, {
				// "----->CHANGE VALUE".postln;
			},
			2, {
				// "----->ONSET LIGHT".postln;
				// postf("~p1_onset Light i:% v:% \n", i, v);
				if (i.odd) {
					var amp = ~p1_sonarValues[0];
					Synth(\hat909, [\freq, 220 + (i * 10), \amp, amp]);

				} {
					var amp = ~p1_sonarValues[1];
					Synth(\kickmed, [\amp, amp, \decay, 0.01, \release, 0.01, \atk, 0.1, \freq1,90, \freq2, 110, \fratio, (i+1)]);

				};
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

	// role: change notes to be played
	~p2_sonarValues = Array.fill(2, {0});
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
				~p2_sonarValues[i] = v;
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
			},
			0, {
				//"----->OFF LIGHT".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;
			},
			2, {
				// "----->ONSET LIGHT".postln;

				if (i.odd)
				{
					var degree = (~p2_sonarValues[0] * 12).asInt ;
					(instrument: \lead1, scale: ~scale, octave:3, degree:degree, mod:(i+2), dur:1/4, latency:Ref(0)).play;
				}
				{
					var degree = (~p2_sonarValues[1] * 12).asInt ;
					(instrument: \lead1, scale: ~scale, octave:3, degree:degree, mod:(i+2), dur:1/4, latency:Ref(0)).play;
				};
			},
		);
	};



	/* =======================================
	SENSOR CALLBACKS : Plant 3 (BIG)
	=======================================*/

	// PLANT 3 = LEADS

	~p3_synthArray = [\lead1, \lead1, \lead1, \lead1];

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

	// role: change notes to be played
	~p3_sonarValues = Array.fill(4, {0});

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
				~p3_sonarValues[i] = v;
			},
			2, {
				// "----->ONSET SONAR".postln;

			},
		);
	};

	~p3_stem_light = {|i=0, v=0, state=0|
		// postf("~p3_stem_light i:% v:% \n", i, v);
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

				// set the sonar index that controls the note for this light sensor
				var sonarIndex = (i % 4);
				var synth = ~p3_synthArray[sonarIndex];


				var degree = (~p3_sonarValues[sonarIndex] * 12).asInt;

				(instrument: synth, scale: ~scale, degree:degree, dur:1/4, amp:v, latency:Ref(0)).play;

			},
		);
	};

	// manage the OSC parsing:
	"plantoids_parseOSC.scd".loadRelative(true, {"loaded parse OSC".postln});
};