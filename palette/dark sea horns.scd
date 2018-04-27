// Original code: "https://sccode.org/1-j"
n=LFNoise1;Ndef(\x,{a=SinOsc.ar(65,Ndef(\x).ar*n.ar(0.1,3),n.ar(3,6)).tanh;9.do{a=AllpassL.ar(a,0.3,{0.2.rand+0.1}!2,5)};a.tanh}).play


// PARAMETRIZING
(
n=LFNoise1;
Ndef(\x,
	{
		| freq = 65, amp = 1|
		a=SinOsc.ar(freq, Ndef(\x).ar*n.ar(0.1,3),n.ar(3,6)).tanh;
		9.do{a=AllpassL.ar(a,0.3,{0.2.rand+0.1}!2,5)};
		a.tanh * amp}
).play;
)

// EXPLORING

(
Ndef(\lfo, { LFNoise1.kr(3, 400, 800) });
Ndef(\x).map(\freq, Ndef(\lfo));
)
Ndef(\x).map(\freq, 1);
Ndef(\x).map(\freq, 10);
Ndef(\x).map(\freq, 30);
Ndef(\x).map(\freq, 65);
Ndef(\x).map(\freq, 100);
Ndef(\x).map(\freq, 1000);
Ndef(\x).map(\freq, 1024);

Ndef(\x).map(\amp, 1);