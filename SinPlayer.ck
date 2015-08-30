
public class SinPlayer {
	SinOsc sin;
	//ResonZ filt;
	LPF lp;

	DynamicValues _dvs;

	fun void Init(DynamicValues dvs){
		sin => lp => dac;
		dvs @=> _dvs;
		// must spork here, or it consumes the score thread and the score gets no further
		spork ~ play();
	}

	fun void play(){
		while(true) {
		    _dvs.ints["lpq"]/1000.0 => lp.Q;
		    _dvs.ints["lpg"]/1000.0 => lp.gain;
		    _dvs.ints["lpf"] => lp.freq;
		    _dvs.ints["gain"]/1000.0 => sin.gain;
			_dvs.ints["freq"] => sin.freq;			
			_dvs.ints["onMs"] * 1 :: ms => now;
			0 => sin.gain;
			_dvs.ints["offMs"] * 1:: ms => now;
		}	
	}
}
