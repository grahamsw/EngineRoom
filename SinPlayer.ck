public class SinPlayer {
	SinOsc sin;
	DynamicValues _dvs;


	fun void Init(DynamicValues dvs){
		sin => dac;
		0.4 => sin.gain;
		dvs @=> _dvs;
	}

	fun void play(){
		while(true) {
		    0.4 => sin.gain;
			_dvs.floats["freq"] => sin.freq;			
			_dvs.ints["onMs"] * 1 :: ms => now;
			0 => sin.gain;
			_dvs.ints["offMs"] * 1:: ms => now;
		}	
	}
}
