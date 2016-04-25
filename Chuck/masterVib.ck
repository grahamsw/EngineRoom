"C:/Users/grahamsw/Documents/dev/EngineRoom/Chuck/" => string dir;

// load the base classes
Machine.add(dir + "CuckLib/DynamicValues.ck");	 
Machine.add(dir + "ChuckLib/OscReceiver.ck");

// load the players
Machine.add(dir + "Players/Vib.ck");

// create instances of the players 
VibPlayer s1;
s1.Init(6449, "vib1");


// need this to keep the receiver and player objects around
while(true){
	1000 :: second => now;	 
}
