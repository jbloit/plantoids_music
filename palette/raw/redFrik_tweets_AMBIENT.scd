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


//--tweet0009 ORCHESTRA TUNING DRONE
{|i|x=i+6.rand;Pbind(\dur,0.06,\sustain,1,\amp,0.01,\degree,Pgauss(x,sin(x+Ptime()%6/6e3)*9),\pan,Pkey(\degree)-x*9).play}!6//#SuperCollider


//--tweet0026  ***** ARP DISTO
{CombL.ar(In.ar(8).tanh/8,1,1,8)!2}.play;Pbind(\amp,8,\dur,1/4,\degree,Pseq(List.fib(32)%(List.fib(64)%12),inf),\out,8).play//#SuperCollider


//--tweet0029  ***** EAR TIKKLING REPEATING PATTERN. UNHARMONICS
play{{|i|CombC.ar(In.ar(8),3+i,LFTri.ar(0.5,0,1,2+i),99)}!2};Pbind(\out,8,\note,Pstutter(8,Pseq(List.fib(32)%9/3,inf))).play//#SuperCollider

//--tweet0061 BEN ARPEGG
a=Demand;b=SinOsc;play{b.ar(a.ar(t=Saw.ar([9,9.01]),0,Dseq(0!6++500,inf)),b.ar(a.ar(t,0,Dshuf((0..7)*99,inf)).lag(0.04)))/2}//#SuperCollider