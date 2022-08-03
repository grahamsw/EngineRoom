//Problem Set Week 2
//Due 3pm CDT Sept 10th

//First, save this scd file as a new file, renaming it with your Last name at the beginning of the file name (e.g. "Fieldsteel Problem Set Week 2.scd"), and upload this renamed file to the course website for your submission.

//As you complete this assignment, be mindful of ear safety. Before running code that produces sound, turn your system volume nearly or completely all the way down, remove headphones, and monitor the visual level on the output meters (evaluate s.meter). Then, slowly turn up your system volume.

//Refer to the "essential UGens.scd" document for a list of commonly used UGens (available on the Lecture section of the course website and linked in the video description for the Week 2 live stream archive). To learn more about each UGen, you can run the examples in the SC help files, and you can also experiment with playing (and plotting) your own simple UGen functions. You may have to experiment a bit!


//Problem 1
//Boot the SuperCollider audio server.




//Problem 2
//The following code produces an error. Evaluate the code and study the error message in the post window. Correct the error and add a comment indicating what the problem was.

(
x = {
	var sig, freq, freq2, width;
	freq = LFSaw.ar(1/5,1).exprange(200,1500);
	freq2 = LFNoise0.ar(40!2).range(1,100);
	freq = (freq + freq2).round(50);
	width = LFTri.ar(0.2).exprange(0.02,0.5);
	sig = VarSaw.ar(freq, 0, width, 0.05);
	sig!2;
}.play;
)

x.free;




//Problem 3
//The following code produces an error. Evaluate the code and study the error message in the post window. Correct the error and add a comment indicating what the problem was.

(
x = {
	var sig, freq, amp;
	freq = LFNoise0.ar(9).exprange(40,500);
	amp = LFSaw.ar(9,1).range(0,1).sqrt.sqrt.neg + 1;
	sig = SinOsc.ar(freq, 0, 0.2) * amp;
	sig!2;
}.play;
)

x.free;




//Problem 4
//The following code does not produce an error, but fails to produce sound. Correct the error and add a comment indicating what the problem was.

(
x = {
	var sig, noiseHz;
	noiseHz = LFNoise1.ar(10).exprange(100,5000);
	sig = LFDNoise1.ar(noiseHz, 0.08);
	sig = sig * 0.4;
	sig = sig!2;
}.play;
)

x.free;



//Problem 5
//The following code does not produce an error, but fails to produce sound. Correct the error and add a comment indicating what the problem was.

(
x = {
	var sig;
	sig = Pulse.ar([100,101], 0.5, 0.04);
	sig = sig + SinOsc.ar([150,150.6], 0, 0.15);
	sig = sig + BrownNoise.ar(0.04!2);
	sig = sig * Line.ar(0,1,10);
}.play;
)

x.free;



//Problem 6
//Use the plot method to graph the waveform of one second of white noise.

{WhiteNoise.ar}.plot(1)


//Problem 7
//Use the plot method to graph exactly 4 complete cycles of a triangle wave that has a frequency of 160 Hz.

{LFTri.ar(160) *  Line.ar(0,1,4/160)}.plot(4/160)


//Problem 8
//Modify the plot from the previous problem so that the overall amplitude of the triangle wave increases from 0 to 1 over the course of the plot.
{LFTri.ar(160)}.plot(4/160)




//Problem 9
//If you grew up with a landline phone in your house, or watched certain classic horror movies, you may have heard the sound of a telephone that's been left off the hook for too long. It's kind of a disturbing sound: a periodic on-off pulsation of a harsh, mid-range tone. For those who have no idea what I'm talking about, paste this link into your browser:

//https://www.youtube.com/watch?v=KO_YErq1M-M

//Create and play a UGen function that emulates this sound. Through an analysis of this sound, I can tell you that it contains the following sinusoidal frequencies: [1400,2060,2450,2600]. The rest is up to you!

{Mix.ar(SinOsc.ar([1400,2060,2450,2600]))*0.1 * LFPulse.kr(5) }.play



//Problem 10
//Create and play a UGen function that emulates a police siren. You can use this video for reference:

//https://www.youtube.com/watch?v=1G9mNBUymP8

//Experiment with different types of oscillators to create the timbre, pitch range, etc. You'll get full credit if your emulation generally approximates the siren — you don't have to aim for perfection! But try to get close.
(
{
	var freq = SinOsc.ar(1/5).range(600, 1200);
    Mix(LFTri.ar(freq)!2 * 0.1);
}.play
)


//Optional Bonus Problem (+1 point)
//You might be familiar with a very distinctive type of lawn sprinkler. Paste the following link into you browser to see an image of one of these sprinklers:

//http://diy.sndimg.com/content/dam/images/diy/fullset/2014/2/24/0/RX-iStock-187558829_Water_Lawn_Sprinkler_h.jpg.rend.hgtvcom.616.462.suffix/1420798717602.jpeg

//And here's a video of one of these sprinklers in action:

//https://www.youtube.com/watch?v=-nA7kUgLykA

//These sprinklers produce a distinctive sound as they operate: a rapid-fire series of noise bursts for a few seconds, followed by noise bursts at a slower frequency for a longer period of time. Then, this cycle repeats. Here's a link to a clear and simple audio example of the sound itself:

//https://uofi.box.com/s/vi5qb9h4yh2uv6mcn9dni7ienjj3p318

//Create and play a UGen function that emulates this sound. The only UGens you'll need are WhiteNoise and LFPulse (but possibly more than two UGens in total).

(
{
	(WhiteNoise.ar * LFPulse.ar(10) * LFPulse.ar(1/4) )
	+
	(WhiteNoise.ar * LFPulse.ar(2,width:0.05) * LFPulse.ar(1/4, pi/2))
}.play
)

pi