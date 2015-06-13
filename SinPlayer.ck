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

	fun void diagnostics(){
		if (1 == _dvs.ints["diagnostics"]){
			<<< "name:" + _dvs.names[0] >>>;
			for(1 => int i; i < _dvs.names.cap(); i++){
				<<< "\t" + _dvs.ints[_dvs.names[i]]>>>;
			}
		}
	}
	fun void play(){
		while(true) {
			diagnostics();
		    0.4 => sin.gain;
			_dvs.ints["freq"] => sin.freq;			
			_dvs.ints["onMs"] * 1 :: ms => now;
			0 => sin.gain;
			_dvs.ints["offMs"] * 1:: ms => now;
		}	
	}
}
