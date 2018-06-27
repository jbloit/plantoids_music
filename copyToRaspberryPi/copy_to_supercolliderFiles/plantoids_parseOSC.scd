// Parse OSC and send msg values to worker functions
// Allows to decouple the OSC message parsing and the composition


// this maps analog index to worker functions

~ldr_max = 1024;
~flex_max = 1024;
~sonar_max = 500;
~temperature_max = 50;
~humidity_max = 10;

~p1_analogSensorsMaxCount = 20;
~p2_analogSensorsMaxCount = 20;
~p3_analogSensorsMaxCount = 20;

~analogSensorsPrev = Array.newClear(3);
~analogSensorsPrev[0] = Array.fill(~p1_analogSensorsMaxCount, 0);
~analogSensorsPrev[1] = Array.fill(~p2_analogSensorsMaxCount, 0);
~analogSensorsPrev[2] = Array.fill(~p3_analogSensorsMaxCount, 0);

// at night, LDRs trigger onsets when value goes OVER threshold,
// during day, it's the opposite.

~isNightMode = false;

/*
Returns a state index based on previous and current values of light sensors:
isNoteOn: 2
isNoteOff: -1
isOn: 1
isOff: 0

isLight: boolean flag, to process light sensors differently in night mode.
*/
~analogOnset = { |plantIndex=0, sensorIndex=0, newValue=0, thresh=0.5, isLight=true|
	var prevVal, isNoteOn, isNoteOff, isOn, isOff, returnState;

	prevVal = ~analogSensorsPrev[plantIndex][sensorIndex];
	// debug:
	// postf("prev val: %, val: % \n", prevVal, newValue);

	if ((~isNightMode && isLight), {newValue = 1-newValue; prevVal = 1-prevVal;});

	// state detection
	isNoteOn = (prevVal <= thresh) && (newValue >= thresh);
	isNoteOff = (prevVal >= thresh) && (newValue <= thresh);
	isOn = (prevVal >= thresh) && (newValue >= thresh);
	isOff = (prevVal < thresh) && (newValue < thresh);

	// store value
	~analogSensorsPrev[plantIndex][sensorIndex] = newValue;

	// return state value
	if (isNoteOn,  {returnState=2});
	if (isNoteOff,  {returnState= -1});
	if (isOn,  {returnState=1});
	if (isOff,  {returnState=0});

	returnState;
};


// ------------------------------------------  Plant 1
OSCdef(\p1_parseAnalogSensors).free;
OSCdef(\p1_parseAnalogSensors, {
	| msg, time, addr, port |

	var val, index, mapped, onsetState;
	index = msg[1]; // numbered from 1 in OSC...

	switch(index,
		1, {
			val = msg[2] / ~ldr_max;
			onsetState =~analogOnset.value(plantIndex:0, sensorIndex:index, newValue:val, isLight:true);
			~p1_flower_ambientLight.value(0, val, onsetState);},
		2, {val = msg[2] / ~flex_max;
			onsetState =~analogOnset.value(plantIndex:0, sensorIndex:index, newValue:val, isLight:false);
			~p1_flower_flexQuake.value(0, val, onsetState);},

		3, {val = msg[2] / ~flex_max;
			onsetState =~analogOnset.value(plantIndex:0, sensorIndex:index, newValue:val, isLight:false, thresh:0.1);
			~p1_flower_flexWind.value(0, val, onsetState);},

		4, {val = msg[2] / ~ldr_max;
			onsetState =~analogOnset.value(plantIndex:0, sensorIndex:index, newValue:val, isLight:true);
			~p1_leaves_light.value(0, val, onsetState)},

		5, {val = msg[2] / ~ldr_max;
			onsetState =~analogOnset.value(plantIndex:0, sensorIndex:index, newValue:val, isLight:true);
			~p1_leaves_light.value(1, val, onsetState)}
	);
	if(
		( index > 5 ),
		{val = msg[2] / ~ldr_max;
			onsetState =~analogOnset.value(plantIndex:0, sensorIndex:index, newValue:val, isLight:true);
			~p1_stem_light.value( (index-6),  val, onsetState)},
		{}
	);

}, '/plantoid/1/1/analog', n);

