// PLINKY SENSOR MAPPERS

~p1_sonarMappers  = [
	SensorKey.new(inputMax:~sonar_max, thresh:0.1,  musicCallback: ~p1_stem_sonar, noteIndex:0, quant:0),
	SensorKey.new(inputMax:~sonar_max, thresh:0.1,  musicCallback: ~p1_stem_sonar, noteIndex:1, quant:0),
	SensorKey.new(inputMax:~sonar_max, thresh:0.1,  musicCallback: ~p1_stem_sonar, noteIndex:2, quant:0),
	SensorKey.new(inputMax:~sonar_max, thresh:0.1,  musicCallback: ~p1_stem_sonar, noteIndex:3, quant:0),
];


~p3_sonarMappers  = [
	SensorMaracas.new(inputMax:~sonar_max, thresh:0.1, filterOrder:10, musicCallback: ~p3_stem_sonar, noteIndex:0, quant:1),
	SensorMaracas.new(inputMax:~sonar_max, thresh:0.1, filterOrder:10, musicCallback: ~p3_stem_sonar, noteIndex:1, quant:1),
];