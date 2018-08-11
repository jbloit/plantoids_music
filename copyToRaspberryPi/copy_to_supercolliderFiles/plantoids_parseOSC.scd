// Parse OSC and send msg values to worker functions
// Allows to decouple the OSC message parsing and the composition
// this maps analog index to worker functions

~postOSC = false;

~ldr_max = 1024;
~flex_max = 1024;
~sonar_max = 3000;
~temperature_max = 50;
~humidity_max = 50;

// ------------------------------------------  Plant 1

// the mappers directly map the sensor values to the music callbacks


OSCdef(\p1_parseAnalogSensors).free;
OSCdef(\p1_parseAnalogSensors, {
	| msg, time, addr, port |
	var val, index, mapped, onsetState;
	index = msg[1];
	val = msg[2];

	~p1_analogMappers[index].process(val);
	if (~postOSC) {postf("OSC IN  [%] - % \n", time, msg)};
}, '/plantoid/1/1/analog', n);



OSCdef(\p1_parseSonars).free;
OSCdef(\p1_parseSonars, {
	| msg, time, addr, port |
	var val, index, mapped, onsetState;
	index = msg[1];
	val = msg[2];

	~p1_sonarMappers[index].process(val);
	if (~postOSC) {postf("OSC IN  [%] - % \n", time, msg)};

}, '/plantoid/1/1/sonar', n);




OSCdef(\p1_parseTemperature).free;
OSCdef(\p1_parseTemperature, {
	| msg, time, addr, port |
	var val;
	val = msg[2] ;
	~p1_temperatureMapper.process(val);

	if (~postOSC) {postf("OSC IN  [%] - % \n", time, msg)};
}, '/plantoid/1/1/temp', n);




OSCdef(\p1_parseHumidity).free;
OSCdef(\p1_parseHumidity, {
	| msg, time, addr, port |
	var val;
	val = msg[2];
	~p1_humidityMapper.process(val);

	if (~postOSC) {postf("OSC IN  [%] - % \n", time, msg)};
}, '/plantoid/1/1/hum', n);


// ------------------------------------------  Plant 2


OSCdef(\p2_parseAnalogSensors).free;
OSCdef(\p2_parseAnalogSensors, {
	| msg, time, addr, port |

	var val, index, mapped, onsetState;
	index = msg[1];
	val = msg[2] ;

	~p2_analogMappers[index].process(val);

	if (~postOSC) {postf("OSC IN  [%] - % \n", time, msg)};

}, '/plantoid/2/1/analog', n);



OSCdef(\p2_parseSonars).free;
OSCdef(\p2_parseSonars, {
	| msg, time, addr, port |
	var val, index, mapped, onsetState;
	index = msg[1];
	val = msg[2];

	~p2_sonarMappers[index].process(val);

	if (~postOSC) {postf("OSC IN  [%] - % \n", time, msg)};

}, '/plantoid/2/1/sonar', n);



// ------------------------------------------  Plant 3



OSCdef(\p3_parseAnalogSensors).free;
OSCdef(\p3_parseAnalogSensors, {
	| msg, time, addr, port |

	var val, index, mapped, onsetState;
	index = msg[1];
	val = msg[2] ;

	~p3_analogMappers[index].process(val);

	if (~postOSC) {postf("OSC IN  [%] - % \n", time, msg)};

}, '/plantoid/3/1/analog', n);



OSCdef(\p3_parseSonars).free;
OSCdef(\p3_parseSonars, {
	| msg, time, addr, port |
	var val, index, mapped, onsetState;
	index = msg[1];
	val = msg[2];

	~p3_sonarMappers[index].process(val);

	if (~postOSC) {postf("OSC IN  [%] - % \n", time, msg)};

}, '/plantoid/3/1/sonar', n);


"sensorMapping_basic.scd".loadRelative(true, {"loaded parse OSC".postln});
