(
// Basic drum kit

SynthDef("hihat", {arg out = 0, amp = 0.5, att = 0.01, rel = 0.2, ffreq = 6000, pan = 0;
	var env, snd;
	env = Env.perc(att, rel, amp).kr(doneAction: 2);
	snd = WhiteNoise.ar;
	snd = HPF.ar(in: snd, freq: ffreq, mul: env);
	Out.ar(out, Pan2.ar(snd, pan));
}).add;

SynthDef("snare", {arg out = 0, amp = 0.1, sinfreq = 180, att = 0.01, rel = 0.2, ffreq = 2000, pan = 0;
	var env, snd1, snd2, sum;
	env = Env.perc(att, rel, amp).kr(doneAction: 2);
	snd1 = HPF.ar(
		in: WhiteNoise.ar,
		freq: ffreq,
		mul: env
	);
	snd2 = SinOsc.ar(freq: sinfreq, mul: env);
	sum = snd1 + snd2;
	Out.ar(out, Pan2.ar(sum, pan));
}).add;

SynthDef("kick", {arg out = 0, amp = 0.3, sinfreq = 60, glissf = 0.9, att = 0.01, rel = 0.45, pan = 0;
	var env, snd, ramp;
	env = Env.perc(att, rel, amp).kr(doneAction: 2);
	ramp = XLine.kr(
		start: sinfreq,
		end: sinfreq * glissf,
		dur: rel
	);
	snd = SinOsc.ar(freq: ramp, mul: env);
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;

// Basic saw synth for chords and bass
SynthDef("sawSynth", { arg freq = 440, amp = 0.1, att = 0.1, rel = 2, lofreq = 1000, hifreq = 3000;
    var env, snd;
    env = Env.perc(
		attackTime: att,
		releaseTime: rel,
		level: amp
	).kr(doneAction: 2);
    snd = Saw.ar(freq: freq * [0.99, 1, 1.001, 1.008], mul: env);
	snd = LPF.ar(
		in: snd,
		freq: LFNoise2.kr(1).range(lofreq, hifreq)
	);
    snd = Splay.ar(snd);
    Out.ar(0, snd);
}).add;
)



// Example
(
Pbind(
	\instrument, "hihat",
	\dur, Pseq([Rest(1/4), 1/4], inf),
	\att, 0.01,
	\rel, 0.1,
	\ffreq, 11000,
	\pan, 0,
	\amp, 0.3
).play;

Pbind(
	\instrument, "snare",
	\dur, Pseq([Rest(1/2), 1/2], inf),
	\att, 0.01,
	\rel, 0.1,
	\sinfreq, 180,
	\ffreq, 2000,
	\amp, 0.25

).play;

Pbind(
	\instrument, "kick",
	\dur, 1/2,
	\att, 0.01,
	\rel, 0.22,
	\sinfreq, 60,
	\glissf, 0.9,
	\amp, 1,
).play;
)

Pbind(
    \instrument, "sawSynth",
    \midinote, Pseq([
        [50, 53, 55, 57],
        [53, 56, 58, 60],
		Prand([
			[56, 59, 61, 63],
            [49, 52, 54, 56],
		], 1)
		],
        inf
    ),
    \dur, Prand([1, 3, 4, 4.5], inf),
	\att, 0.1,
	\rel, Pkey(\dur) + 1,
	\hifreq, 5000,
    \amp, 0.2
).stop;

Pbind(
	\instrument, "sawSynth",
	\midinote, Pseq([36, 32, 32, 37], inf),
	\dur, Pseq([1/4, 1/4, 1/2, Rest(3), 1/4], inf),
	\ctranspose, [0, -12],
	\att, 0.01,
	\rel, 0.2,
	\amp, 0.4,
	\lofreq, 100,
	\hifreq, 1000
).stop;
)