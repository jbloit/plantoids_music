// REDFRIK UNVOICED OR RIFFING

//--tweet0002 phased light drops
r{99.do{x={Pan2.ar(BPF.ar(Impulse.ar(18.linrand+0.5),9999.linrand,0.3.linrand,5),1.0.rand2)}.play;3.wait;x.release(9)}}.play//#SuperCollider

//--tweet0004 pulsing noise (insect like)
r{loop{z=20.rand+6;x={y=LFTri.ar(z).abs/9/z;RLPF.ar(TDuty.ar(y,0,y),z*600,0.06,9)!2}.play(s,0,z);wait(26-z);x.release}}.play//#SuperCollider

//--tweet0005 pulsing noises (wood perc like)
r{loop{z=60.rand+1;x={y=LFTri.ar(z).abs/z;RLPF.ar(TDuty.ar(y,0,y),z*99+y,0.01,6+y)!2}.play(s,0,z);wait(z/3);x.release}}.play//#SuperCollider

//--tweet0006 NOISE WINDS - crashes after some time if low memory.
/*
s.quit
Server.local.options.memSize = 65536
s.boot
*/
r{loop{x={GVerb.ar(MoogFF.ar(ClipNoise.ar*0.4,LFPar.kr({0.3.rand}!2,0,600,990)),9,9,1)}.play(s,0,19);3.wait;x.release}}.play//#SuperCollider


//--tweet0008 noisy tropical rain
play{x=LFNoise1.ar(0.5!2);Formlet.ar(Crackle.ar(x.range(1.8,1.98)),TExpRand.ar(200,2e3,x).lag(2),x.range(5e-4,1e-3),0.0012)}//#SuperCollider

//--tweet0016 HARSH GLASS BITS
play{b=LocalBuf(9e4,2).clear;i=Sweep.ar(BufRd.ar(2,b,Saw.ar(12,3e4,4e4)),9e4);BufWr.ar(Saw.ar([8,9]),b,i);BufRd.ar(2,b,i)/2}//#SuperCollider

//--tweet0017 MARCHING IKEDA
play{b=LocalBuf(8e4,2).clear;i=Sweep.ar(BufRd.ar(2,b,Saw.ar(3.1,4e4,4e4)),8e4);BufWr.ar(Blip.ar([2,3]),b,i);BufRd.ar(2,b,i)}//#SuperCollider


//--tweet0018 SYNCOPED SNARE
play{b=LocalBuf(5e3,2).clear;i=Sweep.ar(BufRd.ar(2,b,Saw.ar(50,2e3,5e3)),6e4);BufWr.ar(Saw.ar([4,3]),b,i);BufRd.ar(2,b,i)/6}//#SuperCollider


//--tweet0019 FRIDGE TECHNO
play{b=LocalBuf(1e4,2).clear;i=Sweep.ar(BufRd.ar(2,b,Saw.ar(1,2e3,5e3)),5e5);BufWr.ar(Saw.ar([8,50]),b,i);BufRd.ar(2,b,i)/3}//#SuperCollider

//--tweet0021 ANTBITS
r{{|j|a=play{sin(Decay.ar(Duty.ar(1/50,0,Dseq(flat({|i|asBinaryDigits(j+1*i)}!8),4),2),j+1*0.008))/2!2};5.12.wait}!256}.play//#SuperCollider

//--tweet0041  ***** IKEDA TUNNEL
play{o=SinOsc.ar(1/RunningMax.ar(Sweep.ar(LocalIn.ar(6)),Impulse.ar([1,0.749,6,12,3,4])));LocalOut.ar(o);Splay.ar(o).tanh/2}//#SuperCollider

