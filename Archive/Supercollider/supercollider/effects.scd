(
Server.default= s=Server.internal;
s.boot;
)

(
SynthDef(\impulse, {
Out.ar(0,Pan2.ar(Saw.ar(440,Decay2.ar(Impulse.ar(1),0.001,0.1,0.5)),0.0));
}).add;

SynthDef(\continuous, {
Out.ar(0,Pan2.ar(WhiteNoise.ar(0.1),0.0));
}).add;
)

a = Group.basicNew(s,1)
x = Synth.head(a, \impulse);

s.scope


(
SynthDef(\fxexampledelay, {arg delaytime=0.1;
var input, effect;

input=In.ar(0,2); //get two channels of input starting (and ending) on bus 0

effect= DelayN.ar(input, 1,delaytime); //max delay of one second

Out.ar(0,effect); //adds to bus 0
}).add;
)

x.free;
x = Synth.head(a, \impulse);
y= Synth.tail(a, \fxexampledelay);
y.set(\delaytime, 0.04)
y.free;

y= Synth.tail(a, \fxexampledelay, [\delaytime, 0.4]);


(

{
var source;
var fx;


source= Saw.ar(440,0.1);

fx= DelayC.ar(source, 0.01, SinOsc.ar(Rand(5,10),0,0.0025,0.0075));

fx
}.play

)

(

{
var source;
var fx;
var n=10;

source= EnvGen.ar(Env([0,1,0],[0.1,0.5]),Impulse.kr(2))*Saw.ar(440,0.5);

fx= Mix.fill(n, {
var maxdelaytime= rrand(0.01,0.03);
var half= maxdelaytime*0.5;
var quarter= maxdelaytime*0.25;

//%half+(quarter*LPF.ar(WhiteNoise.ar,rrand(1.0,10)))
DelayC.ar(source, maxdelaytime, LFNoise1.kr(Rand(5,10),0.01,0.02) )

});

fx
}.play

)


(
SynthDef(\fxexamplereverb, {arg delaytime=0.01, decaytime=1;
var input;
var numc,numa,temp;

input=In.ar(0,2); //get two channels of input starting (and ending) on bus 0

numc = 4; // number of comb delays
numa = 6; // number of allpass delays

// reverb predelay time :
temp = DelayN.ar(input, 0.048,0.048);

temp=Mix.fill(numc,{CombL.ar(temp,0.1,rrand(0.01, 0.1),5)});

// chain of 4 allpass delays on each of two channels (8 total) :
numa.do({ temp = AllpassN.ar(temp, 0.051, [rrand(0.01, 0.05),rrand(0.01, 0.05)], 1) });

// add original sound to reverb and play it :
Out.ar(0,(0.2*temp));
}).add;
)

y= Synth.tail(a, \fxexamplereverb);


(
{
	var source = Impulse.ar(MouseX.kr(1,10));
	var sound, feedback;

	feedback = LocalIn.ar(1);	//one channel of feedback

	sound = source + feedback;

	LocalOut.ar(sound* MouseY.kr(0,0.9));  //feedback sound with some gain (<1 to stop feedback building up and overloading!).

	sound;

}.play
)



