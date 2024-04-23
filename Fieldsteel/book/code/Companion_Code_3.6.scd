// Companion Code 3.6
// Wavetable Creation Techniques

// We begin with the simple example from Code Example 3.15 in the book.

s.boot;

(
~wt = Signal.sineFill(8192, [1], [0]).asWavetable;
b = Buffer.loadCollection(s, ~wt);
)

(
x = {
	var sig;
	sig = Osc.ar(b, 200);
	sig = sig * 0.2 ! 2;
}.play;
)

x.release(2);

// First, a technical note: Buffer allocation does not happen instantaneously. The process takes some amount of time, usually quite small, depending on the size of the buffer. Attempts to allocate a buffer and access it in the same evaluated block of code may fail. For this reason, the previous code separates these processes into two separate chunks. We can illustrate such a failure as follows:

(
~wt = Signal.sineFill(8192, [1], [0]).asWavetable;
~testbuf = Buffer.loadCollection(s, ~wt);
~testbuf.numFrames;
)

// After evaluating, the post window displays the number of frames as 'nil'. But, we know that this buffer should contain 16384 samples. If we run the following individual expression a second time, the correct value is displayed:

~testbuf.numFrames;

// In the previous three-line block, the buffer allocation process begins, but is not complete when the frame count is queried. Therefore, the buffer's attributes, e.g. number of frames, have not been updated. To get the results we want, we need to wait an extra millisecond or so. These timing issues between language and server are a topic of focus in other chapters of this book (particularly Chapter 9), which deal with building larger code structures for musical compositions.

// The following code creates a wavetable representing a slightly more complex additive spectrum. In this case, the fundamental is present. Relative to the fundamental, the 2nd harmonic is one half cycle out of phase and its amplitude is halved. The 3rd harmonic is absent. The 4th harmonic is one quarter-cycle out of phase with one tenth the amplitude. The amplitude values are relative, and Signal will always normalize the resulting waveshape to a peak value of 1. Therefore, the amplitude values you provide need not be constrained between 0 and 1 — any numerical value is fine.

(
~wt = Signal.sineFill(
	8192,
	[ 1, 0.5, 0, 0.1 ],
	[ 0, pi, 0, pi/2 ]
).asWavetable;
b = Buffer.loadCollection(s, ~wt);
)

// Wavetables, like most data collections, can be plotted. As a convenience, the plot method "undoes" the wavetable format before plotting, showing its true waveshape.

~wt.plot;

(
x = {
	var sig;
	sig = Osc.ar(b, 200);
	sig = sig * 0.2 ! 2;
}.play;
)

// We can visually confirm the spectrum and waveshape using the scope and frequency analyzer tools:

(
FreqScope.new;
s.scope(zoom: 0.305);
)

x.release(2);

// Array methods and operations permit concise expression of complex wavetables. In this case, the amplitude of each harmonic is 75% of the previous harmonic, and each harmonic is one quarter-cycle out of phase relative to the previous harmonic.

(
~wt = Signal.sineFill(
	8192,
	Array.geom(200, 1, 0.75),
	(0..199) * (pi / 2)
);
b = Buffer.loadCollection(s, ~wt.asWavetable);
~wt.plot;
)

(
x = {
	var sig;
	sig = Osc.ar(b, 200);
	sig = sig * 0.2 ! 2;
}.play;
)

x.release(2);

// It's possible to apply math operations to a Signal before converting to wavetable format. In the following code, after the initial table is created, we take the square root of the absolute value of each sample. This produces a range of values between 0 and 1, which is then scaled to be between ± 1. Finally, for every sample value, we take the lesser of 0.9 and that value, which has the effect of truncating the positive region of the waveshape at 0.9. Waveform truncation creates hard corners, producing a spectrum with substantial energy at higher frequencies, which may be prone to aliasing, but it can sometimes be appropriate to embrace some degree of aliasing, depending on taste and context.

