(
SynthDef(\sawpulse, { |out, freq = 99, gate = 0.5, plfofreq = 6, mw = 0, ffreq = 2000, rq = 0.3, freqlag = 0.05, amp = 1, pan=0|
	var sig, plfo, fcurve;
	plfo = SinOsc.kr(plfofreq, mul:mw, add:1);
	freq = Lag.kr(freq, freqlag) * plfo;
	fcurve = EnvGen.kr(Env.adsr(0, 0.3, 0.1, 20), gate);
	fcurve = (fcurve - 1).madd(0.7, 1) * ffreq;
	sig = Mix.ar([Pulse.ar(freq, 0.9), Saw.ar(freq*1.007)]);
	sig = RLPF.ar(sig, fcurve, rq)
	* EnvGen.kr(Env.adsr(0.04, 0.2, 0.6, 0.1), gate, doneAction:2)
	* amp;
	Out.ar(out, sig ! 2)
}).add;
)

(
Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1, \degree, 0, )).play;
)

Scale.directory;
(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq((0..5), inf), \octave, 3, \mw, 0.0 )).play;
)


// mw == 0.05  is the max without losing pitch senstation
(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a,\degree, Pseq((0..5), inf), \octave, 3, \mw, 0.05 )).play;
)

(
a = Scale.majorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq((0..10), inf), \octave, 3, \mw, 0.0 )).play;
)

(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq((0..10), inf), \octave, 3, \mw, 0.0 )).play;
)

// more roundy sound
(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq((0..10), inf), \octave, 5, \mw, 0.0, \ffreq, 1000 )).play;
)

// min: ffreq = 200. below that, it sonds like a kick is playing at the same time
(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq((0..10), inf), \octave, 5, \mw, 0.0, \ffreq, 200 )).play;
)


// max (ffreq = 8000)
(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq((0..10), inf), \octave, 5, \mw, 0.00, \ffreq, 8000 )).play;
)


// rq = Acid param, apparent with low values

// min(rq) = 0.1 (artefacts start below)
(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq((0..10), inf), \octave, 5, \mw, 0.00, \ffreq, 2000, \rq, 0.1 )).play;
)

(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq((0..10), inf), \octave, 3, \mw, 0.00, \ffreq, 1000, \rq, 0.1 )).play;
)

// max(rq) = 1
(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq((0..10), inf), \octave, 3, \mw, 0.00, \ffreq, 2000, \rq, 1 )).play;
)


//freqlag: I can't reaaly figure this out
(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/4, \scale, a, \degree, Pseq((0..3), inf), \octave, 4, \mw, 0.1, \ffreq, 500, \rq, 1, \freqlag,  2.0, \plofreq, 10)).play;
)

// Chords and arps
(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq([0, 3, 7], inf), \octave, 3, \mw, 0.00, \ffreq, 2000, \rq, 1 )).play;
)
(
a = Scale.minorPentatonic;
	Pdef(\chords,
	Pbind(\instrument, \sawpulse, \dur, 1, \scale, a, \degree, Pseq([[0, 3, 7]], inf), \octave, 3, \mw, 0.00, \ffreq, 2000, \rq, 1 )).play;
)

(
a = Scale.minorPentatonic;
	Pdef(\chords,
	Pbind(\instrument, \sawpulse, \dur, 2, \scale, a, \degree, Pseq([[0, 3, 7]], inf), \octave, 3, \mw, 0.00, \ffreq, 2000, \rq, 1 )).play;
)

// tranpose chords with \root
(
a = Scale.minorPentatonic;
	Pdef(\chords,
	Pbind(\instrument, \sawpulse, \dur, 2, \scale, a, \degree, Pseq([[0, 3, 7]], inf), \root, 3, \octave, 3, \mw, 0.00, \ffreq, 2000, \rq, 1 )).play;
)

(
a = Scale.minorPentatonic;
	Pdef(\chords,
	Pbind(\instrument, \sawpulse, \dur, 2, \scale, a, \degree, Pseq([[0, 3, 7]], inf), \root, 0, \octave, 3, \mw, 0.00, \ffreq, 2000, \rq, 1 )).play;
)

