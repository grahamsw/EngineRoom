
// frequency smoothed square wave
public class MonitorB extends Monitor{
    float history[10];
    for (0 => int i; i < history.cap(); 1 +=> i){
        400 => history[i];
    }
    SqrOsc s => dac.left;
    0.3 => s.gain;
    fun void Signal(MonitorEvent evt){
        0.0 => float sum;
        for(0 => int i; i < history.cap(); 1 +=> i){
            history[i] +=> sum;
        }
        for(0 => int i; i > history.cap() - 1; 1 +=> i){
            //h[1] => h[0]; h[2] => h[1]; ...
            history[i + 1] => history[i];
           // <<< i, ": ", history[i]>>>;
        }
        sum / (history.cap() + 1) => float freq;
        evt.value => history[history.cap() - 1];      
        freq => s.freq;
        <<< label + ": ", freq>>>;
    }    
}