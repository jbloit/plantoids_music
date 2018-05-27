// Parse OSC and send msg values to worker functions
// Allows to decouple the OSC message parsing and the composition


// this maps analog index to worker functions

~ldr_max = 1024;
~sonar_max = 500;
~temperature_max = 50;
~humidity_max = 10;

OSCdef(\p1_parseAnalogSensors).free;
OSCdef(\p1_parseAnalogSensors, {
	| msg, time, addr, port |

	var val, index, mapped;
	index = msg[1]; // numbered form 1 in OSC...
	val = msg[2] / ~ldr_max;

	switch(index,
		1, ~p1_flower_ambientLight.value(0, val),
		2, ~p1_flower_flexQuake.value(0, val),
		3, ~p1_flower_flexWind.value(0, val),
		4, ~p1_leafs_light.value(0, val),
		5, ~p1_leafs_light.value(1, val)
	);
	if(
		( index > 5 ),
		{~p1_stem_light.value( (index-6),  val)},
		{}
	);
}, '/plantoid/1/1/analog', n);


OSCdef(\p1_parseAnalogSensors).free;
OSCdef(\p1_parseAnalogSensors, {
	| msg, time, addr, port |

	var val, index, mapped;
	index = msg[1]; // numbered form 1 in OSC...
	val = msg[2] / ~ldr_max;

	switch(index,
		1, {~p1_flower_ambientLight.value(0, val)},
		2, {~p1_flower_flexQuake.value(0, val)},
		3, {~p1_flower_flexWind.value(0, val)},
		4, {~p1_leafs_light.value(0, val)},
		5, {~p1_leafs_light.value(1, val)}
	);
	if(
		( index > 5 ),
		{~p1_stem_light.value( (index-6),  val)},
		{}
	);
}, '/plantoid/1/1/analog', n);


OSCdef(\p1_parseSonars).free;
OSCdef(\p1_parseSonars, {
	| msg, time, addr, port |
	var val, index, mapped;
	index = msg[1]; // numbered form 1 in OSC...
	val = msg[2] / ~sonar_max;
	~p1_stem_sonar.value(index-1, val);
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

