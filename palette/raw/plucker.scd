
(
SynthDef(\plucker,
	{|out=0, amp=0.1|
		var sig, gen;
		gen = { rrand(1,10).reciprocal };
		sig = Pluck.ar(
			WhiteNoise.ar ! 2,
			Dust.ar(LFNoise2.kr(gen!2).exprange(1/5,5)),
			1/200, LFNoise2.kr(gen!2).exprange(1/14000,1/200),
			LFNoise2.kr(gen!2).range(1,10),
			LFNoise2.kr(gen!2).range(0,1),
			LFNoise2.kr(gen!2).exprange(0.2,1)
		);
		Out.ar(out, sig*amp);
	};
).add;
)
~plucker = Synth(\plucker);
