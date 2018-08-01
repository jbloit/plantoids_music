SensorMaracas_debug {
	// Turn continuous values into note on/note off states, when sensor changes direction.
	// increase filter order (int values > 1) for smoother reaction.

	/*
	Returns a state index based on previous and current values of sensors:
	isNoteOn: 2
	isNoteOff: -1
	*/
	var <>inputMax, <>thresh, filterOrder, <>musicCallback, <>noteIndex, <>quant, prevVal, prevDirection, prevArray, guard, prevVal, <>triggerUpwards=1;
	*new {|inputMax=1024, thresh= 0.5, filterOrder=10, musicCallback, noteIndex=0, quant=0|
		^super.newCopyArgs(inputMax, thresh, filterOrder, musicCallback, noteIndex, quant).reset;
	}
	reset {
		triggerUpwards=1;
		prevDirection = -1; // 1: up, -1: down
		prevVal = thresh;
		prevArray =Array.fill(filterOrder, 0);
		guard = 0;
	}

	// send a note On state whenever the sensor changes direction, or crosses the initial threshold.
	process {|newValue|
		var returnState, isNoteOn, isNoteOff, isOn, isOff, direction;

		newValue = newValue / inputMax;

		direction = if ( (newValue > prevVal), {1}, {-1});

		//[newValue, prevVal, triggerUpwards, prevDirection, direction].debug("n, p, y, pd, d");

		// postf("Direction: %\n", direction);
		// state detection
		if ((triggerUpwards > 0), {
			// UPWARDS state detection
			isOn = (prevVal >= thresh) && (newValue >= thresh);
			isOff = (prevVal < thresh) && (newValue < thresh);
		}, {
			// DOWNWARDS state detection
			isOn = (prevVal <= thresh) && (newValue <= thresh);
			isOff = (prevVal > thresh) && (newValue > thresh);
		}
		);

		//[isOn, isOff, prevVal, newValue].debug("o, f, pv, nv");
		isNoteOn = (prevDirection != direction) && (newValue >= thresh);
		isNoteOff = (prevVal >= thresh) && (newValue <= thresh);

		// filter prevValue
		prevArray[0] = newValue;
		prevArray= prevArray.shift(1);
		prevVal = prevArray.median;

		prevDirection = direction;

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

a=SensorMaracas.new(0.5, 100)
-> a SensorMaracas

a.process(0.1)

*/

