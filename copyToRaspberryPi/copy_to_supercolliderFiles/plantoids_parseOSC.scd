// Parse OSC and send msg values to worker functions
// Allows to decouple the OSC message parsing and the composition
// this maps analog index to worker functions

~postOSC = true;

~ldr_max = 1024;
~flex_max = 1024;
~sonar_max = 3000;
~temperature_max = 50;
~humidity_max = 50;

<<<<<<< Updated upstream
=======

/** Notes video oakland adressage sensors

GRAND PLANTOID (P1)
boitier 1
sonars x 2
0 ldr
1 ldr
2 ldr
3 ldr
4 ldr
5,6,7 : rien

boitier 2
sonars x 2
0 tilt sensor
1 tilt sensor
2 ldr
3 ldr ensoleillement
4 ldr
5 ldr
6 ldr
7 ldr


Plantoid Moyen (P2)
sonar x 2
analog
0 tilt
1 tilt
2 ldr
3 ldr
4 ldr
5 ldr
6 ldr
7 ldr

Plantoid petit  (P3)
Pareil que p2

*/



>>>>>>> Stashed changes
// ------------------------------------------  Plant 1

// the mappers directly map the sensor values to the music callbacks

// analog sensors from box 1
OSCdef(\p1_parseAnalogSensors1).free;
OSCdef(\p1_parseAnalogSensors1, {
	| msg, time, addr, port |
	var val, index, mapped, onsetState;
	index = msg[1];
	val = msg[2];

	~p1_analogMappers_box1[index].process(val);
	if (~postOSC) {postf("OSC IN  [%] - % \n", time, msg)};
}, '/plantoid/1/1/analog', n);


// analog sensors from box 2
OSCdef(\p1_parseAnalogSensors2).free;
OSCdef(\p1_parseAnalogSensors2, {
	| msg, time, addr, port |
	var val, index, mapped, onsetState;
	index = msg[1];
	val = msg[2];

	~p1_analogMappers_box2[index].process(val);
	if (~postOSC) {postf("OSC IN  [%] - % \n", time, msg)};
}, '/plantoid/1/2/analog', n);


// sonars from sensor box 1
OSCdef(\p1_parseSonars1).free;
OSCdef(\p1_parseSonars1, {
	| msg, time, addr, port |
	var val, index, mapped, onsetState;
	index = msg[1];
	val = msg[2];

	~p1_sonarMappers_box2[index].process(val);
	if (~postOSC) {postf("OSC IN  [%] - % \n", time, msg)};

}, '/plantoid/1/1/sonar', n);

// sonars from sensor box 2
OSCdef(\p1_parseSonars2).free;
OSCdef(\p1_parseSonars2, {
	| msg, time, addr, port |
	var val, index, mapped, onsetState;
	index = msg[1];
	val = msg[2];

	~p1_sonarMappers_box2[index].process(val);
	if (~postOSC) {postf("OSC IN  [%] - % \n", time, msg)};

}, '/plantoid/1/2/sonar', n);




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
