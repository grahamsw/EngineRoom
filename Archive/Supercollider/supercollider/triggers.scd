(
{
	[
	LFNoise0.ar(100),	//step
	LFNoise1.ar(100),	//linear interpolation
	LFNoise2.ar(100)	//quadratic interpolation
	]
}.plot(0.1)
)
{Impulse.ar(MouseX.kr(1,100))}.play

{Dust.ar(MouseX.kr(1,100))}.play

{ Stepper.ar(Dust.ar(50), 0,1,10,1) }.plot(0.3,minval:0,maxval:10);

{ Saw.ar(Select.kr(Stepper.kr(Impulse.kr(4,0.1),0,0,7,1),[72,63,67,72,55,62,63,60].midicps),0.1) }.play

{ Saw.ar(Select.kr(Stepper.kr(Impulse.kr(MouseX.kr(1,40),0.1),0,0,7,1),[75,63,67,72,55,62,63,60].midicps),0.1) }.play


(
SynthDef("help-Select",{ arg out=0;

    var a,cycle;
    a = [
            SinOsc.ar,
            Saw.ar,
            Pulse.ar
        ];
    cycle = a.size  * 0.5;
    Out.ar(out,
        Select.ar(LFSaw.kr(1.0,0.0,cycle,cycle),a) * 0.2
    )
}).play;

)

(

var a, cycle;
a = [9,4,7];
cycle = a.size * 0.5;
{Select.kr(LFSaw.kr(1.0, 0.0, cycle, cycle),a)}.plot(2);
)



(
{
	var source = SinOsc.ar(100);
	//plot both original signal, and the trigger pattern
	[source, Trig1.ar(source,0.01), Trig.ar(source, 0.001)]

	}.plot(0.1)
)

(
{var source, trigger;

source= LFNoise0.ar(100);
trigger= Trig1.ar(source, 0.001); //0.001 is duration of trigger signal output

[source, trigger]
}.plot(0.2)
)

(
{var source, trigger;

source= LFNoise0.ar(100);
trigger= Trig1.ar(source, 0.001); //0.001 is duration of trigger signal output

[source, trigger]
}.plot(0.2)
)

(
{var source, trigger;

source= LFNoise0.ar(100);
trigger= Trig1.ar(source- Delay1.ar(source), 0.001); //0.001 is duration of trigger signal output

[source, trigger]
}.plot(0.2)
)

(
{var source, trigger;

source= LFNoise0.ar(100);
trigger= Trig1.ar(abs(source- Delay1.ar(source)), 0.001); //0.001 is duration of trigger signal output

[source, trigger]
}.plot(0.2)
)


{Latch.ar(SinOsc.ar(133), Impulse.ar(100))}.plot(0.5)


{Latch.ar(LFNoise2.ar(100), Impulse.ar(100))}.plot(0.1) //removes smoothing!

{SinOsc.ar(300+(200*Latch.ar(SinOsc.ar(13.3), Impulse.ar(10))))*0.2}.plot(5)

{EnvGen.ar(Env([0,1,0],[0.01,0.01]),Impulse.kr(50))}.plot(0.1)

{EnvGen.ar(Env([0,1,0,0.5,-0.4],0.01!4),Impulse.kr(25))}.plot(0.1)





{SinOsc.ar(EnvGen.ar(Env([63,63,60,55,60],0.125!4,curve:\step),Impulse.kr(2)).midicps)}.play

(
{
var sound,env, trig;

	trig= Impulse.ar(XLine.ar(1, 30, 10,doneAction:2)); //trigger source

sound= Mix(LFPulse.ar(110*[1,5/2],0.0,0.5,0.2));

env= EnvGen.ar(Env.perc(0.02,0.2),trig); //with retriggering controlled by impulse

Pan2.ar(sound*env,0.0)
}.play
)


(
SynthDef(\mytriggersynth,{arg trig=0;
var env;

//must have additional starting level in envelope, else no nodes to go back to
env= EnvGen.ar(Env([2,2,1],[0.0,0.5],'exponential'),trig);

Out.ar(0,Pan2.ar(Resonz.ar(Saw.ar(env*440),1000,0.1),0.0))
},[\tr]).add
)
a= Synth(\mytriggersynth);
a.set(\trig, 1)



(
{
var sound,env, trig;

//> is itself a UGen when used in this context; it is outputting the result of comparing the LFNoise0 with the value 0 every sample!
trig= LFNoise0.ar(13)>0; //trigger source (might also use Dust, for example)

//TRand chooses a random number in its range when triggered
sound= Mix(LFPulse.ar(110*[1,5/2,TRand.ar(3.9,4.1,trig)],0.0,0.5,0.2));

env= EnvGen.ar(Env.perc(0.02,0.1),trig); //with retriggering controlled by impulse

Pan2.ar(sound*env,0.0)
}.play
)

{ SyncSaw.ar(MouseX.kr(1,400), MouseY.kr(400,800), 0.1) }.play;
{EnvGen.ar(Env([0,0,1,-1,0],MouseY.kr(0,1)*[0,128,256,128]/SampleRate.ir),Impulse.ar(MouseX.kr(10,300,'exponential')))}.play

(
{
var source;

source= LFNoise0.ar(10);

[
	source,			//step
	source.lag(0.1)	//step with lag of period; so only gets to target value at end of step
]
}.plot(1.0)
)



//another example: Ringz is a resonant filter, exprange puts values from -1 to 1 to the desired range (100 to 2000) with an exponential mapping more fitting to human perception of frequency values
{Ringz.ar(Saw.ar(LFNoise0.kr(5).lag(0.1).exprange(100,2000),0.2), 1000, 0.01)}.play

(
{
	Decay.ar(Impulse.ar(100),0.01)
}.plot(0.1)
)

(
{
	Decay2.ar(Impulse.ar(100),0.005,0.01)
}.plot(0.1)
)
