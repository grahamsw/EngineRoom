MidiOut mout;
1 => int port;

if (!mout.open(port)){
    <<< "can't open midi port ", port >>>;
    me.exit();
}
else {
    <<< "opened midi on port ", port >>>;
}

fun void SendMsgs(MidiMsg msgs[]){
    for(0 => int i; i < msgs.cap(); i++){
        mout.send(msg);
    }
}



