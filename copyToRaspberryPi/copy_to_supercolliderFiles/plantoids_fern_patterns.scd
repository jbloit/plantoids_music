(

SynthDef(\stepchord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, lpfac2=1, lpfac3=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = Duty.ar(1 / \lfofreq1.kr(1/4), 0, Dseq([
		1,2,4,3/2,
	],inf));
	lfo2 = Duty.ar(1 / \lfofreq2.kr(1/4), 0, Dseq([
		1/2,1,2,4,3/2,
	],inf));
	freq = freq * [2,1,lfo2, lfo1];
	sig1 = SinOsc.ar(freq);
	sig2 = LFSaw.ar(freq);
	sig2 = BPF.ar(sig2, freq * lpfac2 * SinOsc.kr(1/2).range(0.5,2), 0.5 * SinOsc.kr(1/13).range(1.4,1/4));
	sig3 = SinOsc.ar(freq * ( SinOsc.ar(freq) * 1 + 1 ));
	sig3 = BPF.ar(sig3, freq * lpfac3 * SinOsc.kr(1/3).range(0.5,2), 0.5 * SinOsc.kr(1/7).range(1.4,1/4));
	sig4 = SinOsc.ar(freq).fold2( EnvGen.kr(Env([0,0.1,1,0.01],[Rand(0.01,0.4), Rand(0.01,0.4), Rand(0.21,2)]), 1) )*0.7;

	sig = ( [sig1,sig2, sig3, sig4] * LFNoise1.kr([1/17,1/13,1/16, 1/20]).range(0.0,1) ).mean * 3;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,8.1,0.2,2.1,1,-1)), gate, doneAction:2);
	pan = pan + LFNoise1.ar(1/2!sig.size);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;


	~bus = ~bus ? ();
	~bus[\lfofreq1] = ~bus[\lfofreq1] ?? { Bus.control(s,1) };
	~bus[\lfofreq2] = ~bus[\lfofreq2] ?? { Bus.control(s,1) };
	~bus[\fernhi_hpfac] = ~bus[\fernhi_hpfac] ?? { Bus.control(s,1) };
	~bus[\fernhi_hprq] = ~bus[\fernhi_hprq] ?? { Bus.control(s,1) };
	~bus[\fernhi_rel] = ~bus[\fernhi_rel] ?? { Bus.control(s,1) };
	~bus[\fernbass_lpf] = ~bus[\fernbass_lpf] ?? { Bus.control(s,1) };
	~bus[\fxchorus] = ~bus[\fxchorus] ?? { Bus.audio(s,2) };

	~fernbass_lpftab = 0!6;
	~fernhi_durfac = 1;
	~stepchord_voices = 0!11;
	~stepchord_legato = 0.2!11;
	~ch = ();
	~ch[\min] = [0,3,7];
	~ch[\dim] = [0,3,6];
	~ch[\maj] = [0,4,7];

	~ch2 = ();
	~ch2[\min] = [0,2,4];
	~ch2[\dim] = [0,1,7];
	~ch2[\maj] = [0,-3,6];

	~notebank_old = [
		[
			-1,2,5,7,
			2,-1,2,5,
			1,3,7,0,
			3,1,3,7,
			4,7,9,12,
			9,7,9,12,
		],
	];

	~gen_notebanks = ();
	~gen_notebanks[1] = {
		var scaleroot = (0..6).choose;
		var root = scaleroot + { (0..5).choose }.dup(4);
		var root2 = scaleroot + { (0..5).choose }.dup(4);
		var acc = [11,10,9].choose + [-12,0,12].choose;
		var arp = { ( ~ch2.choose ++ [acc] ).dup(2).scramble }.dup(4);
		Pdefn(\notebank, 
			Pseq([
				Pser([
					Pseq( 
						root
					,1).stutter(8) + Pseq(arp,inf) + Pseq({ [-12,12,0,0,0,0,4].choose }.dup(8),inf),
					Pseq( 
						root
					,1).stutter(8) + Pseq(arp,inf) + Pseq({ [-12,12,0,0,0,0,4].choose }.dup(8),inf),
				],3),
				Pseq( 
					root2
				,1).stutter(8) + Pseq(arp,inf) + Pseq({ [-12,12,0,0,0,0,4].choose }.dup(8),inf),
			],inf),
		
		)
	};
	~gen_notebanks[2] = {
		var scaleroot = (0..6).choose;
		var root = scaleroot + { [0,2,4,5,7,9,11 ].choose }.dup(4).stutter((1..4).choose);
		var root2 = scaleroot + { [0,2,4,5,7,9,11 ].choose }.dup(4).stutter((1..4).choose);
		var acc = [11,10,9].choose + [-12,0,12].choose;
		var arp = { ( ~ch.choose ++ [acc] ).dup(2).scramble }.dup(4);
		Pdefn(\notebank, 
			Pstep(

			Pseq([
				Pser([
					Pseq( 
						root
					,1).stutter(8) + Pseq(arp,inf) + Pseq({ [-12,12,0,0,0,0,4].choose }.dup(8),inf),
					Pseq( 
						root
					,1).stutter(8) + Pseq(arp,inf) + Pseq({ [-12,12,0,0,0,0,4].choose }.dup(8),inf),
				],3),
				Pseq( 
					root2
				,1).stutter(8) + Pseq(arp,inf) + Pseq({ [-12,12,0,0,0,0,4].choose }.dup(8),inf),
			],inf),
				1/11*3
			)
		
		)
	};
	~gen_notebanks[3] = {
		var scaleroot = (0..6).choose;
		var root = scaleroot + { [0,2,4,5,7,9,11 ].choose }.dup(4);
		var root2 = scaleroot + { [0,2,4,5,7,9,11 ].choose }.dup(4);
		var acc = [11,10,9].choose + [-12,0,12].choose;
		var arp = { ( ~ch.choose ++ [acc] ).dup(2).scramble }.dup(4);
		Pdefn(\notebank, 
			Pseq([
				Pser([
					Pseq( 
						root
					,1).stutter(8) + Pseq(arp,inf) + Pseq({ [-12,12,0,0,0,0,4].choose }.dup(8),inf),
					Pseq( 
						root
					,1).stutter(8) + Pseq(arp,inf) + Pseq({ [-12,12,0,0,0,0,4].choose }.dup(8),inf),
				],3),
				Pseq( 
					root2
				,1).stutter(8) + Pseq(arp,inf) + Pseq({ [-12,12,0,0,0,0,4].choose }.dup(8),inf),
			],inf),
		
		)
	};
	~gen_notebank = {
		~gen_notebanks.choose.value;
	};
	~gen_notebank.();
	~pseqenv = { arg key, size=11;
			Prout({ arg ev;
				size.do { arg i;
					currentEnvironment[key][i].yield;
				}
			});
	};
	~fernhi_rest = 0!5;
	~fernhi_legato = 0.2;

