// Put sythdefs here

// =========================================================
//                                                                          TANGUY SPECIFIC
// =========================================================



SynthDef(\ambiant, {
	|fi,fo,sus,freq,pan,amp|
	var sig,env;
	env = Env([0,1,1,0],[fi,sus,fo],[\sin,0,\lin]).kr(2);
	sig = PinkNoise.ar(0.2!2);
	2.do{sig = BPF.ar(sig, freq.midicps, 0.02, 2)};
	sig = Balance2.ar(sig[0],sig[1],LFNoise1.kr(pan));
	Out.ar(0, sig*env*amp);
}).add;


SynthDef.new(\multi, {
	|freq,detune,fi,sus,fo,cfmin,cfmax,rqmin,rqmax,out,amp,cfhzmin,cfhzmax,mix,room,pan|
	var sig,env;
	env = EnvGen.kr(Env([0,1,1,0],[fi,sus,fo],[\sin,0,\lin]),doneAction:2);
	sig = Saw.ar(freq * {LFNoise1.kr(0.5,detune).midiratio}!2);
	sig = BPF.ar(sig,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(cfhzmin, cfhzmax)).exprange(cfmin, cfmax)}!2,
		{LFNoise1.kr(0.5).exprange(rqmin,rqmax)}!2);
	sig = PanAz.ar(2,sig,SinOsc.kr(pan),amp);
	Out.ar(out,sig * env);
}).add;















// =========================================================
//                                                                            MELODIC
// =========================================================






SynthDef(\plant1,{arg freq=432,amp=1,gate=1;
    var env= EnvGen.ar(Env.perc,gate,doneAction:2);
	var sig = SinOsc.ar(freq/440*432)*env*amp.linlin(0,1,0,0.25 );
	sig = Limiter.ar(LeakDC.ar(sig),0.9);
	Out.ar([0,1],sig*0.1);
}).add;



SynthDef(\lead1,{arg freq=432,amp=1,gate=1;
    var env= EnvGen.ar(Env.perc,gate,doneAction:2);
	var sig = SinOsc.ar(freq/440*432)*env*amp.linlin(0,1,0,0.25 );
	sig = Limiter.ar(LeakDC.ar(sig),0.9);
	Out.ar([0,1],sig*0.3);
}).add;


SynthDef(\lead2,{arg freq=432,amp=1,gate=1;
    var env= EnvGen.ar(Env.perc,gate,doneAction:2);
	var sig = LFSaw.ar(freq/440*432)*env*amp.linlin(0,1,0,0.25 );
	sig = BRF.ar(sig,freq+1000,0.1);
	sig = Limiter.ar(LeakDC.ar(sig),0.9);
	Out.ar([0,1],sig*0.3);
}).add;


SynthDef(\lead3,
{arg gate=1,freq=36,amp=1,out=0;
	var strike, env, noise, pitch, delayTime, detune,sig;
		var env2 = EnvGen.ar(Env.adsr(0.1,0.4,0.5,0.5),gate,doneAction:2);
		strike = SinOsc.ar(0.1);
	env = Decay2.ar(strike, 0.008, 0.04);
sig=Mix.ar(Array.fill(3, { arg i;
			detune = #[-0.05, 0, 0.04].at(i);
			delayTime = 1 / ((freq*432/440) + detune);
					noise = LFNoise2.ar(3000, env);
				CombL.ar(noise,
					delayTime,
					delayTime,
				1)
			}),
			(freq - 36)/27 - 1
		);
		Out.ar([0,1],sig*env2*0.0015*amp);
}).add;


SynthDef(\lead4,
{arg gate=1,freq=36,amp=1,out=0;
	var strike, env, noise, pitch, delayTime, detune,sig;
		var env2 = EnvGen.ar(Env.adsr(0.1,1,0.5,1),gate,doneAction:2);
		strike = SinOsc.ar(0.1);
	env = Decay2.ar(strike, 0.008, 0.04);
sig=
			Mix.ar(Array.fill(3, { arg i;
				detune = #[-0.05, 0, 0.04].at(i);
			delayTime = 1 / ((freq*432/440) + detune);
				noise = LFSaw.ar(freq*432/440, env);
				CombL.ar(noise,
					delayTime,
				1)
			}),
			(freq - 36)/27 - 1
		);
		Out.ar([0,1],sig*env2*0.02*amp);
}).add;


