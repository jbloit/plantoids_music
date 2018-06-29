fork{
	// launch sound
	(dur:1, strum: 0.1, degree: [0,4,7]).play;

	currentEnvironment.clear;

	// GLOBAL VARS
	~p1StemLDRsCount=11;
	~samplesDir = thisProcess.nowExecutingPath.dirname +/+ "../soundfiles";

	// AUDIO GRAPH
	// =================== /
	~p1src= Group.new;
	~p1fx = Group.after(~p1src);
	~p1bus = Bus.audio(s, 2);

	~p2src= Group.new;
	~p2fx = Group.after(~p2src);
	~p2bus = Bus.audio(s, 2);

	~p3src= Group.new;
	~p3fx = Group.after(~p3src);
	~p3bus = Bus.audio(s, 2);

	SynthDef(\gain, {
		|in=0, out=0, amp=1|
		Out.ar(out, In.ar(in, 2) * amp);
	}).add;

	SynthDef(\reverb, {
		|in=0, out = 0, mix=0.8|
		var sig;
		sig = In.ar(in, 1);
		sig = FreeVerb.ar(sig, mix, 0.1)!2;
		Out.ar(out, sig);
	}).add;

	s.sync;
	Synth.new(\reverb, [\in, ~p1bus], ~p1fx);
	Synth.new(\reverb, [\in, ~p2bus], ~p2fx);
	Synth.new(\reverb, [\in, ~p3bus], ~p3fx);

	// P1 Synths
	// ---------------------------------- /

	~rootFreq = 99;

	SynthDef(\windBasic, {
		|out=0, freqNorm=0.5, amp=0.1|
		var sig;
		sig = PinkNoise.ar();
		sig = LPF.ar(sig, ((freqNorm*2000) + 100)) * amp;
		Out.ar(out, sig!2);
	}).add;

	SynthDef(\droneee, { arg freq = 440, amp = 0.3, out = 0, phase = 0;
		var sig, env;
		env = EnvGen.kr(Env.sine(10),doneAction: 2);
		sig = LFPulse.ar(freq , 0.15);
		sig = RLPF.ar(sig,SinOsc.kr(0.3, 0, 200, 1500), 0.1);
		sig = FreeVerb.ar(sig, 0.5, 0.5, 0.5) * env;
		sig = Pan2.ar(sig, SinOsc.kr(1/10, phase),amp);

		Out.ar(out, sig);
	}).add;

	~tic = Buffer.read(s, ~samplesDir +/+ "tic.aif");
	~tac = Buffer.read(s, ~samplesDir +/+ "tac.aif");

	SynthDef(\thump,
	{
		|out=0, amp=0.6, filter=0.5|
		var nse, env, kic;
		env = Env.perc(0.05, 1, 1, -4);
		nse = BrownNoise.ar(2) + PinkNoise.ar(0.5)  * EnvGen.kr(env, doneAction: 2);

		nse = Mix.ar(BPF.ar(nse,[100,1200,80,40,20], mul:[1,0.2,1,1,1]));
		nse = LPF.ar(nse, (filter*900 + 100))! 2;
		Out.ar(out, nse*amp);

	};
).add;

	TempoClock.tempo = 1.45;

	/* =======================================
	SENSOR CALLBACKS : Plant 1
	=======================================*/

	s.sync;
	~p1_wind;
	~p1_sonars= Array.newClear(4);
	~p1_quake;

	// ~p1_flower_ambientLight = {|i=0, v=0| postf("~p1_flower_ambientLight i:% v:% \n", i, v);};

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
				 ~p1_wind.set(\freqNorm, v);
				 ~p1_wind.set(\amp, v/5);
			},
			2, {
				// "----->ONSET FLEX".postln;
				~p1_wind.free;
				~p1_wind = Synth(\windBasic);
			},
		);
	};

	// ~p1_flower_temperature = {|i=0, v=0| postf("~p1_flower_temperature i:% v:% \n", i, v);};

	// ~p1_flower_humidity = {|i=0, v=0| postf("~p1_flower_humidity i:% v:% \n", i, v);};

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
				~tac.play;
			},
		);
	};

	~p1_stem_light = {|i=0, v=0, state=0|
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
			},
		);
	};

	~p1_stem_sonar = {|i=0, v=0, state=0|
		// postf("~p1_stem_sonar i:% v:% \n", i, v);
		switch(state,
			-1, {
				// "----->OFFSET SONAR".postln;
				~p1_sonars[i].free;
			},
			0, {
				//"----->OFF SONAR".postln;
			},
			1, {
				//"----->CHANGE VALUE".postln;
				 ~p1_sonars[i].set(\amp, v);
			},
			2, {
				// "----->ONSET SONAR".postln;
				~p1_sonars[i].free;
				~p1_sonars[i]=Synth(\droneee, [freq: ~rootFreq*(i+1)]);
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
			},
			1, {
				//"----->CHANGE VALUE".postln;
			},
			2, {
				// "----->ONSET LIGHT".postln;
				~tac.play;
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
			},
			2, {
				// "----->ONSET LIGHT".postln;
				~tic.play;
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
				~p2_sonars[i].free;
				~p2_sonars[i]=Synth(\droneee, [freq: ~rootFreq*1.5*(i+1)]);
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
				~p3_sonars[i]=Synth(\droneee, [freq: ~rootFreq*3/5*(i+1)]);
			},
		);
	};


	// manage the OSC parsing:
	"plantoids_parseOSC.scd".loadRelative(true, {"loaded parse OSC".postln});

};
