(
/* run this code segment, then you can register synths
to receive OSC messages that will set their parameters
as
~register(aSynthInstance, "/some/osc/name");
*/

// these two variables should be nested and hidden
var setProp, regSynth;

setProp = {
	|synth, prop, val|
	synth.set(prop, val);
};

regSynth = {
	|synth|
	   {
		|msg, time, addr, port|
		var name = msg[1],
	        val =  msg[2].asFloat;
	    setProp.value(synth, name, val);
       };
};


// there has to be a module system that lets me create proper function names
// register a synth to receive parameter setting
// messages on the OC address
~register =
	{ |synth, oscchannelName|
		var rcvr = OSCFunc(regSynth.value(h), oscchannelName);
		rcvr;
	};

)

/*
#the python code

import OSC
import time, random
client = OSC.OSCClient()
client.connect( ( '127.0.0.1', 57120 ) )
msg = OSC.OSCMessage()
msg.setAddress("/print")
msg.append(100)
client.send(msg)

*/