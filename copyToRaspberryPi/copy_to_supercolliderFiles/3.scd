CmdPeriod.run;
currentEnvironment.clear;
s.quit;
s.boot;
s.waitForBoot{
	~path = "/home/pi/prynth/server/public/supercolliderfiles/";
	(~path++"bubbles.scd").load;
};