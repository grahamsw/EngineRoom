"C\\:/Users/shyguy/Documents/gsw/dev/EngineRoom/" => string root;

 

MonitorEvent evt[3];
MonitorEvent evt0 @=> evt[0];
MonitorEvent evt1 @=> evt[1];
MonitorEvent evt2 @=> evt[2];




MonitorA ms0  @=>  Monitor m0;
MonitorB ms1  @=> Monitor m1;
MonitorC ms2  @=> Monitor m2;

Monitor mss[3];
m0 @=> mss[0];
m1 @=> mss[1];
m2 @=> mss[2];



// random event simulation
[10::ms, 1::second, 10::samp] @=> dur duration[];

while(true){
        Math.random2(0, 2) => int i;
        Math.random2(60, 100) => evt[i].reading;

        evt[i].signal();
        duration[Math.random2(0,2)] => dur d;
		<<< i  + ", " + evt[i].reading >>>;
        d => now;
}
 