SynthDef(\avbass, {|out= 0, amp= 0.1, freq= 100, pan= 0, atk= 0.01, rel= 0.2, cur= -4, mod= 0, gate= 1|
    var env= EnvGen.ar(Env.adsr(atk, atk, 0.75, rel, 1, cur), gate, doneAction:2);
    var src= BLowPass4.ar(Saw.ar(freq, amp), freq+(mod+1*100).min(900), 1-env+0.1);
    OffsetOut.ar(out, Pan2.ar(src*env, pan));
}).add;

// Synth(\avbass);

// (instrument: \avbass, degree:0, mod:10, dur:0.1, latency:Ref(0)).play;

SynthDef(\avlead, {|out= 0, amp= 0.1, freq= 400, pan= 0, atk= 0.01, rel= 0.1, cur= -4, gate= 1|
    var env= EnvGen.ar(Env.asr(atk, 1, rel, cur), gate, doneAction:2);
    var src= Pulse.ar(freq, 1-env.lag(1)*0.5, amp);
    OffsetOut.ar(out, Pan2.ar(src*env, pan));
}).add;

SynthDef(\avswop, {|out= 0, amp= 0.1, start= 5000, end= 500, mod= 0, pan= 0, atk= 0.01, rel= 4, cur= -4, gate= 1|
    var env= EnvGen.ar(Env.asr(atk, 1, rel, cur), gate, doneAction:2);
    var src= BPF.ar(WhiteNoise.ar(amp+SinOsc.ar(mod, 0.5pi, amp*0.25)), XLine.kr(start, end, 20), 2-env);
    OffsetOut.ar(out, Pan2.ar(src*env, pan+SinOsc.kr(0.1, 0, 0.3)));
}).add;

