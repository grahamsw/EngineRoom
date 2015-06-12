fun void trace(string label, string msg){
	<<< label + ": " + msg >>>;
}

public class Receiver {  
	int _port;
	string _msgHeader;
	string _valuesNames[];

	int _values[0];
		
	fun void listen(){
		OscIn oscin;
		_port => oscin.port;

		for (0 => int i; i < _valuesNames.cap(); i++){
		   "/" + _msgHeader +"/" + _valuesNames[i] => string addr;
		   trace("registering", addr);
			addr => oscin.addAddress;
		}

		OscMsg msg;

		while(true) {
			oscin => now;
			while(oscin.recv(msg)){
				msg.address => string ad;
				trace("got", ad);
				for(0 => int i; i < _valuesNames.cap(); i++){
					if (ad == "/" + _msgHeader + "/" + _valuesNames[i]) {
							msg.getInt(0) => _values[_valuesNames[i]];
							trace("receiving", ad);
					}
				}
			}
		}
	}

	fun void Init(int port, string msgHeader, string valuesNames[]){
		port => _port;
		msgHeader => _msgHeader;
		valuesNames @=> _valuesNames;

		spork ~ listen();		
		spork ~ play();
	}	

	// this is the only thing that knows about sound, and the only thing that needs customized
	// This will be factored out into a Player object
	fun void play(){
		SinOsc sin;
		sin => dac;		
		0.4 => sin.gain;

		500 => _values["freq"];
        400 => _values["onMs"];
		200 => _values["offMs"];

		while (true) {
		    0.4 => sin.gain;
			_values["freq"] => sin.freq;			
			_values["onMs"] * 1 :: ms => now;
			0 => sin.gain;
			_values["offMs"] * 1:: ms => now;
		}
	
	}

}