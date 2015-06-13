fun void trace(string header, string msg){
	//<<< header + ": " + msg>>>;
}
public class SinPlayer {
	SinOsc sin;
	DynamicValues _dvs;

	fun void Init(DynamicValues dvs){
	    trace("SinPlayer Name", dvs.names[0]);
		sin => dac;
		0.4 => sin.gain;
		dvs @=> _dvs;
		// must spork here, or it consumes the score thread and the score gets no further
		spork ~ play();
	}

	fun void play(){
		while(true) {
		    _dvs.ints["gain"]/1000.0 => sin.gain;
			_dvs.ints["freq"] => sin.freq;			
			_dvs.ints["onMs"] * 1 :: ms => now;
			0 => sin.gain;
			_dvs.ints["offMs"] * 1:: ms => now;
		}	
	}
}
