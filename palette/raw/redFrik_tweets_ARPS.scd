// set output device
Server.local.options.outDevice_("Fireface UC Mac (23669936)")

// set mem size if necessary
/*(
s.quit
Server.local.options.memSize = 65536
s.boot
Server.local.options.memSize
)*/



//--tweet0227 COOL BASS PATTERN
play{a=LFPulse;f=SinOsc;b=a.ar(a.ar(4/3)*4).lag2(0.01);Splay.ar(f.ar(d=lag(99**b*a.ar(c=2/(6..9))))+f.ar(d*b/c,b*d,1-c))/4}// #SuperCollider

//--tweet0122 TWO NOTE PATTERN
play{a=LFPar;BLowPass.ar(a.ar(Select.kr(a.kr(1/[3,4],0,64*a.kr(5)),(60..67).midicps)),a.kr(0.04)+5*500,a.kr(1/[5,6])+1.01)}// #SuperCollider

//--tweet0140 HARSH PATTERN PROLATING
play{a=LFTri;LFPulse.ar(a.ar(Duty.ar(1/8,0,Dswitch([Dseq((1..8),4),Dseq([60,1,2],[4,3])]/2,Dseq([0,1],99))*99),0,3e3,300))}// #SuperCollider


//--tweet0237 MONO PATTERN
r{inf.do{|i|a=play{Duty.ar(3e-3*[b=i%99/99,1-b],0,Dseq(i.asInt.asDigits(2,8),8))*Saw.ar(99+[b,0])/2};0.2.wait;a.free}}.play// #SuperCollider