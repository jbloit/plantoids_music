fork{
	// launch sound
	(dur:1, strum: 0.1, degree: [0,4,7]).play;

	~sensorRange = 1024;

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
		|patternIndex|
		if(~patterns[patternIndex].isPlaying, {~patterns[patternIndex].stop;}, {~patterns[patternIndex].play;});
		// ("TOGGLE " ++ patternIndex).postln;
	};

	~patterns = Array.newClear(8);
	~patternToggles = Array.newClear(~patterns.size);
	4.do{|i|  //do something 12 times

		~patternToggles[i] = i + 1;
		~patterns[i] = Pdef(("pat"++i).asSymbol, PmonoArtic(\sweepKick,
			\freq, Pseq([(50 * i) + 50], inf),
			\sweepHi, Pseq([(50*i ) + 5000], inf),
			\dur, 1/(2.pow(i)),
			\amp, Pseq([1], inf),
			\legato, 1/2 ,
			\atk, Pseq([0.1, 0.1, 0.3, 0.2], inf),
			\rel, Pseq([0.1, 0.01, 0.3, 0.2], inf),
			\pan, Pseq([-1, 0, 1], inf),
			\foo, Pfunc({~toggle.(~patternToggles[i])}),
		));
	};

	//
	// ~patternToggles[3] = 1;
/*	~toggle.(0)
	~toggle.(1)
	~toggle.(2)
	~toggle.(3)
	~toggle.(4)*/

	// ~toggle.(5)
	// ~toggle.(4)
	// ~toggle.(6)
	// ~toggle.(7)


	4.do{|i|  //do something 12 times
		var j = i+4;
		~patterns[j] = Pdef(("kick2_"++j).asSymbol, PmonoArtic(\kick2,
			\sweepHi, Pseq([500*i], inf),
			\dur, (1/(3.pow(i))),
			\amp, Pseq([1], inf),
			\pan, Pseq([-1, 0, 1], inf),
			\foo, Pfunc({~toggle.(~patternToggles[j])}),
		));
	};


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
		if( (msg[1] < 512), {~patterns[0].play; ~patternToggles[1]=4;}, {~patterns[0].stop; ~patternToggles[1]=2;});
	}, '/plantoid/1/1/analog1', n);

	// sensor -> toggle pattern
	OSCdef(\toggleP2).free;
	OSCdef(\toggleP2, {
		| msg, time, addr, port |
		if( (msg[1] < 512), {~patternToggles[2]=1;}, {~patternToggles[1]=3;});
	}, '/plantoid/1/1/analog2', n);

	// sensor -> toggle pattern
	OSCdef(\toggleP3).free;
	OSCdef(\toggleP3, {
		| msg, time, addr, port |
		if( (msg[1] < 512), {~patternToggles[3]=2;}, {~patternToggles[3]=4;});
	}, '/plantoid/1/1/analog3', n);

	// sensor -> toggle pattern
	OSCdef(\toggleP4).free;
	OSCdef(\toggleP4, {
		| msg, time, addr, port |
		if( (msg[1] < 512), {~patternToggles[4]=3;}, {~patternToggles[4]=5;});
	}, '/plantoid/1/1/analog4', n);

	// sensor -> toggle pattern
	OSCdef(\toggleP5).free;
	OSCdef(\toggleP5, {
		| msg, time, addr, port |
		if( (msg[1] < 512), {~patternToggles[5]=4;}, {~patternToggles[5]=6;});
	}, '/plantoid/1/1/analog5', n);

	// sensor -> toggle pattern
	OSCdef(\toggleP6).free;
	OSCdef(\toggleP6, {
		| msg, time, addr, port |
		if( (msg[1] < 512), {~patternToggles[6]=5;}, {~patternToggles[6]=7;});
	}, '/plantoid/1/1/analog6', n);

	// sensor -> toggle pattern
	OSCdef(\toggleP7).free;
	OSCdef(\toggleP7, {
		| msg, time, addr, port |
		if( (msg[1] < 512), {~patternToggles[7]=6;}, {~patternToggles[7]=7;});
	}, '/plantoid/1/1/analog7', n);

	// sensor -> toggle pattern
	OSCdef(\toggleP8).free;
	OSCdef(\toggleP8, {
		| msg, time, addr, port |
		if( (msg[1] < 512), {~patterns[7].stop}, {~patterns[7].play;});
	}, '/plantoid/1/1/analog8', n);


};
