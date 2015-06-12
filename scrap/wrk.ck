<<< me.dir() >>>;
Machine.add(me.dir() + "/range.ck");

Range rangeUp;
(0.1, 0.2, 10) => rangeUp.init;

Range rangeDown;
(0.2, 0.1, 10) => rangeDown.init;

SinOsc s => Envelope e => dac;
400.0 => s.freq;
0.8 => s.gain;

0 => int i;
while(true){
    float envTime;
    i % 20  => int step;
    string updown;
    if (step <= 10){
       step => rangeUp.step => envTime;
       "up" => updown;
    }
    else {
        step - 10 => rangeDown.step => envTime;
        "down" => updown;
    }
    <<< i, step, step - 10, updown, envTime>>>;
    1 +=> i;
    envTime => e.time;
    1 => e.keyOn;
    0.1:: second => now;
    1 => e.keyOff;
    0.05 :: second => now;
}

