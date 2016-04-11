

DynamicValues dvs1;
			
			
dvs1.Init(["f/lpf/freq","f/lpf/Q","f/gain","f/freq","f/msOn","f/vibratoFreq","f/vibratoGain","f/msOff"], 
          [300.0, 1.0, 0.5, 600.0, 100.0, 5.0, 20.0, 100.0 ]);

OscReceiver orc;
orc.Init(6449, "vib1", dvs1);

VibPlayer s1;
s1.Init(dvs1);

// need this to keep the receiver and player objects around
while(true){
	1000 :: second => now;	 
}
