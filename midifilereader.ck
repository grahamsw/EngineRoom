
MidiOut mout;

1 => int port;

if (!mout.open(port)){
    <<< "can't open midi port ", port >>>;
    me.exit();
}
else {
    <<< "opened midi on port ", port >>>;
}
"midi-multi-instrument.txt" => string filename;
FileIO file;

file.open(filename, FileIO.READ);

MidiLine lr;


while(!file.eof()){
    file.readLine() => string line;
    if ( line.length() > 0){
        lr.parseLine(line);
        mout.send(lr.msg());
       // <<< lr.wait() >>>;
        if (lr.wait() > 0 ){
            lr.wait() :: ms => now;
        }
    } 
}
<<< "eof" >>>;