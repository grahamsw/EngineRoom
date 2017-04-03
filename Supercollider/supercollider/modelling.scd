(
var modes,modefreqs,modeamps;
var mu,t,e,s,k,f1,l,c,a,beta,beta2,density;
var decaytimefunc;
var material;

material= \nylon; // \steel

//don't know values of E and mu for a nylon/gut string
//so let's try steel

//radius 1 cm
a=0.01;

s=pi*a*a;

//radius of gyration
k=a*0.5;


if (material ==\nylon,{

e=2e+7;

density=2000;

},{//steel

e= 2e+11; // 2e+7; //2e+11 steel;

//density p= 7800 kg m-3
//linear density kg m = p*S

density=7800;
});

mu=density*s;

t=100000;

c= (t/mu).sqrt;	//speed of sound on wave

l=1.8;	//0.3

f1= c/(2*l);

beta= (a*a/l)*((pi*e/t).sqrt);

beta2=beta*beta;

modes=10;

modefreqs= Array.fill(modes,{arg i;
var n,fr;
n=i+1;

fr=n*f1*(1+beta+beta2+(n*n*pi*pi*beta2*0.125));

if(fr>21000, {fr=21000}); //no aliasing

fr
});

decaytimefunc= {arg freq;
var t1,t2,t3;
var m,calc,e1dive2;

//VS p 50 2.13.1 air damping

m=(a*0.5)*((2*pi*freq/(1.5e-5)).sqrt);

calc= 2*m*m/((2*(2.sqrt)*m)+1);

t1= (density/(2*pi*1.2*freq))*calc;

e1dive2=0.01; //a guess!

t2= e1dive2/(pi*freq);

//leave G as 1
t3= 1.0/(8*mu*l*freq*freq*1);

1/((1/t1)+(1/t2)+(1/t3))
};

modeamps=Array.fill(modes,{arg i; decaytimefunc.value(modefreqs.at(i))});

modefreqs.postln;
modeamps.postln;

{
var output;
//EnvGen.ar(Env.new([0.001,1.0,0.9,0.001],[0.001,0.01,0.3],'exponential'),WhiteNoise.ar)
//could slightly vary amps and phases with each strike?

output=EnvGen.ar(
Env.new([0,1,1,0],[0,10,0]),doneAction:2)*
//slight initial shape favouring lower harmonics- 1.0*((modes-i)/modes)
Mix.fill(modes,{arg i; XLine.ar(1.0,modeamps.at(i),10.0)*SinOsc.ar(modefreqs.at(i),0,1.0/modes)});

Pan2.ar(output,0)
}.play;

)


(
{
	var str, env, nose;
	str = Impulse.ar(0.01);
	env = Decay2.ar(str, 0.008, 0.04);
	nose = LFNoise2.ar(3000, env);
	[str, env, nose]
}.scope(0.03); //.scope
)

(
// hear the energy impulse alone without any comb resonation
{
	var strike, env, noise;
	strike = Impulse.ar(0.01);
	env = Decay2.ar(strike, 0.008, 0.04);
	noise = LFNoise2.ar(3000, env);
	10*noise
}.scope
)

(
{
	var strike, env, noise, pitch, delayTime, detune;
	strike = Impulse.ar(0.01);
	env = Decay2.ar(strike, 0.008, 0.04);

	pitch = (36 + 54.rand);

	Pan2.ar(
			// array of 3 strings per note
			Mix.ar(Array.fill(3, { arg i;
				// detune strings, calculate delay time :
				detune = #[-0.05, 0, 0.04].at(i);
				delayTime = 1 / (pitch + detune).midicps;
				// each string gets own exciter :
				noise = LFNoise2.ar(3000, env); // 3000 Hz was chosen by ear..
				CombL.ar(noise,		// used as a string resonator
					delayTime, 		// max delay time
					delayTime,			// actual delay time
					6) 				// decay time of string
			})),
			(pitch - 36)/27 - 1 // pan position: lo notes left, hi notes right
		)

}.scope
)



(
// synthetic piano patch (James McCartney)
var n;
n = 10;	// number of keys playing
play({
	Mix.ar(Array.fill(n, {	// mix an array of notes
		var delayTime, pitch, detune, strike, hammerEnv, hammer;

		// calculate delay based on a random note
		pitch = (36 + 54.rand);
		strike = Impulse.ar(0.1+0.4.rand, 2pi.rand, 0.1); // random period for each key
		hammerEnv = Decay2.ar(strike, 0.008, 0.04); // excitation envelope
		Pan2.ar(
			// array of 3 strings per note
			Mix.ar(Array.fill(3, { arg i;
				// detune strings, calculate delay time :
				detune = #[-0.05, 0, 0.04].at(i);
				delayTime = 1 / (pitch + detune).midicps;
				// each string gets own exciter :
				hammer = LFNoise2.ar(3000, hammerEnv); // 3000 Hz was chosen by ear..
				CombL.ar(hammer,		// used as a string resonator
					delayTime, 		// max delay time
					delayTime,			// actual delay time
					6) 				// decay time of string
			})),
			(pitch - 36)/27 - 1 // pan position: lo notes left, hi notes right
		)
	}))
})
)


(

{
var freq,time, ex, delay, filter, local;

freq= 440;
time= freq.reciprocal;

ex= WhiteNoise.ar(EnvGen.kr(Env([1.0,1.0,0.0,0.0], [time,0,100])));

local= LocalIn.ar(1);

filter= LPZ1.ar(ex+local); //apply filter

delay= DelayN.ar(filter, time, time-ControlDur.ir);

ControlDur.ir.poll;

LocalOut.ar(delay*0.95);

Out.ar(0, Pan2.ar(filter,0.0))
}.play

)

