

SimpleOscReceiver r1;
SimpleOscReceiver r2;
SimpleOscReceiver r3;


r1.Init(6449, "/sinOsc1/f/msOn");
r2.Init(6449, "/sinOsc1/f/msOff");
r2.Init(6449, "/sinOsc1/f/freq");


// need this to keep the receiver and player objects around
while(true){
	1000 :: second => now;
}