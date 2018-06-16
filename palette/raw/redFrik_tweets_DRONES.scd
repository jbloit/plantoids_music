// set output device
Server.local.options.outDevice_("Fireface UC Mac (23669936)")

// set mem size if necessary
/*(
s.quit
Server.local.options.memSize = 65536
s.boot
Server.local.options.memSize
)*/


// April 19th -- an evergoing piece
play{a=SinOsc;f={|...x|1.5**perform(a,\ar,*x)};Splay ar:({|i|l=perform(a,\ar,f.(i+5/150)<1).abs.round(0.5);y=perform(VarSaw,\ar,1.5**l*(f.(l/155,0,5).ceil*50.05),0,f.(l*f.(l/50))-0.55,max(f.(i+1/500.05)-1,0));y+perform(PitchShift,\ar,y*f.(0.1),0.5,5,0.05,1)}!15)}// #SuperCollider


//--tweet0008 noisy tropical rain
play{x=LFNoise1.ar(0.5!2);Formlet.ar(Crackle.ar(x.range(1.8,1.98)),TExpRand.ar(200,2e3,x).lag(2),x.range(5e-4,1e-3),0.0012)}//#SuperCollider


//--tweet0009 ORCHESTRA TUNING DRONE
{|i|x=i+6.rand;Pbind(\dur,0.06,\sustain,1,\amp,0.01,\degree,Pgauss(x,sin(x+Ptime()%6/6e3)*9),\pan,Pkey(\degree)-x*9).play}!6//#SuperCollider


//--tweet0084 SOFTLY BLOWING THE ROOF
play{a=Saw;Splay.ar(Formant.ar(a.ar((5,7..15)*19)*99+199, a.ar((1,3..13)*29)*199+299, a.ar((3,5..11)*a.ar(3,2,3))*299+399))/3}//#SuperCollider

//--tweet0078 HARSH DRONE OCTAVES
play{a=GrayNoise.ar;b=(1..9);CombL.ar(a,1,b/Duty.ar(3,0,Dseq([0.5,1,2,3]*99,99)).lag3(1)).mean/2+Ringz.ar(a/99,b*99).mean!2}//#SuperCollider

/*//--tweet0086 THEY ARE COMING DRONE >> BUGGY!!!! (loud chirp comes and goes after a while)
play{a=LFNoise2.kr(1/(9..17));Splay.ar(Ringz.ar(BPF.ar(Dust2.ar(a.abs*1e4),a.exprange(99,1e4),1.1-a),(9..1)*99,a+1.1,a)/5)}// #SuperCollider*/


//--tweet0098 HARSHY AND SCRATCHY
play{a=LFSaw;b=LocalIn.ar;LocalOut.ar(c=Limiter.ar(CombC.ar(a.ar(d=b+3.3*99)*a.ar(a.ar(d/9)*99),2,a.ar(1/d)/2+1,9)));c/2!2}// #SuperCollider

//--tweet0103 BIG LOW
{|i|b=SinOsc;play{a=DelayC.ar(InFeedback.ar(1-i),6,b.ar(1e-3*(b.ar(1,i)),i,3,3));b.ar(45+[a/8,a/9]+b.ar(0.123),a*3)/5!2}}!2// #SuperCollider

//--tweet0110  DRONE CREATURES
play{Splay.ar({a={LFSaw.kr(0.05.rand2,0,1.0.rand)}!3;BLowPass4.ar(Saw.ar(a@0*250+300,a[2].max(0)),a@1*2e3+2100,0.025)}!99)}// #SuperCollider


//--tweet0115 **** DETUNED DRONE
play{a=Pulse;d=Splay.ar(a.ar(Duty.ar(c=a.ar(b=(6..1),b/7.5)/8+1,0,Dseq(b*c+c.lag3(9)*66,inf))))/9;d+GVerb.ar(d.mean,25,25)}// #SuperCollider

//--tweet0125 TABLES ARE DRONING
play{a=SinOsc;a.ar(a.ar(1/[8,9])*4+[400,202],CombC.ar(InFeedback.ar([1,0]).lagud(a.ar(1/9)+1/88,a.ar(1/8)+1/99),1,0.08,9))}// #SuperCollider

//--tweet0143  O CHOIRD
play{l=LocalBuf(b=1e4,2);{|i|BufWr.ar(a=LFTri.ar(i+1*[8,19.2]),l,a/[i+1]*b)}!3;LPF.ar(PlayBuf.ar(2,l,1/9,1,0,1).clip2,b)/2}// #SuperCollider


//--tweet0160 MEAN BONE
play{a=SinOscFB;c=a.ar([50,99],0.4);RecordBuf.ar(InFeedback.ar(0,2)+c/3,b=LocalBuf(8e4,2).clear);BufRd.ar(2,b,a.ar(c)*6e4)}// #SuperCollider