// Original code: "https://sccode.org/1-j"
n=LFNoise1;Ndef(\x,{a=SinOsc.ar(65,Ndef(\x).ar*n.ar(0.1,3),n.ar(3,6)).tanh;9.do{a=AllpassL.ar(a,0.3,{0.2.rand+0.1}!2,5)};a.tanh}).play


// PARAMETRIZING

// control a1 directly instead of through the NoiseLF1
(
Ndef(\x,
	{
		| f1 = 65, a1=0.1, f2=3, amp = 1|
		var aa;
		aa=SinOsc.ar(f1, Ndef(\x).ar*a1,LFNoise1.ar(f2,6)).tanh;
		9.do{aa=AllpassL.ar(aa,0.3,{0.2.rand+0.1}!2,5)};
		aa.tanh * amp}
).play;
)


// EXPLORING PARAM SPACE

Server.default.record;
Server.default.stopRecording


Ndef(\x).map(\a1, 0);
Ndef(\x).map(\a1, 1);
Ndef(\x).map(\a1, 2);
Ndef(\x).map(\a1, 3);

Ndef(\x).map(\f1, ~droneFreq)
Ndef(\x).map(\amp, 0.01)


Ndef(\x).map(\f1, 1);
Ndef(\x).map(\f1, 10);
Ndef(\x).map(\f1, 30);
Ndef(\x).map(\f1, 65);
Ndef(\x).map(\f1, 100);
Ndef(\x).map(\f1, 1000);
Ndef(\x).map(\f1, 1024);
(
Ndef(\lfo, { LFNoise1.kr(3, 400, 800) });
Ndef(\x).map(\f1, Ndef(\lfo));
)

Ndef(\x).map(\f2, 0.05);
Ndef(\x).map(\f2, 0.1);
Ndef(\x).map(\f2, 3);
Ndef(\x).map(\f2, 30);
Ndef(\x).map(\f2, 300);


Ndef(\x).map(\amp, 1);
Ndef(\x).map(\amp, 0);