SensorMaracas {
	// Turn continuous values into note on/note off states, when sensor changes direction.
	// increase filter order (int values > 1) for smoother reaction.

	/*
	Returns a state index based on previous and current values of sensors:
	isNoteOn: 2
	isNoteOff: -1
	*/
	var <>inputMax, <>thresh, filterOrder, <>musicCallback, <>noteIndex, <>quant, prevVal, prevDirection, prevArray, guard;
	*new {|inputMax=1024, thresh= 0.5, filterOrder=10, musicCallback, noteIndex=0, quant=0|
		^super.newCopyArgs(inputMax, thresh, filterOrder, musicCallback, noteIndex, quant).reset;
	}
	reset {
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

		// postf("Direction: %\n", direction);
		// state detection
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

		// on note On, apply quantization, if required
		if ((returnState == 2),

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

			{
				musicCallback.value(noteIndex, newValue, returnState);
			}
		);

		^returnState
	}
}

/*
Usage:

a=SensorMaracas.new(0.5, 100)
-> a SensorMaracas

a.process(0.1)

*/