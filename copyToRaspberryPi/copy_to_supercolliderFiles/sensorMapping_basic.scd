// DEFAULT SENSOR MAPPERS
// These map the continous sensor values into discrete events, which are sent to callbacks in a music scene.
// Add different values for this at the end of your music scene, to override these values.

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

~p1_sonarMappers  = [
	SensorMaracas.new(inputMax:~sonar_max, thresh:0.1, filterOrder:10, musicCallback: ~p1_stem_sonar, noteIndex:0, quant:1/4),
	SensorMaracas.new(inputMax:~sonar_max, thresh:0.1, filterOrder:10, musicCallback: ~p1_stem_sonar, noteIndex:1, quant:1/4),
	SensorMaracas.new(inputMax:~sonar_max, thresh:0.1, filterOrder:10, musicCallback: ~p1_stem_sonar, noteIndex:2, quant:1/4),
	SensorMaracas.new(inputMax:~sonar_max, thresh:0.1, filterOrder:10, musicCallback: ~p1_stem_sonar, noteIndex:3, quant:1/8),
];


~p1_temperatureMapper = SensorKey.new(inputMax:~temperature_max, thresh:0.1, musicCallback: ~p1_flower_temperature, noteIndex:0, quant:0);

~p1_humidityMapper = SensorKey.new(inputMax:~humidity_max, thresh:0.1, musicCallback: ~p1_flower_humidity, noteIndex:0, quant:0);




// ------------------------------------------  Plant 2

~p2_analogMappers = [
	//0
	SensorKey.new(inputMax:~flex_max, thresh:0.1, musicCallback: ~p2_flower_flexQuake, noteIndex:0, quant:0),
	//1
	SensorKey.new(inputMax:~ldr_max, thresh:0.3, musicCallback: ~p2_leaves_light, noteIndex:0, quant:1/8),
	//2
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p2_leaves_light, noteIndex:1, quant:1/8),
	//3
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p2_stem_light, noteIndex:0, quant:1/8),
	//4
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p2_stem_light, noteIndex:1, quant:1/8),
	//5
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p2_stem_light, noteIndex:2, quant:1/8),
	//6
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p2_stem_light, noteIndex:3, quant:1/8),
	//7
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p2_stem_light, noteIndex:4, quant:1/8),

];

~p2_sonarMappers  = [
	SensorMaracas.new(inputMax:~sonar_max, thresh:0.1, filterOrder:10, musicCallback: ~p2_stem_sonar, noteIndex:0, quant:1/8),
	SensorMaracas.new(inputMax:~sonar_max, thresh:0.1, filterOrder:10, musicCallback: ~p2_stem_sonar, noteIndex:1, quant:1/8),
	SensorMaracas.new(inputMax:~sonar_max, thresh:0.1, filterOrder:10, musicCallback: ~p2_stem_sonar, noteIndex:2, quant:1/8),
	SensorMaracas.new(inputMax:~sonar_max, thresh:0.1, filterOrder:10, musicCallback: ~p2_stem_sonar, noteIndex:3, quant:1/8),
];


// ------------------------------------------  Plant 3

~p3_analogMappers = [
	//0
	SensorKey.new(inputMax:~flex_max, thresh:0.1, musicCallback: ~p3_flower_flexQuake, noteIndex:0, quant:0),
	//1
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p3_flower_light, noteIndex:0, quant:1/8),
	//2
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p3_flower_light, noteIndex:1, quant:1/8),
	//3
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p3_flower_light, noteIndex:2, quant:1/8),
	//4
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p3_flower_light, noteIndex:3, quant:1/8),
	//5
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p3_flower_light, noteIndex:4, quant:1/8),
	//6
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p3_flower_light, noteIndex:5, quant:1/8),
	//7
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p3_leaves_light, noteIndex:0, quant:0),
	//8
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p3_leaves_light, noteIndex:1, quant:0),

];

~p3_sonarMappers  = [
	SensorMaracas.new(inputMax:~sonar_max, thresh:0.1, filterOrder:10, musicCallback: ~p3_stem_sonar, noteIndex:0, quant:1/8),
	SensorMaracas.new(inputMax:~sonar_max, thresh:0.1, filterOrder:10, musicCallback: ~p3_stem_sonar, noteIndex:1, quant:1/8),
];
