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
	var <>thresh, <>triggerUpwards, <>musicCallback, <>noteIndex, <>quant, prevVal, guard;
	*new {|thresh= 0.5, triggerUpwards=1, musicCallback, noteIndex=0, quant=0|
		^super.newCopyArgs(thresh, triggerUpwards, musicCallback, noteIndex, quant).reset;
	}
	reset {
		prevVal = thresh;
		guard = 0;
	}

	process {|newValue|
		var returnState, isNoteOn, isNoteOff, isOn, isOff;

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

		prevVal = newValue;


		// return state value
		if (isNoteOn,  {returnState=2});
		if (isNoteOff,  {returnState= -1});
		if (isOn,  {returnState=1});
		if (isOff,  {returnState=0});

		// on note On, apply quantization, if required
		if (isNoteOn,

			// PROCESS NOTE ON FOR QUANTIZATION
			{ if(quant>0,
				{	if(guard != 1) {
					guard = 1;
					TempoClock.sched( TempoClock.timeToNextBeat(quant), {
						guard = 0;
						musicCallback.value(noteIndex, newValue, returnState);
					});
				};},
				{
					musicCallback.value(noteIndex, newValue, returnState);
			});
			},

			// DONT PROCESS OTHER EVENTS, JUST EXECUTE CALLBACK
			{
				{musicCallback.value(noteIndex, newValue, returnState);};
			}
		);

		^returnState
	}
}


/*
Usage:
// WARNING: the triggerUpwards mode doesn't work yet...
a=SensorKey.new(0.5, true)
-> a SensorKey

a.process(0.1)
-> -1

a.process(0.2)
-> 0

a.process(0.8)
-> 2

*/