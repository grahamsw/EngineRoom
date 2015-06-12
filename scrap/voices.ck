VoicForm singer => dac;

0.05 => singer.vibratoGain;

[40, 42, 44, 45, 47, 45, 44, 42] @=> int scale[];

Std.mtof(scale[0]) => singer.freq;

11 => singer.phonemeNum;

1 => singer.noteOn;
0 => int note;

while(note < scale.cap()){
    dipth("lll", "ahh", scale[note]);
    1 +=> note;
}

dipth("lll", "ahh", scale[0]);
0.15 => singer.vibratoGain;
2.0::second => now;
1 => singer.noteOff;

0.2 :: second => now;

fun void dipth(string phoneme0, string phoneme1, int note){
    phoneme0 => singer.phoneme;
    0.1::second => now;
    phoneme1 => singer.phoneme;
    Std.mtof(note) => singer.freq;
    0.4::second => now;
}