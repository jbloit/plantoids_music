// hacked from "https://sccode.org/1-4VR"

(
SynthDef(\thump,
	{
		|out=0, amp=0.6, filter=0.5|
		var nse, env, kic;
		env = Env.perc(0.05, 1, 1, -4);
		nse = BrownNoise.ar(2) + PinkNoise.ar(0.5)  * EnvGen.kr(env, doneAction: 2);

		nse = Mix.ar(BPF.ar(nse,[100,1200,80,40,20],MouseX.kr(0,1),[1,0.2,1,1,1]));
		nse = LPF.ar(nse, (filter*900 + 100))! 2;
		Out.ar(out, nse*amp);

	};
).add;
)

Synth(\thump);

Synth(\thump, [\filter, 0.9]);
Synth(\thump, [\filter, 0.2]);