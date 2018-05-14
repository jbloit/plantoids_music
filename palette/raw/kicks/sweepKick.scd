(
{ | dur = 0.15, atk = 0.015, amp = 0.8, pan = 0 |
    Pan2.ar(
        SinOsc.ar(
            EnvGen.ar(Env(\freq_l.kr([2960, 70, 90]), \freq_d.kr([0.07, 0.15]), \freq_c.kr([-13, -1]))),
            mul:EnvGen.ar(
                Env.perc( atk, max(dur - atk, atk), curve: \amp_c.kr([-1, 5])),
                doneAction: 2 ) ),
        pan, amp )
}.asSynthDef.name_("ckick").add.play;
)

(
Pbind(*[
    instrument: \ckick,
    delta: Pseg(Pwhite()/*Pbrown(step:0.05)*/.linexp(0, 1, 1/32, 1), Pbrown(0,1,0.05).linexp(0, 1, 1/8, 8), \sine),
    //delta: Pseg(Pbrown(0,1,0.05).linexp(0, 1, 1/32, 1), Pbrown(0,1,0.05).linexp(0, 1, 1, 4), \step),
    dur: Pfunc({ thisThread.clock.beatDur }) * Pkey(\delta),
    atk: min(0.01, Pkey(\dur)/2),
    freq_l: Pcollect(`_, Ptuple([Pbrown(1500, 4000, 50), Pbrown(40, 65, 1)/*+Pseq([0,300,100,0,50,0],inf)*/, Pbrown(45, 90, 5)], inf)),
    freq_d: Pfunc({ |e| `[e.atk*7, e.dur - 0.07] }),
    //freq_c: Pcollect(`_, Ptuple([Pbrown(-17, -4q, 0.5), Pbrown(0, 4)], inf)),
    freq_c: Ptuple({Pcollect(`_, Ptuple([Pbrown(-17, -4, 0.5), Pbrown(0, 4)], inf))}!2,inf),
    //amp_c: ``[-6,6],
    amp_c: Ptuple({Pcollect(`_, Ptuple([Pbrown(0, -6, 0.5), Pbrown(1, 6)], inf))}!2,inf),
    pan: Ptuple({Pbrown(-1,1)}!2, inf),
    amp: Ptuple({Pbrown(0.1,0.5,0.1)}!2, inf)
])
//.trace
.play(TempoClock(120/60))
)