// Companion Code 3.5
// Advanced FM Synthesis Concepts

// The following FM example of modulators in series serves as a starting point.

s.boot;

(
x = {
	var sig, mod1, mod2;
	mod2 = SinOsc.ar(0.2, mul: 450);
	mod1 = SinOsc.ar(500 + mod2, mul: 800);
	sig = SinOsc.ar(1000 + mod1);
	sig = sig * 0.2 ! 2;
}.play;
)

x.release(2);

// Though providing specific values is a valid approach, a full embrace of randomness may produce interesting results more quickly. Here, the previous example is converted to a SynthDef, and most frequency and amplitude values have been replaced with random number generators:

(
SynthDef(\fm_series, {
	arg freq = 200, lo = 80, hi = 10000,
	atk = 0.001, rel = 2, amp = 0.1, out = 0;
	var sig, mod1, mod2, env;
	env = EnvGen.ar(
		Env.perc(atk, rel),
		doneAction: 2
	);
	mod2 = SinOsc.ar(ExpRand.new(lo, hi), mul: ExpRand.new(lo, hi));
	mod1 = SinOsc.ar(ExpRand.new(lo, hi) + mod2, mul: ExpRand.new(lo, hi));
	sig = SinOsc.ar(freq + mod1);
	sig = sig * env * amp ! 2;
	Out.ar(out, sig);
}).add;
)

Synth(\fm_series, [freq: exprand(80, 600)]); // evaluate repeatedly

// If more serial modulators are desired, iteration can help express the algorithm more concisely:

(
SynthDef(\fm_series, {
	arg freq = 200, lo = 80, hi = 8000,
	atk = 0.001, rel = 2, amp = 0.1, out = 0;
	var sig, mod, env;
	env = EnvGen.ar(
		Env.perc(atk, rel),
		doneAction: 2
	);

	// inital modulator
	mod = SinOsc.ar(ExpRand.new(lo, hi), mul: ExpRand.new(lo, hi));

	// eight additional modulators in series
	8.do({
		mod = SinOsc.ar(
			ExpRand.new(lo, hi) + mod,
			mul: ExpRand.new(lo, hi)
		);
	});
	sig = SinOsc.ar(freq + mod);
	sig = sig * env * amp ! 2;
	Out.ar(out, sig);
}).add;
)

Synth(\fm_series, [freq: exprand(80, 600)]); // evaluate repeatedly

// Multichannel expansion, in combination with Splay, creates a more interesting stereophonic image of random FM textures:

