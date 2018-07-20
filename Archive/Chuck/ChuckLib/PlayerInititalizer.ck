// Init();


public class PlayerInitializer {
    string _ip;
	int _port;
	DynamicValue[] _dvs;
	
	fun void Init(string ip, int port, DynamicValues[] dvs){
		ip => _ip;
		port => _port;
		dvs @=> _dvs;
	}

	fun void Init2(string jsontxt) {
		for(0 => int i; i < _names.cap(); i++){
			<<< _names[i], _vals[_names[i]] >>>;
		}
	}
}
