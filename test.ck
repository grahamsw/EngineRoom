SinOsc osc => dac;

400.0 => osc.freq;

0.8 => osc.gain;

while (true){
    1::second => now;
}