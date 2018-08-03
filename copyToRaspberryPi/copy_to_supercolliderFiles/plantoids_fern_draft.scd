
///////////////////// DRAFT


(
Pdef(\part1, Pdef(\stepchord,
	Ppar([
		Pbind(
			\instrument, \stepchord,
			\legato, 0.91,
			/*
			\note, Pseq([
				[7,-1,2,5],
				[0,1,3,7],
				[4,7,9,12],
			],inf),
			*/
			\lfofreq1, Pseg(Pwhite(0.001,20),Pwhite(1.0,17)),
			\lfofreq2, Pseg(Pwhite(0.001,20),Pwhite(1.0,17)),
			//\lfofreq1, ~pmodenv.(Pseq([1/2,2,1/23,1,40],inf), 8),
			//\lfofreq2, ~pmodenv.(Pseq([1,1/100,20,1/4,4,1/122],inf), 5),
			\strum, Pwhite(0.001,0.1),
			\dur, 2,
			\amp, 0.1,
			\latency, 0,
		),
	])
)).play;
)

Pdef(\stepchord).quant = 1

Synth(\stepchord, [\freq, 1])

~t = 1; TempoClock.default.tempo = ~t;

(
Pdef(\chordpat, 
	Pbind(
		\instrument, \stepchord,
		\degree, Pseq([0,2,4,0],inf),
		\mtranspose, Pseq([0,-1,2,1],inf).stutter(8),
		\isRest, Pseq([
			Prout({ arg ev;
				1.yield;
				7.do { arg i;
					~stepchord_voices[i+1].yield;
				}
			}).trace,
		],inf).coin.not,
		//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\legato, 0.1,
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);

Pdef(\chordpat).clear;


////////////////


(
	Pdef(\insects, 
		Ppar(
			10.collect { arg idx;
				PmonoArtic(( \babass++rrand(0,32) ).asSymbol,
				\degree, Pstep(Pseq([
					9, 9, 8, 8,
				],inf),4)+Pseq([0,1,0,3],inf),
				\modamp, Pseq([
					Pseq([
						Pseq({[
							1,0,
							0,1,
							1,1,
							0,0,
						].clump(2).choose}.dup([2,4,8,16].choose).flat,[2,4,8,16].choose).dup([2,4,8,16].choose)
					].flat,1) * Pstep(Pseq([[1,0].choose],inf),[1,3].choose)
				],inf),
				\legato, Pseq([{ [rrand(0.1,0.8),1].choose }!( 2**rrand(0,3) )].flat,inf),
				\lpfratio, 3,
				\octave, [3,4,5,6].choose,
				\dur, [[1/4,1/16].choose,1/8,1/4,1/2,1,2].choose,
				\amp, 0.1 * [0.8,0.5,Pseq([0.8,0.5],inf)].choose * 0.5,
			)
	}
		),
).play;
)


	(
	Pdef(\far, 
		Plazy({
			Ppar([
				Plazy({
					Pfindur([64,32].choose, Ppar([
						rrand(1,8).collect({ arg idx;
							PmonoArtic(( \babass++rrand(0,32) ).asSymbol,
							\degree, Pstep(Pseq([
								9, 9, 8, 8,
							],inf),4)+Pseq([0,1,0,3],inf),
							\modamp, Pseq([
								Pseq([
									Pseq({[
										1,0,
										0,1,
										1,1,
										0,0,
									].clump(2).choose}.dup([2,4,8,16].choose).flat,[2,4,8,16].choose).dup([2,4,8,16].choose)
								].flat,1) * Pstep(Pseq([[1,0].choose],inf),[1,3].choose)
							],inf),
							\legato, Pseq([{ [rrand(0.1,0.8),1].choose }!( 2**rrand(0,3) )].flat,inf),
							\lpfratio, 1,
							\octave, [3,4,5,6].choose,
							\dur, [[1/4,1/16].choose,1/8,1/4,1/2,1,2].choose,
							\amp, 0.1 * [0.8,0.5,Pseq([0.8,0.5],inf)].choose * 0.5,
						)
					}),
				].flat))
			}).loop,
			Plazy({
				Pfindur([64,32,16,8].choose, Ppar([
					rrand(1,8).collect({ arg idx;
						PmonoArtic(( \babass++rrand(0,32) ).asSymbol,
						\degree, Pstep(Pseq([
							9, 9, 8, 8,
						],inf),4)+Pseq([0,1,0,3],inf),
						\modamp, Pseq([
							Pseq([
								Pseq({[
									1,0,
									0,1,
									1,1,
									0,0,
								].clump(2).choose}.dup([2,4,8,16].choose).flat,[2,4,8,16].choose).dup([2,4,8,16].choose)
							].flat,1) * Pstep(Pseq([1,0],inf),Pseq([1,3].scramble,inf) * [1,2,4,8,16].choose)
						],inf),
						\legato, Pseq([{ [rrand(0.1,0.8),1].choose }!( 2**rrand(0,3) )].flat,inf),
						\lpfratio, 1,
						\octave, [3,4,5,6].choose,
						\dur, [1/2,1/4,1/8,1/4,1/2,1,2].choose,
						\amp, 0.1 * [0.8,0.5,Pseq([0.8,0.5],inf)].choose * 0.5,
					)
				}),
			].flat));
		}).loop,
	],inf);
})).play;
	)



(
Ndef(\drone, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * LFNoise1.kr((1..8)/8,add:1));
	sig = sig + LFSaw.ar(freq * ( SinOsc.ar(100 * LFNoise1.kr(1.0.rand)) * 1 + 1 ));
	sig = sig.fold( SinOsc.ar(freq * ( LFNoise1.kr((1..8)/8) * 1 + 1 ))  );
	sig = sig * 2;
	sig = Pan2.ar(sig, pan, amp).mean;
	sig.debug("sig");
}).play;
);

(
Ndef(\drone, { arg freq=400, pan=0, amp=0.1, fac1=0.001;
	var sig;
	freq = [1/2,1,2]*freq * [0,4,7].midiratio;
	sig = SinOsc.ar(freq * LFNoise1.kr((1..8)/8,mul:fac1,add:1));
	sig = sig + LFSaw.ar(freq * ( SinOsc.ar(freq * LFNoise1.kr(1.0.rand)) * fac1 + 1 ));
	sig = sig.fold( SinOsc.ar(freq * ( LFNoise1.kr((1..8)/8) * fac1 + 1 ))  );
	sig = RLPF.ar(sig, \lpfr.kr(4.1) * freq, \rq.kr(0.5));
	sig = sig * 2;
	sig = Pan2.ar(sig, pan, amp).mean;
	sig.debug("sig");
}).play;
);

Ndef(\drone).edit
Ndef(\drone2).edit



(
Ndef(\drone2, { arg freq=400, pan=0, amp=0.1, fac1=0.001, fac2=200;
	var sig;
	sig = LFNoise1.ar(60*(1..8));
	sig = 0;
	sig = sig + LFSaw.ar(60*( (1..8)/fac2+1 ));
	sig = BPF.ar(sig, freq * \bpfac.kr(1) * LFNoise1.kr(1/2!8,mul:fac1,add:1));
	sig = Pan2.ar(sig, pan, amp).mean;
	sig.debug("sig");
}).play;
);
