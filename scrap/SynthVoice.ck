SawOsc folds => ResonZ formant1 => dac;

folds => ResonZ formant2 => dac;
folds => ResonZ formant3 => dac;

SinOsc vibrato => folds;
6.0 => vibrato.freq;
1.5 => vibrato.gain;

2 => folds.sync;

20 => formant1.Q => formant2.Q => formant3.Q;

while (1) {
    Math.random2f(500,500) => formant1.freq;
    Math.random2f(1000, 1000) => formant2.freq;
    Math.random2f(3000,3000) => formant3.freq;
    
    if (Math.random2(0,3) == 0){
        Math.random2f(100.0, 200.0) => folds.freq;
    }
    Math.random2f(0.4, 0.5) :: second => now;
}