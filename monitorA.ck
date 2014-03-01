public class MonitorA extends Monitor{
    SinOsc s => dac;
    1 => s.gain;
    
    fun void signal(int n) {        
        Std.mtof(n) => s.freq;
	//	<<<"A: " + s.freq >>>;

    }
}

