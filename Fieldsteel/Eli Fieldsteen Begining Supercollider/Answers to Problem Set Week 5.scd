//(Answers to) Problem Set Week 5

//Problem 1
/*
Using what you've learned from syntax exercises with randomness and Arrays, create and plot a "random" envelope (using Env) with the following characteristics:
- 20 breakpoints (therefore 19 segments connecting these points)
- breakpoint levels are random Floats between 0.0 and 1.0
- segment durations are random Floats between 0.01 and 1, with an exponential distribution
- segment curve values are random Integers between -8 and +8, with a linear distribution
*/

(
Env.new(
	Array.rand(20, 0.0, 1.0),
	Array.exprand(19, 0.01, 1),
	Array.rand(19,-8,8)
).plot;
)

//Problem 2
//Create and plot an envelope (using Env) that looks like this one:
//https://uofi.box.com/s/vkfjxg80cwxbnjwku91tdwy3hf4xhqwj
//Total duration should be 6 seconds (other than that, it doesn't have to be "perfect" — just reasonably close).

(
Env(
	[0, 1, 0, 1, 0, 1, 0],
	[0.1, 1.9, 1, 1, 1.9, 0.1],
	[0, -5, -5, 5, 5, 0]
).plot;
)

//Problem 3
//Boot the audio server. The following code plays pink noise through a bandpass filter with a center frequency at 800 Hz. Use the envelope from the previous problem to control the amplitude of this filtered noise. Make sure the synthesis process frees itself after the envelope is finished.

(
x = {
	var sig;
	sig = PinkNoise.ar(1!2);
	sig = BPF.ar(sig, 800, 0.02, 7);
}.play
)

//with envelope applied:
(
e = Env(
	[0, 1, 0, 1, 0, 1, 0],
	[0.1, 1.9, 1, 1, 1.9, 0.1],
	[0, -5, -5, 5, 5, 0]
);

x = {
	var sig, env;
	env = EnvGen.kr(e, doneAction:2);
	sig = PinkNoise.ar(1!2);
	sig = BPF.ar(sig, 800, 0.02, 5);
	sig = sig * env;
}.play
)

//Problem 4
//Modify the synthesis function from the previous problem in the following way. Add a second envelope that controls the center frequency of the bandpass filter. This envelope should go from 150 Hz to 1000 Hz over 1 second, and back to 50 Hz over 4 seconds. Make a sensible coding decision that allows all envelopes to finish, and frees the synthesis process from the audio server when the sound is done.

(
e = Env(
	[0, 1, 0, 1, 0, 1, 0],
	[0.1, 1.9, 1, 1, 1.9, 0.1],
	[0, -5, -5, 5, 5, 0]
);

f = Env(
	[150, 1000, 150],
	[1, 4],
	[2,-2] //use whatever curves you like
);

x = {
	var sig, env, freqenv;
	freqenv =

	env = EnvGen.kr(e, doneAction:2); //this env is longer and represents the sound "lifespan"

	freqenv = EnvGen.kr(f); //this one is shorter; doneAction:2 here would prematurely end the sound

	sig = PinkNoise.ar(1!2);
	sig = BPF.ar(sig, freqenv, 0.02, 5);
	sig = sig * env;
}.play
)

//Problem 5
//Build a UGen function with the following features. When played, it should produce a sine wave with a percussive amplitude envelope (Env.perc, very short attack, long-ish release). The function should have an arument for the frequency of the sine wave, and also a gate argument that can be used to re-trigger the percussive envelope as often as desired. The overall amplitude should be sensible, and the output sound should be stereo (use !2 at the end). Just build the function in this problem, but don't play it yet.

(
x = {
	arg freq=800, t_gate=1;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(
		Env.perc(0.01, 1),
		t_gate
	);
	sig = sig * env * 0.2;
	sig = sig!2;
};
)

//Problem 6
//Relying on your function from the previous problem, write two lines of code: The first line should "play" the synthesis process on the server, but it should initially be silent (initialize the envelope gate at zero). The second line of code should simultaneously re-trigger the envelope, and set the frequency to a new, random value. In addition, it must be possible to re-evaluate this second line of code as many times as desired in order to re-randomize the frequency and re-trigger the envelope.

y = x.play(args: [\t_gate, 0]); //init t_gate=0 means the env hasn't "started" yet

y.set(\t_gate, 1, \freq, exprand(200,2000)); //run this over and over again

