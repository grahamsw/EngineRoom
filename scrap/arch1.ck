


SinOsc sin => dac;
0.8 => sin.gain;
1700.0 => sin.freq;
0.2 :: second => dur pause1;
0.8 :: second => dur pause2;

while (true){
	pause1 => now;
	0.0 => sin.gain;
	pause2 => now;	
	0.8 => sin.gain;	
}