public class SimpleOscReceiver {  

	OscIn oscin;
	
	fun void Init(int port, string addr){
		port => oscin.port;		
        addr => oscin.addAddress;
		spork ~ listen();	
	}		
	
	fun void listen(){
		OscMsg msg;
		while(true) {
			oscin => now;
			while(oscin.recv(msg)){
				msg.address => string addr;
				<<< addr>>>;
				msg.getFloat(0) => float val;
				<<< val >>>;
			}
		}
     }
}

