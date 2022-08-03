//(Answers to) Problem Set Week 4

//Problem 1
//Boot the audio server. Then, run Ex#1 and listen to the signal that is produced. Press-command period to stop the sound. Then, change the ".ar" method to ".kr" on line 16 (the first SinOsc), re-run the Ex#1 code, and listen to the sound. Notice the difference.

//Then, repeat this process with Ex#2, and notice that the ar/kr versions are sonically indistinguishable. In your own words, write a comment that explains why the first example sounds different when the ar method is changed to kr, but the second example does not seem to change.

(
{	//Ex#1
	var freqmod, sig;
	freqmod = SinOsc.ar(325, mul:300); //change ar -> kr
	sig = SinOsc.ar(650 + freqmod);
	sig = sig * 0.1!2;
}.play
)

(
{	//Ex#2
	var freqmod, sig;
	freqmod = SinOsc.ar(6, mul:300); //change ar -> kr
	sig = SinOsc.ar(650 + freqmod);
	sig = sig * 0.1!2;
}.play
)

//EMF: In Ex#1, the frequency of the oscillator is 325 Hz. This is fairly fast compared to the control rate, and the waveform will exhibit aliasing, i.e. a low resolution/inaccurate shape. Thus, the resulting synthesis algorithm sounds kind of glitchy and garbage-y when ar is changed to kr. In Ex#2, the frequency is 6 Hz, which is quite slow, certainly slow enough to be represented with high accuracy by the control rate.



//Problem 2
//Run these three bits of code, in order.

(
f = {	//run me first
	var sig;
	sig = Saw.ar([60,60.2]);
	sig = LPF.ar(sig, 480);
	sig = sig * 0.2!2;
};
)

f.play; //then me

f.free; //and finally run me

//Notice that the ".free" method does not stop the sound (press command-period to do so). Add a comment, in your own words, explaining why the ".free" method doesn't work.

//EMF: f is a Function, and is not the same thing as the synthesis algorithm that is running on the audio server. It is not possible to "free" a function. Instead, it is necessary to store the result of f.play in a variable, so that we can address the synthesis process itself later on, specifically to send it the "free" message. E.g.:

x = f.play;

x.free;



//Problem 3
//The following UGen function applies an envelope to the signal's amplitude. Everything seems to work fine; it produces sound and there are no errors. But, there's a problem. What is it? Fix the issue and add a comment.

(
{
	var sig, env;
	env = EnvGen.kr(
		Env.new(
			[1,0],
			[4],
			[-3]
		)
	);
	sig = Blip.ar([300,305], 16);
	sig = sig * LFPulse.kr(12, width:0.2);
	sig = sig * env;
	sig = sig * 0.4!2;
}.play
)

//EMF: there is no doneAction:2, so the synthesis process will continue to exist on the server (consuming CPU power) after the envelope has finished and we hear nothing. This is a careless oversight, and if these oversights continue, synthesis processes will pile up on the server, and we will eventually overwhelm the CPU, resulting in audio drop-outs and possibly server crashes. The correction:

(
{
	var sig, env;
	env = EnvGen.kr(
		Env.new(
			[1,0],
			[4],
			[-3]
		),
		doneAction:2
	);
	sig = Blip.ar([300,305], 16);
	sig = sig * LFPulse.kr(12, width:0.2);
	sig = sig * env;
	sig = sig * 0.4!2;
}.play
)


//Problem 4
//The following UGen function is supposed to play a tone with a 1 second fade-in and 1 second fade out. But, we just hear a steady tone for 2 seconds. What's wrong? Fix the issue and add a comment.

(
{
	var sig, env;
	sig = SinOsc.ar(250);
	env = EnvGen.kr(
		Env.new(
			[0,1,0],
			[1,1],
			[0,0]
		),
		doneAction:2
	);
	sig = sig * 0.2!2;
}.play
)

//EMF: the envelope is never actually *applied* to the signal. Here is a corrected version:

(
{
	var sig, env;
	sig = SinOsc.ar(250);
	env = EnvGen.kr(
		Env.new(
			[0,1,0],
			[1,1],
			[0,0]
		),
		doneAction:2
	);
	sig = sig * env;
	sig = sig * 0.2!2;
}.play
)

//Problem 5
//The following UGen function produces a monophonic pink noise signal. Modify this UGen function, using Pan2, so that the output is a two-channel signal, and plays equally loud in both channels (i.e. is "panned center").

(
{
	var sig;
	sig = PinkNoise.ar(0.2);
}.play
)

//EMF: modified version:

(
{
	var sig;
	sig = PinkNoise.ar(0.2);
	sig = Pan2.ar(sig, 0);
}.play
)

//Problem 6
//Modify your work from the previous problem so that the sound slowly oscillates back and forth between the left and right speaker (instead of being fixed in the center), at a frequency of 1 Hz, i.e. a full "left-right-left" cycle once per second.

(
{
	var sig;
	sig = PinkNoise.ar(0.2);
	sig = Pan2.ar(sig, SinOsc.kr(1));
}.play
)

//Problem 7
//Modify your work from the previous problem, adding an amplitude envelope, so that the spatial noise gradually fades in over 5 seconds, then fades out over 5 seconds. Make sure the Synth process automatically frees itself after the envelope is complete.

(
{
	var sig, env;
	env = EnvGen.kr(
		Env.new(
			[0,1,0],
			[5,5],
			[1,-1]
		),
		doneAction:2
	);
	sig = PinkNoise.ar(0.2);
	sig = sig * env;
	sig = Pan2.ar(sig, SinOsc.kr(1));
}.play
)


