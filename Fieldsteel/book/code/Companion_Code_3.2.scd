// Companion Code 3.2
// Additive Synthesis and Iteration

/*------------------------------*/
/* Additive Synthesis with "do" */
/*------------------------------*/

s.boot;

// We begin with the iteration example from Code Example 3.2 in the book.

(
x = {
	var sig = 0, freqs = [200, 400, 600, 800];
	freqs.do({ |f, i|
		sig = sig + SinOsc.ar(f, mul: 0.2 / 2.pow(i));
	});
	sig = sig ! 2;
}.play;
)

x.release(2);

// As an alternative to the mathematical expression "0.2 / 2.pow(i)", we can use the range-mapping method 'linexp':

(
x = {
	var sig = 0, freqs = [200, 400, 600, 800];
	freqs.do({ |f, i|
		sig = sig + SinOsc.ar(
			f,
			mul: i.linexp(0, freqs.size - 1, 0.2, 0.025)
		);
	});
	sig = sig ! 2;
}.play;
)

x.release(2);

// By specifying the upper input bound as "freqs.size - 1" (instead of 3), we can freely change the number of frequencies in the array, without having to manually change this value. Amplitude adjustment may be necessary if the number of frequencies substantially increases:

(
x = {
	var sig = 0, freqs = Array.series(30, 200, 200);
	freqs.do({ |f, i|
		sig = sig + SinOsc.ar(
			f,
			mul: i.linexp(0, freqs.size - 1, 0.2, 0.025)
		);
	});
	sig = sig * 0.1; // amplitude adjustment
	sig = sig ! 2;
}.play;
)

x.release(2);

// We can alter the timbre by modifying the output range of linexp, which alters the relative amplitudes of the individual sine waves. A minimum and maximum which are relatively close together will produce a sum of sines with nearly equal amplitudes, which yields a bright, buzzy timbre:

(
x = {
	var sig = 0, freqs = Array.series(30, 200, 200);
	freqs.do({ |f, i|
		sig = sig + SinOsc.ar(
			f,
			mul: i.linexp(0, freqs.size - 1, 0.12, 0.11)
		);
	});
	sig = sig * 0.1;
	sig = sig ! 2;
}.play;
)

x.release(2);

// If the linexp output range values are relatively far apart, the amplitudes of the individual sine waves will vary more significantly. If the output minimum is the greater value, the timbre will have a darker, mellower character, due to emphasis being placed on the lower harmonics:

(
x = {
	var sig = 0, freqs = Array.series(30, 200, 200);
	freqs.do({ |f, i|
		sig = sig + SinOsc.ar(
			f,
			mul: i.linexp(0, freqs.size - 1, 1, 0.0001)
		);
	});
	sig = sig * 0.1;
	sig = sig ! 2;
}.play;
)

x.release(2);

// The frequencies can vary as well. For example, we can modify the array to include only odd-numbered harmonics, which produces a more hollow-sounding timbre, similar to a square wave:

(
x = {
	var sig = 0, freqs = Array.series(15, 200, 400);
	freqs.do({ |f, i|
		sig = sig + SinOsc.ar(
			f,
			mul: i.linexp(0, freqs.size - 1, 1, 0.0001)
		);
	});
	sig = sig * 0.1;
	sig = sig ! 2;
}.play;
)

x.release(2);

// Or, we can use random frequencies. In this example, the frequency array is sorted to ensure the highest amplitude values are assigned to the lowest frequencies. This code will sound different each time it is evaluated:

(
x = {
	var sig = 0, freqs = Array.exprand(15, 200, 6000);
	freqs.sort.do({ |f, i|
		sig = sig + SinOsc.ar(
			f,
			mul: i.linexp(0, freqs.size - 1, 1, 0.0001)
		);
	});
	sig = sig * 0.1;
	sig = sig ! 2;
}.play;
)

x.release(2);

// Finally, here is a more sophisticated example involving a SynthDef with several arguments and an amplitude envelope.

(
SynthDef(\add_do, {
	arg freq = 200, amp = 0.5, out = 0;
	var sig = 0, freqs = Array.series(15, 1, 2);
	freqs.do({ |f, i|
		var sine;
		sine = SinOsc.ar(
			freq * f * ExpRand(0.99, 1.01),
			mul: i.linexp(0, freqs.size - 1, 1, 0.0001)
		);
		sine = Pan2.ar(sine, Rand(-0.9, 0.9));
		sig = sig + sine;
	});
	sig = sig * Env([0, 1, 0], [5, 5], [1, -2]).kr(2);
	sig = sig * 0.1 * amp;
	Out.ar(out, sig);
}).add;
)

// We can use iteration to create multiple Synths. Because of the randomness (ExpRand) applied to the frequencies of the sine waves, we'll hear beating patterns.

3.do({ Synth(\add_do, [freq: 64.midicps]) });

// And, for one final finesse, we can use nested iteration (a 'do' within a 'do') to create a cluster of five pitches, with three individual Synths for each voice:

(
[38, 50, 57, 59, 66].do({ |note, index|
	3.do({
		Synth(
			\add_do, [
				freq: note.midicps,
				amp: index.linexp(0, 4, 0.6, 0.2),
			]
		)
	});
});
)

/*-----------------------------------*/
/* Additive Synthesis with "collect" */
/*-----------------------------------*/


// We begin with the iteration example from Code Example 3.3 in the book.

