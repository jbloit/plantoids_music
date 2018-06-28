(
SynthDef(\wind, {
	|out=0, freqNorm=0.5, amp=0.1|
	var sig;
	sig = PinkNoise.ar();
	sig = LPF.ar(sig, ((freqNorm*2000) + 100)) * amp;
	Out.ar(out, sig!2);
}).add;
)

Synth(\wind, [\freqNorm, 0.9]);
