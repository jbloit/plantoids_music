s.waitForBoot{
	fork{
		~path = "/home/pi/prynth/server/public/supercolliderfiles/";
		(~path++"plantoids.scd").load;
	};
};
