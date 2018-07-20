OscIn oscin;
6449 => oscin.port;
"/siga/property1" => oscin.addAddress;

OscMsg msg;
SinOsc sin => dac;
0.5 => sin.gain;

while(true) {
    oscin => now;
    while(oscin.recv(msg)){
         msg.getInt(0) => int note;
        <<< "receiver2 ", note>>>;
        note => Std.mtof => sin.freq;
    }
}