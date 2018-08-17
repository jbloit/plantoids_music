SensorKey {
	// Turn continuous values into note on/note off states.
	// set "triggerUpwards" to 0 if you want to trigger when values go below a threshold instead of above.
	// no filtering (was messing up detection)
	/*
	Returns a state index based on previous and current values of light sensors:
	isNoteOn: 2
	isNoteOff: -1
	isOn: 1
	isOff: 0
	*/
	var <>inputMax, <thresh, <>triggerUpwards, <>musicCallback, <>noteIndex, <>quant, prevVal, guard;
	*new {|inputMax=1024, thresh= 0.5, triggerUpwards=1, musicCallback, noteIndex=0, quant=0|
		^super.newCopyArgs(inputMax, thresh, triggerUpwards, musicCallback, noteIndex, quant).reset;
	}
	reset {
		prevVal = thresh;
		guard = 0;
	}

	// autoset triggerDirection
	thresh_ {|newValue|
		thresh = newValue;
		if (thresh<0.5)
		{
			triggerUpwards=1;
		}
		{
			triggerUpwards=0;
		};

		// prevent values too close to min or max input values, that will stuck the detection
		thresh = min(0.9, thresh);
		thresh = max(0.1, thresh);
	}

	process {|newValue|
		var returnState, isNoteOn, isNoteOff, isOn, isOff;

		// postf("KEY, newValue: % \n", newValue);

		newValue = newValue / inputMax;

		// postf("KEY, newValue: % \n", newValue);

		if ((triggerUpwards > 0), {
			// UPWARDS state detection
			isNoteOn = (prevVal <= thresh) && (newValue >= thresh);
			isNoteOff = (prevVal >= thresh) && (newValue <= thresh);
			isOn = (prevVal >= thresh) && (newValue >= thresh);
			isOff = (prevVal < thresh) && (newValue < thresh);
		}, {
			// DOWNWARDS state detection
			isNoteOn = (prevVal >= thresh) && (newValue <= thresh);
			isNoteOff = (prevVal <= thresh) && (newValue >= thresh);
			isOn = (prevVal <= thresh) && (newValue <= thresh);
			isOff = (prevVal > thresh) && (newValue > thresh);
		}
		);

		//store previous value for detection method above
		prevVal = newValue;

		// newValue is passed to music callback but needs to be revesed according to mode
		if (triggerUpwards < 1) {
			newValue = 1 - newValue;
		};

		// return state value
		if (isNoteOn,  {returnState=2});
		if (isNoteOff,  {returnState= -1});
		if (isOn,  {returnState=1});
		if (isOff,  {returnState=0});





		// on note On, apply quantization, if required
		if (returnState == 2) {
			// PROCESS NOTE ON FOR QUANTIZATION
			if(quant>0) {
				if(guard != 1) {
					guard = 1;
					TempoClock.sched( TempoClock.timeToNextBeat(quant), {
						guard = 0;
						musicCallback.value(noteIndex, newValue, returnState);
						nil;
					});
				}
			} {
				musicCallback.value(noteIndex, newValue, returnState);
			};
		} {
			// DONT PROCESS OTHER EVENTS, JUST EXECUTE CALLBACK
			musicCallback.value(noteIndex, newValue, returnState);
			// postf("NON-ONSET event: % \n", returnState);
		};

		^returnState
	}
}


/*
Usage:

c={|i,v,s|
	"callback".postln;
	v.postln;
};

a = SensorKey(inputMax:100, musicCallback:c);

a.process(1)
a.process(100)
a.process(49)
a.process(52)
a.thresh = 0.2
a.process(100)
a.process(49)
a.process(52)
a.process(1)
a.process(19)
a.process(21)

a.triggerUpwards
a.thresh = 0.9
a.triggerUpwards

*/