//--tweet0050   **** HITTING THE TANK
play{a=Saw;b=(2..12);c=0.015;GVerb.ar(Splay.ar(Klank.ar(`[b*50+b,c,c],Hasher.ar(a.ar(b/4pi,a.ar(c)*b+b).ceil)))/9,5.rand+1)}//#SuperCollider


//--tweet0052  ***** SLOW SWIPE NOISE WITH CLICK
{Splay.ar(BLowPass.ar(Impulse.ar("sunday".ascii),LFTri.ar(3/"live".ascii)*1800+1900,LFTri.ar(4/"coding".ascii)+1.01))}.play// #SuperCollider

//--tweet0058 4 ON FLOWER
play{CombN.ar(SinOsc.ar(Saw.ar(3,64,99),Saw.ar([3,4],Saw.ar(1,32,128),Duty.ar(1,0,flop(Dseq([0,8,1,5])*[1,4,8]))))/9,1,1/6)}//#SuperCollider

//--tweet0060  BEATS IN A PLATE
a=LFSaw;play{FreeVerb.ar(CombN.ar(VarSaw.ar(a.ar([32,48],0,42*a.ar(1/[16,24]),8),0,a.ar([18,12],0,1/64,1/64)).sin/2,1,1,2))}//#SuperCollider


//--tweet0084 WIND UNDER THE ROOF
play{a=Saw;Splay.ar(Formant.ar(a.ar((5,7..15)*19)*99+199,a.ar((1,3..13)*29)*199+299,a.ar((3,5..11)*a.ar(3,2,3))*299+399))/3}//#SuperCollider

//--tweet0090 TAKING A LEAK
play{FreeVerb.ar(Splay.ar(BBandPass.ar(Blip.ar(b=(1..8)+1,LFTri.ar(1/b)*9e3,LFTri.ar(3/4/b).max(0)),b*999,1/b),2,3),0.3,1)}// #SuperCollider

//--tweet0107 YES IKED
play{a=SinOsc;d=a.ar(12*a.ar(9))%1/4;c=Amplitude.ar(InFeedback.ar(0),d,d)+a.ar(d*d+[32.01,32]);BBandPass.ar(a.ar(0,c*9,c))}// #SuperCollider

//--tweet0111 FIND THE BEAT
play{a=SinOsc;Splay.ar(a.ar(PulseCount.ar(f=InFeedback.ar(0,2).sum)%999+(60,63.0005..99)*a.ar(2**f)*2+[3,4],f>0*f*9)).tanh}// #SuperCollider

//--tweet0132 CRUNCHY PATTERN
play{a=SinOsc;HPF.ar(a.ar(HPZ1.ar(Amplitude.ar(InFeedback.ar(0,2)*9,0,a.ar(2)%1/6)*8e3),Decay2.ar(a.ar(0.5005)>0.93)),9)/2}// #SuperCollider

//--tweet0146 SOFT ROLL
play{a=LFTri;l=LocalBuf(c=99,20).clear;RecordBuf.ar(a.ar(c=(1..20)),l);GVerb.ar(HPF.ar(IndexL.ar(l,a.ar(c/45)).sum,9)/9,1)}// #SuperCollider


//--tweet0165 CRACKLES
play{CombC.ar(BLowPass.ar(Limiter.ar(LeakDC.ar(InFeedback.ar([1,0]))),2e3)+Impulse.ar(0),1,LFTri.ar(1/[6,8])*0.4+0.5)*0.99}// #SuperCollider

//--tweet0170 BEAT PONG
play{a=SinOsc;c=a.ar(0,a.ar(b=[2,3])*400,a.ar(b/4.1));c+a.ar(b*99*Amplitude.ar(c,0,1/7))+GrayNoise.ar(CombN.ar(c,1,b/3))/2}// #SuperCollider

//--tweet0175 BEAT BURROUGH
a=LFPar;play{Out.ar(5,a.ar(1)|a.ar(5)+RLPF.ar(x=Pan2.ar(InFeedback.ar(5),SinOsc.ar(5.5)),3e3,a.ar(1/25)/2+1.7));x*a.ar(99)}// #SuperCollider


//--tweet0222 RIOJI ASMR
a=SinOscFB;play{((c=InFeedback.ar(0,2).lag(b=1/67))+DelayL.ar(HPF.ar(a.ar([99,98]*50.666*a.ar(c+b*b,c),c%2),50),b,b)).tanh}// #SuperCollider

//--tweet0224 IN THE CATS THROAT
a=SinOsc;play{d=BufRd.ar(2,b=LocalBuf(c=2e5,2).clear,a.ar([2,3]*9)*c,0);BufWr.ar(a.ar(3/[2,3])/3,b,a.ar([99,145]).abs*c);d}// #SuperCollider

//--tweet0227 COOL BASS PATTERN
play{a=LFPulse;f=SinOsc;b=a.ar(a.ar(4/3)*4).lag2(0.01);Splay.ar(f.ar(d=lag(99**b*a.ar(c=2/(6..9))))+f.ar(d*b/c,b*d,1-c))/4}// #SuperCollider

//--tweet0237 MONO PATTERN
r{inf.do{|i|a=play{Duty.ar(3e-3*[b=i%99/99,1-b],0,Dseq(i.asInt.asDigits(2,8),8))*Saw.ar(99+[b,0])/2};0.2.wait;a.free}}.play// #SuperCollider


//--tweet0242 CARGLASS
play{a=LFTri;b=Splay.ar(Decay2.ar(a.ar(c=' #SuperCollider '.ascii),a.ar(1/4)%0.2,a.ar(3/c)%1/99,a.ar(3*c)/9).sin)/15;b+GVerb.ar(b,99,4,0.9)}

//--tweet0256 CHIRPER BEATER
play{a=LFSaw;(c=HPF.ar(a.ar(b=1/16)+a.ar(b/4)+a.ar(b/3)*9|(e=a.ar(b,d=[0,1])*99),9,e/9).sin)+PitchShift.ar(c,b,e>>5%2+1)/3}// #SuperCollider


//--tweet0262 WOBBLY WOBBLES
play{a=SinOsc;c=Decay2;CombN ar:a.ar(a.ar(b=(1..6)).sum*9+99,sum(c.ar(t=a.ar(10/b).sum>[1,2]*a.ar)*b),c.ar(t,0.02,0.2))/20}// #SuperCollider

//--tweet0264 CLIPPING PHASING HOPKINS
play{a=Saw;GVerb.ar(a.ar(25*b=(8..2))).mean.lag2(c=LFSaw.ar(a.ar([33,99])+2)+1/99)+mean(a.ar(8/b,a.ar(b))|a.ar(c+2)).sin/3}// #SuperCollider

//--tweet0271 RYOJI ON LINE 9
play{a=SinOsc;b=(a.ar(c=0.015)/9<a.ar(5/(1..7))).varlag(c);Splay.ar(a.ar(2-b**ceil(a.ar(b)*5+6),b)+BrownNoise.ar(b%1)).sin}// #SuperCollider

//--tweet0275 MONO BASS GROOVE
play{a=SinOsc;CombN.ar(a.ar(a.ar(a.ar(1/[2,3])<0+1)**a.ar(1+a.ar(1+a.ar(1/6)*99)*666).lag(a.ar([1.55,1])%1)*99),1,0.9,3)/3}// #SuperCollider

//--tweet0286 CRIDGING THE JAR
play{a=Blip;GVerb.ar(HPF.ar(a.ar(a.ar(1/4,8).ceil+1*[99,9])*a.ar(1.01,ceil(2**a.ar(1/16)*4))>(a.ar(1/128)/4),9)/9,9,2,0.9)}// #SuperCollider

//--tweet0292 HOPKINS ON LINE 5
play{a=Saw;RecordBuf.ar(a.ar(d=[2,4,8,3,6])%a.ar(9)/6,b=LocalBuf(3e3,5).clear);Splay.ar(Shaper.ar(b,a.ar(d*32+a.ar(d/8))))}// #SuperCollider

//--tweet0315 ------- OPENING UP
play{a=Blip;b=(1..8);Splay.ar(a.ar(a.ar(3.125,b)+a.ar(b/2.45,b)+1*a.ar(8/b,50)+1*99,a.ar(b/pi,b)+b-a.ar(1/4/b,2,4)).sin/2)}// #SuperCollider

//--tweet0316 ****** RIFF OCTAVE
play{a=LFSaw;Formlet.ar(Formlet.ar(a.ar(a.ar(c=a.ar([1,2]/32)<0+1)>0+c.lag(c)*99),0,a.ar(3-c/[4,3])+1).sin,99,0,0.01).tanh}// #SuperCollider


//--tweet0326    ------ NOW DANCE
play{a=LFTri;Splay ar:CombC.ar(a.ar(2**a.ar(1/6**(1..6))*99)*Decay.ar(HPZ1.ar(a.ar(#[2,3])<0),c=a.ar(98)%1/3),2,c.lag+1,6)}// #SuperCollider

//--tweet0341 GITCHES ON A PLATE
play{a=LFTri;e=a.ar(2**a.ar(1/5)).round(a.ar(1/8)/3);GVerb.ar(HPF.ar(SinOsc.ar(e**[99,150],BPF.ar(e%1,500))/6,9),99,5,0.1)}// #SuperCollider

//--tweet0347  ********* TRIPPY
play{a=LFSaw;Splay.ar({|i|VarSaw.ar(round(a.ar(c=i/48)*a.ar(b=c/72)*8+9,i%9+1)*25+c,c,a.ar(3,i)+1/3,a.ar(b,i/pi)%1)/2}!30)}// #SuperCollider


//--tweet0351
play{LocalOut.ar(b=HPF.ar(Saw.ar([50,99],9e3**lag(Saw.ar([9,8])+LocalIn.ar(2),LFTri.ar(1/[19,18])/19+0.09)).cos,9));b.tanh}//

//--tweet0354
play{a=LFTri;c=Klank.ar(`[[12,4,3,9,10]*2*99],a.ar(5*b=[1,9/8]),b)*d=a.ar(b/8);a.ar(b*2).sum<0*SinOscFB.ar(b*99,d+1/2)+c/2}// #SuperCollid

s.quit
Server.local.options.memSize = 65536
s.boot
Server.local.options.memSize