(

{
var freq,time, ex, delay, filter, local;

freq= 440;
time= freq.reciprocal;

ex= WhiteNoise.ar(EnvGen.kr(Env([1.0,1.0,0.0,0.0], [time,0,100])));

freq= SinOsc.ar(6, 0, 10, freq);
time= freq.reciprocal;

local= LocalIn.ar(1);

filter= LPZ1.ar(ex+local); //apply filter

//maximum delay time is 440-10
delay= DelayN.ar(filter, 430.reciprocal, time-ControlDur.ir);

LocalOut.ar(delay*0.99);

Out.ar(0, Pan2.ar(filter,0.0))
}.play

)





Contributions from Thor Magnusson giving an alternative viewpoint:


// we use a noise ugen to generate a burst
(
{
 var burstEnv, att = 0, dec = 0.001; //Variable declarations
 burstEnv = EnvGen.kr(Env.perc(att, dec), gate: Impulse.kr(1)); //envelope
 PinkNoise.ar(burstEnv); //Noise, amp controlled by burstEnv
}.play
)

// but then we use Comb delay to create the delay line that creates the tone


// let's create a synthdef using Karplus-Strong
SynthDef(\ks_guitar, { arg note, pan, rand, delayTime, noiseType=1;
	var x, y, env;
	env = Env.new(#[1, 1, 0],#[2, 0.001]);
	// A simple exciter x, with some randomness.
	x = Decay.ar(Impulse.ar(0, 0, rand), 0.1+rand, WhiteNoise.ar);
 	x = CombL.ar(x, 0.05, note.reciprocal, delayTime, EnvGen.ar(env, doneAction:2));
	x = Pan2.ar(x, pan);
	Out.ar(0, LeakDC.ar(x));
}).store;

// and play the synthdef
(
{
	20.do({
		Synth(\ks_guitar, [\note, 220+(400.rand),
					\pan, 1.0.rand2,
					\rand, 0.1+0.1.rand,
					\delayTime, 2+1.0.rand]);

	   (1.0.rand + 0.5).wait;
	});
}.fork
)

// here using patterns
a = Pdef(\kspattern,
		Pbind(\instrument, \ks_guitar, // using our sine synthdef
					\note, Pseq.new([60, 61, 63, 66], inf).midicps, // freq arg
					\dur, Pseq.new([0.25, 0.5, 0.25, 1], inf),  // dur arg
					\rand, Prand.new([0.2, 0.15, 0.15, 0.11], inf),  // dur arg
					\pan, 2.0.rand-1,
					\delayTime, 2+1.0.rand;  // envdur arg

		)
).play;

// compare using whitenoise and pinknoise as an exciter:

// whitenoise

(
{
 var burstEnv, att = 0, dec = 0.001;
 var burst, delayTime, delayDecay = 0.5;
 var midiPitch = 69; // A 440
 delayTime = midiPitch.midicps.reciprocal;
 burstEnv = EnvGen.kr(Env.perc(att, dec), gate: Impulse.kr(1/delayDecay));
 burst = WhiteNoise.ar(burstEnv);
 CombL.ar(burst, delayTime, delayTime, delayDecay, add: burst);
}.play
)

// pinknoise
(
{
 var burstEnv, att = 0, dec = 0.001;
 var burst, delayTime, delayDecay = 0.5;
 var midiPitch = 69; // A 440
 delayTime = midiPitch.midicps.reciprocal;
 burstEnv = EnvGen.kr(Env.perc(att, dec), gate: Impulse.kr(1/delayDecay));
 burst = PinkNoise.ar(burstEnv);
 CombL.ar(burst, delayTime, delayTime, delayDecay, add: burst);
}.play
)



// Note that delayTime is controlling the pitch here. The delay time is reciprocal to the pitch. // 1/100th of a sec is 100Hz, 1/400th of a sec is 400Hz.


(
SynthDef(\KSpluck, { arg midiPitch = 69, delayDecay = 1.0;
	var burstEnv, att = 0, dec = 0.001;
	var signalOut, delayTime;

	delayTime = [midiPitch, midiPitch + 12].midicps.reciprocal;
	burstEnv = EnvGen.kr(Env.perc(att, dec));
	signalOut = PinkNoise.ar(burstEnv);
	signalOut = CombL.ar(signalOut, delayTime, delayTime, delayDecay, add: signalOut);
	DetectSilence.ar(signalOut, doneAction:2);
	Out.ar(0, signalOut)
	}
).store;
)

(
//Then run this playback task
r = Task({
	{Synth(\KSpluck,
		[
		\midiPitch, rrand(30, 90), //Choose a pitch
		\delayDecay, rrand(0.1, 3.0) //Choose duration
		]);
		//Choose a wait time before next event
		[0.125, 0.125, 0.25].choose.wait;
	}.loop;
}).play
)

s.sampleRate
(
{
[LFSaw.ar(1000),Saw.ar(1000)]
}.plot(0.01)
)

{LFSaw.ar(4410+(MouseX.kr(0,10).round(1)),0,0.5)}.scope

{LFSaw.ar(1102.5+(MouseX.kr(0,10).round(1)),0,0.5)}.scope


(
{Mix.fill(4,{Saw.ar(440*(1+SinOsc.ar(LFNoise1.kr(rrand(0.25,0.5),4,5),pi.rand,0.02)),0.2)}) }.play
)

{Mix.fill(3,{|i| [LFTri, LFCub, LFPar].choose.ar(110*(2**i),pi.rand,10.rand.neg.dbamp)})}.play

