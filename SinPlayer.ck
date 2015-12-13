
public class SinPlayer {
	SinOsc sin;

	DynamicValues _dvs;

	fun void Init(DynamicValues dvs){
		sin =>  dac;
		dvs @=> _dvs;
		// must spork here, or it consumes the score thread and the score gets no further
		spork ~ play();
	}

	fun void play(){
		while(true) {
		    _dvs._vals["f/gain"] => sin.gain;
			_dvs._vals["f/freq"] => sin.freq;			
			_dvs._vals["f/msOn"] :: ms => now;
			0 => sin.gain;
			_dvs._vals["f/msOff"] :: ms => now;
		}	
	}
}
