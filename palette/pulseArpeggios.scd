// from tutorial: "https://www.youtube.com/watch?v=LKGGWsXyiyo&list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC&index=4&t=453s"


/* expand from here:
- pick from freq arrays (scales, or freqs analysed from sounds) -> use patterns?
- play another arpeggiated synth with a different kind of sound, in a complement freqs region, find out how to sync them (or not)
- add silent steps in the arp
- slowly change timbre
- add a drone layer
- add perc layer, maybe using samples from 0 coast. see tutorial in same serie about playing samples.

*/


// NEXT: pattern tutorial: "https://www.youtube.com/watch?v=nB_bVJ1c1Rg&index=11&list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC"

(
SynthDef.new(\pulse, {

	arg fund=40, rate=4, width=0.5, maxPartials=4, multFreq=8, ampFreq=4;
	var amp1, amp2, sig1, sig2, freq1, freq2;

	amp1 = LFPulse.kr(ampFreq, 0, 0.12) * 0.7;
	amp2 = LFPulse.kr(ampFreq, 0.5, 0.12) * 0.7;


	freq1 = LFNoise0.kr(rate).exprange(fund, fund*maxPartials);
	freq1 = freq1 * LFPulse.kr(multFreq, add: 1);

	freq2 = LFNoise0.kr(rate).exprange(fund, fund*maxPartials);
	freq2 = freq2 * LFPulse.kr(multFreq, add: 1);

	sig1 = Pulse.ar(freq1, width, amp1);
	sig2 = Pulse.ar(freq2, width, amp2);

	sig1 = FreeVerb.ar(sig1, 0.7, 0.8, 0.25);
	sig2 = FreeVerb.ar(sig2, 0.7, 0.8, 0.25);

	Out.ar(0, sig1);
	Out.ar(1, sig2);

}).add;

)

x = Synth.new(\pulse);

x.set(\rate, 8);
x.set(\width, 0.5);
x.set(\multFreq, 4);
x.set(\ampFreq, 4);
x.free;




