// This first function is a noisy ambiance produced by the combinaisons of multiple LFTri sinewaves. Differents variables for frequency, amplitude, panoramic... are set and can be modified by making them react to the sensors. I think this one could work fine with the wind sensors either the sonars, creating frequency shifting linked to the strenght of wind,  the proximity of people or the number or people around the plants. I let at the end of the code some commands examples to control the frequencies but those variables must of course be linked to the sensors (it's just to give you an idea of the sound).

(

~ambiance = {
	var sig;
	sig = BLowShelf.ar((1-LFTri.ar(NamedControl.kr(\freq,100,10)) // first variable freq can be changed (set to 100Hz);
		* (1-LFTri.ar(NamedControl.kr(\freq2,200,10))) // second variable freq2 can be changed (set to 200Hz);
		* (1-LFTri.ar([55,56],{Rand(0,1)}!2,1.5)) // some fixed values (set to 55 and 56 Hz, it creates a stereo signal);
		* (1-LFTri.ar([65,66],{Rand(0,1)}!2,1.5)) // some fixed values (set to 65and 66Hz, it creates a stereo signal);
		* (1-LFTri.ar(NamedControl.kr(\freq3,300,10),mul:NamedControl.kr(\famp,0,10)))),400,db:9);  // third variable freq can be changed (set to 300Hz) ; another variable : famp is set to to 0 and can be changed to control the amplitude of the third frequency;
	sig = Balance2.ar(sig[0],sig[1],LFSaw.kr(NamedControl.kr(\pan,0,10)),NamedControl.kr(\amp,0,10)); // A master amplitude variable is set to 0 and a variable pan (for the stereo paning is set to 0);
}.play;

)

// Some commands examples to control the variables in live. (the variables must now be applied to the sensors)

(
~ambiance.setn(\amp, 0.01);
~ambiance.setn(\pan, 0);
~ambiance.setn(\freq, 300);
~ambiance.setn(\freq2, 550);
~ambiance.setn(\freq3, 700);
~ambiance.setn(\famp, 1);
)

(
~ambiance.setn(\amp, 0.01);
~ambiance.setn(\pan, 0);
~ambiance.setn(\freq, [300,305]);
~ambiance.setn(\freq2, [400,401]);
~ambiance.setn(\freq3, [800,810]);
~ambiance.setn(\famp, 1);
)

(
fork{
	~ambiance.setn(\amp, 0);
	11.wait;
	~ambiance.free;
};
)


// This second function creates two functions at the same time, producing two PinkNoise sounds, passing threw a BandPassFilter which the center frequency can be modified, as the reciproqual quality, amplitude, panoramic ... It can really worlk well with the wind sensors : the wind would make the differents pitches of the center frequency get lower or higher and maybe the light could make the amplitude change ? ... The sound at the end, is produced by a pattern that reads threw the function and creates multiples Synths.

(

SynthDef(\ambiant, {
	|fi,fo,sus,freq,pan,amp|
	var sig,env;
	env = Env([0,1,1,0],[fi,sus,fo],[\sin,0,\lin]).kr(2);
	sig = PinkNoise.ar(0.2!2);
	2.do{sig = BPF.ar(sig, freq.midicps, 0.02, 2)};
	sig = Balance2.ar(sig[0],sig[1],LFNoise1.kr(pan));
	Out.ar(0, sig*env*amp);
}).add;

)

// All the variables can be changed on the fly by using the pattern "Pbindef" (or including a Pbind inside a Pdef). You can here create chords with the freq values, change the attack, sustain and release with fi, sus and fo values, the duration between the creation of two synths with the dur value and the panoramic. Try it in live, it's lovely.

(Pbindef(\ambiant,
	\instrument, \ambiant,
	\dur, Pwhite(1,2),
	\freq, ([62,65,69,72]-2),
	\fi, 1,
	\sus, 2,
	\fo, 1,
	\pan, 0,
	\amp, 0.5,
).play;
)

Pbindef(\ambiant).stop;


// This function can produce multiple kind of sounds. It basically a SawToothWave passing threw a BPF and a reverb. Differents patterns can be used, using this one function to create differents sounds.

