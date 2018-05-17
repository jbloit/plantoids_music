fork{
	// launch sound
	(dur:1, strum: 0.1, degree: [0,4,7]).play;

	~sensorRange = 1024;
	~temperatureRange = 50;
	~sonarRange = 500;

	{ | dur = 0.15, atk = 0.15, rel = 0.1, amp = 0.8, pan = 0, gate = 1, freq = 110, sweepHi= 2960|
		Pan2.ar(
			SinOsc.ar(
				EnvGen.ar(Env([sweepHi, freq, 110], [0.07, 0.15], [-13, -1])),
				mul:EnvGen.ar(
					Env.asr( atk, 0.5,  rel, -4), gate,
					doneAction: 2 ) ),
			pan, amp )
	}.asSynthDef.name_("sweepKick").add;

	SynthDef(\snare, {
		var snd;
		snd = DC.ar(0);
		snd = snd + (HPF.ar(Hasher.ar(Sweep.ar), 1320) * Env.perc(0.003, 0.03).ar * 0.5);
		snd = snd + (SinOsc.ar(XLine.ar(750, 161, 0.02)) * Env.perc(0.0005, 0.02).ar);
		snd = snd + (SinOsc.ar(XLine.ar(167, 52, 0.04)) * Env.perc(0.0005, 0.3).ar(2));
		snd = snd.tanh;
		Out.ar(\out.kr(0), Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1)));
	}).add;

	Pdef.all.do{|x| x.clear};

	4.do{|i|
		Pdef(("pat"++i).asSymbol, PmonoArtic(\sweepKick,
			\freq, Pseq([(50 * i) + 50], inf),
			\sweepHi, Pseq([(50 ) + 5000], inf),
			\dur, 1/(2.pow(i)),
			\amp, Pdefn(("amp"++i).asSymbol, Pseq([0], inf)),
			\legato, 1/2 ,
			\atk, Pseq([0.01 , 0.1, 0.3, 0.2], inf),
			\rel, Pseq([0.1, 0.01, 0.3, 0.2], inf),
			\pan, Pseq([-1, 0, 1], inf),
			// \foo, Pfunc({~toggle.(~patternToggles[i])}),
		)).play;
	};


	2.do{|i|  //do something N times
		Pdef(("snare"++i).asSymbol, PmonoArtic(\snare,
			\dur, 1/((i+1)*3),
			\amp, Pdefn(("ampSnare"++i).asSymbol, Pseq([1, Pstutter((i+1), Pseq([0], 1))], inf)),
			\pan, Pseq([-1, 0, 1], inf),
		)).play;
	};


	/*	4.do{|i|  //do something 12 times
	var j = i+4;
	~patterns[j] = Pdef(("kick2_"++j).asSymbol, PmonoArtic(\kick2,
	\sweepHi, Pseq([500*i], inf),
	\dur, 1/((i+1)*3),
	\amp, Pseq([1], inf),
	\pan, Pseq([-1, 0, 1], inf),
	\foo, Pfunc({~toggle.(~patternToggles[j])}),
	));
	};*/


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
		TempoClock.tempo= t/60;
	}, '/plantoid/1/1/temp', n);

	// plant 1 sensors -> beat
	OSCdef(\sensorsBeat).free;
	OSCdef(\sensorsBeat, {
		| msg, time, addr, port |
		var amp;

		// sensor 1-4 -> kick pattern level
		amp = msg[2] / ~sensorRange;
		Pdefn(("amp"++msg[1]).asSymbol, Pseq([amp], inf));

	}, '/plantoid/1/1/analog', n);


	// plant 1 sonars -> change snare pattern
	OSCdef(\sonarSnare).free;
	OSCdef(\sonarSnare, {
		| msg, time, addr, port |
		var val, sonarIndex, mapped;

		sonarIndex = msg[1] - 1;
		val = msg[2] / ~sonarRange;
		mapped = (val * 10).ceil;

		Pdefn(("ampSnare"++sonarIndex).asSymbol, Pseq([1, Pstutter(mapped, Pseq([0], 1))], inf));

	}, '/plantoid/1/1/sonar', n);

};
