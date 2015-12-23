
public class SinPlayer {
	SinOsc sin;
	BiQuad f;

	DynamicValues _dvs;

	fun void Init(DynamicValues dvs){
		// set biquad pole radius
		.99 => f.prad;
		// set biquad gain
		.05 => f.gain;
		// set equal zeros 
		1 => f.eqzs;

		sin => f => dac;
		dvs @=> _dvs;
		// must spork here, or it consumes the score thread and the score gets no further
		spork ~ play();
	}

	fun void play(){
		while(true) {
			_dvs._vals["f/pfreq"] => f.pfreq;
		    _dvs._vals["f/gain"] => sin.gain;
			_dvs._vals["f/freq"] => sin.freq;			
			_dvs._vals["f/msOn"] :: ms => now;
			0 => sin.gain;
			_dvs._vals["f/msOff"] :: ms => now;
		}	
	}
}
