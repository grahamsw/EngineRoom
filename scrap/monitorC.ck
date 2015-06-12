
public class MonitorC extends Monitor{
    SqrOsc t => dac;

    1 => t.gain;
    
    fun void Signal(MonitorEvent evt){        
        evt.value => t.freq;
		<<<label + " " +evt.value >>>;
    }
}
