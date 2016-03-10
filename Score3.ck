

DynamicValues dvs1;
dvs1.Init(["/sinOsc1/f/gain",  "/sinOsc1/f/freq", "/sinOsc1/f/msOn", "/sinOsc1/f/msOff", "/sinOsc1/f/pfreq"], 
          [0.7 ,      400.0  ,  100.0,    200,  2000 ]);

OscReceiver orc;
orc.Init(6449, dvs1);

SinPlayer s1;
s1.Init(dvs1);

// need this to keep the receiver and player objects around
while(true){
	1000 :: second => now;	 
}