(
x = {
	var sig, freqs = [200, 400, 600, 800];
	sig = freqs.collect({ |f, i|
		SinOsc.ar(f, mul: 0.2 / 2.pow(i));
	});
	sig = sig.sum;
	sig = sig ! 2;
}.play;
)


x.release(2);

// For our first variation, we enlarge and randomize the frequency array, and also modify the amplitude expression. We select 30 frequencies between 100 and 10000 Hz. The amplitude of each sine is determined by its frequency, so the lowest frequencies have the highest amplitudes. This code will sound different on each evaluation.

(
x = {
	var sig, freqs = Array.exprand(30, 100, 10000);
	sig = freqs.collect({ |f|
		SinOsc.ar(f, mul: f.expexp(100, 10000, 0.3, 0.0005));
	});
	sig = sig.sum * 0.2;
	sig = sig ! 2;
}.play;
)

x.release(2);

// Using Splay to spread these signals across the stereophonic field creates a richer sense of width and movement, especially noticeable if monitoring with headphones. This is a more interesting version than the previous example, which is simply a mono mix copied to both output channels. By default, Splay will apply level compensation based on the size of the array, so we can remove the manual amplitude adjustment from the previous example.

(
x = {
	var sig, freqs = Array.exprand(30, 100, 10000);
	sig = freqs.collect({ |f|
		SinOsc.ar(f, mul: f.expexp(100, 10000, 0.3, 0.0005));
	});
	sig = Splay.ar(sig);
}.play;
)

x.release(2);

// An additive texture becomes more interesting if each individual sine has its own unique amplitude envelope, a process sometimes referred to as "time-varying" additive synthesis. In the following code, each sine is scaled by an envelope with random attack and release times. However, this approach presents a problem. If we specify doneAction: 0, the Synth process will not be automatically removed, even after the sound becomes silent. But, if we specify doneAction: 2, then the shortest envelope will free the Synth, prematurely ending the rest of the sound (demonstrated here).

(
x = {
	var sig, freqs = Array.exprand(30, 100, 10000);
	sig = freqs.collect({ |f|
		var sine;
		sine = SinOsc.ar(f, mul: f.expexp(100, 10000, 0.3, 0.0005));
		sine = sine * EnvGen.kr(
			Env.new(
				[0, 1, 0],
				[Rand(0.0, 2.0), ExpRand(3.0, 6.0)],
				[1, -3]
			),
			doneAction:2
		);
	});
	sig = Splay.ar(sig.scramble);
}.play;
)

// The envelope durations are random, so we cannot know in advance which one will be the longest (and which one therefore should be given doneAction: 2). So, what is the solution? One option is to include a Line UGen whose duration is equal to the longest possible envelope (in this case, eight seconds), and provide it with doneAction: 2. Even though the Line does not influence the sound itself, its doneAction still functions normally, and its presence will free the Synth after an appropriate amount of time has passed.

(
x = {
	var sig, freqs = Array.exprand(30, 100, 10000);
	sig = freqs.collect({ |f|
		var sine;
		sine = SinOsc.ar(f, mul: f.expexp(100, 10000, 0.3, 0.0005));
		sine = sine * EnvGen.kr(
			Env.new(
				[0, 1, 0],
				[Rand(0.0, 2.0), ExpRand(3.0, 6.0)],
				[1, -3]
			),
		);
	});
	Line.kr(0, 0, 8, doneAction:2);
	sig = Splay.ar(sig.scramble);
}.play;
)

// Another variation involves rounding the random frequencies to the nearest multiple of a fundamental in order to create a harmonic spectrum from an inharmonic one. Though not strictly necessary in this case, it is sensible to also constrain the rounded values within a desired range, which can be done with "clip." If, for example, our random values were as low as 20, they could be rounded down to zero instead of rounded up to 55.

(
x = {
	var sig, freqs = Array.exprand(30, 100, 10000);
	freqs = freqs.round(55).clip(55, 10000);
	sig = freqs.collect({ |f|
		var sine;
		sine = SinOsc.ar(f, mul: f.expexp(100, 10000, 0.3, 0.0005));
		sine = sine * EnvGen.kr(
			Env.new(
				[0, 1, 0],
				[Rand(0.0, 2.0), ExpRand(3.0, 6.0)],
				[1, -3]
			),
		);
	});
	Line.kr(0, 0, 8, doneAction:2);
	sig = Splay.ar(sig.scramble);
}.play;
)

// Finally, here is a slightly more sophisticated example involving SynthDef and Synth:

(
SynthDef(\add_collect, {
	arg freq = 55, amp = 0.5, out = 0;
	var sig, freqs;
	freqs = { ExpRand(freq, 10000) } ! 30;
	freqs = freqs.round(freq).clip(freq, 10000);
	sig = freqs.collect({ |f|
		var sine;
		sine = SinOsc.ar(f, mul: f.expexp(100, 10000, 0.3, 0.0005));
		sine = sine * EnvGen.kr(
			Env.new(
				[0, 1, 0],
				[Rand(0.0, 2.0), ExpRand(3.0, 6.0)],
				[1, -3]
			)
		);
	});
	sig = Splay.ar(sig.scramble) * amp;
	Line.kr(0, 0, 8, doneAction:2);
	Out.ar(out, sig);
}).add;
)

(
[39, 54, 65, 70].do({
	arg n;
	Synth(\add_collect, [freq: n.midicps]);
});
)