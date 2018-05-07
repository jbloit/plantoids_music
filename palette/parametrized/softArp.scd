(
SynthDef(\avping, {|out= 0, freq= 400, atk= 0.01, rel= 0.1, cur= -4, amp= 0.1, gate= 1, pan= 0, mod= 1|
    var env= EnvGen.ar(Env.asr(atk, 1, rel, cur), gate, doneAction:2);
    var snd= SinOsc.ar(freq, SinOsc.ar(freq*mod, env*pi, mod));
    Out.ar(out, Pan2.ar(snd*env, pan, amp));
}).add;
)

(
~toggle = {
	|pat|
	if(pat.isPlaying, {pat.stop}, {pat.play});
};
)

//--start playing
(
~p1 = Pdef(\ping1, PmonoArtic(\avping,
    \freq, Pseq([300], inf),  //change these
    \dur, 0.5,
	\amp, Pseq([1], inf),
    \legato, 0.1,  //this key for example is for the PmonoArtic sequencer
    \atk, 0.1,    //while this key belongs to the \avping SynthDef
    \rel, 0.1,
	\sustain, 0.05,
)).play;
)

//--start playing
(
~p2 = Pdef(\ping2, PmonoArtic(\avping,
    \freq, Pseq([300, 400, 600, 533], inf),  //change these
    \dur, 2,
    \legato, 0.1,  //this key for example is for the PmonoArtic sequencer
    \atk, 1,    //while this key belongs to the \avping SynthDef
    \rel, 5,
    \amp, 0.5,
)).play;
)

//--start playing
(
~p3 = Pdef(\ping3, PmonoArtic(\avping,
    \freq, Pseq([300, 400, 600, 533], inf),  //change these
    \dur, 2,
    \legato, 0.1,  //this key for example is for the PmonoArtic sequencer
    \atk, 1,    //while this key belongs to the \avping SynthDef
    \rel, 5,
    \amp, 0.5,
)).play;
)

~toggle.(~p1);
~toggle.(~p2);
~toggle.(~p3);

~p1.play;
~p2.play;
~p3.play;

~p1.stop;
~p2.stop;
~p3.stop;




