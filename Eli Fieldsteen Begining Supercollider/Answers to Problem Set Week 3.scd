//(Answers to) Problem Set Week 3

//Problem 1
//Generate an array of 16 random integers between 100 and 2000. Use an exponential distribution, so that the values tend toward the lower end of this range.

//There are a few different ways to do this:
Array.exprand(16, 100, 2000).asInteger;

//(technically these are not integers, but otherwise this is fine)
Array.exprand(16, 100, 2000).round(1);

Array.fill(16, {exprand(100,2000).asInteger});

//using the ! shortcut for the .dup method
{exprand(100,2000).asInteger}!16;



//Problem 2
//Generate an array containing 16 random odd integers between 100 and 2000. Use a linear distribution, so that the values are equally distributed across this range.

//Again, there are several ways you might approach this problem. I feel like this is the simplest/most elegant:
Array.fill(16, {(101,103..1999).choose})

//Alternatives:
Array.rand(16,50,999) * 2 + 1;

{rrand(50,999) * 2 - 1}!16;

(
Array.rand(16,101,2000).collect({
	arg n;
	if(n.even, {n-1}, {n});
});
)



//Problem 3
//Generate an array containing 16 random integer multiples of 50 between 100 and 2000. Use an exponential distribution. Also, use a global variable to store the array.

//similar to problems 1 and 2, this is not the only way to solve this problem.
a = Array.fill(16, {exprand(100,2000).round(50).asInteger});



//Problem 4
//Using the global variable from the previous problem, write some code that adds to the array four more multiples of 50 between 2000 and 3000. Use a linear distribution. The same global variable should now store this new, larger array.

//one option, using iteration
(
4.do({
	a = a.add(rrand(2000,3000).round(50));
});

a;	//this line is not necessary; just here
	//so that the new array prints in the post window
)

//a different option using array concatenation (++)
a = a ++ Array.fill(4, {rrand(2000,3000).round(50)});

//technically possible to do it manually, but this is inelegant/unoptimal:
(
a = a.add(rrand(2000,3000).round(50));
a = a.add(rrand(2000,3000).round(50));
a = a.add(rrand(2000,3000).round(50));
a = a.add(rrand(2000,3000).round(50));
)


//Problem 5
//Write some code that plots a graph of the contents of the new, larger array that you created in the previous problem. Arrays respond to the "plot" method (no need to overthink this problem).

a.plot;

//Problem 6
//Use the "series" method to generate an array of numbers that represent frequencies of the first 12 harmonics of the overtone series, with a fundamental starting at 350 Hz (include the fundamental, 12 frequencies total).

Array.series(12, 350, 350);



//Problem 7
//Use the "geom" method to generate an array of 8 numbers that represent signal amplitude. The first value should be 1, and each subsequent number should be equal to half the previous number.

Array.geom(8, 1, 0.5);



//Problem 8
//Use one or more iteration methods (do, collect, select, reject, etc.) to return an integer corresponding to the number of multiples of 100 that are contained in the array of 20 values (stored in your global variable from Problem 4).

//looks elegant on a single line:
a.select({ arg n; n.mod(100) == 0 }).size;

//NOTE: recall 'mod' is the modulo operator, which returns the
//remainder after dividing by the operator.
//i.e. "does the remainder of n divided by 100 equal zero?"
//i.e. "does n divide evenly into 100?"

//multi-line approach
(
var subArray;
subArray = a.select({
	arg n;
	n%100 == 0; //syntax shortcut for .mod
});
subArray.size;
)

//an alternative, using collect
//if the item is a multiple of 100, return 1.
//if not, return zero.
//sum the contents of the new array that collect returns.
a.collect({ arg n; if(n%100 == 0, {1}, {0}) }).sum;



//before continuing, boot the audio server:
Server.local.boot;



//Problem 9
//Consider the following UGen function, which produces a 2-channel sine wave with a frequency of 300 Hz and amplitude of 0.1. Use iteration to play this function five times, such that each instance has a random frequency between 200 and 1000 (exponential distribution).

(
Array.exprand(5, 200, 1000).do({
	arg n;
	{
		var sig;
		sig = SinOsc.ar(n);
		sig = sig * 0.1;
		sig!2;
	}.play;
});
)


//Problem 10
//Once again, consider the same UGen function. This time, use your global variable that holds the array of 20 values. Iterate over your array, using the values within as frequency values for SinOsc.

***IMPORTANT***
//Note that the amplitude has been intentionally lowered from 0.1 to 0.02, because 20 summed waveforms is louder than 5! Be mindful of ear safety!


(
a.do({
	arg n;
	{
		var sig;
		sig = SinOsc.ar(n);
		sig = sig * 0.02;
		sig!2;
	}.play;
});
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

//Here's one possible solution:
(
//declare a local variable
var amp;

//which holds an array containing the appropriate amplitude values
amp = Array.geom(a.size, 0.1, 0.75);

a.sort.do({
	arg n, i;
	{
		var sig;
		sig = SinOsc.ar(n);

		//when the amplitude is needed, simply index into the array,
		//using the index argument declared inside the iteration block.
		sig = sig * amp.at(i);
		sig!2;
	}.play;
});
)


//alternative solution:
(
a.sort.do({
	arg n, i;
	{
		var sig;
		sig = SinOsc.ar(n);

		//multiply the amplitude by the scaling factor,
		//raised to the power of the iteration index.
		//on the first pass, 0.75.pow(0) == 1.
		//next, 0.75.pow(1) == 0.75,
		//next, 0.75.pow(2) == 0.75 * 0.75 == 0.5625, etc.
		sig = sig * 0.1 * 0.75.pow(i);
		sig!2;
	}.play;
});
)





//Bonus Question (+1 pt)
//Modify your work from the final problem to generate 40 SinOsc generators instead of 20. Each of the original 20 oscillators should have a nearly-identical twin; the only difference between each original and its copy is that the frequency of each new copy should be slightly higher than its original, by a random float amount between 0.0 and 4.0. Sonically, the result should be similar, but now with a slow pulsing, beating sound. (Hint: the stutter method may be useful).

//your frequency array might look something like:
[150, 153.47338628769, 250, 251.30930900574, 300, 302.16426753998, ...etc... ]

(
var newArray;
newArray = a.sort.stutter;
newArray.do({
	arg n, i;
	if(i.odd, {n = n + rrand(0.0, 4.0)});
	{
		var sig;
		sig = SinOsc.ar(n);

		//reduce exponent by half to roughly preserve
		//amplitude of SinOscs (timbre) because we now
		//have twice as many oscillators
		//(precise, but not necessary)
		sig = sig * 0.1 * 0.75.pow(i/2);
		sig!2;
	}.play;
});
)