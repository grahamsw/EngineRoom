(
Server.default = s = Server.internal;
s.reboot;

s.makeGui
FreqScope.new;
)

({LPF.ar(WhiteNoise.ar(0.3),Line.kr(10000,1000,10, doneAction:2))}.scope)

{BPF.ar(Resonz.ar(LFNoise0.ar(MouseY.kr(50,1000)),MouseX.kr(100,5000),0.1), 1000, 2)}.scope


{Mix.ar(SinOsc.ar(500*[0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1], 0, 0.1))}.scope

{Mix(SinOsc.ar(500*[0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1],0,0.1*[0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1]))}.scope


(1..10)

{SinOsc.ar(mul:MouseY.kr(1.0,0.1))}.scope


{SinOsc.ar(mul:0.1, add:MouseY.kr(0.9,-0.9))}.scope

(
{
	//cutoff values need to be sensible frequencies in Hz; here sine output turned from -1 to 1 into 2000+-1700
	var cutoff = 	SinOsc.ar(1,mul:MouseX.kr(0.0,1700.0), add:2000.0);
	//var cutoff = SinOsc.ar(1)*1700.0 + 2000.0;  //same thing
	LPF.ar(WhiteNoise.ar,freq:cutoff);
}.scope
)

a = {arg freq = 440; SinOsc.ar(freq)*0.1}.play
a.set(\freq, 330)

a.set(\freq, MouseX.kr(220,440))


