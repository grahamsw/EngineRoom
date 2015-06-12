

public class Settings1 {
	fun void listen(){
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
				if (addr == "/siga/bpm" ) {
					msg.getInt(0) => bpm;
					<<< addr, bpm >>>;
				}
				else if ( addr == "/siga/pitch") {
					msg.getInt(0) => pitch;
					<<< addr, pitch >>>;
				}
				else if ( addr == "/siga/gain") {
					msg.getFloat(0) => gain;
					<<< addr, gain >>>;
				}    
			}
		}
	}

	fun void Init(){
		spork ~ listen();		
	}

	int bpm;
	int pitch;
	float gain;

	fun play(){
		while (true) {
		
		}
	
	}

}