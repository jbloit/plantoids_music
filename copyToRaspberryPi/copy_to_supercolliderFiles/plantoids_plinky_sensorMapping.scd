// ALT PLINKY SENSOR MAPPERS
// trig ldrs with keys instead of maracas

// ------------------------------------------  Plant 3 (BIG PLANTOID)

~p3_analogMappers_box1 = [
	//0
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p3_stem_light, noteIndex:0, quant:0),
	//1
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p3_stem_light, noteIndex:1, quant:0),
	//2
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p3_stem_light, noteIndex:2, quant:0),
	//3
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p3_stem_light, noteIndex:3, quant:0),
	//4
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p3_stem_light, noteIndex:4, quant:0),


	// 5,6,7: NOT USED
	//5
	SensorMaracas.new(inputMax:~ldr_max, thresh:0.1, filterOrder:10, musicCallback: ~p3_stem_light, noteIndex:-1, quant:1/8),
	//6
	SensorMaracas.new(inputMax:~ldr_max, thresh:0.1, filterOrder:10, musicCallback: ~p3_stem_light, noteIndex:-1, quant:1/8),
	//7
	SensorMaracas.new(inputMax:~ldr_max, thresh:0.1, filterOrder:10, musicCallback: ~p3_stem_light, noteIndex:-1, quant:1/8),
];

~p3_analogMappers_box2 = [
	//0
	SensorKey.new(inputMax:~flex_max, thresh:0.1, musicCallback: ~p3_flower_flexQuake, noteIndex:0, quant:0),
	//1
	SensorKey.new(inputMax:~flex_max, thresh:0.1, musicCallback: ~p3_flower_flexQuake, noteIndex:1, quant:0),
	//2
	SensorKey.new(inputMax:~ldr_max, thresh:0.1,  musicCallback: ~p3_stem_light, noteIndex:5, quant:0),
	//3
	SensorKey.new(inputMax:~ldr_max, thresh:0.1,  musicCallback: ~p3_flower_ambientLight, noteIndex:0, quant:0),
	//4
	SensorKey.new(inputMax:~ldr_max, thresh:0.1,  musicCallback: ~p3_stem_light, noteIndex:6, quant:0),
	//5
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p3_stem_light, noteIndex:7, quant:0),
	//6
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p3_stem_light, noteIndex:8, quant:0),
	//7
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p3_stem_light, noteIndex:9, quant:0),
];

~p3_sonarMappers_box1  = [
	SensorKey.new(inputMax:~sonar_max, thresh:0.1, musicCallback: ~p3_stem_sonar, noteIndex:0, quant:0),
	SensorKey.new(inputMax:~sonar_max, thresh:0.1, musicCallback: ~p3_stem_sonar, noteIndex:1, quant:0),
];

~p3_sonarMappers_box2  = [
	SensorKey.new(inputMax:~sonar_max, thresh:0.1, musicCallback: ~p3_stem_sonar, noteIndex:2, quant:0),
	SensorKey.new(inputMax:~sonar_max, thresh:0.1, musicCallback: ~p3_stem_sonar, noteIndex:3, quant:0),
];

~p3_temperatureMapper = SensorKey.new(inputMax:~temperature_max, thresh:0.1, musicCallback: ~p3_flower_temperature, noteIndex:0, quant:0);

~p3_humidityMapper = SensorKey.new(inputMax:~humidity_max, thresh:0.1, musicCallback: ~p3_flower_humidity, noteIndex:0, quant:0);



// ------------------------------------------  Plant 2 (MEDIUM PLANTOID)

~p2_analogMappers = [
	//0
	SensorKey.new(inputMax:~flex_max, thresh:0.1, musicCallback: ~p2_flower_flexQuake, noteIndex:0, quant:0),
	//1
	SensorKey.new(inputMax:~flex_max, thresh:0.1, musicCallback: ~p2_flower_flexQuake, noteIndex:1, quant:0),
	//2
	SensorKey.new(inputMax:~ldr_max, thresh:0.1,  musicCallback: ~p2_stem_light, noteIndex:0, quant:0),
	//3
	SensorKey.new(inputMax:~ldr_max, thresh:0.1,  musicCallback: ~p2_stem_light, noteIndex:1, quant:0),
	//4
	SensorKey.new(inputMax:~ldr_max, thresh:0.1,  musicCallback: ~p2_stem_light, noteIndex:2, quant:0),
	//5
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p2_stem_light, noteIndex:3, quant:0),
	//6
	SensorKey.new(inputMax:~ldr_max, thresh:0.1,  musicCallback: ~p2_stem_light, noteIndex:4, quant:0),
	//7
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p2_stem_light, noteIndex:5, quant:0),

];

~p2_sonarMappers  = [
	SensorKey.new(inputMax:~sonar_max, thresh:0.1, musicCallback: ~p2_stem_sonar, noteIndex:0, quant:0),
	SensorKey.new(inputMax:~sonar_max, thresh:0.1, musicCallback: ~p2_stem_sonar, noteIndex:1, quant:0),
];


// ------------------------------------------  Plant 1 (SMALL PLANTOID)

~p1_analogMappers = [
	//0
	SensorKey.new(inputMax:~flex_max, thresh:0.1, musicCallback: ~p1_flower_flexQuake, noteIndex:0, quant:0),
	//1
	SensorKey.new(inputMax:~flex_max, thresh:0.1, musicCallback: ~p1_flower_flexQuake, noteIndex:1, quant:0),
	//2
	SensorKey.new(inputMax:~ldr_max, thresh:0.1,  musicCallback: ~p1_stem_light, noteIndex:0, quant:0),
	//3
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p1_stem_light, noteIndex:1, quant:0),
	//4
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p1_stem_light, noteIndex:2, quant:0),
	//5
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p1_stem_light, noteIndex:3, quant:0),
	//6
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p1_stem_light, noteIndex:4, quant:0),
	//7
	SensorKey.new(inputMax:~ldr_max, thresh:0.1, musicCallback: ~p1_stem_light, noteIndex:5, quant:0),

];

~p1_sonarMappers  = [
	SensorKey.new(inputMax:~sonar_max, thresh:0.1, musicCallback: ~p1_stem_sonar, noteIndex:0, quant:0),
	SensorKey.new(inputMax:~sonar_max, thresh:0.1, musicCallback: ~p1_stem_sonar, noteIndex:1, quant:0),
];
