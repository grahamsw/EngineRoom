

b = Buffer.read(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav");
(
{
var singrain1, singrain2, sfgrain;
singrain1=SinOsc.ar(440,0,XLine.kr(1.0, 0.0001, 0.05));
singrain2=FSinOsc.ar(800, 0.0, Line.kr(1.0,0,0.05).squared);
sfgrain=(PlayBuf.ar(1,b.bufnum, BufRateScale.kr(b.bufnum)))*EnvGen.kr(Env([0,1,1,0],[0.01,0.01,0.01], -4));

[singrain1,singrain2,sfgrain]
}.plot(0.1,s)
)

(
SynthDef(\sinegrain, {arg pan, freq, amp; var grain;

grain= SinOsc.ar(freq, 0, amp)*(XLine.kr(1.001,0.001,0.1,doneAction:2)-0.001);

Out.ar(0,Pan2.ar(grain, pan))}).add;
)
Synth(\sinegrain,[\freq,rrand(100,10000),\amp, exprand(0.05,0.06), \pan, 1.0.rand2]);

(
{
100.do{arg i;

	Synth(\sinegrain,[\freq,rrand(1000,2000),\amp, exprand(0.05,0.055), \pan, 1.0.rand2]);
	0.007.wait
};
}.fork
)

(
{
200.do{arg i;
var timeprop = (i/199.0)**3;

	Synth(\sinegrain,[\freq,exprand(100,5000-(20*i)),\amp, exprand(0.05,0.1), \pan, 1.0.rand2]);
	rrand((timeprop*0.1).max(0.01),timeprop*0.3).wait
};
}.fork
)
(
SynthDef(\sfgrain, {arg bufnum=0, pan=0.0, startPos=0.0, amp=0.1, dur=0.04;
var grain;

grain= PlayBuf.ar(1,bufnum, BufRateScale.kr(bufnum), 1, BufFrames.ir(bufnum)*startPos, 0)*(EnvGen.kr(Env.perc(0.01,dur),doneAction:2)-0.001);

Out.ar(0,Pan2.ar(grain, pan))}).add;
)

b = Buffer.read(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav");

Synth(\sfgrain,[\bufnum, b.bufnum, \startPos,rrand(0.0,1.0),\amp, exprand(0.005,0.1), \pan, 1.0.rand2]);


(
{
200.do{arg i;
var timeprop = (i/199.0)**3;

	Synth(\sfgrain,[\bufnum, b.bufnum, \startPos,rrand(0.0,timeprop),\amp, exprand(0.005,0.1), \pan, 1.0.rand2]);
	rrand((timeprop*0.1).max(0.01),timeprop*0.4).wait
};
}.fork
)



(
var w, slid, lastval;
lastval=0.0;

w=Window("My Window", Rect(100,500,200,200));
//A 200 by 200 window appears at screen co-ordinates (100, 500)

slid=Slider(w,Rect(10,10,150,40)); //a basic slider object

slid.action_({lastval= slid.value;}); //this is the callback- the function is called whenever you move the slider

{
inf.do{arg i;

var prop, timestart, timeend;

prop= (i%300)/300;

timestart= prop*0.8;
timeend= prop*(0.8+(0.1*lastval));

	Synth(\sfgrain,[\bufnum, b.bufnum, \startPos,rrand(timestart,timeend),\amp, exprand(0.005,0.1), \pan, lastval.rand2, \dur, 0.1+(lastval*0.5)]);
	//max in this to avoid ever going near 0.0 wait time, which would crash the computer!
	(((lastval*0.2)+0.01).max(0.01)).wait
};
}.fork;


w.front;
)







