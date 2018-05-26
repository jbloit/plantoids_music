//--tweet0347  ********* TRIPPY
play{a=LFSaw;Splay.ar({|i|VarSaw.ar(round(a.ar(c=i/48)*a.ar(b=c/72)*8+9,i%9+1)*25+c,c,a.ar(3,i)+1/3,a.ar(b,i/pi)%1)/2}!30)}// #SuperCollider

(
SynthDef.new(\trippy, {
	|amp=0.1, freq=0, gate=1|
	var sig, env;
	env = Env.adsr(0.001, 0.1, 0.01, 0.001);
	sig = SinOsc.ar(freq) * EnvGen.kr(env, gate,  doneAction: 2, levelScale: [amp, amp]);
	Out.ar(0, sig);
}).add;
)

x = Synth(\trippy);
x.set(\gate, 1);
x.set(\gate, 0);

(
p = Pbind(
	\instrument, \trippy,
	\dur, 0.9,
	\note, Pseq([33,34],inf)
).play;
)


Pdefn(\x, Pbrown(0, 6, 0.1, inf));
(
Pdef(\p1,
	PmonoArtic(\trippy,
		\note, Pseq([33,34, 22],inf),
		\dur, Pdefn(\x))
).play;
)


Pdef(\p1).stop;
Pdefn(\x, Pseq([0.1, 0.9], inf));
Pdefn(\x, Pseq([0.1, 0.9, 2, 2], inf));

Pdef(\p1).play;




Pdefn(\x, Pbrown(0, 6, 0.1, inf));
Pbind(\note, Pdefn(\x), \dur, 0.3).play;
Pbind(\note, Pdefn(\x), \dur, 0.1, \ctranspose, 15).play;
// now change the definition
Pdefn(\x, Pseq([0, 3, 5, 7, 9, 11], inf));
Pdefn(\x, Pseq([0, 3, 3, 7], inf) + Pseq([0, [0, 3], [0, 5, 7]], inf));

Pdef(\bd).set(\note, Pseq([40, 21], 3));
Pdef(\bd).play;
Pdef(\bd).stop;
