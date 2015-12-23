

DynamicValues dvs1;
dvs1.Init(["f/gain",  "f/freq", "f/msOn", "f/msOff", "f/pfreq"], 
          [0.7 ,      400.0  ,  100.0,    200, 2000 ]);

OscReceiver orc;
orc.Init(6449, "sinOsc1", dvs1);

SinPlayer s1;
s1.Init(dvs1);

// need this to keep the receiver and player objects around
while(true){
	1000 :: second => now;	 
}
