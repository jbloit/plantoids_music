// Parse OSC and send msg values to worker functions
// Allows to decouple the OSC message parsing and the composition
// this maps analog index to worker functions

~ldr_max = 1024;
~flex_max = 1024;
~sonar_max = 500;
~temperature_max = 50;
~humidity_max = 10;

// ------------------------------------------  Plant 1

// the mappers directly map the sensor values to the music callbacks

~p1_analogMappers = [
	//0
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p1_flower_ambientLight, noteIndex:0, quant:0),
	//1
	SensorKey.new(inputMax:~flex_max, thresh:0.3, musicCallback: ~p1_flower_flexQuake, noteIndex:0, quant:0),
	//2
	SensorKey.new(inputMax:~flex_max, thresh:0.1, musicCallback: ~p1_flower_flexWind, noteIndex:0, quant:0),
	//3
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p1_leaves_light, noteIndex:0, quant:1/8),
	//4
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p1_leaves_light, noteIndex:1, quant:1/8),
	//5
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p1_stem_light, noteIndex:0, quant:1/8),
	//6
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p1_stem_light, noteIndex:1, quant:1/8),
	//7
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p1_stem_light, noteIndex:2, quant:1/8),
	//8
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p1_stem_light, noteIndex:3, quant:1/8),
	//9
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p1_stem_light, noteIndex:4, quant:1/8),
	//10
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p1_stem_light, noteIndex:5, quant:1/8),
	//11
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p1_stem_light, noteIndex:6, quant:1/8),
	//12
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p1_stem_light, noteIndex:7, quant:1/8),
	//13
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p1_stem_light, noteIndex:8, quant:1/8),
	//14
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p1_stem_light, noteIndex:9, quant:1/8),
	//15
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p1_stem_light, noteIndex:10, quant:1/8),
];

OSCdef(\p1_parseAnalogSensors).free;
OSCdef(\p1_parseAnalogSensors, {
	| msg, time, addr, port |
	var val, index, mapped, onsetState;
	index = msg[1] - 1; // numbered from 1 in OSC...
	val = msg[2];

	~p1_analogMappers[index].process(val);

}, '/plantoid/1/1/analog', n);


~p1_sonarMappers  = [
	SensorMaracas.new(inputMax:~sonar_max, thresh:0.1, filterOrder:10, musicCallback: ~p1_stem_sonar, noteIndex:0, quant:0),
	SensorMaracas.new(inputMax:~sonar_max, thresh:0.1, filterOrder:10, musicCallback: ~p1_stem_sonar, noteIndex:1, quant:0),
	SensorMaracas.new(inputMax:~sonar_max, thresh:0.1, filterOrder:10, musicCallback: ~p1_stem_sonar, noteIndex:2, quant:0),
	SensorMaracas.new(inputMax:~sonar_max, thresh:0.1, filterOrder:10, musicCallback: ~p1_stem_sonar, noteIndex:3, quant:0),
];

OSCdef(\p1_parseSonars).free;
OSCdef(\p1_parseSonars, {
	| msg, time, addr, port |
	var val, index, mapped, onsetState;
	index = msg[1] - 1; // numbered from 1 in OSC...
	val = msg[2];

	~p1_sonarMappers[index].process(val);

}, '/plantoid/1/1/sonar', n);



~p1_temperatureMapper = SensorKey.new(inputMax:~temperature_max, thresh:0.1, musicCallback: ~p1_flower_temperature, noteIndex:0, quant:0);

OSCdef(\p1_parseTemperature).free;
OSCdef(\p1_parseTemperature, {
	| msg, time, addr, port |
	var val;
	val = msg[1] ;
	~p1_temperatureMapper.process(val);

}, '/plantoid/1/1/temp', n);



~p1_humidityMapper = SensorKey.new(inputMax:~humidity_max, thresh:0.1, musicCallback: ~p1_flower_humidity, noteIndex:0, quant:0);

OSCdef(\p1_parseHumidity).free;
OSCdef(\p1_parseHumidity, {
	| msg, time, addr, port |
	var val;
	val = msg[1];
	~p1_humidityMapper.process(val);
}, '/plantoid/1/1/hum', n);
















/*
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
	var val, index, mapped, onsetState;
	index = msg[1]; // numbered from 1 in OSC...
	val = msg[2] / ~sonar_max;

	onsetState =~analogOnset.value(plantIndex:1, sensorIndex:index, newValue:val, isLight:false, thresh:0.1);
	~p2_stem_sonar.value(index-1, val, onsetState);

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
	var val, index, mapped, onsetState;
	index = msg[1]; // numbered from 1 in OSC...
	val = msg[2] / ~sonar_max;

	onsetState =~analogOnset.value(plantIndex:2, sensorIndex:index, newValue:val, isLight:false, thresh:0.1);
	~p3_stem_sonar.value(index-1, val, onsetState);

}, '/plantoid/3/1/sonar', n);

*/

