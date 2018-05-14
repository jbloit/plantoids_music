fork{
	// launch sound
	(dur:1, strum: 0.1, degree: [0,4,7]).play;

	// Dev sound. go for as organic as possible.
	SynthDef(\avping, {|out= 0, freq= 400, atk= 0.01, rel= 0.1, cur= -4, amp= 0.1, gate= 1, pan= 0, mod= 1|
		var env= EnvGen.ar(Env.asr(atk, 1, rel, cur), gate, doneAction:2);
		var snd= SinOsc.ar(freq, SinOsc.ar(freq*mod, env*pi, mod));
		Out.ar(out, Pan2.ar(snd*env, pan, amp));
	}).add;

	// Toggle function
	~toggle = {
		|pattern|
		if(pattern.isPlaying, {pattern.stop}, {pattern.play});
		// ("TOGGLE " ++ pattern).postln;
	};

	// Patterns
	~p1 = Pdef(\pattern1, PmonoArtic(\avping,
		\freq, Pseq([110], inf),  //change these
		\dur, 1,
		\amp, Pseq([1], inf),
		\legato, 0.1,  //this key for example is for the PmonoArtic sequencer
		\atk, 0.01,    //while this key belongs to the \avping SynthDef
		\rel, 0.01,
		\sustain, 1/2,
		\foo, Pfunc({~toggle.(~p3)}),
	));

	~p2 = Pdef(\pattern2, PmonoArtic(\avping,
		\freq, Pseq([200], inf),  //change these
		\dur, 1/2,
		\amp, Pseq([1], inf),
		\legato, 0.1,  //this key for example is for the PmonoArtic sequencer
		\atk, 0.01,    //while this key belongs to the \avping SynthDef
		\rel, 0.01,
		\sustain, 1/4,
		\foo, Pfunc({~toggle.(~p3)}),
	));

	~p3 = Pdef(\pattern3, PmonoArtic(\avping,
		\freq, Pseq([300], inf),  //change these
		\dur, 1/3,
		\amp, Pseq([1], inf),
		\legato, 1,  //this key for example is for the PmonoArtic sequencer
		\atk, 0.01,    //while this key belongs to the \avping SynthDef
		\rel, 0.001,
		\sustain, 1/6,
		\foo, Pfunc({~toggle.(~p4)}),
		));

	~p4 = Pdef(\pattern4, PmonoArtic(\avping,
		\freq, Pseq([500], inf),  //change these
		\dur, 1/6,
		\amp, Pseq([1], inf),
		\legato, 0.1,  //this key for example is for the PmonoArtic sequencer
		\atk, 0.01,    //while this key belongs to the \avping SynthDef
		\rel, 0.01,
		\sustain, 1/12,
		// \foo, Pfunc({~toggle.(~p2)}),
	));

	//-------------------------------------------------
	//                                       OSC  CTRLS
	//-------------------------------------------------

	//-------------------------------------------------
	// Temperature -> bpm
	OSCdef(\bpm).free;
	OSCdef(\bpm, {
		| msg, time, addr, port |
		var t;
		t = 160 - msg[1];
		TempoClock.tempo= t/60;
	}, '/plantoid/1/1/temp', n);

	// sensor -> toggle pattern
	OSCdef(\toggleP1).free;
	OSCdef(\toggleP1, {
		| msg, time, addr, port |
		if( (msg[1] < 512), {~p1.play;}, {~p1.stop;});
	}, '/plantoid/1/1/analog1', n);

	// sensor -> toggle pattern
	OSCdef(\toggleP2).free;
	OSCdef(\toggleP2, {
		| msg, time, addr, port |
		if( (msg[1] < 512), {~p2.play;}, {~p2.stop;});
	}, '/plantoid/1/1/analog2', n);

	// sensor -> toggle pattern
	OSCdef(\toggleP3).free;
	OSCdef(\toggleP3, {
		| msg, time, addr, port |
		if( (msg[1] < 512), {~p3.play;}, {~p3.stop;});
	}, '/plantoid/1/1/analog3', n);

	// sensor -> toggle pattern
	OSCdef(\toggleP4).free;
	OSCdef(\toggleP4, {
		| msg, time, addr, port |
		if( (msg[1] < 512), {~p4.play;}, {~p4.stop;});
	}, '/plantoid/1/1/analog4', n);
};