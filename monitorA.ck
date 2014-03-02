
public class MonitorA extends Monitor{
    SinOsc s => dac.right;
    0.7 => s.gain;
    fun void ReadValue(float val){
       2 * val => s.freq;        
  //     <<< label + ": ", val>>>;
    }    
}
