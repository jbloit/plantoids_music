fork{
	// launch sound
	(dur:1, strum: 0.1, degree: [0,4,7]).play;

	// Dev sound. go for as organic as possible.
	/*	SynthDef(\sweepKick, {|out= 0, freq= 400, atk= 0.01, rel= 0.1, cur= -4, amp= 0.1, gate= 1, pan= 0, mod= 1|
	var env= EnvGen.ar(Env.asr(atk, 1, rel, cur), gate, doneAction:2);
	var snd= SinOsc.ar(freq, SinOsc.ar(freq*mod, env*pi, mod));
	Out.ar(out, Pan2.ar(snd*env, pan, amp));
	}).add;*/

	{ | dur = 0.15, atk = 0.15, rel = 0.1, amp = 0.8, pan = 0, gate = 1, freq = 110, sweepHi= 2960|
		Pan2.ar(
			SinOsc.ar(
				EnvGen.ar(Env([sweepHi, freq, 110], [0.07, 0.15], [-13, -1])),
				mul:EnvGen.ar(
					Env.asr( atk, 0.5,  rel, -4), gate,
					doneAction: 2 ) ),
			pan, amp )
	}.asSynthDef.name_("sweepKick").add;

	SynthDef(\kick2, {
		var snd;
		snd = DC.ar(0);
		snd = snd + (HPF.ar(Hasher.ar(Sweep.ar), 1320) * Env.perc(0.003, 0.03).ar * 0.5);
		snd = snd + (SinOsc.ar(XLine.ar(750, 161, 0.02)) * Env.perc(0.0005, 0.02).ar);
		snd = snd + (SinOsc.ar(XLine.ar(167, 52, 0.04)) * Env.perc(0.0005, 0.3).ar(2));
		snd = snd.tanh;
		Out.ar(\out.kr(0), Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1)));
	}).add;

	// Toggle function triggered from patterns
	~toggle = {
		|pattern|
		if(pattern.isPlaying, {pattern.stop; ("TOGGLE STOP " ++ pattern).postln;}, {pattern.play; ("TOGGLE PLAY " ++ pattern).postln;});
		// ("TOGGLE " ++ pattern).postln;
	};

	// Patterns
	~p1 = Pdef(\pattern1, PmonoArtic(\sweepKick,
		\freq, Pseq([200], inf),  //change these
		\sweepHi, Pseq([1000], inf),  //change these
		\dur, 1,
		\amp, Pseq([1], inf),
		\legato, 1/2 ,  //this key for example is for the PmonoArtic sequencer
		\atk, Pseq([0.1, 0.1, 0.3, 0.2], inf),    //while this key belongs to the \sweepKick SynthDef
		\rel, Pseq([0.1, 0.01, 0.3, 0.2], inf),
		\pan, Pseq([-1, 0, 1], inf),
		\foo, Pfunc({~toggle.(~p2)}),
	));

	~p1.play;
	~p1.stop;

	~p2 = Pdef(\pattern2, PmonoArtic(\sweepKick,
		\freq, Pseq([300], inf),  //change these
		\sweepHi, Pseq([3000], inf),  //change these
		\dur, 1/2,
		\amp, Pseq([1], inf),
		\legato, 1/2 ,  //this key for example is for the PmonoArtic sequencer
		\atk, Pseq([0.1, 0.3, 0.2], inf),    //while this key belongs to the \sweepKick SynthDef
		\rel, Pseq([0.1, 0.01, 0.3, 0.2], inf),
		\pan, Pseq([-1, 0, 1], inf),
		\foo, Pfunc({~toggle.(~p3)}),
	));

	~p2.play;
	~p2.stop;

	~p3 = Pdef(\pattern3, PmonoArtic(\sweepKick,
		\freq, Pseq([400], inf),  //change these
		\sweepHi, Pseq([10000], inf),  //change these
		\dur, 1/3,
		\amp, Pseq([1], inf),
		\legato, 1/6 ,  //this key for example is for the PmonoArtic sequencer
		\atk, Pseq([0.1, 0.3, 0.2], inf),    //while this key belongs to the \sweepKick SynthDef
		\rel, Pseq([0.1, 0.01, 0.3, 0.2], inf),
		\pan, Pseq([-1, 0, 1], inf),
		 \foo, Pfunc({~toggle.(~p4)}),
	));

	~p3.play;
	~p3.stop;

	~p4 = Pdef(\pattern4, PmonoArtic(\sweepKick,
		\freq, Pseq([50000], inf),  //change these
		\sweepHi, Pseq([10000], inf),  //change these
		\dur, 1/8,
		\amp, Pseq([1], inf),
		\legato, 1/8 ,  //this key for example is for the PmonoArtic sequencer
		\atk, Pseq([0.1, 0.3, 0.2], inf),    //while this key belongs to the \sweepKick SynthDef
		\rel, Pseq([0.1, 0.01, 0.3, 0.2], inf),
		\pan, Pseq([-1, 0, 1], inf),
		\foo, Pfunc({~toggle.(~p3)}),
	));

	~p4.play;
	~p4.stop;

	~p5 = Pdef(\pattern5, PmonoArtic(\kick2,
		\freq, Pseq([500], inf),  //change these
		\dur, 1/2,
		\amp, Pseq([1], inf),
		\legato, 0.1,  //this key for example is for the PmonoArtic sequencer
		\atk, 0.01,    //while this key belongs to the \sweepKick SynthDef
		\rel, 0.01,
		\sustain, 1/12,
		\pan, Pseq([-1, 0, 1]),
		\foo, Pfunc({~toggle.(~p6)}),
	));

	~p6 = Pdef(\pattern5, PmonoArtic(\kick2,
		\freq, Pseq([500], inf),  //change these
		\dur, 1/3,
		\amp, Pseq([1], inf),
		\legato, 0.1,  //this key for example is for the PmonoArtic sequencer
		\atk, 0.01,    //while this key belongs to the \sweepKick SynthDef
		\rel, 0.01,
		\sustain, 1/12,
		\pan, Pseq([-1, 0, 1]),
		\foo, Pfunc({~toggle.(~p7)}),
	));

	~p7 = Pdef(\pattern5, PmonoArtic(\kick2,
		\freq, Pseq([500], inf),  //change these
		\dur, 1/4,
		\amp, Pseq([1], inf),
		\legato, 0.1,  //this key for example is for the PmonoArtic sequencer
		\atk, 0.01,    //while this key belongs to the \sweepKick SynthDef
		\rel, 0.01,
		\sustain, 1/12,
		\pan, Pseq([-1, 0, 1]),
		\foo, Pfunc({~toggle.(~p8)}),
	));

	~p8 = Pdef(\pattern5, PmonoArtic(\kick2,
		\freq, Pseq([500], inf),  //change these
		\dur, 1/6,
		\amp, Pseq([1], inf),
		\legato, 0.1,  //this key for example is for the PmonoArtic sequencer
		\atk, 0.01,    //while this key belongs to the \sweepKick SynthDef
		\rel, 0.01,
		\sustain, 1/12,
		\pan, Pseq([-1, 0, 1]),
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
		t = 120 - msg[1];
		// TempoClock.tempo= t/60;
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

	// sensor -> toggle pattern
	OSCdef(\toggleP5).free;
	OSCdef(\toggleP5, {
		| msg, time, addr, port |
		if( (msg[1] < 512), {~p5.play;}, {~p5.stop;});
	}, '/plantoid/1/1/analog5', n);

	// sensor -> toggle pattern
	OSCdef(\toggleP6).free;
	OSCdef(\toggleP6, {
		| msg, time, addr, port |
		if( (msg[1] < 512), {~p6.play;}, {~p6.stop;});
	}, '/plantoid/1/1/analog6', n);

	// sensor -> toggle pattern
	OSCdef(\toggleP7).free;
	OSCdef(\toggleP7, {
		| msg, time, addr, port |
		if( (msg[1] < 512), {~p7.play;}, {~p7.stop;});
	}, '/plantoid/1/1/analog7', n);

	// sensor -> toggle pattern
	OSCdef(\toggleP8).free;
	OSCdef(\toggleP8, {
		| msg, time, addr, port |
		if( (msg[1] < 512), {~p8.play;}, {~p8.stop;});
	}, '/plantoid/1/1/analog8', n);


};
