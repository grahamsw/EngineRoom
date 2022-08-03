//Problem Set Week 9
//Due 3pm CDT Thursday Oct 29th

//First, save this scd file as a new file, renaming it with your Last name at the beginning of the file name (e.g. "Fieldsteel Problem Set Week 9.scd").

//For this problem set, I am providing you with some starting SynthDefs - one that loops a buffer, one that applies a flanger effect to an input signal, and one that applies a reverb effect to an input signal. You will reuse the drumloop1.wav sample from last week's homework. If you've deleted it, you can redownload it here:

https://uofi.box.com/s/vrh8j78mhend29hvyydpt4gygtlb0wfh


(
//Here are the starting SynthDefs.
//Boot the server, evaluate this clump of code, and take a few minutes to study them.
SynthDef.new(\playbuf, {
	arg buf=0, rate=1, amp=0.3, gate=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env.asr(0,1,2,-1), gate, doneAction:2);
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf) * rate, loop:1);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;

SynthDef.new(\flanger, {
	arg in=0, out=0;
	var sig, flanger;
	sig = In.ar(in, 2);
	flanger = In.ar(in, 2);

	//Note for the curious: a flanger effect is created by summing a signal with a delayed copy of itself, in which the delay time is varying (typically sinusoidally). This creates predictable patterns of constructive and destructive interference, resulting in a sweeping resonance effect that follows the pattern of the sine wave (in this case, the pitch of the resonance varies between 100 and 1000 Hz)
	flanger = CombL.ar(sig, 0.01, SinOsc.ar(0.1, pi/2).exprange(0.001,0.01), 0.03);
	sig = (sig + flanger) * 0.5;

	Out.ar(out, sig);
}).add;

SynthDef.new(\reverb, {
	arg in=0, drylevel=0.7, wetlevel=0.3, out=0;
	var sig, reverb;
	sig = In.ar(in, 2);
	reverb = In.ar(in, 2);
	reverb = LPF.ar(GVerb.ar(sig, 250, 4), 900);
	sig = (sig * drylevel) + (reverb * wetlevel);
	Out.ar(out, sig);
}).add;
)

//Problem 1. Load the drum loop audio file into a Buffer, stored in a global variable. Make sure to follow the "thisProcess.nowExecutingPath method," structuring a folder appropriately (exactly as you did last week). When you are ready to submit your answers for this problem set, make sure to create a zip file from your folder that contains this code file *and* the drum loop audio file. I should be able to run your code without needing to change the file path.



(

var root = PathName(thisProcess.nowExecutingPath).parentPath.postln;

~drum = Buffer.read(s, root ++ "audio/drumloop1.wav");
~bell = Buffer.read(s, root ++ "audio/deskBell.aiff");

)

~drum.play






//Problem 2. Write some code that plays (loops) through the buffer, sending the audio signal through the flanger effect, and sending the flanger output through the reverb. This will involve allocating some audio busses using Bus.audio. Add one or more lines of code afterward that stop the sound and handle cleanup (e.g. fade out the \playbuf Synth, free the effect Synths). Do this without using Groups. The signal path should look like this:

// [buf] --> [flange] --> [verb] --> [speakers]
(

~audio = Bus.audio(s, 2);
~flanged = Bus.audio(s,2);

)
(
~player = Synth(\playbuf, [\buf, ~drum, \out, ~audio]);

~flanger = Synth(\flanger, [\in, ~audio, \out, ~flanged ], ~player, 'addAfter');

~reverber = Synth(\reverb, [\in, ~flanged, \out, 0], ~flanger, 'addAfter');

)

(
Routine({
~player.set(\gate, 0);
5.wait;

~flanger.free;
~reverber.free;
}).play
)







//Problem 3. Same as the previous problem, but this time, create and use some Groups to help organize your signal flow. Remember that you only have to allocated busses once, and redundant bus allocation can lead to problems. Reuse the busses you allocated from the previous problem. Don't forget to include cleanup code again, making sure to remove the Groups as well.


(

~audioGroup = Group.new;
~flangerGroup = Group.new(~audioGroup);
~reverbGroup = Group.new(~flangerGroup);


~player = Synth(\playbuf, [\buf, ~drum, \out, ~audio], ~audioGroup);

~flanger = Synth(\flanger, [\in, ~audio, \out, ~flanged ], ~flangerGroup);

~reverber = Synth(\reverb, [\in, ~flanged, \out, 0], ~reverbGroup);

)

(
Routine({
~player.set(\gate, 0);
5.wait;

	~reverbGroup.free;
	2.wait;
	~flangerGroup.free;
	2.wait;
	~audioGroup.free;
}).play
)




//Problem 4. Same as the previous problem, but swap the order of the two effects. Include some cleanup code. The signal path should look like this:

// [buf] --> [verb] --> [flange] --> [speakers]

(

~audioGroup = Group.new;
~reverbGroup = Group.new(~audioGroup, \addAfter);
~flangerGroup = Group.new(~reverbGroup, \addAfter);


~player = Synth(\playbuf, [\buf, ~drum, \out, ~audio], ~audioGroup);


~reverber = Synth(\reverb, [\in, ~audio, \out, ~flanger], ~reverbGroup);
~flanger = Synth(\flanger, [\in, ~flanger, \out, 0 ], ~flangerGroup);

)

(
Routine({
~player.set(\gate, 0);
5.wait;

	~reverbGroup.free;
	2.wait;
	~flangerGroup.free;
	2.wait;
	~audioGroup.free;
}).play
)






//Problem 5. Write some code that loops the buffer, and sends that audio signal to both effects in parallel, instead of in series. This will involve modifying the \playbuf SynthDef so that there are two "Out.ar" UGens (and a second bus argument as well), one for each signal path. You can use Groups if you want, but this is not required – your choice. The signal path should look like this:

// [buf] -----> [verb] ----> [speakers]
//         |                     ^
//         |                     |
//         |                     |
//         \--> [flange] --------/




(



~player = Synth(\playbuf, [\buf, ~drum, \out, ~audio]);


~reverber = Synth(\reverb, [\in, ~audio, \out, 0],~player, \addAfter );
~flanger = Synth(\flanger, [\in, ~audio, \out, 1 ], ~player, \addAfter);

)