//Problem 8
//Study the following UGen function, which passes an 80Hz sawtooth wave through a lowpass filter, with a cutoff frequency at 1 kHz.

(
{
	var sig;
	sig = Saw.ar(80);
	sig = LPF.ar(sig, 1000);
	sig = sig * 0.3!2;
}.play
)

//Create a synth "stab" by doing the following:

//a. Add an amplitude envelope. The envelope should start at a reasonably high amplitude and fade to zero over a relatively quick period of time, around 0.3 seconds or so.

//b. Add a second envelope to control the filter's cutoff frequency. The envelope should go from a high frequency (approx 15 kHz) to a very low frequency (approx 30 Hz). It should have a duration that is less than or equal to the duration of the amplitude envelope.

//c. Make sure the Synth frees itself after the longer envelope is finished.

//d. Tweak the parameters of these two envelopes (particularly the Env curves) so that it sounds like a nice *juicy* stab.

(
{
	var sig;
	sig = Saw.ar(80);
	sig = LPF.ar(sig, 1000);
	sig = sig * 0.3!2;
}.play
)

//EMF: stab version:

(
{
	var sig, freqEnv, ampEnv;
	freqEnv = EnvGen.ar(
		Env.new(
			[15000, 30],
			[0.3],
			[-10]
		)
	);
	ampEnv = EnvGen.ar(
		Env.new(
			[1,0],
			[0.7],
			[-2]
		),
		doneAction:2
	);
	sig = Saw.ar(80);
	sig = LPF.ar(sig, freqEnv);
	sig = sig * ampEnv;
	sig = sig * 0.3!2;

}.play
)


//Problem 9
//Modify your work from Problem 8 to create chords from your synth stab instrument. In particular:

//a. Separate the process of *defining* the function from the process of *evaluating* the function.

//b. Add a frequency argument and give it a sensible default value.

//c. Add arguments for the start and end values of the frequency envelope, and give them sensible default values.

//d. Remove the !2 and replace it with Pan2. being sure to add a pan argument, with a default value of 0.

//e. Add other arguments, if you feel like it (optional).

//f. In the part of your code that *evaluates* (i.e. "plays") the function, create at least two chords, each with at least five notes, with some tasteful panning variation on each note. Use arrays, randomness, iteration, etc. Get creative with it!

(
~stab = {
	arg freq=80, freqStart=15000, freqEnd=30,
	pan=0, amp=0.3;
	var sig, freqEnv, ampEnv;
	freqEnv = EnvGen.ar(
		Env.new(
			[freqStart, freqEnd],
			[0.3],
			[-10]
		)
	);
	ampEnv = EnvGen.ar(
		Env.new(
			[1,0],
			[0.5],
			[-3]
		),
		doneAction:2
	);
	sig = Saw.ar(freq);
	sig = LPF.ar(sig, freqEnv);
	sig = sig * ampEnv;
	sig = Pan2.ar(sig, pan, amp);
};
)

(
//chord function: accepts an array and produces sounds from those midi note numbers
~playChord = {
	arg array;
	array.do({
		arg n, i;
		~stab.play(
			args: [
				\freq, n.midicps,
				\freqStart, 15000,
				\freqEnd, n.midicps/2,
				\pan, (i+1).linlin(0,4,-0.5,0.5),
			]
		);
	});
};
)

//chords
~playChord.value([36,55,58,60,63]);
~playChord.value([39,53,55,58,62]);
~playChord.value([41,48,53,57,60]);


//Bonus problem (+1 point)
//Modify your the synth stab function so that it has a "chorus" effect. Each time the function is played, it should produce eight slightly detuned voices. Compensate for the increase in amplitude, if necessary. Copy and paste your chords from the previous problem to demonstrate your chorus effect.

(
~stab = {
	arg freq=80, detune=0.2, //detune = value in semitones
	freqStart=15000, freqEnd=30,
	pan=0, amp=0.05;
	var sig, freqEnv, ampEnv, detuneArray;
	freqEnv = EnvGen.ar(
		Env.new(
			[freqStart, freqEnd],
			[0.3],
			[-10]
		)
	);
	ampEnv = EnvGen.ar(
		Env.new(
			[1,0],
			[0.5],
			[-3]
		),
		doneAction:2
	);

	//eight random values based on detune, converted to frequency ratios
	detuneArray = {Rand(detune.neg, detune).midiratio}!8;

	sig = Saw.ar(freq * detuneArray);
	sig = sig.sum;
	sig = LPF.ar(sig, freqEnv);
	sig = sig * ampEnv;
	sig = Pan2.ar(sig, pan, amp);
};
)

(
//chord function: accepts an array and produces sounds from those midi note numbers
~playChord = {
	arg array, detune=0.2; //add detune argument to function
	array.do({
		arg n, i;
		~stab.play(
			args: [
				\freq, n.midicps,
				\freqStart, 15000,
				\freqEnd, n.midicps/2,
				\pan, (i+1).linlin(0,4,-0.5,0.5),
				\detune, detune,
			]
		);
	});
};
)

//chords, gentle chorus effect
//provide array of notes, and detune value
~playChord.value([36,55,58,60,63], 0.15);
~playChord.value([39,53,55,58,62], 0.15);
~playChord.value([41,48,53,57,60], 0.15);

//with somewhat extreme chorusing
~playChord.value([36,55,58,60,63], 0.5);
~playChord.value([39,53,55,58,62], 0.5);
~playChord.value([41,48,53,57,60], 0.5);