// DRIVE
(
a = Scale.chromatic;
	Pdef(\chords,
	Pbind(\instrument, \sawpulse, \dur, 2, \scale, a, \degree, Pseq([[0, 4, 7]], inf), \root, 0, \octave, 4, \mw, 0.00, \ffreq, 2000, \rq, 0.3 )).play;

Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq([0, 3, 7], inf), \octave, 3, \mw, 0.00, \ffreq, 2000, \rq, 1 )).play;
)


(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq([0, 3, 7], inf), \octave, 3, \mw, 0.00, \ffreq, 2000, \rq, 1 )).play;

	Pdef(\chords,
	Pbind(\instrument, \sawpulse, \dur, 2, \scale, a, \degree, Pseq([[0, 3, 7]], inf), \root, 0, \octave, 4, \mw, 0.00, \ffreq, 2000, \rq, 0.3 )).play;
)


(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq([0, 3, 7], inf), \octave, 3, \mw, 0.00, \ffreq, 2000, \rq, 1 )).play;
	Pdef(\chords,
	Pbind(\instrument, \sawpulse, \dur, 2, \scale, a, \degree, Pseq([[0, 3, 7]], inf), \root, 0, \octave, 4, \mw, 0.00, \ffreq, 2000, \rq, 0.3 )).play;
)

(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq([0, 3, 6], inf), \octave, 3, \mw, 0.00, \ffreq, 2000, \rq, 1 )).play;

	Pdef(\chords,
	Pbind(\instrument, \sawpulse, \dur, 2, \scale, a, \degree, Pseq([[0, 3, 6]], inf), \root, 0, \octave, 4, \mw, 0.00, \ffreq, 2000, \rq, 0.3 )).play;
)

(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq([0, 3, 6], inf), \octave, 3, \mw, 0.00, \ffreq, 2000, \rq, 1 )).play;

	Pdef(\chords,
	Pbind(\instrument, \sawpulse, \dur, 2, \scale, a, \degree, Pseq([[0, 3, 6]+3], inf), \root, 0, \octave, 4, \mw, 0.00, \ffreq, 2000, \rq, 0.3 )).play;
)

(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq([0, 3, 6], inf), \octave, 3, \mw, 0.00, \ffreq, 2000, \rq, 1 )).play;

	Pdef(\chords,
	Pbind(\instrument, \sawpulse, \dur, 2, \scale, a, \degree, Pseq([[0, 3, 6] + 5], inf), \root, 0, \octave, 4, \mw, 0.00, \ffreq, 2000, \rq, 0.3 )).play;
)

(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq([0, 4, 5], inf), \octave, 3, \mw, 0.00, \ffreq, 2000, \rq, 1 )).play;

	Pdef(\chords,
	Pbind(\instrument, \sawpulse, \dur, 2, \scale, a, \degree, Pseq([[0, 3, 6] + 5], inf), \root, 0, \octave, 4, \mw, 0.00, \ffreq, 2000, \rq, 0.3 )).play;
)


(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq([0, 4, 5], inf), \octave, 3, \mw, 0.00, \ffreq, 2000, \rq, 1 )).play;

	Pdef(\chords,
	Pbind(\instrument, \sawpulse, \dur, 2, \scale, a, \degree, Pseq([[0, 3, 6] + 5], inf), \root, 0, \octave, 4, \mw, 0.00, \ffreq, 2000, \rq, 0.3 )).play;
)

(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq((0..2)*4, inf), \octave, 3, \mw, 0.00, \ffreq, 2000, \rq, 1 )).play;

	Pdef(\chords,
	Pbind(\instrument, \sawpulse, \dur, 2, \scale, a, \degree, Pseq([[0, 3, 6] + 5], inf), \root, 0, \octave, 4, \mw, 0.00, \ffreq, 2000, \rq, 0.3 )).play;
)

