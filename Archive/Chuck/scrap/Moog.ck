Moog mog => dac;

0.5 => float vibratoGain;

[77] @=> int cars[];

while(true){
    for(0 => int i; i < cars.cap(); i++){
            play(cars[i], 10);
        
    }
}


fun void play(int note, float howLong){
    vibratoGain => mog.vibratoGain;
    Std.mtof(note) => mog.freq;
    1 => mog.noteOn;
    (howLong - 0.5) :: second => now;
    1 => mog.noteOff;
    0.5 :: second => now;
}