(
SynthDef(\fm_series, {
	arg freq = 200, lo = 80, hi = 8000,
	atk = 0.001, rel = 2, amp = 0.1, out = 0;
	var sig, mod, env;
	env = EnvGen.ar(
		Env.perc(atk, rel),
		doneAction: 2
	);
	mod = SinOsc.ar(
		freq: { ExpRand.new(lo, hi) } ! 8,
		mul: { ExpRand.new(lo, hi) } ! 8
	);
	8.do({
		mod = SinOsc.ar(
			freq: { ExpRand.new(lo, hi) } ! 8 + mod,
			mul: { ExpRand.new(lo, hi) } ! 8
		);
	});
	sig = SinOsc.ar(freq + mod);
	sig = Splay.ar(sig);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

Synth(\fm_series, [freq: exprand(80, 600)]); // evaluate repeatedly

// Parallel modulators refers to a configuration in which multiple modulators are applied to carrier frequency in summation, effectively operating on that carrier simultaneously. The following code is adapted from the previous example, but 'collect' is used to create an array of eight random modulators, which are then summed. Because of the quantity and randomness of the modulators, the result is fairly noisy. The multichannel expansion has also been removed.

(
SynthDef(\fm_parallel, {
	arg freq = 200, lo = 80, hi = 8000,
	atk = 0.001, rel = 2, amp = 0.1, out = 0;
	var sig, mod, env;
	env = EnvGen.ar(
		Env.perc(atk, rel),
		doneAction: 2
	);
	mod = 8.collect({
		SinOsc.ar(
			freq: ExpRand.new(lo, hi),
			mul: ExpRand.new(lo, hi)
		);
	}).sum;
	sig = SinOsc.ar(freq + mod);
	sig = sig * env * amp ! 2;
	Out.ar(out, sig);
}).add;
)

Synth(\fm_parallel, [freq: exprand(80, 600), amp: 0.05]);

// To produce a sound with a clearer sense of pitch, we can modify the previous code so that every random frequency is rounded to the nearest multiple of the fundamental frequency. This ensures that the summed modulator will be phase-locked with the carrier. Viewed another way, we are creating a waveform using additive synthesis, and then using it to modulate the frequency of a carrier with the same fundamental.

(
SynthDef(\fm_parallel, {
	arg freq = 200, lo = 80, hi = 8000,
	atk = 0.001, rel = 2, amp = 0.1, out = 0;
	var sig, mod, env;
	env = EnvGen.ar(
		Env.perc(atk, rel),
		doneAction: 2
	);
	mod = 8.collect({
		SinOsc.ar(
			freq: ExpRand.new(freq, 20000).round(freq),
			mul: ExpRand.new(lo, hi)
		);
	}).sum;
	sig = SinOsc.ar(freq + mod);
	sig = sig * env * amp ! 2;
	Out.ar(out, sig);
}).add;
)

Synth(\fm_parallel, [freq: 40]);

// To soften the timbre, we can limit the upper boundary of modulator amplitude, thus reducing the number of audible sidebands:

Synth(\fm_parallel, [freq: 40, hi: 500]);

// Adding a touch of randomness to the frequency of each modulator slightly blurs the pitch center and creates subtle beating patterns:

(
SynthDef(\fm_parallel, {
	arg freq = 200, lo = 80, hi = 8000,
	atk = 0.001, rel = 2, amp = 0.1, out = 0;
	var sig, mod, env;
	env = EnvGen.ar(
		Env.perc(atk, rel),
		doneAction: 2
	);
	mod = 8.collect({
		SinOsc.ar(
			freq: ExpRand.new(freq, 20000).round(freq) * ExpRand.new(0.98, 1.02),
			mul: ExpRand.new(lo, hi)
		);
	}).sum;
	sig = SinOsc.ar(freq + mod);
	sig = sig * env * amp ! 2;
	Out.ar(out, sig);
}).add;
)

Synth(\fm_parallel, [freq: 40, hi: 500]);

// If we don't sum the modulators, the result will be a multichannel signal, and each modulator will operate on the carrier on a unique channel. We can then remove the "! 2" and use Splay to create a stereo spread of these channels. In this case, we have eight carrier-modulator pairs which are pure sinusoids, instead of a singular, more complex modulator produced from a sum of sines. As a result, the modulation timbres are tamer than those in the previous example.

(
SynthDef(\fm_parallel, {
	arg freq = 200, lo = 80, hi = 8000,
	atk = 0.001, rel = 2, amp = 0.1, out = 0;
	var sig, mod, env;
	env = EnvGen.ar(
		Env.perc(atk, rel),
		doneAction: 2
	);
	mod = 8.collect({
		SinOsc.ar(
			freq: ExpRand.new(freq, 20000).round(freq) * ExpRand.new(0.98, 1.02),
			mul: ExpRand.new(lo, hi)
		);
	});
	sig = SinOsc.ar(freq + mod);
	sig = Splay.ar(sig);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

Synth(\fm_parallel, [freq: 40, hi: 500]);

// How about a carrier that modulates itself? This presents an interesting programming challenge. It may be tempting to try something like the following, which fails, because it attempts to define a signal recursively, which is not supported in this particular context. 'sig' cannot be used in its own algorithm until it is properly defined, and it cannot be properly defined if it is used in its own algorithm. A conundrum!

(
{
	var sig;
	sig = SinOsc.ar(200 + sig);
}.play;
)

// SinOscFB is an oscillator whose output controls its own phase pointer within a sinusoidal wavetable (in a digital context, phase modulation is functionally equivalent to frequency modulation). SinOscFB provides a clean solution to feedback FM, but offers little flexibility. In the following code, a triangle wave scales the amplitude of the feedback signal. The result becomes more chaotic as the feedback coefficient becomes larger.

(
x = {
	var sig, fb;
	fb = LFTri.kr(0.1, 3).range(0, 5);
	sig = SinOscFB.ar(200, fb);
	sig = sig * 0.05 ! 2;
}.play;
)

x.release(2);

// To solve this problem without SinOscFB, we must accept a small delay, equal to the length of one control block, between creating the initial signal and feeding it back into itself as a frequency offset. In other words, a control block's worth of signal must be generated first, and only then can it be used as an input to itself. This can be achieved using LocalIn and LocalOut, a pair of UGens designed to facilitate a signal feedback path that is local to a particular UGen function. Comments are included in-line for a more in-depth explanation:

(
x = {
	var sig, mod;

	// At the start of each control block, we read the signal from the 2-channel feedback bus. Since it will be used as a frequency offset, we scale it by an appropriate amount (300) so that it will have an audible influence on the carrier. On the first control block, no data has been written to the local bus yet, so LocalIn is silent, but on subsequent control blocks it contains the carrier signal.
	mod = LocalIn.ar(2) * 300;

	// Then, we create the carrier, whose frequency is offset by the local feedback signal.
	sig = SinOsc.ar(300 + mod);

	// Here, we write the carrier signal to the local bus, making sure it has the correct number of channels.
	LocalOut.ar(sig ! 2);

	// This signal we want to monitor through speakers must be the last line of the function.
	sig * 0.1;
}.play;
)

x.release(2);

// With static values, this is not a particularly impressive sound (and it will vary depending on your sample rate and block size), but we can be assured that self-modulation is occurring by checking the scope while the sound is playing, and noting that the waveform is not sinusoidal:

s.scope;

// To hear self-modulation more clearly, we can replace the amplitude scaling factor with MouseX, so that the amount of modulation follows the horizontal mouse position. As the mouse cursor moves from the left side of the screen to the right, the signal is gradually driven into a chaotic state. We can traverse a spectrum between pure tone and broadband noise, with an interesting "sweet spot" somewhere in the middle (which sounds kind of like an angry cat).

(
x = {
	var sig, mod;
	mod = LocalIn.ar(2) * MouseX.kr(1, 10000, 1);
	sig = SinOsc.ar(300 + mod);
	LocalOut.ar(sig ! 2);
	sig * 0.1;
}.play
)

x.release(2);

// Feedback can be dangerous! This particular example is relatively safe, because SinOsc's response to negative or extremely large frequency values is stable. Replacing SinOsc with another signal generator may exhibit explosive behavior!

// Serial, parallel, and self-modulation techniques can be used in combination for even more variety. A comprehensive personal exploration is left as an exercise for the reader, but a small example of combined use is provided here. The following code blends the feedback modulation approach in the previous example with the serial modulator approach featured at the very beginning of this companion code file. Most of the numbers have been altered according to personal taste on a trial-and-error basis. MouseX has been replaced with a 2-channel non-interpolating noise generator, the carrier is a stereo sine wave with slightly different frequencies in each channel (creating a more interesting stereo image), and the feedback modulator is used as an amplitude control on both serial modulators, instead of only one:

(
x = {
	var sig, mod1, mod2, mod3;
	mod3 = LocalIn.ar(2) * LFNoise0.kr(8 ! 2).exprange(50, 2000);
	mod2 = SinOsc.ar(3, mul: mod3);
	mod1 = SinOsc.ar(800 + mod2, mul: mod3);
	sig = SinOsc.ar([500, 501] + mod1);
	LocalOut.ar(sig);
	sig = sig * 0.1;
}.play;
)

x.release(2);

// Experimentation is key, both here, and in the larger world of creative audio coding. Modulation synthesis is fertile soil for unexpectedly interesting sounds. So, while being mindful of ear safety, be adventurous with your synthesis — try something unconventional!