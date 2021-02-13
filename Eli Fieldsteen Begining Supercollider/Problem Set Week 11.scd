//Problem Set Week 11
//Due 3pm CDT Thursday November 12th

//First, save this scd file as a new file, renaming it with your Last name at the beginning of the file name (e.g. "Fieldsteel Problem Set Week 11.scd").

//Problem 1. Using a pattern (or combination of patterns), produce an infinite-length stream that outputs the number 1 approximately 97% of the time, and produces a random integer between 100-200 3% of the time. Include a line of code that generates the first 40 values of this stream.

(
p = Pwrand([1, Pwhite(100,200,1)], [0.97, 0.03], inf);

v = p.asStream.nextN(40)

)





//Problem 2. Using a pattern (or combination of patterns), produce a stream that outputs an infinite sequence of ascending integers that starts at one, but skips every multiple of five. Include a line of code that generates the first 40 values of this stream.

(
p = Pseries(1, 1, inf) + Pstutter(4, Pseries(0,1,inf));

p.asStream.nextN(40);
)





//Next, boot the server, then evaluate the following SynthDef. Study it well, and experiment with a few test lines of your own below. Feel free to modify this SynthDef so that it has some custom arguments and features of your own!

(
SynthDef.new(\basic, {

	arg freq=500, atk=0.002, sus=0, rel=1,
	pan=0, amp=0.1, out=0;

	var sig, env;

	env = EnvGen.ar(
		Env.new([0,1,1,0],[atk,sus,rel],[2,0,-2]),
		doneAction:2
	);

	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp) * env;
	Out.ar(out, sig);
}).add;
)

x = Synth(\basic); //testing


//Problem 3. using the SynthDef provided, create a Pbind, then play it to create an EventStreamPlayer. The event stream should produce exactly five Synths. (1) Each Synth should have a total duration of 0.05 seconds, (2) each frequency should be higher than the one before it, (3) each Synth should occur 1/4 second after the one before it, and (4) the amplitude of each Synth should decrease exponentially over time. Other details are up to you.


(

p = Pbind (
	\instrument, \basic,
	\dur, 0.25,
	\atk, 0.025,
	\rel, 0.025,
    \amp, Pgeom(0.1, 0.8, inf),
	\degree, Pseq([1,3,5,7,8], 1)
);

p.play
)

,



//Problem 4. Copy, paste, and modify your work from the previous problem so that (1) the pan position of each synth is a random float between -1 and 1 and (2) exactly one of these five notes is noticeably longer than the rest - but the note that is longer should be randomly chosen from the five each time the sequence is played.




(

p = Pbind (
	\instrument, \basic,
	\dur, 0.25 ,
	\atk, 0.025,
	\rel, (0.025+ Pshuf([0,0,0,0,1.5],inf)).trace,
	\amp, Pgeom(0.1, 0.8, inf),
	\degree, Pseq([1,3,5,7,8], 1),
	\pan, Pwhite(-1.0, 1.0, inf)
);

p.play
)






//Problem 5. A semi-free composition exercise: Using the SynthDef provided (and your modifications, if you made any), create and play a Pbind that produces a spectrally and spatially complex drone/pad sound. There should be lots and lots of simultaneous overlapping Synths, each with long attacks and long releases. Monitor your output amplitude and make sure the signal doesn't clip. Pitch content and other musical decisions are up to you. Make it sound awesome!
s.meter

(

p = Pbind (
	\instrument, \basic,
	\dur, Pwhite(0.01, 0.1, inf),
	\atk, Pbrown(0.1, 3, 0.1, inf),
	\rel,  Pbrown(0.1, 3, 0.1, inf),
    \amp, Pwhite(0.01, 0.02, inf),
	\degree, Pwhite(0, 7, inf)
);
x = p.play
x.stop
)






//Problem 6. Another semi-free composition exercise: Using the SynthDef provided (and your modifications, if you made any), create and play 3 different Pbinds that each produces a unique, interesting, somewhat complex, rhythmic, percussive texture. Create a TempoClock and write your code so that each Pbind can be manually evaluated, one after the other, but all three should play on the clock you created, and they should be perfectly synchronized (quantized) with each other. Rhythms, pitches, panning, amplitude, etc. is up to you, but get creative and make it sound cool!



(

t = TempoClock.new(30/60).permanent_(true);

Pbindef(\p1,
	\instrument, \basic,
	\dur, Pn(Pseq([0.5, 0.25, 0.25, 1], 2), inf),
    \degree, ,
	\rel, 0.2,
	\atk, 0.1,
	\amp, 0.3
);


Pbindef(\p2,
	\instrument, \basic,
	\dur, Pn(Pseq([0.25, 0.25,0.25, 0.25, 0.5, 0.5], 2), inf),
	\degree, 8,
	\amp, 0.01
);
)


t.tempo_(1);

Pdef(\p1).play(t,quant:2);

Pbindef(\p1).play(t, quant:2);
Pbindef(\p1, \degree, 2, \amp, 0).quant_(2);
Pbindef(\p1).stop;
Pbindef(\p2, \degree, Pseq([2, 4, 2, 2, 4, 4], inf)).quant_(2);




