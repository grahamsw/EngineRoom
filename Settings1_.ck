

public class Settings1 {
  
	int _port;
	string _msgHeader;

	SinOsc sin;
	int bpm;
	int pitch;
	float gain;
	
		
	fun void listen(){
		OscIn oscin;
		_port => oscin.port;
		"/" + _msgHeader + "/bpm" => oscin.addAddress;
		"/" + _msgHeader + "/gain" => oscin.addAddress;
		"/" + _msgHeader + "/pitch" => oscin.addAddress;

		OscMsg msg;

		while(true) {
			oscin => now;
			while(oscin.recv(msg)){
				msg.address => string addr;
				if (addr == "/" + _msgHeader + "/bpm" ) {
					msg.getInt(0) => bpm;
				}
				else if ( addr == "/" + _msgHeader + "/pitch") {
					msg.getInt(0) => pitch;
				}
				else if ( addr == "/" + _msgHeader + "/gain") {
					msg.getFloat(0) => gain;
				}    
			}
		}
	}

	fun void Init(int port, string msgHeader){
		port => _port;// 6449
		msgHeader => _msgHeader;
		100 => bpm;
		800 => pitch;
		0.4 => gain;
		sin => dac;

		spork ~ listen();		
		spork ~ play();
	}
	

	fun void play(){
		while (true) {
		  //  <<< _msgHeader + " " + pitch + " " + gain + " " + bpm >>>;
			pitch => sin.freq;
			gain => sin.gain;
			bpm * 1 :: ms => now;
			0 => sin.gain;
			bpm * 1:: ms => now;
		}
	
	}

}