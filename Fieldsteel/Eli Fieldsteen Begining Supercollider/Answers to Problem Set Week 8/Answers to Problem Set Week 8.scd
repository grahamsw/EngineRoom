//Answers to Problem Set Week 8

//Problem 1
//Download the following two audio samples (a desk bell and a drum loop):

https://uofi.box.com/s/vrh8j78mhend29hvyydpt4gygtlb0wfh //drum loop
https://uofi.box.com/s/2jcyp9wic50dqs78fa1weyijihldwwtj //desk bell

//Boot the audio server. Then, follow the approach shown in the lecture videos to create a project folder that contains your code file and audio files: create a new folder on your computer named "LastName Problem Set Week 8," and save your scd file in that folder. Then, create a sub-folder in that folder, named "audio," and store the two downloaded audio files in that folder. **NOTE: when you submit your assignment, make sure to compress the parent folder as a zip file and submit the zip file, so that your submission contains code and audio -- don't submit only the scd file!!**

//Using the "thisProcess.nowExecutingPath" approach, write some code that reads these two files into Buffers, and stores the result in a pair of global variables, one for each sound file. I should be able to run this code on my own computer to read these files into buffers, without having to change any of your code.

s.boot;

(
~path = PathName.new(thisProcess.nowExecutingPath).parentPath ++ "audio/";
~drum = Buffer.read(s, ~path ++ "drumloop1.wav");
~bell = Buffer.read(s, ~path ++ "deskBell.aiff");
)


//Problem 2
//Write a line of code that returns the number of channels in the drum loop file, and another line of code that returns the number of channels in the delk bell file.

~drum.numChannels;

~bell.numChannels;


//Problem 3
//Write a simple sound function (not a SynthDef) that plays the desk bell sample once, at its original playback rate.

{PlayBuf.ar(2, ~bell, BufRateScale.ir(~bell), doneAction:2)}.play;


//Problem 4
//Use iteration to play a desk bell chord with five unique p(
[-11, -7, -5, -4, 0].do({
	arg semi;
	{
		PlayBuf.ar(
			2,
			~bell,
			BufRateScale.ir(~bell) * semi.midiratio,
			doneAction:2
		) * 0.3
	}.play;
});
)
itches. Don't use randomness — choose five pitches yourself. Be mindful of amplitude.



//Problem 5
//Create and play a Routine that quickly arpeggiates the pitches in your chord from the previous problem. The arpeggio should go up and down (the top-most pitch should only be heard once).

(
Routine.new({
	[-11, -7, -5, -4, 0].mirror.do({
		arg semi;
		{
			PlayBuf.ar(
				2,
				~bell,
				BufRateScale.ir(~bell) * semi.midiratio,
				doneAction:2
			) * 0.5
		}.play;
		0.08.wait;
	});
}).play;
)



//Problem 6
//Write a simple sound function (not a SynthDef) that loops through the drum sample indefinitely. Include a gated amplitude envelope in your UGen function. Include a line of code that fades out the sample loop over 5 seconds.

(
x = {
	arg gate=1;
	var sig, env;
	sig = PlayBuf.ar(2, ~drum, BufRateScale.ir(~drum), loop:1);
	env = EnvGen.kr(
		Env.asr(0.001, 0.4, 5, [1,-1]),
		gate,
		doneAction:2
	);
	sig = sig * env;
}.play;
)

x.set(\gate, 0);

//or:

(
x = {
	var sig;
	sig = PlayBuf.ar(2, ~drum, BufRateScale.ir(~drum), loop:1);
	sig = sig * 0.4;
}.play;
)

x.set(\gate, 0, \fadeTime, 5);

//or:

(
x = {
	var sig;
	sig = PlayBuf.ar(2, ~drum, BufRateScale.ir(~drum), loop:1);
	sig = sig * 0.4;
}.play;
)

x.release(5);

//Problem 7
//Modify the code from the previous problem so that the loop plays backwards.

(
x = {
	var sig;
	sig = PlayBuf.ar(2, ~drum, BufRateScale.ir(~drum) * -1, loop:1);
	sig = sig * 0.4;
}.play;
)

x.release(5);




//Problem 8
//Create a SynthDef, using PlayBuf and EnvGen, that is capable of playing an arbitrary sub-section of an audio file (you can copy this from the week 8 lecture video, but it's good practice to try to build it from scratch on your own!). The SynthDef should have arguments for bufnum, playback rate, start position, overall amplitude, and for durations of the envelope segments. Give these arguments sensible default values. Specify loop and doneActions appropriately. Add a few lines of code that create new Synths in order to demonstrate how your SynthDef works.

(
SynthDef.new(\pb, {
	arg buf=0, rate=1, spos=0, amp=0.5,
	atk=0.001, sus=0, rel=0.1, out=0;
	var sig, env;
	sig = PlayBuf.ar(
		2,
		buf,
		BufRateScale.kr(buf) * rate,
		trigger: 1,
		startPos: spos,
		loop: 1,
		doneAction: 0
	);
	env = EnvGen.ar(
		Env.new([0,1,1,0],[atk,sus,rel],[0,0,0]),
		doneAction:2
	);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

Synth(\pb, [\buf, ~drum, \spos, ~drum.numFrames.rand]);

Synth(\pb, [\buf, ~bell, \spos, 0, \rate, rrand(-10,3).midiratio]);


//Problem 9
//Create and play Routine that produces an infinite-length rhythmic sequence of short chunks from both audio files. The routine should alternate back and forth between a drum chunk and a bell chunk, but not always the same exact pair of chunks. Keep in mind that all of the desk bell "content" is near the beginning of the file, so it doesn't make sense to choose chunks from the end of the bell sample. Other parameters are at your discretion, but try to make it sound cool!

(
r = Routine.new({
	loop{
		Synth(\pb, [
			\buf, ~bell,
			\rate, (-12,-10..4).choose.midiratio,
		]);
		0.2.wait;
		Synth(\pb, [
			\buf, ~drum,
			\spos, (0,0.02..0.95).choose * ~drum.numFrames,
		]);
		[0.1,0.4].choose.wait;
	}
}).play;
)

r.stop;


//Bonus Problem (+1)
//Modify Problem 6 so that it uses BufRd instead of PlayBuf. The resulting sound should be exactly the same.

//EMF: a low-frequency sawtooth makes a good sample pointer, because it's a pure upward ramp shape. its frequency = 1 / buffer duration (because frequency = 1/period), the phase values is 1, which causes the sawtooth to start at its lowest value (corresponding to the beginning of sound file), and the output range of the sawtooth wave is 0 to last frame of buffer.

(
x = {
	var sig, ptr;
	ptr = LFSaw.ar(
		~drum.duration.reciprocal,
		1
	).range(0, ~drum.numFrames - 1);
	sig = BufRd.ar(2, ~drum, ptr);
	sig = sig * 0.4;
}.play;
)

x.release(5);