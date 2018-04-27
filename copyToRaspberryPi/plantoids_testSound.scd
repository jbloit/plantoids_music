fork{
(dur:1, strum: 0.1, degree: [0,4,7]).play;
SynthDef.new(\chirpTri,
{
		arg gate=0, amp=0.2;
		var a, c, env;
		env = EnvGen.kr(Env.adsr(0.1, 0.1, 0.9, 1), gate);

		a=SinOsc;
		c=a.ar(999**(a.ar(3)*a.ar([3,1]/8)%1),a.ar(0.03,a.ar(98)*a.ar(0.02,[0,1],3),4));
		c+a.ar(99,c*a.ar(0.01)*12)/3;
		c = c * env * amp;
		Out.ar(0, c);
}).add;

	s.sync;

	~testsynth = Synth(\chirpTri);

	s.sync;

	OSCdef(\test, {|msg, time, addr, recvPort|
		~testsynth.set(\gate, msg[1]);

	}, '/toggle1', n);
};
