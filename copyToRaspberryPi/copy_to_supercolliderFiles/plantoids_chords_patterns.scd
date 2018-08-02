(
SynthDef(\stepchord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
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
	sig2 = BPF.ar(sig2, freq * SinOsc.kr(1/2).range(0.5,2), 0.5 * SinOsc.kr(1/13).range(1.4,1/4));
	sig3 = SinOsc.ar(freq * ( SinOsc.ar(freq) * 1 + 1 ));
	sig3 = BPF.ar(sig3, freq * SinOsc.kr(1/3).range(0.5,2), 0.5 * SinOsc.kr(1/7).range(1.4,1/4));
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
	~stepchord_voices = 0!11;
Pdef(\chordpat, 
	Pbind(
		\instrument, \stepchord,
		\note, Pseq([
			-1,2,5,7,
			2,-1,2,5,
			1,3,7,0,
			3,1,3,7,
			4,7,9,12,
			9,7,9,12,
		],inf),
		\xisRest, Pseq([
			Prout({ arg ev;
				1.yield;
				7.do { arg i;
					~stepchord_voices[i+1].yield;
				}
			}),
		],inf).collect({ arg x; if(x==0) { Rest(0) } { 1 } }),
		//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\lfofreq1, ~bus[\lfofreq1].asMap,
		\lfofreq2, ~bus[\lfofreq2].asMap,
		\legato, Pseq([0.4,0.3,0.2,0.1],inf),
		\dur, 1/4,
		\amp, 0.1,
	)
);
);