Pdef(\chordpat, 
	Ppar([
		Pbind(
			\instrument, Prand([\wavechord, \stepchord],inf),
			\note, Pseq([
				Pdefn(\notebank),
			],inf),
			\octave, Prand([4,5,6,7],inf),
			\xisRest, Pseq([
				Prout({ arg ev;
					1.yield;
					10.do { arg i;
						0.yield
					}
				}),
			],inf).collect({ arg x; if(x==0) { Rest(0) } { 1 } }),
			\adsr, Prand([
				[ Env.adsr(0.1,0.1,0.8,1.01) ],
				[ Env.adsr(0.2,0.1,0.8,2.01) ],
				[ Env.adsr(0.1,0.1,0.8,1.01) ],
				[ Env.adsr(0.3,0.5,0.8,1.01) ],
				[ Env.adsr(0.1,0.1,0.3,2.01) ],
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
				[ Env.adsr(0.01,0.1,0.8,1.01) ],
				[ Env.adsr(0.01,0.1,0.8,0.21) ],
			],inf),
			\legato, 0.1,
			\dur, 1/11*3,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \stepchord,
			\note, Pseq([
				Pdefn(\notebank),
			],inf),
			//\octave, 4,
			\xisRest, Pseq([
				Prout({ arg ev;
					1.yield;
					7.do { arg i;
						~stepchord_voices[i+1].yield;
					}
				}),
			],inf).collect({ arg x; if(x==0) { Rest(0) } { 1 } }),
			\xisRest, Pseq([
				~pseqenv.(\stepchord_voices)
			],inf).collect({ arg x; if(x==0) { Rest(0) } { 1 } }),
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lfofreq1, ~bus[\lfofreq1].asMap,
			\lfofreq2, ~bus[\lfofreq2].asMap,
			\lpfac3, Pseq([1,2,1/2],inf),
			\legato, Pseq([0.4,0.3,0.2,0.1],inf),
			\legato, ~pseqenv.(\stepchord_legato).loop,
			\dur, 1/11*3,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				Pdefn(\notebank).collect({ arg x; x.mod(12) }),
			],inf),
			\octave, 3,
			\xisRest, Pseq([
				//Pseq([1,0,1,1,0,Prand([0,1],2),0,0],inf)
				Pfunc({
					if(~fernbass_next == 1) {
						~fernbass_next = 0;
						1
					} {
						0
					};
				}),
				//Prout({ arg ev;
					//1.yield;
					//2.do { arg i;
						//0.yield;
					//}
				//}),
			],inf).collect({ arg x; if(x==0) { Rest(0) } { 1 } }),
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpf, ~bus[\fernbass_lpf].asMap,
			\legato, Prand([1,0.4],inf),
			\dur, 1/11*3,
			\dur, Pfunc({
				~fernbass_durfac ? 1
			}),
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \fernhi,
			\note, Pseq([
				Pdefn(\notebank).collect({ arg x; x.mod(24) }) 
				+ 
				Pseq([
					Pseq([-12,0,0,0,12],9),
					Prand([-12,0,0,0,12],9),
					Prand([0,0,0,0,2],9),
					Prand([0,0,0,0,0],9),
					Prand([12,0,0,0,0],9),
				],inf),
			],inf),
			\octave, 5,
			\xisRest, Pseq([
				//Pseq([1,0,1,1,0,Prand([0,1],2),0,0,1,1,0,0,0].scramble,1),
				//Pindex(~fernhi_rest, Pseq((0..4).scramble))
				~pseqenv.(\fernhi_rest,2),
				~pseqenv.(\fernhi_rest,2),
				~pseqenv.(\fernhi_rest,5),
				//Prout({ arg ev;
					//1.yield;
					//2.do { arg i;
						//0.yield;
					//}
				//}),
			],inf).collect({ arg x; if(x==0) { Rest(0) } { 1 } }),
			\hpfac, ~bus[\fernhi_hpfac].asMap,
			\hprq, ~bus[\fernhi_hprq].asMap,
			\rel, ~bus[\fernhi_rel].asMap,
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\legato, ~fernhi_legato*4,
			\dur, 1/11*1,
			\dur, 1*Pfunc({ ~fernhi_durfac ? 1 }),
			\amp, 0.1/2,
			\out, ~bus[\fxchorus],
		),
		Pmono(\chorus,
			\inbus, ~bus[\fxchorus],
			\dur, 1,
			\modfreq, 0.2,
			\diff, 0.61,
			\delay, 0.6,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/11*2,
			\xisRest, Pseq([
				Pfuncn({
					if(~fernhat_next == 1) {
						~fernhat_next = 0;
						1
					} {
						0
					};
				},7),
				1,
			],inf).collect({ arg x; if(x==0) { Rest(0) } { 1 } }),
			\amp, 0.01 * Pseq([
				Pseq (
					 {
						[
						[ 1,0.1,0.4, ],
						[ 1,0.1,0.4, ],
						[ 1,0.4, ],
						].at((0..2).scramble)
					}.dup(2).flat
				,3)* Pfunc({ ~fernhat_ampfac ? 1 }),
				Pseq (
					 {
						[
						[ 0,0.0,0.4, ],
						[ 0,0.1,0.0, ],
						[ 0,0.4, ],
						].at((0..2).scramble)
					}.dup(2).flat
				,3) * Pfunc({ ~fernhat_ampfac ? 1 }),
				Pser([0],20.rand) + Pfunc({ ( ~fernhat_ampfac ? 1 )/2 }),
			],inf),
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/11*2,
			\xisRest, ( 
				Pseq([
					Pfuncn({
						if(~fernhat_next == 1) {
							~fernhat_next = 0;
							1
						} {
							0
						};
					},7),
					1,
				],inf) 
				* Pseq({[
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 0,0,0,0,
					1,0,1,0, 1,0,1,0, 
				].clump(8).choose}.dup(8).flat,inf) 
			).collect({ arg x; if(x<1) { Rest(0) } { 1 } }),
			\amp, 0.2,
		),
	]),
);
);

