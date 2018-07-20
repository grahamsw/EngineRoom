MidiOut mout;

1 => int port;

if (!mout.open(port)){
    <<< "can't open midi port ", port >>>;
    me.exit();
}
else {
    <<< "opened midi on port ", port >>>;
}

MidiMsg msg;

[60, 65, 65, 60, 70, 75] @=> int notes[];

fun void MIDInote(int onoff, int note, int velocity){
    if (onoff == 0){
        0x3A => msg.data1;
    }
    else {
        144 => msg.data1;
    }
    note => msg.data2;
    velocity => msg.data3;
  //  144 => msg.data1;
  //  0x64 => msg.data2;
   // 90 => msg.data3;
    mout.send(msg);
}
0 => int i;
while (true) {
    notes[i++ % notes.cap()] => int note;
   // Math.random2(60,100) => int note;
    Math.random2(30, 127) => int velocity;
    if ( i % notes.cap() == 1) {
        70 => velocity;
    }
    else {
        60 => velocity;
    }
    MIDInote(1, note, velocity);
    MIDInote(1, note + 7, velocity);
    MIDInote(1, note + 9, velocity);
    .05:: second => now;
    MIDInote(0, note, velocity);
    MIDInote(0, note + 7, velocity);
    MIDInote(0, note + 9, velocity);
    .05::second => now;
}