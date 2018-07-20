
<<< "in Vib.ck" >>>;

public class VibPlayer {

	
	SinOsc vibrato => SawOsc viol => ADSR env => LPF lpf => dac;
	env.set(0.1 :: second, 0.1 :: second, 0.5, 0.1 :: second);	  
	2 => viol.sync;

	DynamicValues _dvs;
	OscReceiver _orc;

	fun void Init(int port, string instanceName){

		_dvs.Init(["f/lpf/freq","f/lpf/Q","f/gain","f/freq","f/msOn","f/vibratoFreq","f/vibratoGain","f/msOff"], 
                  [300.0, 1.0, 0.5, 600.0, 100.0, 5.0, 20.0, 100.0 ]);
		_orc.Init(port, instanceName, _dvs);
		// must spork here, or it consumes the score thread and the score gets no further
		spork ~ play();
	
}
	fun void play(){
		while(true) {
			1 => env.keyOn;					   
			_dvs._vals["f/lpf/freq"] => lpf.freq;
			_dvs._vals["f/lpf/Q"] => lpf.Q;

		    _dvs._vals["f/gain"] => viol.gain;
			_dvs._vals["f/freq"] => viol.freq;			
			_dvs._vals["f/msOn"] :: ms => now;			  
			_dvs._vals["f/vibratoFreq"] => vibrato.freq;	
			_dvs._vals["f/vibratoGain"] => vibrato.gain;			
			1 => env.keyOff;
			_dvs._vals["f/msOff"] :: ms => now;
		}	
	}

}