(
SynthDef(\fernbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = SinOsc.ar(freq);
	sig2 = LFSaw.ar(freq*1.5 * ( SinOsc.ar(freq) * 3 + 1 ));
	sig2 = RLPF.ar(sig2, freq*2);
	sig2 = sig2 * EnvGen.kr(Env([0,1,0],[0.2,0.8]), 1);
	sig = [sig1, sig2].sum;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.5)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\fernhi, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.001) + 1));
	sig2 = LFSaw.ar(freq*1.5 * ( SinOsc.ar(freq) * 0.3 + 1 ));
	sig2 = RHPF.ar(sig2, ( freq*\hpfac.kr(2) ).clip(20,19990), \hprq.kr(0.5));
	sig2 = sig2 * EnvGen.kr(Env([0,1,0],[0.2,0.1]), 1);
	sig = [sig1, sig2].sum;
	sig = LPF.ar(sig, ( freq * 4 ).clip(20,19996));
	sig = sig * EnvGen.kr(Env.adsr(0.01,0.1,0.8,\rel.kr(0.01)), gate, doneAction:2);
	pan = pan + LFNoise1.kr((1..8)/10);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

SynthDef(\phyhat3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([8210,1100,2051],[0.1,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([18210,200,7451],[0.1,0.8],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.1,0.9));
	sig = HPF.ar(sig, 20000-env2);
	sig1 = sig;
	//sig = RLPF.ar(sig, env2, \rq.kr(0.5));
	sig = WhiteNoise.ar;
	env3 = EnvGen.kr(Env([1,0.9,1]*Rand(0.91,1.1),[0.01+Rand(0,0.1),0.8]), 1);
	sig = sig + Ringz.ar(sig, [9400,17030,1410,8000.14,5000] * env3, 0.001).mean/10;
	env1 = EnvGen.kr(Env([8821,7810,251],[0.01,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([13820,15800,151],[0.01,0.8*\fac1.kr(1)],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = HPF.ar(sig, env1);
	sig = LPF.ar(sig, env2);
	sig2 = sig*1.3;

	sig = sig1+sig2;

	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.4,1,-4) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
SynthDef(\snapkickx, { |out = 0, pan = 0, amp = 0.3|
	var body, bodyFreq, bodyAmp;
	var pop, popFreq, popAmp;
	var click, clickAmp;
	var snd;

	// body starts midrange, quickly drops down to low freqs, and trails off
	bodyFreq = EnvGen.ar(\bodyfreqenv.kr(Env([261, 60, 51], [0.035, 0.08], curve: \exp)));
	bodyAmp = EnvGen.ar(\bodyenv.kr(Env.linen(0.005, 0.1, 0.3)), doneAction: 2);
	body = SinOsc.ar(bodyFreq) * bodyAmp;
	// pop sweeps over the midrange
	popFreq = XLine.kr(\popfstart.kr(750), \popfend.kr(261), \popfdur.kr(0.02));
	popAmp = EnvGen.ar(\popenv.kr(Env.linen(0.001, 0.02, 0.001))) * \popamp.kr(0.15);
	pop = SinOsc.ar(popFreq) * popAmp;
	// click is spectrally rich, covering the high-freq range
	// you can use Formant, FM, noise, whatever
	clickAmp = EnvGen.ar(Env.perc(\clickat.kr(0.001), \clickrel.kr(0.01))) * \clickamp.kr(0.15);
	click = LPF.ar(Formant.ar(\formfund.kr(910), \formfreq.kr(4760), \formbw.kr(2110)), \lpf.kr(3140)) * clickAmp;

	snd = body + pop + click;
	snd = snd * \distpreamp.kr(1);
	snd = snd.tanh;
	snd = snd * \distpostamp.kr(1);

	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;
SynthDef(\chorus, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.4);
	sig = sig + in;
	sig = DelayC.ar(sig, \maxdelay.ir(0.2), \delay.kr(0.0101) * ((0..7)/7 - 0.5 * \diff.kr(0.4001) + 1) * ( SinOsc.ar(\modfreq.kr(8.1)) * \modamp.kr(0.48) + 1 )).mean;
	//sig = LPF.ar(sig, \dif.kr(7500));
	LocalOut.ar(sig);

	sig = LPF.ar(sig, \lpf.kr(15000));
	sig = HPF.ar(sig, \hpf.kr(40));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0,1,0.1) ),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\basicbass, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var in;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1.2,1],[Rand(0.01,0.4),Rand(0.1,1.8)]), 1);
	sig = LFSaw.ar(freq * [1,1.0001,1.001]);
	sig = sig + LFPulse.ar(freq * [1,1.0001,1.001]);
	sig = sig / 2;
	sig = BPF.ar(sig, freq * env1, 0.1).tanh + sig;

	//sig = sig;
	sig = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.5));
	sig.debug("basicbas");
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.7)),gate,doneAction:doneAction);
	Out.ar(out, sig);
}).add;

