MandoPlayer m;

m.init(dac);

["G", "C", "G", "D", "D", "D", "D", "G"] @=> string chords[];
[0.4, 0.4, 0.4, 0.1, 0.1, 0.1, 0.1, 0.01] @=> float durs[];
[79, 81, 83] @=>  int strums[];

0 => int i;
while( i < chords.cap() ){
    m.roll(chords[i], durs[i] :: second);
    i++;
}

0 => i;
while(i < strums.cap()){
    m.strum(strums[i++], 1.0 :: second);
}

m.damp(1.0);

m.roll("G", 0.02 :: second);
2.0 :: second => now;

m.damp(0.01);
1.0 :: second => now;
