
public class MonitorD extends Monitor{
    SqrOsc t => Delay d => dac;

    1 => t.gain;
    
    fun void signal(int n){
	    if (        
        Std.mtof(n) => t.freq;
		//<<<"C: " + s.freq >>>;
    }
}
