//(Answers to) Problem Set Week 2

//Problem 1
//Boot the SuperCollider audio server.

s.boot;

//Problem 2
//The following code produces an error. Evaluate the code and study the error message in the post window. Correct the error and add a comment indicating what the problem was.

(
x = {
	//freq2 was not defined in the variable statement.
	var sig, freq, width, freq2;
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

	//the range method was preceded with a comma istead of a period.
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

	//the signal was multiplied by zero!
	//sig = sig * 0.0;

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

	//the SinOsc class requires an .ar method to create an audio rate instance.
	sig = sig + SinOsc.ar([150,150.6], 0, 0.15);

	sig = sig + BrownNoise.ar(0.04!2);
	sig = sig * Line.ar(0,1,10);
}.play;
)

x.free;

//Problem 6
//Use the plot method to graph the waveform of one second of white noise.

{WhiteNoise.ar}.plot(1);

//Problem 7
//Use the plot method to graph exactly 4 complete cycles of a triangle wave that has a frequency of 160 Hz.

{LFTri.ar(160)}.plot(1/40);

//Problem 8
//Modify the plot from the previous problem so that the overall amplitude of the triangle wave increases from 0 to 1 over the course of the plot.

{LFTri.ar(160, mul:Line.ar(0,1,1/40))}.plot(1/40);

//Problem 9
//If you grew up with a landline phone in your house, or watched certain classic horror movies, you may have heard the sound of a telephone that's been left off the hook for too long. It's kind of a disturbing sound: a periodic on-off pulsation of a harsh, mid-range tone. For those who have no idea what I'm talking about, paste this link into your browser:

//https://www.youtube.com/watch?v=KO_YErq1M-M

//Create and play a UGen function that emulates this sound. Through an analysis of this sound, I can tell you that it contains the following sinusoidal frequencies: [1400,2060,2450,2600]. The rest is up to you!

(
~phone = {
	var sig, amp;

	//tone pulsing amplitude signal
	amp = LFPulse.kr(5);

	//four tones summed
	sig = SinOsc.ar(1400);
	sig = sig + SinOsc.ar(2060);
	sig = sig + SinOsc.ar(2450);
	sig = sig + SinOsc.ar(2600);

	//apply amplitude, avoid clipping, make 2-channel
	sig = sig * amp * 0.05;
	sig!2;
}.play;
)

~phone.free;

//Problem 10
//Create and play a UGen function that emulates a police siren. You can use this video for reference:

//https://www.youtube.com/watch?v=1G9mNBUymP8

//Experiment with different types of oscillators to create the timbre, pitch range, etc. You'll get full credit if your emulation generally approximates the siren — you don't have to aim for perfection! But try to get close.


//EMF: here's a very simple version, if your version looks sort of like this, you've done reasonably well, enough to earn full credit. The numbers don't have to be precise, and it's possible to get full credit with different UGens.

(
~siren = {
	var sig, freq;

	//frequency of siren
	freq = SinOsc.ar(1/5).range(690,1226);

	//siren sound
	sig = LFTri.ar(freq);

	//avoid clipping & make 2-channel
	sig = sig * 0.1;
	sig!2;
}.play;
)

~siren.free;

//EMF: here's my own attempt at re-creating this sound as accurately as possible. I wouldn't expect most attempts to get this close, especially since it covers concepts not yet discussed (nuance of waveform phase, envelopes, reverb, softclip, gate & fadeTime), but this is perhaps a good piece of code to study once we get a bit farther!

(
~siren = {
	var sig, freq;
	freq = EnvGen.kr(Env.circle([690,1226,690],[2.45,2.45,0],[-5,0]));
	sig = SinOsc.ar(freq,[0,pi]).softclip * 0.2;
	sig = GVerb.ar(sig,99,5) * 0.2;
}.play;
)

~siren.set(\gate, 0, \fadeTime, 10); //drives away into the distance

//Optional Bonus Problem (+1 point)
//You might be familiar with a very distinctive type of lawn sprinkler. Paste the following link into you browser to see an image of one of these sprinklers:

//http://diy.sndimg.com/content/dam/images/diy/fullset/2014/2/24/0/RX-iStock-187558829_Water_Lawn_Sprinkler_h.jpg.rend.hgtvcom.616.462.suffix/1420798717602.jpeg

//And here's a video of one of these sprinklers in action:

//https://www.youtube.com/watch?v=-nA7kUgLykA

//These sprinklers produce a distinctive sound as they operate: a rapid-fire series of noise bursts for a few seconds, followed by noise bursts at a slower frequency for a longer period of time. Then, this cycle repeats. Here's a link to a clear and simple audio example of the sound itself:

//https://uofi.box.com/s/vi5qb9h4yh2uv6mcn9dni7ienjj3p318

//Create and play a UGen function that emulates this sound. The only UGens you'll need are WhiteNoise and LFPulse (but possibly more than two UGens in total).

(
~sprinkler = {
	var waterPulses, sprinklerSpeed, water, spatialPosition;

	//represents speed of sprinkler (fast vs slow pulses). relatively slow frequency.
	//one full cycle lasts about 6.67 secs.
	//17 pulses per second for 18% of the cycle,
	//7 pulses per second for 82% of the cycle.
	sprinklerSpeed = LFPulse.kr(0.15, 0, 0.18).range(7,17);

	//represents whether the sprinkler is spewing water. relatively fast frequency.
	//frequency controlled by sprinklerSpeed.
	//pulse wave alternates between 0.1 (on amplitude) & zero (off amplitude).
	//Pulse width is "on" 25% of cycle.
	waterPulses = LFPulse.kr(sprinklerSpeed,0,0.25).range(0,0.1);

	//white noise to simulate water sound.
	//amplitude determined by "waterPulses"
	water = WhiteNoise.ar(waterPulses)!2;

	//just for fun: uncomment these two lines for panning! (listen with headphones)
	//spatialPosition = VarSaw.kr(0.15,0,0.18).range(-1,1);
	//water = Balance2.ar(water[0], water[1], spatialPosition);

}.play
)