(
~wt = Signal.sineFill(
	8192,
	Array.geom(200, 1, 0.75),
	(0..199) * (pi / 2)
);

~wt = ~wt.abs.sqrt;
~wt = ~wt * 2 - 1;
~wt = ~wt.min(0.9);

b = Buffer.loadCollection(s, ~wt.asWavetable);
~wt.plot;
)

// The amplitude of the signal has been reduced to compensate for the additional high freuqency energy:

(
x = {
	var sig;
	sig = Osc.ar(b, 200);
	sig = sig * 0.1 ! 2;
}.play;
)

x.release(2);

// 'waveFill' is a flexible method for creating arbitrary waveshapes, unrelated to sums of sines. This method iterates over a signal and evaluates a function for each value, along an interval (0 to 1 by default). The behavior of waveFill is similar to 'collect,' with the exception that waveFill overwrites values in the starting collection, instead of returning a new collection. The use of waveFill often begins with a blank signal (i.e. a signal filled with zeroes), but any signal object can be used. Multiple waveFill calls can be chained together, one after the other.

// The following code creates a wavetable containing a linear ramp.

(
~wt = Signal.newClear(8192); // initially filled with zeroes
~wt.waveFill(
	{
		arg ival, old, index;
		ival;
	}, -1, 1
);
b = Buffer.loadCollection(s, ~wt.asWavetable);
~wt.plot;
)

// The three arguments that waveFill accepts (here, arbitrarily named "ival," "old," and "index") represent:

// ival - the current value along the specified interval, in this case ± 1; in other words, the interval range is divided equally into n equal parts, where n is the size of the signal.

// old - the current value in the starting signal.

// index - the integer index of the current value in the starting signal.

// Specifically, the sequential argument values in this case are equal to:

/*

[ ival,			old,	index ],
--------------------------------
[ -1.0,			0.0,	0     ],
[ -0.999756...,	0.0,	1     ],
[ -0.999512...,	0.0,	2     ],
[ -0.999268...,	0.0,	3     ],

...etc...

[ 0.999512...,	0.0,	8190  ],
[ 0.999756...,	0.0,	8191  ],

*/

// The waveFill function returns the interval value 'ival,' therefore the wavetable in the waveFill example above is filled with linearly-spaced values from -1 to just below +1.

// After creating the ramp wavetable, we can manipulate the values with subsequent waveFill calls. In the following example, we divide each sample value by a value 0.2 greater than the absolute value of the inverval. This operation has the effect of bending the line into a S-curve.

(
~wt = Signal.newClear(8192); // initially filled with zeroes
~wt.waveFill(
	{
		arg ival, old, index;
		ival;
	}, -1, 1
);
~wt.waveFill(
	{
		arg ival, old, index;
		old / (ival.abs + 0.2)
	}, -1, 1
);
b = Buffer.loadCollection(s, ~wt.asWavetable);
~wt.plot;
)

// Next, we add some noise to the wavetable by subtracting a random value from each sample. Values with low indices are likely to receive smaller deviations from their original values, and values toward the end of the table are likelier to be drastically shifted, which creates an interesting noise "imprint" on the S-curve.

(
~wt = Signal.newClear(8192); // initially filled with zeroes
~wt.waveFill(
	{
		arg ival, old, index;
		ival;
	}, -1, 1
);
~wt.waveFill(
	{
		arg ival, old, index;
		old / (ival.abs + 0.2)
	}, -1, 1
);
~wt.waveFill(
	{
		arg ival, old, index;
		old - exprand(0.00001, (index/8192) * 0.8)
	}, -1, 1
);
b = Buffer.loadCollection(s, ~wt.asWavetable);
~wt.plot;
)

// This code produces a wavetable that is "experimental" at best, and of dubious value at worst. The first and last values in the table don't align, resulting in a cyclic discontinuity that produces an audible click on each oscillator period. In addition, the noise we've added is of a very high-freuqency nature (a random deviation on every sample). These two factors both contribute toward severe aliasing, even at midrange frequencies. At this point, it's fair to say we're embracing aliasing as a deliberate creative choice!

