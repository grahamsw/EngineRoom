
public class MonitorA extends Monitor{
    SinOsc s => dac.right;
    0.7 => s.gain;
    fun void Signal(MonitorEvent evt){
       2 * evt.value => s.freq;        
       <<< label + ": ", evt.value>>>;
    }    
}
