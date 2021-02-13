//Take-Home Midterm Exam
//MUS 499C Fall 2020
//Due 4pm CDT Friday Oct 9th

//First, save this scd file as a new file, renaming it with your Last name at the beginning of the file name (e.g. "Fieldsteel Midterm Exam"), and upload this renamed file to the course website for your submission.

//You may review your notes and other class materials, but collaboration with others is not allowed.

//Each problem is worth 10 points, for a total of 40. Each bonus question is worth 2 points. Minor code issues will result in small deductions (1-3 pts), and major code issues will result in larger deductions (4-9 pts). Problems left blank will receive no credit. Use comments where appropriate, which can help me understand your thought process. After all deductions and bonus points are summed, your point total will be scaled to 100.




//Problem 1 (adapted from Problem Set Week 2, #7/#8)
//Boot the audio server. Create a UGen funtion and use the plot method to graph exactly 6 complete cycles of a sine wave at 120 Hz, the overall amplitude of which decreases linearly from 1 to 0 over the first three cycles, and increases linearly from 0 to 1 over the next three cycles.


s.boot;

(
{
	var sig = SinOsc.ar(120);
	var env = EnvGen.kr(Env([0,1,0], [3/120, 3/120]),doneAction:Done.freeSelf);
	sig = sig * env;
}.plot(6/120)
)




//Problem 2 (adapted from Problem Set Week 1, #8)
//Create a function that has one input argument. The function should check to see whether its input is an integer multiple of four (including zero and negative numbers). If so, return that number. If not, return the closest multiple of 4 that is greater than the input value. If the input  provided is not a number (i.e. not an Integer and not a Float), return the string "not a number". After creating the function, write a few additional lines of code that demonstrate the use of this function by passing in several different values.

(
f = {
	|n|
	if (n.isNumber, {
		if(n.mod(4) == 0, {n}, {(n.div(4)+1)*4})
	},
	{"not a number"});
}
)

(-4..10).collect({|n| [n,f.(n)]})
f.("poo")


//Problem 3 (adapted from Problem Set Week 5, #2/#3)
//Create and plot an envelope that looks like this one:
//https://uofi.box.com/s/qjr6hvyk8ih13ie8obtcmlmk6lv9g0lv
//The total duration of the envelope must be exactly 6 seconds. Beyond the duration, it doesn't have to be "perfect" — just reasonably close. Then, create a play a UGen function, using this envelope to control the amplitude of a pink noise generator. Make sure the synthesis process is freed after completion.

(
{
var levels = [0,1,0,1,0,1,0];
var times = [1,1,1,1,1,1];
var curves = [0,0,5,-5,-5,5];
	var env = EnvGen.kr(Env(levels, times, curves), doneAction:Done.freeSelf);
	PinkNoise.ar(env);
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





//Bonus Problem #1 (+2)
//Without modifying the UGen function from Problem 4, write an additional bit of code (using the 'set' method and the \gate and \fadeTime arguments) that uses iteration to fade out all five Synths. Each Synth's fade time should be randomly generated, between 3 and 10 seconds.





//Bonus Problem #2 (+2)
//Modify the code that generates the Synths, so that five *unique* random values are selected from the Array (i.e. no duplicates — every five-note chord will have five different frequencies).


