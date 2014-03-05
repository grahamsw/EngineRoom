
public class MonitorD extends Monitor{
    SqrOsc t => Delay d => dac;

    1 => t.gain;
    
    fun void Signal(MonitorEvent evt){
	    if (evt.label == "CPU"){
			evt.value => t.freq;
		}
		else if ("Memory" == evt.label){
			evt.value => 
		//<<<"C: " + s.freq >>>;
    }
}
