
public class MonitorB extends Monitor{
    TriOsc t => JCRev r => dac;
    1 => t.gain;
    
    fun void signal(int n){        
        Std.mtof(n) => t.freq;
	//	<<<"B: " + s.freq >>>;
    }
}

