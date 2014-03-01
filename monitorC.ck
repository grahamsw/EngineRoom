
public class MonitorC extends Monitor{
    SqrOsc t => Delay d => dac;

    1 => t.gain;
    
    fun void signal(int n){        
        Std.mtof(n) => t.freq;
		//<<<"C: " + s.freq >>>;
    }
}
