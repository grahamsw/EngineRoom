// this will be replaced with something generic that 
// reads a configuration file, generates the monitors, adds them, 
// and - the tricky bit - handles the event pump


// the events
MonitorEvent e0;
MonitorA m0;
"monitor 0" => m0.label;
spork~addMoonitor(m0, e0);

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

    Math.random2(0, 4) => int which;
	if (which == 0){
		"sgain" => e0.label;
		Math.random2f(0.2, 0.5) => e0.value;
	}
	else if (which ==1 ){
		"sfreq" => e0.label;
		Math.random2f(350,500) => e0.value;
	}
	else if (which == 2){
		"mfreq" => e0.label;
		Math.random2f(350, 500) => e0.value;
	}
	else if (which == 3){
	    "mgain" => e0.label;
		Math.random2f(0.4,0.65) => e0.value;
	}

	e0.signal();
}
