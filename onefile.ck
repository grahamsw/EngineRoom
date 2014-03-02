// extended event
class MonitorEvent extends Event{
    float value;
}

class Monitor{
    string label;
    SinOsc s => dac;
    0.5 => s.gain;
    fun void ReadValue(float val){
       val => s.freq;        
        <<< label + ": ", val>>>;
    }
}

fun int AddMonitor( Monitor monitor, MonitorEvent event){
    while( true ){
        // wait on event
        event => now;
        event.value => monitor.ReadValue;
    }
}

// the event
MonitorEvent e0;
Monitor m0;
"monitor 0" => m0.label;

MonitorEvent e1;
Monitor m1;
"monitor 1" => m1.label;

[e0, e1] @=> MonitorEvent events[];
[m0, m1] @=> Monitor monitors[];

for(0 => int i; i < monitors.cap(); 1 +=> i){
    spork~AddMonitor(monitors[i], events[i]);
}

while (true){
    1::second => now;
    Math.random2(0, 1) => int which;   
    Math.random2f(400,800) => events[which].value;
    events[which].signal();
}