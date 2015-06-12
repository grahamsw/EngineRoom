
SinOsc s1 =>  dac;
SinOsc s2 => dac;
SinOsc s3 => dac;


0.3 => s1.gain;
0.3 => s2.gain;
0.2 => s3.gain;


fun void chord(string ch, int note, float howLong){
    Std.mtof(note) => s1.freq;
    Std.mtof(note + 3) => s2.freq;
    Std.mtof(note + 7) => s3.freq;
    howLong :: second => now;
}

[70, 72, 74, 75, 77, 75, 74, 72] @=> int scale[];

for(0 => int i; i < scale.cap(); i++){
    chord("", scale[i], 1);
}
    
    