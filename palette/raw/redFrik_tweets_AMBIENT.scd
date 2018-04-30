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