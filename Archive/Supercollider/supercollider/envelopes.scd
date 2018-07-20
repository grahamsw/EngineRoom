{SinOsc.ar(440, 0, Line.kr(0.1, 0, 1, doneAction:2))}.play

Env.linen(0.1, 0.5, 0.2, 0.5, curve:\exponential).plot


Env.adsr(0.01, 0.5, 0.5, 0.1, 4.0, 0).plot

{SinOsc.ar(440,0,0.1)*EnvGen.kr(Env([1,0],[1.0]))}.scope

(

SynthDef(\bzz, {|start = 1000, end=20, dur = 0.1, mul=0.1|
	Saw.ar(EnvGen.ar(Env([start,end],[dur]),doneAction:2),mul)}).add

)


(
{
	Saw.ar(
		EnvGen.kr(Env([10000,20],[0.5])),  //frequency input
		EnvGen.kr(Env([0.1,0],[0.5]),doneAction:2)      //amplitude input
	)
}.play
)


{Saw.ar(SinOsc.ar(1,0,10,440),XLine.kr(0.01,1,1,doneAction:2))}.scope

a = {EnvGen.ar(Env.asr(0.1,0.1,1.0),doneAction:2)*SinOsc.ar(330)}.play //sound continues


a.release(2.0);

a = {arg gate=0; EnvGen.ar(Env.asr(0.1,0.4,6),gate)*SinOsc.ar(330)}.play

a.set(\gate,0)

(
e = Env([0.0,0.0,1.0,0.0],[0.5,1.0,2.0],0,2,0); //releaseNode at 2, loopNode at 0
a= {arg gate=1; EnvGen.ar(e,gate,doneAction:2)*SinOsc.ar(550,0,0.1)}.play
)

e = Env([0.0,1.0,-1.0,0.0],[0.01,0.01,2.0],0,2,0);
e.plot
a= {arg gate=1; EnvGen.ar(e,gate,timeScale:MouseX.kr(0.1,2.0),doneAction:2)}.play
a.set(\gate, 0); 