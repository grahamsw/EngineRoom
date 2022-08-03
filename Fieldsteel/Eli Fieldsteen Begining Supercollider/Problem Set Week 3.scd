//Problem Set Week 3
//Due 3pm CDT Sept 17th

//First, save this scd file as a new file, renaming it with your Last name at the beginning of the file name (e.g. "Fieldsteel Problem Set Week 3.scd"), and upload this renamed file to the course website for your submission.

//As you complete this assignment, be mindful of ***ear safety***. Before running code that produces sound, turn your system volume nearly or completely all the way down, remove headphones, and monitor the visual level on the output meters (evaluate s.meter). Then, slowly turn up your system volume.


//Problem 1
//Generate an array of 16 random integers between 100 and 2000. Use an exponential distribution, so that the values tend toward the lower end of this range.

16.collect({exprand(100,200).asInteger})



//Problem 2
//Generate an array containing 16 random odd integers between 100 and 2000. Use a linear distribution, so that the values are equally distributed across this range.

16.collect({rrand(50, 999) * 2 + 1})


//Problem 3
//Generate an array containing 16 random integer multiples of 50 between 100 and 2000. Use an exponential distribution. Also, use a global variable to store the array.

a = 16.collect({exprand(2, 40).round * 50})

//Problem 4
//Using the global variable from the previous problem, write some code that adds to the array four more multiples of 50 between 2000 and 3000. Use a linear distribution. The same global variable should now store this new, larger array.
a = a ++ 4.collect({exprand(2, 40).round * 50})

a.size


//Problem 5
//Write some code that plots a graph of the contents of the new, larger array that you created in the previous problem. Arrays respond to the "plot" method. (no need to overthink this problem.)

a.plot

//Problem 6
//Use the "series" method to generate an array of numbers that represent frequencies of the first 12 harmonics of the overtone series, with a fundamental starting at 350 Hz (include the fundamental, 12 frequencies total).

Array.series(12, 350, 350)

//Problem 7
//Use the "geom" method to generate an array of 8 numbers that represent signal amplitude. The first value should be 1, and each subsequent number should be equal to half the previous number.
Array.geom(8, 1, 0.5)



//Problem 8
//Use one or more iteration methods (do, collect, select, reject, etc.) to return an integer corresponding to the number of multiples of 100 that are contained in the array of values (stored in your global variable from Problem 4).
a.select({|i| i.mod(4) == 0}).size


//before continuing, boot the audio server:
Server.local.boot;



//Problem 9
//Consider the following UGen function, which produces a 2-channel sine wave with a frequency of 300 Hz and amplitude of 0.1. Use iteration to play this function five times, such that each instance has a random frequency between 200 and 1000 (exponential distribution).

(
a.do({ |val|
{
	var sig;
		sig = SinOsc.ar(val);
	sig = sig * 0.05;
	sig!2;
}.play;
})
)



//Problem 10
//Once again, consider the same UGen function. This time, use your global variable that holds the array of 20 values. Iterate over your array, using the values within as frequency values for SinOsc.

***IMPORTANT***
//Note that the amplitude has been intentionally lowered from 0.1 to 0.02, because 20 summed waveforms is louder than 5! Be mindful of ear safety!

(
{
	var sig;
	sig = SinOsc.ar(300);
	sig = sig * 0.02;
	sig!2;
}.play;
)



//Problem 11
/*
Modify your work from the previous problem, making the following changes:

- the frequency array should be sorted from low to high

- the amplitude of the 0th SinOsc should be 0.1

- the amplitude of each subsequent SinOsc should be
0.75 times as loud as the previous one (hint: declare
a second argument in your iteration function so you can
access the iteration count)
*/

//The result should be a more "bass-heavy" timbre.
(
a.sort.do({ |val, i|
{
	var sig;
		sig = SinOsc.ar(val);
		sig = sig * (i + 1).reciprocal * 0.05;
	sig!2;
}.play;
})
)


//Bonus Question (+1 pt)
//Modify your work from the final problem to generate 40 SinOsc generators instead of 20. Each of the original 20 oscillators should have a nearly-identical twin; the only difference between each original and its copy is that the frequency of each new copy should be slightly higher than its original, by a random float amount between 0.0 and 4.0. Sonically, the result should be similar, but now with a slow pulsing, beating sound. (Hint: the stutter method may be useful).

//your frequency array might look something like:
[150, 153.47338628769, 250, 251.30930900574, 300, 302.16426753998, ...etc... ]


(1..4).stutter.collect({|v,i| if (i.mod(2)== 0, {v}, {v + rrand(0.0, 4.0)})})


(
a.stutter.collect({|v,i| if (i.mod(2)== 0, {v}, {v + rrand(0.0, 4.0)})}).sort.do({ |val, i|
{
	var sig;
		sig = SinOsc.ar(val);
		sig = sig * (i + 1).reciprocal * 0.05;
	sig!2;
}.play;
})
)