(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq([0, 4, 5], inf), \octave, 3, \mw, 0.00, \ffreq, 2000, \rq, 1 )).play;

	Pdef(\chords,
	Pbind(\instrument, \sawpulse, \dur, 2, \scale, a, \degree, Pseq([[0, 3, 6] + 5], inf), \root, 0, \octave, 4, \mw, 0.00, \ffreq, 2000, \rq, 0.3 )).play;
)


// modulate
(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq([0, 4, 5], inf), \root, 1, \octave, 3, \mw, 0.00, \ffreq, 2000, \rq, 1 )).play;

	Pdef(\chords,
	Pbind(\instrument, \sawpulse, \dur, 2, \scale, a, \degree, Pseq([[0, 3, 6] + 5], inf), \root, 1, \octave, 4, \mw, 0.00, \ffreq, 2000, \rq, 0.3 )).play;
)

// and back
(
a = Scale.minorPentatonic;
	Pdef(\pulses,
	Pbind(\instrument, \sawpulse, \dur, 1/8, \scale, a, \degree, Pseq([0, 3, 5], inf), \root, 0, \octave, 3, \mw, 0.00, \ffreq, 2000, \rq, 1 )).play;

	Pdef(\chords,
	Pbind(\instrument, \sawpulse, \dur, 2, \scale, a, \degree, Pseq([[0, 3, 6] + 5], inf), \root, 0, \octave, 4, \mw, 0.00, \ffreq, 2000, \rq, 0.3 )).play;
)


// add a lead
(
a = Scale.minorPentatonic;

Pdef(\lead,
	Pbind(\instrument, \sawpulse, \dur, Prand([ 1/8, 1], inf), \scale, a, \degree, Pstutter( rrand(1,3), Prand((0..8), inf)), \isRest,Prand([1,0], inf).coin.not, \root, 0, \octave, 5, \mw, 0.01, \ffreq, 2000, \rq, 0.1
	)).play;
)

//
(
a = Scale.minorPentatonic;

Pdef(\lead1,
	Pbind(\instrument, \sawpulse, \dur, Prand([ 1/8, 1/2], inf), \scale, a, \degree, Pstutter( rrand(1,3), Prand((0..8), inf)), \isRest,Prand([1,0], inf).coin.not, \root, 0, \octave, 5, \mw, 0.01, \ffreq, 1000, \rq, 0.1
	)).play;

Pdef(\lead2,
	Pbind(\instrument, \sawpulse, \dur, Prand([ 1/8, 1/2], inf), \scale, a, \degree, Pstutter( rrand(1,3), Prand((0..8), inf)), \isRest,Prand([1,0], inf).coin.not, \root, 0, \octave, 5, \mw, 0.01, \ffreq, 2000, \rq, 0.8
	)).play;
)

(
a = Scale.minorPentatonic;

Pdef(\lead3,
	Pbind(\instrument, \sawpulse, \dur, Prand([ 1/8, 1], inf), \scale, a, \degree, Pstutter( rrand(1,3), Prand((0..8), inf)), \isRest,Prand([1,0], inf).coin.not, \root, 0, \octave, 4, \mw, 0.01, \ffreq, 3000, \rq, 0.1
	)).play;
Pdef(\lead4,
	Pbind(\instrument, \sawpulse, \dur, Prand([ 1/8, 1/2], inf), \scale, a, \degree, Pstutter( rrand(1,3), Prand((0..8), inf)), \isRest,Prand([1,0], inf).coin.not, \root, 0, \octave, 4, \mw, 0.01, \ffreq, 4000, \rq, 0.1
	)).play;

Pdef(\lead5,
	Pbind(\instrument, \sawpulse, \dur, Prand([ 1/8, 1/2], inf), \scale, a, \degree, Pstutter( rrand(1,3), Prand((0..8), inf)), \isRest,Prand([1,0], inf).coin.not, \root, 0, \octave, 4, \mw, 0.01, \ffreq, 5000, \rq, 0.8
	)).play;
)


Scale.directory;

Pdef(\pulses).stop;
Pdef(\chords).stop