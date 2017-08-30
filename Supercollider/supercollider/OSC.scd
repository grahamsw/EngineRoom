(
Server.default = s=Server.local;
if(not(s.serverRunning), {s.boot});
s.makeGui;
s.scope(2);
)

(

SynthDef("sine", {arg freq=440;
	var osc;
	osc = SinOsc.ar(freq, 0, 0.1); //sine oscillator
	Out.ar(0, osc); // send output to audio bus zero.
}).writeDefFile;   //place this SynthDef on disk in compiled form in the 								'synthdefs' folder


)

s.sendMsg("/d_load","synthdefs/sine.scsyndef");   //server loads the SynthDef

s.sendMsg("/s_new", "sine", 1004, 1, 0);
s.sendMsg("/s_new", "sine", 1001, 3, 1000, \freq, 450);

s.sendMsg("/n_free", 1004)
s.sendMsg("/n_free", 1001)
