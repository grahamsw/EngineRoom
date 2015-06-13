
public class Receiver {  
	int _port;
	string _msgHeader;
	DynamicValues _dvs;
		
	fun void listen(){
		OscIn oscin;
		_port => oscin.port;

		for (0 => int i; i < _player._svs.cap(); i++){
		   "/" + _msgHeader +"/" + _player._svs[i].name => string addr;
			addr => oscin.addAddress;
		}

		OscMsg msg;

		while(true) {
			oscin => now;
			while(oscin.recv(msg)){
				msg.address => string ad;
				for(0 => int i; i < _player._svs.cap(); i++){
					if (ad == "/" + _msgHeader + "/" + _player._svs[i].name) {
							msg.getFloat(0) => _player._svs[i].value;
							_player._svs[i].value => _player._values[_player._svs[i].name];
					}
				}
			}
		}
	}

	fun void Init(int port, string msgHeader, DynamicValues dvs){
		port => _port;
		msgHeader => _msgHeader;
		svs @=> _svs;

		spork ~ listen();	
	}	
}

