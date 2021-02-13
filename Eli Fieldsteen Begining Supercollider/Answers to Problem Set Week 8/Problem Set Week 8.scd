//Problem Set Week 8
//Due 3pm CDT Thursday Oct 22nd


//First, save this scd file as a new file, renaming it with your Last name at the beginning of the file name (e.g. "Fieldsteel Problem Set Week 8.scd").

//Problem 1
//Download the following two audio samples (a desk bell and a drum loop):

https://uofi.box.com/s/vrh8j78mhend29hvyydpt4gygtlb0wfh //drum loop
https://uofi.box.com/s/2jcyp9wic50dqs78fa1weyijihldwwtj //desk bell

//Boot the audio server. Then, follow the approach shown in the lecture videos to create a project folder that contains your code file and audio files: create a new folder on your computer named "LastName Problem Set Week 8," and save your scd file in that folder. Then, create a sub-folder in that folder, named "audio," and store the two downloaded audio files in that folder. **NOTE: when you submit your assignment, make sure to compress the parent folder as a zip file and submit the zip file, so that your submission contains code and audio -- don't submit only the scd file!!**

//Using the "thisProcess.nowExecutingPath" approach, write some code that reads these two files into Buffers, and stores the result in a pair of global variables, one for each sound file. I should be able to run this code on my own computer to read these files into buffers, without having to change any of your code.


(

var root = PathName(thisProcess.nowExecutingPath).parentPath.postln;

~drum = Buffer.read(s, root ++ "audio/drumloop1.wav");
~bell = Buffer.read(s, root ++ "audio/deskBell.aiff");

)



//Problem 2
//Write a line of code that returns the number of channels in the drum loop file, and another line of code that returns the number of channels in the delk bell file.

~drum.numChannels.postln;
~bell.numChannels.postln;


//Problem 3
//Write a simple sound function (not a SynthDef) that plays the desk bell sample once, at its original playback rate.

{ PlayBuf.ar(~bell.numChannels, ~bell, BufRateScale.ir(~bell), doneAction:2)}.play




//Problem 4
//Use iteration to play a desk bell chord with five unique pitches. Don't use randomness — choose five pitches yourself. Be mindful of amplitude.

(



	[0,5,7,9, 12].do({
		|n|
		{PlayBuf.ar(
			~bell.numChannels,
			~bell,
			BufRateScale.ir(~bell) * n.midiratio,
			doneAction:2)

	}.play
	}
)


)





//Problem 5
//Create and play a Routine that quickly arpeggiates the pitches in your chord from the previous problem. The arpeggio should go up and down (the top-most pitch should only be heard once).



(

r =  Routine({

	[0,5,7,9, 12].mirror.do({
		|n|
		{PlayBuf.ar(
			~bell.numChannels,
			~bell,
			BufRateScale.ir(~bell) * n.midiratio,
			doneAction:2)

	}.play;
		0.2.wait;
	}
)
}).play

)




//Problem 6
//Write a simple sound function (not a SynthDef) that loops through the drum sample indefinitely. Include a gated amplitude envelope in your UGen function. Include a line of code that fades out the sample loop over 5 seconds.

(
p =
{
	|gate=1|
	var sig, env;
	sig = PlayBuf.ar(
		~drum.numChannels,
		~drum,
		BufRateScale.ir(~drum),
		loop:1
	);
	env = EnvGen.kr(Env.asr(0.01, 0.4, 5, [1,-1]), gate, doneAction:Done.freeSelf);
	sig * env;
};
)
x = p.play;

x.set(\gate, 0);


//Problem 7
//Modify the code from the previous problem so that the loop plays backwards.


(
p =
{
	|gate=1|
	var sig, env;
	sig = PlayBuf.ar(
		~drum.numChannels,
		~drum,
		-1 * BufRateScale.ir(~drum),
		loop:1
	);
	env = EnvGen.kr(Env.asr(0.01, 0.4, 5, [1,-1]), gate, doneAction:Done.freeSelf);
	sig * env;
};
)
x = p.play;

x.set(\gate, 0);




//Problem 8
//Create and add a SynthDef, using PlayBuf and EnvGen, that is capable of playing an arbitrary sub-section of an audio file (you can copy this from the week 8 lecture video, but it's good practice to try to build it from scratch on your own!). The SynthDef should have arguments for bufnum, playback rate, start position, overall amplitude, and for durations of the envelope segments. Give these arguments sensible default values. Specify loop and doneActions appropriately. Add a few lines of code that create new Synths in order to demonstrate how your SynthDef works.

(
SynthDef(\sp, {
	| bufnum = 0, startpos = 0, rate = 1, amp = 0.1, atk = 0.1, rel =0.1 |
	var sig, env;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.ir(bufnum) * rate, startPos: startpos);
	env = EnvGen.kr(Env([0,1, 0], [atk, rel]), doneAction:Done.freeSelf);
	Out.ar(0,sig * env * amp);

}).add;

)

Synth(\sp, [\bufnum, ~drum])

Synth(\sp, [\bufnum, ~drum, \rate, 1, \startpos, ~drum.numFrames * 0.911, \atk, 0.02, \rel, 0.01, \amp, 1])



//Problem 9
//Create and play Routine that produces an infinite-length rhythmic sequence of short chunks from both audio files. The routine should alternate back and forth between a drum chunk and a bell chunk, but not always the same exact pair of chunks. Keep in mind that all of the desk bell "content" is near the beginning of the file, so it doesn't make sense to choose chunks from the end of the bell sample. Other parameters are at your discretion, but try to make it sound cool!
(

r = Routine({
	var cur = ~bell;

	loop {

		var rate = rrand(-1.0, 1.0);
		var amp = rrand(0.01, 0.8);
		var atk = rrand(0.01, 0.8);
		var rel = rrand(0.01, 0.8);
		var startpos = if (cur == ~bell, {rrand(0,0.1) * ~bell.numFrames}, {rrand(0, 0.5) * ~drum.numFrames});


	Synth(\sp,[\bufnum, cur, \rate, rate, \startpos, startpos, \atk, atk, \rel, rel, \amp, 0.2]);

		cur = if (cur == ~bell, {~drum}, {~bell});
		rrand(0.01, 0.2).wait;
	}

});

)


r.play

//Bonus Problem (+1)
//Modify Problem 6 so that it uses BufRd instead of PlayBuf. The resulting sound should be exactly the same.


(
p =
{
	|gate=1|
	var sig, env;
	sig = BufRd.ar(
	sig = PlayBuf.ar(
		~drum.numChannels,
		~drum,
		BufRateScale.ir(~drum),
		loop:1
	);
	env = EnvGen.kr(Env.asr(0.01, 0.4, 5, [1,-1]), gate, doneAction:Done.freeSelf);
	sig * env;
};
)
x = p.play;

x.set(\gate, 0);





(
x = {
	var sig, ptr;
	ptr = LFSaw.ar(
		~drum.duration.reciprocal * SinOsc.kr(1/10).range(0.1, 2),
		1
	).range(0, ~drum.numFrames - 1);
	sig = BufRd.ar(2, ~drum, ptr);
	sig = sig * 0.4;
}.play;
)

x.release(5);

