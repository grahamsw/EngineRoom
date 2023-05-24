
(

~register2D = {
	| address, synth, var1, var2,  v1From = 0.0, v1To = 1.0, v2From = 0.0, v2To = 1.0|
	OSCFunc( {
		|msg|
		var val1 = msg[1];
		var val2 = msg[2];
		msg.postln;
		synth.set(var1, val1.linlin(0, 1, v1From, v1To));
		synth.(var2, val2.linlin(0, 1, v2From, v2To));
	}, address);
};




~register = {
	| address, synth, variable, from = 0.0, to = 1.0, trace=false|
	OSCFunc( {
		|msg|
		var val = msg[1];
		if (trace, {msg.postln});
		synth.set(variable, val.linlin(0, 1.0, from, to));
	}, address);
};

)
