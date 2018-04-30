(
SynthDef.new(\pulse,{
	// hack from "https://sccode.org/1-Z"
	// removing layers
	|f1=8, f2=3, chaos=1, amp=1.0|

	var sig1, chaosMap;
	chaosMap = ControlSpec(0.1, 2.0); // restrict chaos range (see Crackle doc). Crashes above 2.
	chaos = chaosMap.map(chaos);
	sig1 = tanh(Impulse.kr(f1).lag*Crackle.ar(LFSaw.kr(f2).abs.lag*chaos))*5;
	Out.ar(0, (sig1!2)*amp);
}).add;
)

x = Synth(\pulse);

Server.default.record;
Server.default.stopRecording

// default
(
x.set(\f1, 8);
x.set(\f2, 3);
x.set(\chaos, 1);
)

x.set(\chaos, 0.4);
x.set(\chaos, 1);

(
x.set(\f1, 6);
x.set(\f2, 4);
x.set(\chaos, 0.1);
)

(
x.set(\f1, 6);
x.set(\f2, 4);
x.set(\chaos, 0.2);
)


(
x.set(\chaos, 0)
)

// ======== RANDOMIZE
(
x.set(\f1, rrand(8,24));
)
(
x.set(\f2, rrand(3,24));
)

(
var f1 = rrand(4,24);
x.set(\f1, 8);
x.set(\f2, rrand(3,24));
x.set(\chaos, rrand(0.0, 1));
)


x.set(\amp, 4);

(
x.set(\f1, 4);
x.set(\f2, 8);
)

(
x.set(\f1, 8);
x.set(\f2, 4);
)

(
x.set(\f1, 12);
x.set(\f2, 2);
)

(
x.set(\f1, 8);
x.set(\f2, 3);
)

// purr
(
x.set(\f1, 24);
x.set(\f2, 0.2);
)

(
x.set(\f1, 24);
x.set(\f2, 0.02);
)

(
x.set(\f1, 24);
x.set(\f2, 0.12);
)

// drilling
(
x.set(\f1, 24);
x.set(\f2, 13);
)

// purring
(
x.set(\f1, 24);
x.set(\f2, 0.2);
)

// noisy purr
(
x.set(\f1, 100);
x.set(\f2, 24);
)

// noisy
(
x.set(\f1, 240);
x.set(\f2, 0.2);
)

(
x.set(\f1, 12);
x.set(\f2, 2);
)


