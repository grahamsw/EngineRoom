
public class OscReceiver {  

	OscIn oscin;
	string _msgHeader;
	DynamicValues _dvs;
		
	fun void Init(int port, string msgHeader, DynamicValues dvs){
		msgHeader => _msgHeader;
		dvs @=> _dvs;
		port => oscin.port;

		
        for (0 => int i; i < _dvs._names.cap(); i++){
		   "/" + _msgHeader +"/" + _dvs._names[i] => string addr;
			addr => oscin.addAddress;
		}
 
		spork ~ listen();	
	}		
	
	fun void listen(){
		OscMsg msg;
		while(true) {
			oscin => now;
			while(oscin.recv(msg)){
				msg.address => string addr;
				<<< addr>>>;
				for(0 => int i; i < _dvs._names.cap(); i++){
					if (addr == "/" + _msgHeader + "/" + _dvs._names[i]) {
					     msg.getFloat(0) => _dvs._vals[_dvs._names[i]];
						 <<< _dvs._vals[_dvs._names[i]] >>>;
					}	
				}
			}
		}
     }

}