(

SynthDef.new(\multi, {
	|freq,detune,fi,sus,fo,cfmin,cfmax,rqmin,rqmax,out,amp,cfhzmin,cfhzmax,mix,room,pan|
	var sig,env;
	env = EnvGen.kr(Env([0,1,1,0],[fi,sus,fo],[\sin,0,\lin]),doneAction:2);
	sig = Saw.ar(freq * {LFNoise1.kr(0.5,detune).midiratio}!2);
	sig = BPF.ar(sig,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(cfhzmin, cfhzmax)).exprange(cfmin, cfmax)}!2,
		{LFNoise1.kr(0.5).exprange(rqmin,rqmax)}!2);
	sig = FreeVerb.ar(sig,mix,room,0.2);
	sig = PanAz.ar(2,sig,SinOsc.kr(pan),amp);
	Out.ar(out,sig * env);
}).add;

)

// We can create some chords harmony and live-play with them by changing the frequency, detune, reverb... variables.

(Pbindef(\chords,
	\instrument, \multi,
	\dur, 17,
	\midinote, Pshuf([    // Here the chords are randomly selected in a collection of values.
		([62,65,69,72,79]-6),
		([62,65,69,72,79]-4),
		([62,65,69,72,79]-2),
		([62,65,69,72,79])
	],inf),
	\detune, Pseg(Pseq([0,10,10],inf),Pseq([120,inf],inf),[\sin,inf],inf),   // The detune value can create nice pitch effects. (Wait 2 minutes to hear complete change).
	\fi, 7,
	\sus, 6,
	\fo, 7,
	\cfmin, 50*2,
	\cfmax, 50*50,
	\rqmin, 0.01,
	\rqmax, 0.5,
	\cfhzmin, 0.001,
	\cfhzmax, 0.03,
	\mix, 1, // Mix and Room values control the reverb settings
	\room, 1,
	\pan, 0,
	\out, 0,
	\amp, 0.1,
).play;
)

// We can also create some nice balafon/marimba soudns with the same function. Here another pattern.

(Pbindef(\balafon,
	\instrument, \multi,
	\dur, Pseq([1],inf),
	\freq, Pseq([1,3,4],inf),  // Freq value is here controlling the speed of the pitches playing (try to change them !)
	\fi, Pwhite(3,8),
	\sus, Pwhite(2,4),
	\fo, 3,
	\detune, Pseg(Pseq([0,2,2],inf),Pseq([120,inf],inf),[\sin,inf],inf),  // Detune value creates some chaos in rythm (wait for changes)
	\cfmin, Prand((Scale.lydian.degrees+62).midicps,inf) * Prand([0.5,1,2,4,6],inf),  // This is a random collection of pitches taken from a lydian scale
	\cfmax, Pkey(\cfmin) * Pwhite(1.005, 1.009, inf),
	\rqmin, 0.005,
	\rqmax, 0.008,
	\cfhzmin, 0,
	\cfhzmax, 0,
	\mix, Pseg(Pseq([0.3,1,1],inf),Pseq([120,inf],inf),[\sin,inf],inf), // Changing mix and room values make the sound smoother and the attack of the notes played get less hearable (wait to hear changes)
	\room, Pseg(Pseq([0,1,1],inf),Pseq([120,inf],inf),[\sin,inf],inf),
	\pan, 0,
	\out, 0,
	\amp, 0.1,
).play;
)


// Here another function that produces some noise and ambiant artefact. It's a PinkNoise passing threw filters. The idea is the same from the first function : assignate the variables values to the sensors. It could work with the sonar I think !

(

~noise = {
	var sig;
	sig = HPF.ar(PinkNoise.ar(5e-3),Line.kr(90,50,160));
	sig = GVerb.ar(({
		|i|
		Ringz.ar(sig * LFNoise1.kr(0.05+0.1.rand),NamedControl.kr(\freq,200,10)*i+70,0.51)}!99).sum,70,99).tanh; // Freq controls a pitch.
	sig = BLowShelf.ar(sig,150,db:5);
	sig = Balance2.ar(sig[0],sig[1],SinOsc.kr(NamedControl.kr(\pan,0,10)),NamedControl.kr(\amp,0,10)); // Amplitude is set to 0, as panoramic.
}.play;

)

// Try me !!

(
fork{
	~noise.setn(\amp, 0.08);
	5.wait;
	~noise.setn(\freq, 150);
	10.wait;
	~noise.setn(\freq, 20);
	~noise.setn(\pan, 10);
	20.wait;
	~noise.setn(\amp, 0);
	10.wait;
	~noise.free;
};
)

