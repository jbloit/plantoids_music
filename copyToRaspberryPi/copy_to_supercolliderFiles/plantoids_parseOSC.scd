// Parse OSC and send msg values to worker functions
// Allows to decouple the OSC message parsing and the composition
// this maps analog index to worker functions

OSCdef.clear;

currentEnvironment.clear;

~postOSC = true;

~ldr_max = 1024;
~flex_max = 1024;
~sonar_max = 3000;
~temperature_max = 50;
~humidity_max = 50;


// ------------------------------------------  Plant 3 (BIG PLANTOID)

// the mappers directly map the sensor values to the music callbacks

// analog sensors from box 1
OSCdef(\p3_parseAnalogSensors1).free;
OSCdef(\p3_parseAnalogSensors1, {
	| msg, time, addr, port |
	var val, index, mapped, onsetState;
	index = msg[1];
	val = msg[2];

		if (~postOSC) {postf("OSC IN  [%] - % \n", time, msg)};

	~p3_analogMappers_box1[index].process(val);

}, '/plantoid/3/1/analog', n);


// analog sensors from box 2
OSCdef(\p3_parseAnalogSensors2).free;
OSCdef(\p3_parseAnalogSensors2, {
	| msg, time, addr, port |
	var val, index, mapped, onsetState;
	index = msg[1];
	val = msg[2];
	if (~postOSC) {postf("OSC IN  [%] - % \n", time, msg)};

	~p3_analogMappers_box2[index].process(val);

}, '/plantoid/3/2/analog', n);


// sonars from sensor box 1
OSCdef(\p3_parseSonars1).free;
OSCdef(\p3_parseSonars1, {
	| msg, time, addr, port |
	var val, index, mapped, onsetState;
	index = msg[1];
	val = msg[2];

	if (~postOSC) {postf("OSC IN  [%] - % \n", time, msg)};

	~p3_sonarMappers_box1[index].process(val);


}, '/plantoid/3/1/sonar', n);

// sonars from sensor box 2
OSCdef(\p3_parseSonars2).free;
OSCdef(\p3_parseSonars2, {
	| msg, time, addr, port |
	var val, index, mapped, onsetState;
	index = msg[1];
	val = msg[2];

	if (~postOSC) {postf("OSC IN  [%] - % \n", time, msg)};

	~p3_sonarMappers_box2[index].process(val);

}, '/plantoid/3/2/sonar', n);


OSCdef(\p3_parseTemperature).free;
OSCdef(\p3_parseTemperature, {
	| msg, time, addr, port |
	var val;
	val = msg[2] ;
	if (~postOSC) {postf("OSC IN  [%] - % \n", time, msg)};

	~p3_temperatureMapper.process(val);

}, '/plantoid/3/1/temp', n);




OSCdef(\p3_parseHumidity).free;
OSCdef(\p3_parseHumidity, {
	| msg, time, addr, port |
	var val;
	val = msg[2];
	if (~postOSC) {postf("OSC IN  [%] - % \n", time, msg)};

	~p3_humidityMapper.process(val);

}, '/plantoid/3/1/hum', n);


// ------------------------------------------  Plant 2 (MEDIUM PLANTOID)


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



// ------------------------------------------  Plant 1 (SMALL PLANTOID)



OSCdef(\p1_parseAnalogSensors).free;
OSCdef(\p1_parseAnalogSensors, {
	| msg, time, addr, port |

	var val, index, mapped, onsetState;
	index = msg[1];
	val = msg[2] ;

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


"sensorMapping_basic.scd".loadRelative(true, {"loaded parse OSC".postln});
