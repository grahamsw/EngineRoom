// this will be replaced with something generic that 
// reads a configuration file, generates the monitors, adds them, 
// and - the tricky bit - handles the event pump


// the events
MonitorEvent e0;
MonitorA m0;
"monitor 0" => m0.label;

// the monitors
//MonitorEvent e1;
//MonitorB m1;
//"monitor 1" => m1.label;

// [e0, e1] @=> MonitorEvent events[];
// [m0, m1] @=> Monitor monitors[];

//for(0 => int i; i < monitors.cap(); 1 +=> i){
//    spork~AddMonitor.Add(monitors[i], events[i]);
// }
spork~AddMonitor.Add(m0, e0);

while (true){
    1::second => now;

    Math.random2(1, 3) => int which;
	if (which == 0){
		"mag" => e0.label;
		Math.random2f(100, 200) => e0.value;
	}
	else if (which ==1 ){
		"mod" => e0.label;
		Math.random2f(5,7) => e0.value;
	}
	else if (which == 2){
		"freq" => e0.label;
		Math.random2f(400, 800) => e0.value;
	}

	e0.signal();
}
