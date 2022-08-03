//Problem Set Week 11
//Due 3pm CDT Thursday November 12th

//First, save this scd file as a new file, renaming it with your Last name at the beginning of the file name (e.g. "Fieldsteel Problem Set Week 11.scd").

//Problem 1. Using a pattern (or combination of patterns), produce an infinite-length stream that outputs the number 1 approximately 97% of the time, and produces a random integer between 100-200 3% of the time. Include a line of code that generates the first 40 values of this stream.

(
p = Pwrand([1, Pwhite(100,200,1)], [0.97,0.03], inf);
q = p.asStream;
)

q.nextN(40);

//Problem 2. Using a pattern (or combination of patterns), produce a stream that outputs an infinite sequence of ascending integers that starts at one, but skips every multiple of five. Include a line of code that generates the first 40 values of this stream.

//EMF: There are lots of ways to solve this problem. Here's one of them.

(
p = Pseries(1,1,inf) + Pstutter(4, Pseries(0,1,inf));
q = p.asStream;
)

q.nextN(40);

//Next, boot the server, then evaluate the following SynthDef. Study it well, and experiment with a few test lines of your own below. Feel free to modify this SynthDef so that it has some custom arguments and features of your own!

s.boot;

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
p = Pbind(
	\instrument, \basic,
	\dur, 1/4,
	\atk, 0.01,
	\rel, 0.04,
	\freq, Pgeom(340, 1.4, 5),
	\amp, Pgeom(0.5,0.6,5),
);
q = p.play;
)

//Problem 4. Copy, paste, and modify your work from the previous problem so that (1) the pan position of each synth is a random float between -1 and 1 and (2) exactly one of these five notes is noticeably longer than the rest - but the note that is longer should be randomly chosen from the five each time the sequence is played.

(
p = Pbind(
	\instrument, \basic,
	\dur, 1/4,
	\atk, 0.01,
	\rel, 0.04 * Pshuf([1,1,1,1,30],1),
	\freq, Pgeom(340, 1.4, 5),
	\amp, Pgeom(0.5,0.6,5),
	\pan, Pwhite(-1.0,1.0),
);
q = p.play;
)

//Problem 5. A semi-free composition exercise: Using the SynthDef provided (and your modifications, if you made any), create and play a Pbind that produces a spectrally and spatially complex drone/pad sound. There should be lots and lots of simultaneous overlapping Synths, each with long attacks and long releases. Monitor your output amplitude and make sure the signal doesn't clip. Pitch content and other musical decisions are up to you. Make it sound awesome!

//EMF: yours may be wildly different!

(
p = Pbind(
	\instrument, \basic,
	\dur, Pexprand(0.1,1,inf),
	\atk, Pexprand(1,5,inf),
	\sus, 0,
	\rel, Pexprand(2,8,inf),
	\midinote, 38 + Pwhite(-0.4,0.4,inf),
	\harmonic, Pexprand(1,40,inf).round(1),
	\amp, Pfunc({
		arg ev;
		//amplitude is a function of harmonic number
		//(higher harmonics have lower amplitudes)
		ev[\harmonic].reciprocal.pow(0.8);
	}) * 0.1,
	\pan, Pwhite(-0.8,0.8),
);
q = p.play;
)

q.stop;

//Problem 6. Another semi-free composition exercise: Using the SynthDef provided (and your modifications, if you made any), create and play 3 different Pbinds that each produces a unique, interesting, somewhat complex, rhythmic, percussive texture. Create a TempoClock and write your code so that each Pbind can be manually evaluated, one after the other, but all three should play on the clock you created, and they should be perfectly synchronized (quantized) with each other. Rhythms, pitches, panning, amplitude, etc. is up to you, but get creative and make it sound cool!

(
t = TempoClock.new(144/60).permanent_(true);

a = Pbind(
	\instrument, \basic,
	\dur, Prand([
		Pseq([0.25],8),
		Pseq([1],1),
	],inf),
	\atk, 0,
	\sus, 0,
	\rel, 0.02,
	\freq, Pwrand([
		Pexprand(150,300,1),
		Pexprand(1000,4000,1),
	],[0.95,0.05], inf),
	\amp, Pexprand(0.02,0.2,inf),
	\pan, Pwhite(-0.8,0.8),
);

b = Pbind(
	\instrument, \basic,
	\dur, 0.25,
	\atk, 0,
	\sus, 0,
	\rel, 0.3,
	\midinote, Pseq([
		85,Rest(0.25), Rest(0.25), Prand([83,82], 1),
		Prand([
			Pseq([Rest(0.25)],12),
			Pseq([Rest(0.25)],28),
		],1),
	],inf),
	\amp, 0.2,
	\pan, Pwhite(-0.25,0.25),
);

c = Pbind(
	\instrument, \basic,
	\dur, 0.5,
	\atk, 0.2,
	\sus, 0,
	\rel, 0.01,
	\midinote, Pseq([
		37,49,Rest(0.5), 40,
		52, Rest(0.5), 42, 54,
		Prand([
			Pseq([Rest(0.5)],8),
			Pseq([Rest(0.5)],16),
		],1),
	],inf),
	\amp, 0.2,
	\pan, 0,
);
)

~a = a.play(t, quant:4);
~c = c.play(t, quant:4);
~b = b.play(t, quant:4);

[~a,~b,~c].do({arg n; n.stop});