// This waveform will undergo a sort of tone/noise crossfade as the oscillator frequency transitions across the lower end of the audible spectrum:

(
x = {
	var sig, mod;
	mod = SinOsc.ar(0.1, 3pi/2).exprange(0.5, 100);
	sig = Osc.ar(b, mod);
	sig = sig * 0.1 ! 2;
}.play;
)

x.release(2);

// It's possible to create wavetables by working directly with buffers. 'sine1,' 'sine2,' and 'sine3' are methods that require the explicit allocation of a buffer, which is then filled with data. These methods normalize the sample data and convert to wavetable format by default. In contrast to Signal-based approaches, in which the specified wavetable size is ultimately doubled, the size of the allocated buffer is equal to the size of the wavetable format data.

// 'sine1' accepts an array of amplitudes corresponding to a harmonic series. The phase of each partial is locked at 0 radians.

(
b = Buffer.alloc(s, 16384);
b.sine1(
	amps: [1] ++ Array.exprand(31, 0.0001, 0.2)
);
)

(
s.scope(zoom: 0.355);
x = {
	var sig;
	sig = Osc.ar(b, 200);
	sig = sig * 0.1 ! 2;
}.play;
)

x.release(2);

// 'sine2' accepts an array of frequencies (specified as harmonic numbers, i.e. cycles per buffer) and an array of amplitudes.

(
b = Buffer.alloc(s, 16384);
b.sine2(
	freqs: Array.fib(8, 1, 1), // fibonacci series
	amps: Array.geom(8, 1, 0.4)
);
)

(
s.scope(zoom: 0.355);
x = {
	var sig;
	sig = Osc.ar(b, 200);
	sig = sig * 0.2 ! 2;
}.play;
)

x.release(2);

// using non-integer frequency values with 'sine2' will result in a discontinuity between the end and beginning of the wavetable, creating a sharp edge in the waveshape and adding a distinct buzziness to the timbre:

(
b = Buffer.alloc(s, 16384);
b.sine2(
	freqs: [0.2, 1, 1.1, 3.2, 7.1, 13.33],
	amps: [0.4, 0.2, 0.8, 0.6, 0.4, 0.2]
);
)

(
s.scope(zoom: 0.355);
x = {
	var sig;
	sig = Osc.ar(b, 200);
	sig = sig * 0.1 ! 2;
}.play;
)

x.release(2);

// 'sine3' allows specification of frequencies, amplitudes, and initial phases:

(
b = Buffer.alloc(s, 16384);
b.sine3(
	// first 40 harmonics
	freqs: (1..40),

	// amplitues = [ 1, 0, 1/3, 0, 1/5, 0, 1/7, ... ]
	amps: [1,0].dup(20).flat / (1..40),

	// random phases
	phases: Array.rand(40, 0, 2pi)
);
)

(
s.scope(zoom: 0.355);
x = {
	var sig;
	sig = Osc.ar(b, 200);
	sig = sig * 0.2 ! 2;
}.play;
)

x.release(2);

// The Env class can also be used to create custom wavetable shapes. When leaning heavily on randomness, it is sensible to normalize the envelope points between ± 1, to ensure a full-amplitude waveform. Using the 'asSignal' method, we can convert from Env to Signal, at which point the procedure is identical to the earliest examples in this code file. The following envelope starts and ends at 0, with 6 random points in between. The durations between points are similarly random, and the segment curvatures may be linear or sinusoidal. Many variations are possible.

(
~wt = Env.new(
	levels: [0] ++ Array.rand(6, -1.0, 1.0).normalize(-1, 1) ++ [0],
	times: Array.exprand(7, 0.1, 1.0),
	curve: Array.fill(7, { [\lin, \sine].choose })
);
~wt = ~wt.asSignal(8192).normalize;
b = Buffer.loadCollection(s, ~wt.asWavetable);
~wt.plot;
)

// Because of the random nature of this wavetable, the oscillator using it may exhibit DC offset, but the LeakDC UGen can be used to compensate.

