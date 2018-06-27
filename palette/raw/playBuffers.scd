~samplesDir = thisProcess.nowExecutingPath.dirname +/+ "../soundfiles";

~b0 = Buffer.read(s, ~samplesDir +/+ "tic.aif");
~b1 = Buffer.read(s, ~samplesDir +/+ "tac.aif");
~b0.play;
~b1.play;