// Companion Code 5.4
// Real-Time Pattern Control

// This Companion Code presents a flow of ideas for exploring real-time pattern manipulations using Pbindef and two different SynthDefs. Although the incremental changes are written out in advance, these lines of code might be typed on-the-fly in a live-coded performance. The reader is encouraged to edit the Pbindef expressions by changing numbers and/or adding new lines.

s.boot;

(
// A near-identical version of this SynthDef appears in Companion Code 5.2. It passes a sawtooth wave through a resonant low-pass filter, applies a gated amplitude envelope, and pans the signal in stereo.

SynthDef.new(\filtsaw, {
	arg atk = 0.01, dec = 0.1, slev = 0.3, rel = 1, gate = 1,
	freq = 300, lpf = 20000, rq = 1, pan = 0, amp = 0.2, out = 0;
	var sig, env;
	env = Env.adsr(atk, dec, slev, rel).kr(2, gate);
	sig = Saw.ar(freq);
	sig = RLPF.ar(sig, lpf, rq);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

// This second SynthDef features Pluck, a UGen based on the Karplus-Strong algorithm, which models a plucked string using an internal feedback delay and low-pass filter. The frequency of the string is the inverse of the delay time, and a coefficient controls the characteristics of the internal filter in order to modify the timbre. These coefficient values should remain between ±1; outside of this range, the behavior of Pluck becomes unstable. A vibrato effect has also been applied to the frequency of the modeled string.

SynthDef.new(\pluck, {
	arg vibhz = 4, vibdepth = 0.08, vibatk = 0.5, freq = 300,
	dec = 6, coef = 0.7, pan = 0, amp = 0.4, out = 0;
	var sig, env, vib;
	vib = SinOsc.kr(vibhz, Rand(0, 2pi)).bipolar(vibdepth);
	vib = vib * Env([0, 1], [vibatk], [1]).kr;
	vib = vib.midiratio;
	env = Line.kr(0, 0, dec, doneAction: 2);
	sig = Pluck.ar(
		WhiteNoise.ar(1 ! 2),
		Impulse.ar(0),
		1 / 20,
		1 / (freq * vib),
		dec,
		coef
	);
	sig = Balance2.ar(sig[0], sig[1], pan, amp);
	Out.ar(out, sig);
}).add;
)

// With default parameters, our two SynthDefs sound like this:

x = Synth(\filtsaw);
x.set(\gate, 0);

Synth(\pluck);

// To begin, we'll clear any Pbindef data that may be lingering from previous sessions, and build a permament TempoClock running at 80 bpm:

(
Pbindef.all.do({ |n| n.clear });
t = TempoClock.new(80/60).permanent_(true);
)

// We'll start our real-time pattern "performance" session with a low frequency pad based on the \filtsaw SynthDef:

(
Pbindef(\pad,
	\instrument, \filtsaw,
	\dur, 1/4,
	\sustain, 1,
	\atk, Pexprand(1, 2, inf),
	\dec, 0,
	\slev, 1,
	\rel, Pexprand(2, 4, inf),
	\pan, Pwhite(-0.7, 0.7, inf),
	\db, Pwhite(-40.0, -35, inf),
	\midinote, 29,
	\lpf, (Pkey(\freq) * Pexprand(3, 12, inf)).clip(20,20000),
	\rq, 0.1,
	\detune, Pwhite(-0.5, 0.5, inf),
).clock_(t).play;
)

// A reliable performance technique involves incrementally manipulating pitch information, in order to create a sense of musical development over time. These steps are written out for clarity, but in practice, each step would probably be executed by overwriting the previous step. Either approach is fine.

Pbindef(\pad, \midinote, Prand([29, 41],inf));

Pbindef(\pad, \midinote, Prand([29, 41, 51],inf));

Pbindef(\pad, \midinote, Prand([29, 41, 51, 57],inf));

Pbindef(\pad, \midinote, Prand([29, 41, 51, 57, 58],inf));

Pbindef(\pad, \midinote, Prand([29, 41, 51, 57, 58, 60],inf));

// To emphasize lower tones, we could replace Prand with Pwrand, but as an alternative, we could simply expand the array to include duplicates of low pitch values:

Pbindef(\pad, \midinote, Prand([29, 29, 29, 41, 41, 51, 57, 58, 60],inf));

// By halving the \dur values, we double the note density, which also slightly increases the overall amplitude:

Pbindef(\pad, \dur, 1/8);

// The following expression widens the range of the low-pass filter quality and the amount of frequency detuning:

Pbindef(\pad, \rq, Pexprand(0.02, 0.5, inf), \detune, Pwhite(-1.2, 1.2, inf));

// We'll now add another Event stream using the \pluck SynthDef. For each generated Event, this pattern creates four Synths. Each has a unique coefficient and pan position, and the \strum key spreads the note onsets over a time interval. A Pfunc specifies MIDI note numbers, which takes an array of several octaves of an F mixolydian scale, clumps the values into subarrays of size four, randomly selects one note from each, eventually returning a new array containing these four values. It then selects a random starting position within this new array and takes four ordered values.

(
Pbindef(\mel,
	\instrument, \pluck,
	\strum, 1/Pwhite(8.0, 20, inf),
	\dur, Pseq([
		1,
		Prand([Rest(1/2), Rest(1), Rest(2), Rest(4), Rest(8)],1)
	], inf),
	\amp, Pexprand(0.1, 0.18, inf),
	\coef, [0.4, 0.3, 0.2, 0.1] + Pwhite(-0.05, 0.2, inf),
	\vibhz, Pexprand(1, 6, inf),
	\vibdepth, Pexprand(0.1, 0.4, inf),
	\midinote, Pfunc({
		var scl, start;
		scl = Scale.mixolydian.degrees;
		scl = ([0, 12, 24, 36] + 41).collect({ |n| n + scl}).flat;
		scl = scl.clump(4).collect({ |n| n.choose });
		start = rrand(0, 3);
		scl[start..(start+3)];
	}),
	\dec, 10,
	\pan, Pfunc({ Array.rand(4, -0.6, 0.6) }),
).clock_(t).quant_(1).play;
)

// Next, a third Event stream (using the same SynthDef) adds a rhythmic percussive background:

(
Pbindef(\crackle,
	\instrument, \pluck,
	\dur, 1/4, // slow me down or modulate me
	\db, Pwhite(-35.0, -20, inf),
	\coef, -0.1,
	\freq, Pexprand(200, 8000, inf),
	\dec, 0.01,
	\pan, Pwhite(-0.8, 0.8, inf),
).clock_(t).play;
)

// A transition away from low pitches in the pad texture:
Pbindef(\pad, \midinote, Prand([65, 69, 70],inf));

// The filter characteristics are altered to allow more of the sawtooth spectrum to be heard:
Pbindef(\pad, \lpf, 5000, \rq, 0.3);

// The time interval between strummed notes is increased:
Pbindef(\mel, \strum, 1 / Pwhite(1.5, 6, inf));

// Another pitch/filter adjustment creates another mood change:
Pbindef(\pad, \midinote, Prand([29, 60, 62, 65, 67],inf), \lpf, 1000, \rq, 0.5);

// The range of coefficient values is altered to produce a more "muffled" sound:
Pbindef(\mel, \coef, [0.4, 0.3, 0.2, 0.1] + Pwhite(0.2, 0.4, inf));

// We can gradually slow the percussive rhythm. Pseg, discussed in Companion Code 5.2, represents a pattern modeled on a segmented envelope shape. Instead of typing out a Pseg and its internal Patterns, the 'asPseg' method allows us to convert an Env to a Pseg. Here, the duration changes from 1/4 to 2 over 30 beats, and then proceeds indefinitely with a \dur value of 2:

(
Pbindef(\crackle,
	\dur, Pseq([
		Env([1/4, 2], [30], \exp).asPseg,
		Pseq([2], inf),
	], 1)
);
)

// Next, we gradually bring the drone back to something resembling its initial configuration:

Pbindef(\pad, \midinote, Prand([29, 41, 51, 55],inf), \lpf, 750, \rq, 0.4);

Pbindef(\pad, \midinote, Prand([29, 41, 51],inf), \lpf, 650, \rq, 0.2);

Pbindef(\pad, \midinote, Prand([29, 41],inf), \lpf, 500, \rq, 0.05);

// Stop the pad:
Pbindef(\pad).stop;

// Stop the plucked string pattern:
Pbindef(\mel).stop;

// And, finally, stop the percussive rhythm:
Pbindef(\crackle).stop;

Pbindef.all.do({ |n| n.clear }); // clean up