OSCdef(\p1_parseSonars).free;
OSCdef(\p1_parseSonars, {
	| msg, time, addr, port |
	var val, index, mapped, onsetState;
	index = msg[1]; // numbered from 1 in OSC...
	val = msg[2] / ~sonar_max;

	onsetState =~analogOnset.value(plantIndex:0, sensorIndex:index, newValue:val, isLight:false, thresh:0.1);
	~p1_stem_sonar.value(index-1, val, onsetState);

}, '/plantoid/1/1/sonar', n);

OSCdef(\p1_parseTemperature).free;
OSCdef(\p1_parseTemperature, {
	| msg, time, addr, port |
	var val;
	val = msg[1] / ~temperature_max;
	~p1_flower_temperature.value(0, val);
}, '/plantoid/1/1/temp', n);

OSCdef(\p1_parseHumidity).free;
OSCdef(\p1_parseHumidity, {
	| msg, time, addr, port |
	var val;
	val = msg[1] / ~humidity_max;
	~p1_flower_humidity.value(0, val);
}, '/plantoid/1/1/hum', n);

// ------------------------------------------  Plant 2
OSCdef(\p2_parseAnalogSensors).free;
OSCdef(\p2_parseAnalogSensors, {
	| msg, time, addr, port |

	var val, index, mapped, onsetState;
	index = msg[1]; // numbered from 1 in OSC...

	switch(index,
		1, {val = msg[2] / ~flex_max;
			onsetState =~analogOnset.value(plantIndex:1, sensorIndex:index, newValue:val, isLight:false);
			~p2_flower_flexQuake.value(0, val, onsetState);
		},
		2, {val = msg[2] / ~ldr_max;
			onsetState =~analogOnset.value(plantIndex:1, sensorIndex:index, newValue:val, isLight:true);
			~p2_leaves_light.value(0, val, onsetState);
		},
		3, {val = msg[2] / ~ldr_max;
			onsetState =~analogOnset.value(plantIndex:1, sensorIndex:index, newValue:val, isLight:true);
			~p2_leaves_light.value(1, val, onsetState);
		}
	);
	if(
		( index > 3 ),
		{val = msg[2] / ~ldr_max;
			onsetState =~analogOnset.value(plantIndex:1, sensorIndex:index, newValue:val, isLight:true);
			~p2_stem_light.value( (index-4),  val, onsetState);
		},
		{}
	);

}, '/plantoid/2/1/analog', n);

OSCdef(\p2_parseSonars).free;
OSCdef(\p2_parseSonars, {
	| msg, time, addr, port |
	var val, index, mapped;
	index = msg[1]; // numbered from 1 in OSC...
	val = msg[2] / ~sonar_max;
	~p2_stem_sonar.value(index-1, val);
}, '/plantoid/2/1/sonar', n);


// ------------------------------------------  Plant 3
OSCdef(\p3_parseAnalogSensors).free;
OSCdef(\p3_parseAnalogSensors, {
	| msg, time, addr, port |

	var val, index, mapped, onsetState;
	index = msg[1]; // numbered from 1 in OSC...

	switch(index,
		1, {val = msg[2] / ~flex_max;
			onsetState =~analogOnset.value(plantIndex:2, sensorIndex:index, newValue:val, isLight:false);
			~p3_flower_flexQuake.value(0, val, onsetState);
		},
		8, {
			val = msg[2] / ~ldr_max;
			onsetState =~analogOnset.value(plantIndex:2, sensorIndex:index, newValue:val, isLight:true);
			~p3_leaves_light.value(0, val, onsetState);
		},
		9,
		{ val = msg[2] / ~ldr_max;
			onsetState =~analogOnset.value(plantIndex:2, sensorIndex:index, newValue:val, isLight:true);
			~p3_leaves_light.value(1, val, onsetState);
		}
	);
	if(
		( (index > 1)  && (index < 8) ),
		{val = msg[2] / ~ldr_max;
			onsetState =~analogOnset.value(plantIndex:2, sensorIndex:index, newValue:val, isLight:true);
			~p3_flower_light.value( (index-2),  val, onsetState);
		},
		{}
	);

}, '/plantoid/3/1/analog', n);

OSCdef(\p3_parseSonars).free;
OSCdef(\p3_parseSonars, {
	| msg, time, addr, port |
	var val, index, mapped;
	index = msg[1]; // numbered from 1 in OSC...
	val = msg[2] / ~sonar_max;
	~p3_stem_sonar.value(index-1, val);
}, '/plantoid/3/1/sonar', n);



