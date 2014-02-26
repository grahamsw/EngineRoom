public class Monitor {
    fun void signal(int n){        
        //Std.mtof(n) => s.freq;
    }
}

class MonitorA extends Monitor{
    SinOsc s => dac;
    1 => s.gain;
    
    fun void signal(int n) {        
        Std.mtof(n) => s.freq;
    }
}


class MonitorB extends Monitor{
    TriOsc t => JCRev r => dac;
    1 => t.gain;
    
    fun void signal(int n){        
        Std.mtof(n) => t.freq;
    }
}


class MonitorC extends Monitor{
    SqrOsc t => Delay d => dac;

    1 => t.gain;
    
    fun void signal(int n){        
        Std.mtof(n) => t.freq;
    }
}



