(
SynthDef(\event,{ arg freq=440, amp=0.5, pan=0.0;
	var env;

	env = EnvGen.ar(  Env([0,1,1,0],[0.01, 0.1, 0.2]),  doneAction:2);

	Out.ar(0,  Pan2.ar(Blip.ar(freq) * env * amp, pan))
}).add;
)

SynthDescLib.global.synthDescs[\event].def.func.postcs

Synth(\event)
Synth(\event,[\amp,0.2,\pan,1.0])
s.makeGui

(

	var tempoClock = TempoClock(126/60);
a =
{
	4.do {
		|count|
		Synth(\event, [\freq, 60.midicps]);
		count.postln;
		1.0.wait;
	};
	16.do{|count|
		Synth(\event, [\freq, (60 + count + 1).midicps]);
		count.postln;
		0.25.wait;
	};


}.fork(tempoClock);
)

// sequencing on the server
{Impulse.ar(MouseX.kr(1,100))}.scope;
{Dust.ar(MouseX.kr(1,100))}.play

{LFNoise0.ar(100)}.plot(0.1).scope

a.stop
{Impulse.ar(1000)}.plot(0.1)
{ Stepper.ar(Impulse.ar(200), 0,25,30) }.plot(0.1);

{ SinOsc.ar(Stepper.ar(Impulse.ar(100), 0,1,10,1)*100,0,0.1) }.play

{ Saw.ar(Select.kr(Stepper.kr(Impulse.kr(4,0.1),0,0,7,1),[72,63,67,72,55,62,63,60].midicps),0.1) }.play

{ Saw.ar(Select.kr(Stepper.kr(Impulse.kr(MouseX.kr(1,40),0.1),0,0,7,1),[75,63,67,72,55,62,63,60].midicps),0.1) }.play