// from "https://sccode.org/1-579"

SynthDef(\wind, {|amp=0.2, out=0, modFreq=0.1, fFreq = 1348, fRq = 0.5|
	var src, mod;
	mod = {LFNoise2.ar(modFreq).range(0, 1)}!6;
	src = WhiteNoise.ar(mod.lagud(1, 4));
	src = RLPF.ar(src, fFreq.lag(1), fRq);
	Out.ar(out, Splay.ar(src*amp););
}).add;

~p1_wind = Synth(\wind);
~p1_wind.set(\modFreq, 13);
~p1_wind.set(\amp, 0.4);
~p1_wind.set(\fFreq, 1000);
~p1_wind.set(\fRq, 0.1);


