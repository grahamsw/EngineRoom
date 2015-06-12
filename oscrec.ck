OscIn oscin;
6449 => oscin.port;
"/siga/bpm" => oscin.addAddress;
"/siga/gain" => oscin.addAddress;
"/siga/pitch" => oscin.addAddress;

OscMsg msg;

while(true) {
    oscin => now;
    while(oscin.recv(msg)){
        msg.address => string addr;
        if (addr == "/siga/bpm" )
		|| addr == "/siga/pitch") {
            <<< addr, msg.getInt(0) >>>;
        }
        else if ( addr == "/siga/gain") {
            <<< addr, msg.getFloat(0) >>>;
        }    
    }
}

