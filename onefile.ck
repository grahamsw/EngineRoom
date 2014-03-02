// extended event
class MonitorEvent extends Event{
    float value;
}

class Monitor{
    float value;
    SinOsc s => dac;
    0.5 => s.gain;
    fun void ReadValue(float val){
       val => value;
       val => s.freq;
    }
}

fun int AddMonitor( Monitor monitor, MonitorEvent event, string label ){
    while( true ){
        // wait on event
        event => now;
        event.value => monitor.ReadValue;
        <<< label + ": ", event.value>>>;
    }
}

// the event
MonitorEvent e0;
Monitor m0;

MonitorEvent e1;
Monitor m1;

spork~AddMonitor(m0, e0, "monitor 0");
spork~AddMonitor(m1, e1, "monitor 1");

while (true){
    1::second => now;
    if( Math.random2(0, 1)){
        Math.random2f(400,800) => e0.value;
        e0.signal();
    }
    else {
        Math.random2f(1000,1600) => e1.value;
        e1.signal();
    }
        
}