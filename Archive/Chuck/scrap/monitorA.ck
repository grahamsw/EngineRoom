
public class MonitorA extends Monitor{
	SinOsc m => SinOsc s => dac;
    1 => s.gain;
	400 => s.freq;
    1 => s.sync;
	60 => m.freq;
	10 => m.gain;

    fun void Signal(MonitorEvent evt){
	    if(evt.label == "mod") {
		  evt.value => m.freq;
		}
		else if (evt.label == "freq"){
			evt.value => s.freq;
		}
		else if (evt.label == "mag"){
	//		evt.value => m.freq;
	    }   
       <<< "label: ", evt.label>>>;
       <<< "value: ", evt.value>>>;
    }    
}


