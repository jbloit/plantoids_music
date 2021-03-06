fork{
	// launch sound
	(dur:1, strum: 0.1, degree: [0,4,7]).play;

	currentEnvironment.clear;
	"plantoids_apex_synthdefs.scd".loadRelative(true, {"loaded synthdefs".postln});

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
	~clavesN = ~claves.size - 1;

	/* =======================================
	BACKGROUND MUSIC LAYERS (IDLE STATE)
	=======================================*/


	// background ongoing kick
	Pdef(\kick,Pbind(\instrument,\sampler, \bufnum, 0, \pan, 0.5, \dur,1/4,\amp,Pseq([0.2,0.1,0.05, 0.01],inf))).play(quant:4);
	/*


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
	\octave, 3,
	\isRest,Pseq(~arpSteps,inf).coin.not,
	\degree,Prand(~degrees[3], inf),
	\dur,1/8,
	\scale,Pfunc({~scale})
	)).play.quant(1);

	*/

	~droneFreq  = ~scale.degreeToFreq(0, 60.midicps, 0);
	fork{
		Ndef(\darkSeaHorn,
			{
				| freq = 261.63, a1=0.1, timbre=0.3, amp = 0.02|
				var aa, f1, f2;
				f1 = freq;
				f2 = timbre.linlin(0,1, 1, 100);
				aa=SinOsc.ar(f1, Ndef(\x).ar*a1,LFNoise1.ar(f2,6)).tanh;
				9.do{aa=AllpassL.ar(aa,0.3,{0.2.rand+0.1}!2,5)};
				aa.tanh * amp}
		).play;
	};


	Ndef(\darkSeaHorn).map(\freq, ~droneFreq);
	Ndef(\darkSeaHorn).map(\amp, 0.025);
	Ndef(\lfo, { SinOsc.kr(0.1, 0, 0.5, 0.5) });
	Ndef(\darkSeaHorn).map(\timbre, Ndef(\lfo));


	/* =======================================
	SENSOR CALLBACKS : Plant 1 (SMALL)
	=======================================*/

	// PERCS
	~p1_volume = 0.3;
	~p1_voicesCount = 6;
	~p1_amps = Array.fill(~p1_voicesCount, {0});
	~p1_timbres = Array.fill(~p1_voicesCount, {0});
	~p1_degrees = Array.fill(2, {0}); // 2 sonars control the degrees for all parts
	~p1_activeVoices = Array.fill(~p1_voicesCount, {0}); // monitor active voices, as an array of 1 or 0


	Pdef(\p1_0,
		Pbind(\instrument, \sawpulsimp, \amp, Pfunc({~p1_amps[0]}), \dur, Pseq( ~claves[~clavesN]/16, inf), \scale, ~scale, \degree, Pfunc({~p1_degrees[0]}), \root, Pfunc({~root}), \octave, 4, \timbre, Pfunc({~p1_timbres[0]}), \out, ~reverbBus,
	));

	Pdef(\p1_1,
		Pbind(\instrument, \sawpulsimp, \amp, Pfunc({~p1_amps[1]}), \dur, Pseq( ~claves[~clavesN]/16, inf), \scale, ~scale, \degree, Pfunc({~p1_degrees[1]}), \root, Pfunc({~root}), \octave, 4, \timbre, Pfunc({~p1_timbres[1]}), \out, ~reverbBus,
	));

	Pdef(\p1_2,
		Pbind(\instrument, \sawpulsimp, \amp, Pfunc({~p1_amps[2]}), \dur, Pseq( ~claves[~clavesN]/16, inf), \scale, ~scale, \degree, Pfunc({~p1_degrees[0]}), \root, Pfunc({~root}), \octave, 4, \timbre, Pfunc({~p1_timbres[2]}), \out, ~reverbBus,
	));

	Pdef(\p1_3,
		Pbind(\instrument, \sawpulsimp, \amp, Pfunc({~p1_amps[3]}), \dur, Pseq( ~claves[~clavesN]/16, inf), \scale, ~scale, \degree, Pfunc({~p1_degrees[1]}), \root, Pfunc({~root}), \octave, 4, \timbre, Pfunc({~p1_timbres[3]}), \out, ~reverbBus,
	));

	Pdef(\p1_4,
		Pbind(\instrument, \sawpulsimp, \amp, Pfunc({~p1_amps[4]}), \dur, Pseq( ~claves[~clavesN]/16, inf), \scale, ~scale, \degree, Pfunc({~p1_degrees[0]}), \root, Pfunc({~root}), \octave, 4, \timbre, Pfunc({~p1_timbres[4]}), \out, ~reverbBus,
	));

	Pdef(\p1_5,
		Pbind(\instrument, \sawpulsimp, \amp, Pfunc({~p1_amps[5]}), \dur, Pseq( ~claves[~clavesN]/16, inf), \scale, ~scale, \degree, Pfunc({~p1_degrees[1]}), \root, Pfunc({~root}), \octave, 4, \timbre, Pfunc({~p1_timbres[5]}), \out, ~reverbBus,
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
				~p1_degrees[i] = ~degrees[5][(v * 5).asInt];

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

	// Octavers on bass

	~p2_volume = 0.5;
	~p2_voicesCount = 6;
	~p2_amps = Array.fill(~p2_voicesCount, {0});
	~p2_timbres = Array.fill(~p2_voicesCount, {1});
	~p2_degrees = Array.fill(2, {0}); // 2 sonars control the degrees for all parts
	~p2_activeVoices = Array.fill(~p2_voicesCount, {0}); // monitor active voices, as an array of 1 or 0

	~p2_setRandomClaves = {
		Pdefn(\p2_dur_0, Pseq( ~claves[rrand(0, (~claves.size - 1))]/16, inf));
		Pdefn(\p2_dur_1, Pseq( ~claves[rrand(0, (~claves.size - 1))]/16, inf));
		Pdefn(\p2_dur_2, Pseq( ~claves[rrand(0, (~claves.size - 1))]/16, inf));
		Pdefn(\p2_dur_3, Pseq( ~claves[rrand(0, (~claves.size - 1))]/16, inf));
		Pdefn(\p2_dur_4, Pseq( ~claves[rrand(0, (~claves.size - 1))]/16, inf));
		Pdefn(\p2_dur_5, Pseq( ~claves[rrand(0, (~claves.size - 1))]/16, inf));
	};


	// init claves
	~p2_setRandomClaves.value();

	// degree controlled by sonar 0 and 1 alternatively
	Pdef(\p2_0,
		Pbind(\instrument, \moogbass, \dur, Pdefn(\p2_dur_0), \scale, ~scale, \degree, 0, \root, Pfunc({~root}), \octave, Prand([2,3], inf), \timbre, Pfunc({~p2_timbres[0]})
	));

	Pdef(\p2_1,
		Pbind(\instrument, \sawpulsimp, \dur, Pdefn(\p2_dur_1), \scale, ~scale, \degree, 0, \root, Pfunc({~root}), \octave, Prand([2,3], inf), \timbre, Pfunc({~p2_timbres[1]})
	));

	Pdef(\p2_2,
		Pbind(\instrument, \moogbass, \dur, Pdefn(\p2_dur_1), \scale, ~scale, \degree, 5, \root, Pfunc({~root}), \octave, Prand([2,3], inf), \timbre, Pfunc({~p2_timbres[0]})
	));

	Pdef(\p2_3,
		Pbind(\instrument, \sawpulsimp, \dur, Pdefn(\p2_dur_2), \scale, ~scale, \degree, 5, \root, Pfunc({~root}), \octave, Prand([2,3], inf), \timbre, Pfunc({~p2_timbres[0]})
	));

	Pdef(\p2_4,
		Pbind(\instrument, \moogbass, \dur, Pdefn(\p2_dur_3), \scale, ~scale, \degree, 8, \root, Pfunc({~root}), \octave, Prand([2,3], inf), \timbre, Pfunc({~p2_timbres[0]})
	));

	Pdef(\p2_5,
		Pbind(\instrument, \sawpulsimp, \dur, Pdefn(\p2_dur_4), \scale, ~scale, \degree, 8, \root, Pfunc({~root}), \octave, Prand([2,3], inf), \timbre, Pfunc({~p2_timbres[1]})
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
				~p2_setRandomClaves.value();

				// tic
				Synth(\sampler, [\amp, 0.2, \bufnum, ~fxBuffers[0].bufnum, \timbre, 0.9, \pan, 0.5, \rate, v.linlin(0, 1, 0.8, 0.9)]);

				~root = v.linlin(0, 1, -3, 3);
				~droneFreq  = ~scale.degreeToFreq(~root, 60.midicps, 0);
				Ndef(\darkSeaHorn).map(\freq, ~droneFreq);

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
				~p2_timbres[i] = v;
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

	// PLANT 3 = PERCS

	~p3_volume = 2;
	~p3_voicesCount = 10;
	~p3_amps = Array.fill(~p3_voicesCount, {0});
	~p3_timbres = Array.fill(~p3_voicesCount, {1});
	~p3_degrees = Array.fill(4, {0}); // 4 sonars control the degrees for all parts
	~p3_activeVoices = Array.fill(~p3_voicesCount, {0}); // monitor active voices, as an array of 1 or 0

	~p3_setRandomClaves = {
		Pdefn(\p3_dur_0, Pseq( ~claves[rrand(0, (~claves.size - 1))]/16, inf));
		Pdefn(\p3_dur_1, Pseq( ~claves[rrand(0, (~claves.size - 1))]/16, inf));
		Pdefn(\p3_dur_2, Pseq( ~claves[rrand(0, (~claves.size - 1))]/16, inf));
		Pdefn(\p3_dur_3, Pseq( ~claves[rrand(0, (~claves.size - 1))]/16, inf));
		Pdefn(\p3_dur_4, Pseq( ~claves[rrand(0, (~claves.size - 1))]/16, inf));
		Pdefn(\p3_dur_5, Pseq( ~claves[rrand(0, (~claves.size - 1))]/16, inf));
		Pdefn(\p3_dur_6, Pseq( ~claves[rrand(0, (~claves.size - 1))]/16, inf));
		Pdefn(\p3_dur_7, Pseq( ~claves[rrand(0, (~claves.size - 1))]/16, inf));
		Pdefn(\p3_dur_8, Pseq( ~claves[rrand(0, (~claves.size - 1))]/16, inf));
		Pdefn(\p3_dur_9, Pseq( ~claves[rrand(0, (~claves.size - 1))]/16, inf));
	};


	// init claves
	~p3_setRandomClaves.value();


	// degree controlled by sonar 0, 1, 2, 3 alternatively

	// keep kick panned in center
	Pdef(\p3_0,
		Pbind(\instrument, \sampler, \bufnum, ~percBuffers[0].bufnum, \dur, Pdefn(\p3_dur_0),  \timbre, Pfunc({~p3_timbres[0]}),
			\pan, 0.5, \amp, Pfunc({~p3_amps[0]}),
	) );

	Pdef(\p3_1,
		Pbind(\instrument, \sampler, \bufnum, ~percBuffers[1].bufnum, \dur, Pdefn(\p3_dur_1),  \timbre, Pfunc({~p3_timbres[1]}), \pan, Pfunc({rrand(-1.0, 1.0)}), \amp, Pfunc({~p3_amps[1]}),
	));

	Pdef(\p3_2,
		Pbind(\instrument, \sampler, \bufnum, ~percBuffers[2].bufnum, \dur, Pdefn(\p3_dur_2),  \timbre, Pfunc({~p3_timbres[2]}), \pan, Pfunc({rrand(-1.0, 1.0)}), \amp, Pfunc({~p3_amps[2]}),
	));

	Pdef(\p3_3,
		Pbind(\instrument, \sampler, \bufnum, ~percBuffers[3].bufnum, \dur, Pdefn(\p3_dur_3),  \timbre, Pfunc({~p3_timbres[3]}), \pan, Pfunc({rrand(-1.0, 1.0)}), \amp, Pfunc({~p3_amps[3]}),
	));

	Pdef(\p3_4,
		Pbind(\instrument, \sampler, \bufnum, ~percBuffers[4].bufnum, \dur, Pdefn(\p3_dur_4),  \timbre, Pfunc({~p3_timbres[0]})
			, \pan, Pfunc({rrand(-1.0, 1.0)}), \amp, Pfunc({~p3_amps[4]}),
	));

	Pdef(\p3_5,
		Pbind(\instrument, \sampler, \bufnum, ~percBuffers[5].bufnum, \dur, Pdefn(\p3_dur_5),  \timbre, Pfunc({~p3_timbres[1]})
			, \pan, Pfunc({rrand(-1.0, 1.0)}), \amp, Pfunc({~p3_amps[5]}),
	));

	Pdef(\p3_6,
		Pbind(\instrument, \sampler, \bufnum, ~percBuffers[6].bufnum, \dur, Pdefn(\p3_dur_6),  \timbre, Pfunc({~p3_timbres[2]})
			, \pan, Pfunc({rrand(-1.0, 1.0)}), \amp, Pfunc({~p3_amps[6]}),
	));

	Pdef(\p3_7,
		Pbind(\instrument, \sampler, \bufnum, ~percBuffers[7].bufnum, \dur, Pdefn(\p3_dur_7),  \timbre, Pfunc({~p3_timbres[3]})
			, \pan, Pfunc({rrand(-1.0, 1.0)}), \amp, Pfunc({~p3_amps[7]}),
	));


	Pdef(\p3_8,
		Pbind(\instrument, \sampler, \bufnum, ~percBuffers[8].bufnum, \dur, Pdefn(\p3_dur_8),  \timbre, Pfunc({~p3_timbres[0]})
			, \pan, Pfunc({rrand(-1.0, 1.0)}), \amp, Pfunc({~p3_amps[8]}),
	));


	Pdef(\p3_9,
		Pbind(\instrument, \sampler, \bufnum, ~percBuffers[9].bufnum, \dur, Pdefn(\p3_dur_9),  \timbre, Pfunc({~p3_timbres[1]})
			, \pan, Pfunc({rrand(-1.0, 1.0)}), \amp, Pfunc({~p3_amps[9]}),

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
				"----->ONSET FLEX".postln;
				// pick random claves on Tilt onset

				~p3_setRandomClaves.value();

				// tic
				Synth(\sampler, [\amp, 0.2, \bufnum, ~fxBuffers[0].bufnum, \timbre, 0.9, \pan, 0.5]);

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
				~p3_timbres[i] = v.linlin(0,1, 0.5, 1);

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
				// "----->ON LIGHT".postln;

				// normalize amp depending on the number of active voices for this plantoid
				var amp;
				~p3_activeVoices[i] = 1;
				amp = min(1, (1 / sum(~p3_activeVoices)));
				~p3_amps[i] = amp * ~p3_volume;

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