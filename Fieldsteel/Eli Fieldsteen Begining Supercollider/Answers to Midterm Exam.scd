//Answers to Take-Home Midterm Exam
//MUS 499C Fall 2020

//Problem 1 (adapted from Problem Set Week 2, #7/#8)
//Boot the audio server. Create a UGen funtion and use the plot method to graph exactly 6 complete cycles of a sine wave at 120 Hz, the overall amplitude of which decreases linearly from 1 to 0 over the first three cycles, and increases linearly from 0 to 1 over the next three cycles.

s.boot;

{SinOsc.ar(120) * LFTri.ar(20,1).range(0,1)}.plot(0.05);

//or

{SinOsc.ar(120) * EnvGen.ar(Env([1,0,1],[0.025,0.025],[0,0]))}.plot(0.05);



//Problem 2 (adapted from Problem Set Week 1, #8)
//Create a function that has one input argument. The function should check to see whether its input is an integer multiple of four (including zero and negative numbers). If so, return that number. If not, return the closest multiple of 4 that is greater than the input value. If the input  provided is not a number (i.e. not an Integer and not a Float), return the string "not a number". After creating the function, write a few additional lines of code that demonstrate the use of this function by passing in several different values.

(
f = {
	arg input;
	if(
		(input.class != Float) && (input.class != Integer),
		{"not a number"},
		{
			if(
				input % 4 == 0,
				{input},
				//if not a multiple of four,
				//subtract division remainder and add 4 to produce next-highest multiple
				{input = input - (input%4) + 4}
			);
		}
	);
};
)

f.value(4000);
f.value(4000.99);
f.value(-83);
f.value(-84.0);
f.value("hot potato");


//Problem 3 (adapted from Problem Set Week 5, #2/#3)
//Create and plot an envelope that looks like this one:
//https://uofi.box.com/s/qjr6hvyk8ih13ie8obtcmlmk6lv9g0lv
//The total duration of the envelope must be exactly 6 seconds. Beyond the duration, it doesn't have to be "perfect" — just reasonably close. Then, create a play a UGen function, using this envelope to control the amplitude of a pink noise generator. Make sure the synthesis process is freed after completion.

(
e = Env.new([0,1,0,1,0,1,0], 1!6, [0,0,6,-6,-6,6]);
e.plot;
)

(
{
	var sig, env;
	env = EnvGen.kr(e, doneAction:2);
	sig = PinkNoise.ar(0.5!2);
	sig = sig * env;
}.play
)


//Problem 4 (adapted from Problem Set Week 3, #9)
//Study and evaluate the following UGen function. Below this clump of code, use iteration (e.g. 5.collect) to play five instances of this UGen function, storing the resulting five synthesis processes in an array (named with a global variable). For each of the five Synths, the sawtooth oscillator frequency should be randomly chosen from the MIDI note array [36, 48, 55, 60, 62, 63, 65, 67, 70]. Use the 'choose' method to select a number and use the 'midicps' method to convert from note numbers to frequency values in Hz. The filter cutoff frequency of each Synth should be equal to twice the value of the frequency of its sawtooth oscillator.

(
f = {
	arg freq=80, cutoff=1000;
	var sig;
	sig = Saw.ar([freq,freq*1.01]);
	sig = LPF.ar(sig, cutoff);
	sig = sig * 0.2;
};
)

(
~freqs = [36, 48, 55, 60, 62, 63, 65, 67, 70].midicps;
x = 5.collect({
	var freq;
	freq = ~freqs.choose;
	f.play(args:[\freq, freq, \cutoff, freq*2]);
});
)




//Bonus Problem #1 (+2)
//Without modifying the UGen function from Problem 4, write an additional bit of code (using the 'set' method and the \gate and \fadeTime arguments) that uses iteration to fade out all five Synths. Each Synth's fade time should be randomly generated, between 3 and 10 seconds.

x.do({ arg n; n.set(\gate, 0, \fadeTime, exprand(3,10)) });



//Bonus Problem #2 (+2)
//Modify the code that generates the Synths, so that five *unique* random values are selected from the Array (i.e. no duplicates — every five-note chord will have five different frequencies).

(
~freqs = [36, 48, 55, 60, 62, 63, 65, 67, 70].midicps;

//create array of five values, randomly removing one item at a time from the original array
~freqs = 5.collect({ ~freqs.removeAt(rrand(0, ~freqs.size-1)) });

x = 5.collect({
	arg n; //counts integers from 0 to 4
	var freq;
	freq = ~freqs[n].postln; //take each frequency in sequence
	f.play(args:[\freq, freq, \cutoff, freq*2]);
});
)

//or, using a syntax shortcut for returning an array subset:

(
~freqs = [36, 48, 55, 60, 62, 63, 65, 67, 70].midicps;
~freqs = ~freqs.scramble[0..4]; //scramble the array and take the first five numbers;

x = 5.collect({
	arg n; //counts integers from 0 to 4
	var freq;
	freq = ~freqs[n].postln; //take each frequency in sequence
	f.play(args:[\freq, freq, \cutoff, freq*2]);
});
)