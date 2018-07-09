
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

(
SynthDef(\thing, {
	| freq = 440.0, amp = 1.0, vibratoRate = 3.0, vibratoDepth = 5.0 |

	var out = SinOsc.ar(freq + SinOsc.ar(vibratoRate, mul: vibratoDepth ), mul:amp);
	Out.ar(0, out);
}).add;

)

(
e = Synth(\thing);

~register2D.('/3/xyM_l', e, 'freq', 'amp', 50, 2000);
~register2D.('/3/xyM_r', e, 'vibratoRate', 'vibratoDepth', 0.01, 10, 1, 200);
~register.('/faderM', e, 'amp');
//~register.('/3/xyM_r', 'amp');

)




OSCFunc.trace(true, true)