//Problem 7
//Consider the following UGen function, which creates an array of 16 unique pulse waves, roughly tuned to a harmonic series on 50 Hz, and uses Splay to spatialize/spread these 16 signals across a two-channel field.

(
x = {
	var sig, freqs;
	freqs = Array.exprand(16, 50, 1000).round(50);
	freqs = freqs * Array.rand(16, 0.99, 1.01); //"chorus" effect (detune slightly)
	sig = Pulse.ar(freqs);
	sig = Splay.ar(sig);
	sig = sig * 0.05;
}.play
)

//Modify this code, using principles of Multichannel Expansion, so that the amplitude of each of the 16 pulse waves drifts between 0 and 1 slowly, randomly, and uniquely (i.e. don't use one random UGen to control the amplitude of all 16 pulse waves — use an array of 16 unique UGens, one for each pulse wave amplitude). LFNoise1 is a good choice for a slow-moving, random signal.

(
x = {
	var sig, freqs;
	freqs = Array.exprand(16, 50, 1000).round(50);
	freqs = freqs * Array.rand(16, 0.99, 1.01);
	sig = Pulse.ar(freqs);

	//random amplitude modulation:
	sig = sig * LFNoise1.kr(Array.rand(16, 0.3, 0.9)).range(0, 1);

	sig = Splay.ar(sig);
	sig = sig * 0.05;
}.play
)

//Problem 8
//Modify your work from the previous problem so that the 'width' argument of each pulse wave slowly, randomly, and uniquely meanders between a value of 0.01 and 0.99. Again, LFNoise1 is a good choice. Declare more variables as needed/desired, and try to keep your code looking tidy.

//Note: the width argument determines what percentage of the pulse wave is "up" and what percent is "down". A value of 0.5 is 50% up, 50% down. These waveform shape changes result in timbral morphing. Observe:

{Pulse.ar(120, 0.5)}.plot(0.1); //50/50%
{Pulse.ar(120, 0.5, 0.02!2)}.play;

{Pulse.ar(120, 0.75)}.plot(0.1); //75% "down"
{Pulse.ar(120, 0.75, 0.02!2)}.play;

{Pulse.ar(120, 0.1)}.plot(0.1); //10% "down"
{Pulse.ar(120, 0.1, 0.02!2)}.play;

//a pulse width "sweep"
{Pulse.ar(120, Line.kr(0.01, 0.99, 2, doneAction:2), 0.02!2)}.play;
{Pulse.ar(120, Line.kr(0.01, 0.99, 0.5))}.plot(0.5);

(
x = {
	var sig, freqs, widths; //new variable
	freqs = Array.exprand(16, 50, 1000).round(50);
	freqs = freqs * Array.rand(16, 0.99, 1.01);

	//define 16-channel signal to randomly control pulse widths
	widths = LFNoise1.kr(Array.rand(16, 0.3, 0.9)).range(0.01, 0.99);

	//plug it in here:
	sig = Pulse.ar(freqs, widths);
	sig = sig * LFNoise1.kr(Array.rand(16, 0.3, 0.9)).range(0, 1);
	sig = Splay.ar(sig);
	sig = sig * 0.05;
}.play
)


//Bonus Problem (+1)
//Finally, modify your work from the previous problem one more time, so that each Pulse wave is passed through a unique low-pass filter (LPF). The cutoff frequency of each LPF should be slowly, randomly, and uniquely varying between 100 and 15000. Again, LFNoise1 is a good choice for controlling the cutoff frequencies. Declare more variables as needed, and try to keep your code looking tidy.

(
x = {
	var sig, freqs, widths, cutoffs; //new variable
	freqs = Array.exprand(16, 50, 1000).round(50);
	freqs = freqs * Array.rand(16, 0.99, 1.01);
	widths = LFNoise1.kr(Array.rand(16, 0.3, 0.9)).range(0.01, 0.99);
	sig = Pulse.ar(freqs, widths);

	//define 16-channel signal to control cutoff frequencies
	cutoffs = LFNoise1.kr(Array.rand(16, 0.3, 0.9)).exprange(100, 15000);

	//apply lowpass filter
	sig = LPF.ar(sig, cutoffs);

	sig = sig * LFNoise1.kr(Array.rand(16, 0.3, 0.9)).range(0, 1);
	sig = Splay.ar(sig);
	sig = sig * 0.05;
}.play
)