(
SynthDef(\wavechord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	lfo1 = Duty.kr(1/8 * LFNoise1.kr(1/3).range(0.001,4), 0, Dseq([
		1,0,1.5,0.5,0,2,
	],inf)).lag(0.251);
	lfo2 = Duty.kr(1/8 * LFNoise1.kr(1/3).range(0.001,4), 0, Dseq([
		1,0,1.5,0.5,0,2,
	],inf)).lag(0.251);
	env1 = EnvGen.kr(Env([1,2,0.71],[Rand(0.1,0.7),Rand(0.4,1.7)]), 1);
	env2 = EnvGen.kr(Env([1,2,0.71],[Rand(0.1,0.7),Rand(0.4,1.7)]), 1);
	sig1 = SinOsc.ar(freq * [1/2,1,2]) * LFNoise1.kr(1/7!3).range(0,1);
	sig1 = sig1.mean;
	sig2 = LFSaw.ar(freq * [1/2,1,2]) * LFNoise1.kr(1/8!3).range(0,1);
	sig2 = sig2.mean;
	sig2 = RLPF.ar(sig2, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.5));
	sig3 = LFPulse.ar(freq * [1/2,1,2]) * LFNoise1.kr(1/9!3).range(0,1);
	sig3 = sig3.mean;
	sig3 = RLPF.ar(sig3, \lpfr.kr(1.1) * env2 * freq, \rq.kr(0.5));
	sig = SelectX.ar( lfo1, [sig1, sig2, sig3] ) * 1;
	sig = [sig, SelectX.ar( lfo2, [sig1, sig2, sig3] ) * 1];
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.7,0.1,0.8,1.4)), gate, doneAction:2);
	sig = sig * amp * 2;

	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