SynthDef(\sawpulsimp, { |out, freq = 99, gate = 0.5,  amp = 1, pan=0, timbre=0|
	var sig, plfo, fcurve ;
	var plfofreq = 6, mw = 0, ffreq = 2000, rq = 0.3, freqlag = 0.05;
	ffreq = timbre.linexp(0, 1, 200, 8000);
	rq = timbre.linexp(0,1, 0.1, 1);
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

SynthDef(\moogbass, {
	arg out = 0, pan = 0, freq = 440, amp = 0.8, gate = 1, cutoff = 1000, gain = 2.0, lagamount = 0.01, att = 0.001, dec = 0.3, sus = 0.9, rel = 0.2, chorus = 0.7;

	var osc, filter, env, filterenv, snd, chorusfx;

	osc = Mix(VarSaw.ar(
		freq: freq.lag(lagamount) * [1.0, 1.001, 2.0],
		iphase: Rand(0.0,1.0) ! 3,
		width: Rand(0.5,0.75) ! 3,
		mul: 0.5));

	filterenv = EnvGen.ar(
		envelope: Env.asr(0.2, 1, 0.2),
		gate: gate);

	filter =  MoogFF.ar(
		in: osc,
		freq: cutoff * (1.0 + (0.5 * filterenv)),
		gain: gain);

	env = EnvGen.ar(
		envelope: Env.adsr(0.001, 0.3, 0.9, 0.2, amp),
		gate: gate,
		doneAction: 2);

	snd = (0.7 * filter + (0.3 * filter.distort)) * env;

	chorusfx = Mix.fill(7, {

		var maxdelaytime = rrand(0.005, 0.02);
		DelayC.ar(
			in: snd,
			maxdelaytime: maxdelaytime,
			delaytime: LFNoise1.kr(
				freq: Rand(4.5, 10.5),
				mul: 0.25 * maxdelaytime,
				add: 0.75 * maxdelaytime)
		)
	});

	snd = snd + (chorusfx * chorus);

	Out.ar(out, Pan2.ar(snd, pan));

}).add;





// =========================================================
//                                                                            SAMPLER
// =========================================================

Buffer.freeAll;
~samplesDir = thisProcess.nowExecutingPath.dirname +/+ "../soundfiles";

SynthDef(\sampler, {
	|out=0, bufNum=0, amp=0.3, rate=1|
	var sig;
	sig = PlayBuf.ar(1, bufNum, rate * BufRateScale.kr(bufNum), doneAction:2);
	Out.ar(out, Pan2.ar(sig*amp, 0));
}).add;


~kickBuffers= Array.new;
~kickFolder = PathName.new(~samplesDir +/+ "kick" );
~kickFolder.entries.do({
	arg path;
	path.postln;
	~kickBuffers = ~kickBuffers.add(Buffer.read(s, path.fullPath));
});

// =========================================================
//                                                                            PERC
// =========================================================

SynthDef(\kick, {
	arg out=0,tu = 1,amp=1,pitch=1;
	var env0, env1, env1m, sig;
	env0 =  EnvGen.ar(Env.new([0.5, 1, 0.3, 0], [0.01, 0.5, 0.26], [-4, -2, -4]), doneAction:2);
	env1 = EnvGen.ar(Env.new([120, 43, 29], [0.03, 0.29], [-4, -5]));
	env1m = env1.midicps;
	sig = LFPulse.ar(env1m*tu, 0, 0.5, 1, -0.5);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, env1m*1.5, env0);
	sig = sig + SinOsc.ar(env1m*tu, 0.5, env0);
	sig = sig * amp*0.3;
	sig = sig.clip2(1);
	Out.ar([0,1], sig);
}).add;

// Synth(\kick);

SynthDef("kickhi", {
	arg out=0,timbre = 1;
	var env0, env1, env1m, sig;
	// timbre  = 1 - timbre;
	env0 =  EnvGen.ar(Env.new([0.5, 0.1, 0.01, 0.01,0], [0.01, 0.5, 1.26,0.1], [-4, -2, -4]), doneAction:2);
	env1 = EnvGen.ar(Env.new([122, 30, 33,28], [0.05, 0.29,1], [-4, -5]));
	env1m = env1.midicps;
	sig = LFPulse.ar(env1m*timbre, 0, 0.5, 1, -0.5);
	sig = out + WhiteNoise.ar(1);
	sig = LPF.ar(sig, env1m*1.5, env0);
	sig = sig + SinOsc.ar(env1m*timbre, 0.5, env0*4);
	sig = sig * 1.2;
	sig = sig.clip2(1);
	Out.ar(out, sig!2);
}).send(s);

// Synth(\kickhi, [\timbre, 0.3])

SynthDef(\kick2,{arg out=0,gate = 1 ,freq=60,tu = 1,amp=1,atf = 80, rel =1;
	var env = EnvGen.ar(Env.perc(0,rel),gate,doneAction:2);
	var frequ = EnvGen.ar(Env([freq-30,freq,60],[0.001,0.01]));
	var sig = SinOsc.ar(frequ*tu,0,env);
	sig = LPF.ar(sig,100);
	Out.ar(out,sig * amp);
}).add;



SynthDef(\kick3,{arg out=0,amp=1,gate = 1, tu = 1, rel =3,freq=60;
	var env = EnvGen.ar(Env.perc(0,rel),gate,doneAction:2);
	var frequ = EnvGen.ar(Env([130,freq,30],[0.05,rel]));
	var sig = SinOsc.ar(freq*tu,0,env);
	Out.ar(out,sig * amp);
}).add;



SynthDef(\kicknoise,{arg out=0, amp=0.5;
	var env = EnvGen.ar(Env([0,1,0],[0.01,1]),doneAction:2);
	var freq =EnvGen.ar(Env([20000,100,30],[0.005,1]));
	var sig =  SinOsc.ar(freq,0,env)+(WhiteNoise.ar(1)*env);
	Out.ar(out,sig*amp);
}).add;



SynthDef(\t1kick,{arg out=0,rel = 0.6,pitch=1 ,amp =1 ,snd;
	var enva = EnvGen.ar(Env([0.01,1,0],[0.001,rel]),doneAction:2);
	var envf = EnvGen.ar(Env([800,50],[0.005,1]));
	var sig = SinOsc.ar(envf,0,enva);
	//sig = HPF.ar(sig*enva,30);
	Out.ar(out,sig*amp);
}).add;


SynthDef(\t1kick2,{arg out = 0,snd=18,rel = 0.6,pitch=0.1 ,amp =1;
	var enva = EnvGen.ar(Env([1,1,0],[rel,0.2]),doneAction:2);
	var envf = EnvGen.ar(Env([10000,20,00,4],[0.002,0.1,1,1]));
	var sig = SinOsc.ar(envf+50*pitch,0,enva);
	//sig = PitchShift.ar(sig,0.001,pitch,0.1);
	sig = sig.distort;
	sig = HPF.ar(FreeVerb.ar(sig,1,1),100)+sig;
	Out.ar(out,sig*amp*enva);
	//Out.ar(snd,sig*amp*enva);
}).add;


// STEREO KICKS

SynthDef(\kickmed, { | out = 0,snd=18,amp=1, pan=0, atk= 0.01,decay = 0.2,release=0.26, fratio=1.5,noise=1,done=2,freq1= 120,freq2=30,freq3=30,dc=1,aamp1=1,aamp2=1,aamp3=1,aamp4=1,curve1= (-4),curve2=(-2),curve3=(-4),famp1,famp2,famp3,famp4,p1,oamp=0.1,owhich2=0,ochoose=0|
	var env0,env1,
env1m, son, son2,son3,son4,p2;
	p2 = p1 * (-pi);
env0 = Env([aamp1,aamp2,aamp3,aamp4,0],[atk,decay,release,0.5],[curve1, curve2, curve3]);
env1 = Env([freq1,freq2,freq3],[famp1,famp2,famp3,famp4],[curve1, curve2, curve3]);
env0 = EnvGen.ar(env0, doneAction:2);
env1 = EnvGen.ar(env1);
env1m = env1.midicps;
	son = LFSaw.ar(env1m,0,oamp, 1,1.4);
	son2 = SinOsc.ar(env1m, 0, oamp, 1,1.4);
	son3 = LFPulse.ar(env1m,0, oamp, 1,1.4);
	son4 = LFTri.ar(env1m,0, oamp, 1,1.4);
son = SelectX.ar(ochoose,[son,son2,son3,son4]);
son = LeakDC.ar(son,dc,30);
son = son + WhiteNoise.ar(noise);
son = LPF.ar(son, env1m*fratio, env0);
	son = son + SelectX.ar(owhich2,[ SinOsc.ar(env1m, p1, env0), LFSaw.ar(env1m, p1, env0), LFPulse.ar(env1m, p1, env0), LFTri.ar(env1m, p1, env0)]);
son = son * 1;
son = son*amp.distort;
OffsetOut.ar(out, son*amp!2).tanh;
//OffsetOut.ar(snd, Mono(son)*amp).tanh;
}).add;

// Synth(\kickmed, [\amp, 0.3, \decay, 0.01, \release, 0.01, \atk, 0.1, \freq1,90, \freq2, 110, \fratio, 10]);

SynthDef(\kick808,{arg rel=1,tu=1,amp=0.5;
	var env = EnvGen.ar(Env([0,1,0],[0,rel],-8),doneAction:2);
	var enf  = EnvGen.ar(Env([1000,20,20],[0.001,0.001,0.001],-4));
	var sig = SinOsc.ar(tu*(enf+40))*env;
	sig = sig + LPF.ar(SinOsc.ar(SinOsc.ar(100,0,50,100*tu),0,0.2)*env,1000);
	Out.ar([0,1],sig*env*amp);
}).add;
// Synth(\kick808)


SynthDef(\hat,{arg gate = 1, amp=1, out=0,rel=0.1;
	var env = EnvGen.ar(Env.perc(0,rel),gate,doneAction:2);
	var freq = EnvGen.ar(Env([12000,80,20000],[0.1,0.1]));
	var sig = PinkNoise.ar(env);
	sig = HPF.ar(sig,freq);
	sig = sig.tanh;
	Out.ar([0,1],sig*amp*12);
}).add;

// Synth(\hat, [\rel,0.1])


SynthDef(\hat909, {|out=0, freq=230, release=0.15, amp=0.4, fxb=0, fxv=0, bbcb=0, bbcv=0, timbre=0.3|
  var pulse, sig, env, freqs, hpf;
	hpf = timbre.linexp(0, 1, 1000, 6400);
  freqs = [freq, freq*1.4471, freq*1.617, freq*1.9265, freq*2.5028, freq*2.6637];
  pulse = Mix.ar(Pulse.ar(freqs, {0.9.rand}!6, mul: 1));
  sig = RHPF.ar(RHPF.ar(pulse, hpf), hpf);
  env = EnvGen.kr(Env.perc(0,release),doneAction:2);
  sig = sig*env;
  Out.ar(out, Pan2.ar(sig*amp,0));
}).add;


// Synth(\hat909, [\timbre, 0.8]);


SynthDef(\hat808, { arg out=0,tu=1, amp=0.1, gate=1, pan=0;
	var sig;
	var env = EnvGen.ar(Env.perc(0.01,0.1),doneAction:2);
	sig = Saw.ar((1..9)*1000.23*env*tu);
	sig = RHPF.ar(sig, \hpf.kr(5700), \rq.kr(0.5));
	sig = sig * (1+EnvGen.ar(Env.perc((-0.1),\rel.kr(0.1),-4),gate))*tu;
	sig = Ringz.ar(sig,(10..15)*1000.234,1).mean;
	sig = RHPF.ar(sig, \lpf.kr(2000)*env*tu, \rq.kr(0.5));
	Out.ar([0,1], sig*amp);
}).add;




//stereo

SynthDef(\noise2,{arg out = 0,rel  = 0.01,a=4;
var env0 =  EnvGen.ar(Env.new([0.1, 1, 0.3, 0], [0.01, rel], [-4, -2, -4]), doneAction:2);
var sig = CuspN.ar(
		SampleRate.ir/a,
		LFNoise2.kr([4,4],1.5,1.5),
		LFNoise2.kr([2,2],1.5,1.5),
		LFNoise2.kr([2,2],0.5,1.5),
		LFNoise2.kr([2,2],0.5,1.5);
	);
	sig = HPF.ar(sig,1000);
	sig = Limiter.ar(sig,0.4);
	sig =	[sig ,DelayL.ar(sig,0.1,100/44100)];
	//sig = PitchShift.ar(sig,0.2,1*a);
	sig = Compander.ar(sig,In.ar(0,1),0.01,1,0.01,0.01,0.1);
	sig=  sig.tanh;
	Out.ar(out,sig*env0);
}).add;

// Synth(\noise2,[\rel, 0.5]);


SynthDef(\noise,{arg out =0,rel  = 0.25,a=4;
var env0 =  EnvGen.ar(Env.new([0.1, 1, 0.3, 0], [0.01, rel], [-4, -2, -4]), doneAction:2);
var sig = LatoocarfianL.ar(
		SampleRate.ir/a,
		LFNoise2.kr([2,2],1.5,1.5),
		LFNoise2.kr([2,2],1.5,1.5),
		LFNoise2.kr([2,2],0.5,1.5),
		LFNoise2.kr([2,2],0.5,1.5);
	);
	sig = HPF.ar(sig,1000);
	sig = Limiter.ar(sig,0.4);
	sig =	[sig ,DelayL.ar(sig,0.1,100/44100)];
	//sig = PitchShift.ar(sig,0.2,1*a);
	sig = Compander.ar(sig,In.ar(0,1),0.01,1,0.01,0.01,0.1);
	sig=  sig.tanh;
	Out.ar(out,sig*env0);
}).add;

// Synth(\noise);


SynthDef(\snare, { arg out=0,tu=1, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env = EnvGen.ar(Env.perc(0.01,0.1));
	var enf = EnvGen.ar(Env([600,1057,230],[0.01,0.01],-4));
	sig = SinOsc.ar(tu*enf+127,0,0.5)*env;
	sig = WhiteNoise.ar+sig;
	sig = RHPF.ar(sig, \hpf.kr(170)*tu, \rq.kr(0.5));
	sig = sig + Mix.ar(BPF.ar(sig,[327,430],[0.5,0.5])*0.1);
	sig = RLPF.ar(sig, \lpf.kr(15100)*tu, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.perc(0.01,\rel.kr(0.1),-4),gate,doneAction:2);
	Out.ar([0,1], sig*amp);
}).add;
// Synth(\snare)


SynthDef(\snare2,{arg gate = 1, amp=1, out=0;
	var env = EnvGen.ar(Env.perc(0.001,0.2),gate,doneAction:2);
	var freq = EnvGen.ar(Env([12000,100,12000],[0.01,0.01]));
	var sig = WhiteNoise.ar(env);
	sig = LPF.ar(sig,freq);
	sig = sig.tanh;
	Out.ar(out,sig );
}).add;

// Synth(\snare2)


SynthDef(\junglesnare, { arg out=0,tu=1, amp=0.1, gate=1, pan=0, freq=200,kracter = 10;
	var sig;
	var env = EnvGen.ar(Env([1,0,1,0],[0,0.004,0.05]),gate,doneAction:2);
	var enf = EnvGen.ar(Env([1600,5600,800,250],[0.001,0.001,0.001],-4));
	var enf2 = EnvGen.ar(Env([1000,1600,700,200],[0.001,0.001,0.06,0.01],-4));
	sig = SinOsc.ar(tu*enf+107,0,0.5)*env;
	sig =  WhiteNoise.ar(env)+sig;
	sig = RHPF.ar(sig, \hpf.kr(100)*tu, \rq2.kr(1))+sig;
	sig = sig + Mix.ar(BPF.ar(sig,[327,430],[0.5,0.5])*0.1)+WhiteNoise.ar(env)+BrownNoise.ar(env/8);
	sig = RLPF.ar(sig, \lpf.kr(11100)*tu, \rq.kr(0.5))+sig;
	sig =( Ringz.ar(WhiteNoise.ar,Mix.ar([enf2,enf*0.9,enf2*0.8]),1,0.01*env) +RLPF.ar(BrownNoise.ar(env),enf*4,1,1)+sig )*env ;
	sig = HPF.ar(sig,350);
	sig = CompanderD.ar(sig*kracter,0.8,0.3,0.5,0.001,0.2,env);
	Out.ar(out, sig*amp);
}).add;

// Synth(\junglesnare, [\pan, 0]);


SynthDef(\t5snare, { arg out=0,tu=1, amp=0.3, gate=1, pan=0, freq=200,snd;
	var sig;
	var env = EnvGen.ar(Env.perc(0.01,1));
	var enf = EnvGen.ar(Env([600,177,230],[0.01,0.1],-4));
	//sig = SinOsc.ar(tu*enf+1207,0,0.5)*env;
	sig = WhiteNoise.ar;
	sig = FreeVerb.ar(sig,0.5,1);
	sig = RHPF.ar(sig, \hpf.kr(180)*tu, \rq.kr(0.5));
	sig = sig + Mix.ar(BPF.ar(sig,[127,430],[0.5,0.5])*0.1);
	sig = RLPF.ar(sig, \lpf.kr(12100)*tu, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.perc(0,\rel.kr(1),-4),gate,doneAction:2);
	sig = sig*amp;
	sig = CompanderD.ar(sig,1,1,0.1,0.01,0.4);
	sig = FreeVerb.ar(sig,1,1)+sig;
	Out.ar(out, sig*amp);
	//Out.ar(snd, sig);
}).add;

// Synth(\t5snare)

SynthDef(\snare808, { arg out=0,timbre=1, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env = EnvGen.ar(Env.perc(0.01,1));
	var enf = EnvGen.ar(Env([600,177,230],[0.01,0.01],-4));
	sig = SinOsc.ar(timbre*enf+127,0,0.5)*env;
	sig = WhiteNoise.ar+sig;
	sig = RHPF.ar(sig, \hpf.kr(170)*timbre, \rq.kr(0.5));
	sig = sig + Mix.ar(BPF.ar(sig,[127,430],[0.5,0.5])*0.1);
	sig = RLPF.ar(sig, \lpf.kr(11100)*timbre, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.perc(0.01,\rel.kr(0.1),-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

// Synth(\snare808, [ \timbre, 0.8])

//  snare

SynthDef(\snaremed, { | out = 0,level=1, pan=0, atk= 0.01,decay = 0.2,release=0.26, fratio=1.5,noise=1,done=2,freq1= 120,freq2=30,freq3=30,dc=1,aamp1=1,aamp2=1,aamp3=1,aamp4=1,curve1= (-4),curve2=(-2),curve3=(-4),famp1,famp2,famp3,famp4,p1,oamp=0.1,owhich2=0,ochoose=0,snd =20|
	var env0,env1,
env1m, son, son2,son3,son4,p2;
	p2 = p1 * (-pi);
env0 = Env([aamp1,aamp2,aamp3,aamp4,0],[atk,decay,release],[curve1, curve2, curve3]);
env1 = Env([freq1,freq2,freq3],[famp1,famp2,famp3,famp4],[curve1, curve2, curve3]);

env0 = EnvGen.ar(env0, doneAction:2);
env1 = EnvGen.ar(env1);
	env1m = env1.midicps;
son = LFSaw.ar(env1m,0,oamp, 1,1.4);//*LFSaw.ar(100).distort;
son2 = SinOsc.ar(env1m,0, oamp, 1,1.4);
son3 = LFPulse.ar(env1m,0, oamp, 1,1.4);
son4 = LFTri.ar(env1m,0, oamp, 1,1.4);

son = SelectX.ar(ochoose,[son,son2,son3,son4]);
son = LeakDC.ar(son,dc,30);
son = son ;
son = HPF.ar(son, 100, env0);
	son = son + SelectX.ar(owhich2,[ SinOsc.ar(env1m, p1, env0), LFSaw.ar(env1m, p1, env0), LFPulse.ar(env1m, p1, env0), LFTri.ar(env1m, p1, env0)]);
	son =  HPF.ar(son +BrownNoise.ar(env0/2*noise)+WhiteNoise.ar(env0*noise),fratio);
//son = son.clip2(1);

	son = Limiter.ar(son,1);
	son = son * level.distort;

OffsetOut.ar(out, son*level).tanh;
//OffsetOut.ar(snd, son*level).tanh;
},
).add;

// Synth(\snaremed)



SynthDef(\cow, { arg out=0,tu=1, amp=0.5, pan=0,gate=1,rel=1;
	var sig;
	var env = EnvGen.ar(Env.adsr(0.001,0.01,0.1,rel),gate,doneAction:2);
	sig = LFPulse.ar(550*tu)+LFPulse.ar(tu*400*(env+250));
	sig = Ringz.ar(sig,(30..35)*10.234*tu,1).mean;
	//sig = Pan2.ar(sig*env, pan, amp);
	Out.ar(out, sig*amp*env);
}).add;
// Synth(\cow)


//STEREO



SynthDef(\notes,{arg out=0,freq = 69,gate = 1,tu = 1,amp=0.5;
	var env = EnvGen.ar(Env.perc(0.01,0.1),gate,doneAction:2);
	var sig = WhiteNoise.ar(env);
	sig = CombL.ar(sig,0.2,(freq+(432.cpsmidi-69)).midicps/SampleRate.ir,1)+sig;
	sig = CombL.ar(sig,0.2,(freq+(432.cpsmidi-69)).midicps/SampleRate.ir,0.2)+sig;
	sig = sig *env *0.5;
	sig = CompanderD.ar(sig*2,0.5,1,0.5);
	Out.ar(out,sig*amp);
}).add;

// Synth(\notes, [\freq, 79])


SynthDef(\notes2,{arg out=0,gate =1,notes=68,at = 0.01,sus=0.4,snd=18;
	var env = EnvGen.ar(Env.adsr(at,1,sus,1.4),gate,doneAction:2);
	//var env = EnvGen.ar(Env.perc(0.01,1),gate,doneAction:2);
	var note = (notes+(432.cpsmidi-69)).midicps;
	var sig = Mix.ar(SinOsc.ar([note,note*2,note/2]));
	sig = Splay.ar(sig*0.1);
	Out.ar(out,sig*env*0.5);
	//Out.ar(snd,sig*env);
}).add;

SynthDef(\sinus,{arg out=0, freq=100,gate =1,release=0.1,lfo=1,amp=0.5;
	var env  = EnvGen.ar(Env.perc(0,release),gate,doneAction:2);
	var sig = SinOsc.ar(freq.midicps+(432-69.midicps)*SinOsc.kr(lfo),0,env);
	sig = HPF.ar(sig,100);
	sig = CompanderD.ar(sig,0.3,0.3,1.5,0.0001,0.01);
	Out.ar(out,sig*amp);
}).add;





