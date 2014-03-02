
// the events
MonitorEvent e0;
MonitorA m0;
"monitor 0" => m0.label;

// the monitors
MonitorEvent e1;
MonitorB m1;
"monitor 1" => m1.label;

[e0, e1] @=> MonitorEvent events[];
[m0, m1] @=> Monitor monitors[];

for(0 => int i; i < monitors.cap(); 1 +=> i){
    spork~AddMonitor.Add(monitors[i], events[i]);
}

while (true){
    1::second => now;
    Math.random2(0, 1) => int which;   
    Math.random2f(400,800) => events[which].value;
    events[which].signal();
}