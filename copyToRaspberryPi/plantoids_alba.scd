fork{
	// launch sound
	(dur:1, strum: 0.1, degree: [0,4,7]).play;

	//
	SynthDef.new(\pulse,{
		// hack from "https://sccode.org/1-Z"
		// removing layers
		|f1=8, f2=3, chaos=1, amp=0.0|

		var sig1, ampMap, chaosMap;
		ampMap = ControlSpec(0.0, 1.0);
		chaosMap = ControlSpec(0.1, 2.0); // restrict chaos range (see Crackle doc). Crashes above 2.
		amp = ampMap.map(amp);
		chaos = chaosMap.map(chaos);
		sig1 = tanh(Impulse.kr(f1).lag*Crackle.ar(LFSaw.kr(f2).abs.lag*chaos))*5;
		Out.ar(0, (sig1!2)*amp);
	}).add;

	s.sync;
	~oscValRange = 1023.0;
	~xxx = Synth(\pulse);
	~selectedSynthIndex = 1;
	s.sync;

	//-------------------------------------------------
	//                                       OSC  CTRLS
	//-------------------------------------------------
	OSCdef(\startPattern).free;
	OSCdef(\startPattern, {
		| msg, time, addr, port |

		switch(~selectedSynthIndex,
			1, {~xxx.set(\amp, msg[1]);},
			2, {"Synth 2: amp ".postln;});
		("*Synth " ++ ~selectedSynthIndex ++ ": amp = " ++ msg[1]).postln;

	}, '/start', n);

	//-------------------------------------------------
	OSCdef(\randomTimbreChange).free;
	OSCdef(\randomTimbreChange, {
		| msg, time, addr, port |
		switch(~selectedSynthIndex,
			1, {if(msg[1] > 0, {~xxx.set(\chaos, rrand(0.0, 1));
				"TIMBRE CHANGE".postln;
			}) },
			2, {"dosdosdos".postln;});
		("*Synth " ++ ~selectedSynthIndex ++ ": timbre change " ++ msg[1]).postln;
	}, '/randTimbre', n);

	//-------------------------------------------------
	OSCdef(\randomAccents).free;
	OSCdef(\randomAccents, {
		| msg, time, addr, port |
		switch(~selectedSynthIndex,
			1, {if(msg[1] > 0, {~xxx.set(\f2, rrand(3,24));
				"ACCENTS CHANGE".postln;
			}) },
			2, {"dosdosdos".postln;});
		("*Synth " ++ ~selectedSynthIndex ++ ": accents change " ++ msg[1]).postln;
	}, '/randAccents', n);


	//-------------------------------------------------
	OSCdef(\randomRate).free;
	OSCdef(\randomRate, {
		| msg, time, addr, port |
		switch(~selectedSynthIndex,
			1, {if(msg[1] > 0, {r = [ 6, 8, 12];
				~xxx.set(\f1, r.choose);
				"RATE CHANGE".postln;
			}) },
			2, {"dosdosdos".postln;});
		("*Synth " ++ ~selectedSynthIndex ++ ": rate change " ++ msg[1]).postln;
	}, '/randRate', n);

	//-------------------------------------------------
	OSCdef(\default).free;
	OSCdef(\default, {
		| msg, time, addr, port |
		switch(~selectedSynthIndex,
			1, {if(msg[1] > 0, {~xxx.set(\f1, 8);
				~xxx.set(\f2, 3);
				~xxx.set(\chaos, 1);
				"DEFAULT".postln;
			}) },
			2, {"dosdosdos".postln;});
		("*Synth " ++ ~selectedSynthIndex ++ ": default " ++ msg[1]).postln;
	}, '/default', n);

	//-------------------------------------------------
	OSCdef(\distance).free;
	OSCdef(\distance, {
		| msg, time, addr, port |
		var d, ampMap, f1Map, f2Map;
		d = msg[1] / ~oscValRange;
		f1Map = ControlSpec(8, 24);
		f2Map = ControlSpec(3.0, 0.12);
		ampMap = ControlSpec(1.0, 0.0);

		switch(~selectedSynthIndex,
			1, {if(msg[1] > 0,
				{~xxx.set(\f1, f1Map.map(d));
					~xxx.set(\f2, f2Map.map(d));
					~xxx.set(\chaos, 1);
					~xxx.set(\amp, (1 - d));
					("AMP " ++ ampMap(d)).postln;
			}) },
			2, {"dosdosdos".postln;});
		("*Synth " ++ ~selectedSynthIndex ++ ": distance " ++ msg[1]).postln;
	}, '/distance', n);

};