(
s.scope(zoom: 0.355);
x = {
	var sig;
	sig = Osc.ar(b, 200);
	sig = LeakDC.ar(sig);
	sig = sig * 0.2 ! 2;
}.play;
)

x.release(2);

// Equipped with a diverse set of waveform-generating tools, we can turn our attention to enriching the wavetable oscillator signal. For example, we can create an array of 16 slightly different frequencies, and an array of 16 low-frequency sine oscillators with random phases, used as amplitude modulators.

(
x = {
	var sig, freqs, amps;
	freqs = 200 * Array.fill(16, { ExpRand.new(0.99, 1.01) });
	amps = SinOsc.kr(0.2, Array.fill(16, { Rand(0, 2pi) })).exprange(0.2, 1);
	sig = Osc.ar(b, freqs) * amps;
	sig = Splay.ar(sig);
	sig = LeakDC.ar(sig);
	sig = sig * 0.3;
}.play;
)

x.release(2);

// Creating a SynthDef facilitates reuse and flexibility. An amplitude envelope has also been added:

(
SynthDef(\osc, {
	arg buf, freq = 200, atk = 3, rel = 5, amp = 0.5, out = 0;
	var sig, env, freqs, amps;
	env = EnvGen.kr(
		Env.new([0, 1, 0], [atk, rel], [1, -3]),
		doneAction: 2
	);
	freqs = freq * Array.fill(16, { ExpRand.new(0.99, 1.01) });
	amps = SinOsc.kr(0.2, Array.fill(16, { Rand(0, 2pi) })).exprange(0.2, 1);
	sig = Osc.ar(buf, freqs) * amps;
	sig = Splay.ar(sig) * amp;
	sig = LeakDC.ar(sig);
	sig = sig * env;
	Out.ar(out, sig);
}).add;
)

Synth(\osc, [buf: b]);

// Below, four chords that can be played in any order/combination. The amplitude is greater for lower pitches, in order to provide a sense of warmth and timbral balance.

(
// G major
[31, 43, 50, 55, 59].midicps.do({ |n, i|
	Synth(\osc, [buf: b, freq: n, amp: 0.5 / (i + 1)]);
});
)

(
// C major7
[24, 48, 52, 55, 59].midicps.do({ |n, i|
	Synth(\osc, [buf: b, freq: n, amp: 0.5 / (i + 1)]);
});
)

(
// D major sus2
[26, 50, 52, 54, 57].midicps.do({ |n, i|
	Synth(\osc, [buf: b, freq: n, amp: 0.5 / (i + 1)]);
});
)

(
// E minor7
[28, 40, 50, 55, 59].midicps.do({ |n, i|
	Synth(\osc, [buf: b, freq: n, amp: 0.5 / (i + 1)]);
});
)

// There's no need to limit ourselves to one wavetable. Multiple wavetables can be stored in an array, and selected when a Synth is created:

(
~wt = 6.collect({
	var table;
	table = Env.new(
		levels: [0] ++ Array.rand(6, -1.0, 1.0).normalize(-1, 1) ++ [0],
		times: Array.exprand(7, 0.1, 1.0),
		curve: Array.fill(7, {[\lin, \sine].choose})
	);
	table = table.asSignal(8192);
});
~buf = ~wt.collect({ |table|
	Buffer.loadCollection(s, table.asWavetable);
});
)

// (optional) plot these wavetables:
~wt.do({ |table| table.plot });

// Here, each Synth selects a random wavetable from the six we've created. The timbre of this chord will be unique each time it is created:

(
[31, 43, 50, 55, 59].midicps.do({ |n,i|
	Synth(\osc, [buf: ~buf.choose, freq: n, amp: 0.4 / (i + 1)]);
});
)

// Wavetables are an endless source of rich timbral color, and it's remarkable how an otherwise bland and static tone generator can evoke an emotional response when tempered with sensitively chosen parameters and situated within a musical context. Variations include creating new wavetable shapes, adding or modifying apsects of the SynthDef, or composing alternate harmonies. Further experimentation with these ideas is left as an open exercise for the reader.