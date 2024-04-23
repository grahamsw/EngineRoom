// Companion Code 3.3
// Experiments with Amplitude Modulation

// We begin with a simple amplitude modulation example based on Code Example 3.8:

s.boot;

(
x = {
	var sig, mod;
	mod = SinOsc.ar(150).range(0, 1);
	sig = SinOsc.ar(750, mul: mod);
	sig = sig * 0.2 ! 2;
}.play;
)

x.release(2);

// The built-in spectrum analyzer provides a helpful resource for visualizing and understanding modulation spectra:

FreqScope.new;

// Recall that a UGen's 'mul' argument is a value that is multiplied by every output sample a UGen produces. Thus, we can rewrite this code using an explicit multiplication operation (a purely stylistic choice).

(
x = {
	var sig, mod;
	mod = SinOsc.ar(150).range(0, 1);
	sig = SinOsc.ar(750) * mod;
	sig = sig * 0.2 ! 2;
}.play;
)

x.release(2);

// The spectrum of AM includes the carrier frequency, as well as the carrier frequency ± the modulator frequency, for a total of three components. It's worth mentioning that an indistinguishable result can be achieved using additive synthesis. AM is perhaps slightly more efficient on account of using two oscillators instead of three, but the difference is marginal.

(
x = {
	var sig;
	sig = SinOsc.ar(750, mul: 0.5);
	sig = sig + SinOsc.ar(600, pi, mul: 0.25);
	sig = sig + SinOsc.ar(900, pi, mul: 0.25);
	sig = sig * 0.2 ! 2;
}.play;
)

x.release(2);

// If modulator frequency is greater than the carrier frequency, the frequency of the lower sideband (carrier Hz - modulator Hz) will have a negative frequency. The result will be a polarity-reversed sideband at the absolute value of that frequency. The following dynamic example demonstrates this "rebound" behavior:

(
x = {
	var sig, mod, modHz;
	modHz = XLine.kr(1, 1000, 6);
	mod = SinOsc.ar(modHz).range(0, 1);
	sig = SinOsc.ar(750) * mod;
	sig = sig * 0.2 ! 2;
}.play;
)

x.release(2);

// Certain AM configurations produce sideband frequencies that coincide with the carrier. If the modulator frequency is twice the carrier frequency, the lower sideband will bounce off of 0 Hz and realign with the carrier. These two components will sum, but because they have different amplitudes, they will not fully cancel each other out.

(
x = {
	var sig, mod, modHz;
	modHz = XLine.kr(1, 600, 6);
	mod = SinOsc.ar(modHz).range(0, 1);
	sig = SinOsc.ar(300) * mod;
	sig = sig * 0.2 ! 2;
}.play;
)

x.release(2);

// What happens if the carrier is non-sinusoidal? In this case, if the modulator is still sinusoidal, a pair of sidebands appears on either side of every frequency in the carrier spectrum. In the following example, the carrier is the sum of three sines at 200, 700, and 1200 Hz, the modulator frequency terminates at 150 Hz, at which point the six sideband frequencies will be 200 ± 150, 700 ± 150, and 1200 ± 150:

(
x = {
	var sig, mod, modHz;
	modHz = XLine.kr(1, 150, 8);
	mod = SinOsc.ar(modHz).range(0, 1);
	sig = SinOsc.ar(
		freq: [200, 700, 1200],
		mul: [1, 0.5, 0.25]
	).sum;
	sig = sig * mod;
	sig = sig * 0.1 ! 2;
}.play;
)

x.release(2);

// If the carrier is sinusoidal, but the modulator is not, multiple pairs of sidebands will appear around the carrier (one pair for each frequency in the modulator signal's spectrum). The following example also producdes six sidebands, with frequencies equal to 800 ± 250, 800 ± 475, and 800 ± 700:

(
x = {
	var sig, mod, modHz;
	modHz = XLine.kr(1, [250, 475, 700], 8);
	mod = SinOsc.ar(modHz).range(0, 1).sum;
	sig = SinOsc.ar(800, mul: 0.5) * mod;
	sig = sig * 0.1 ! 2;
}.play;
)

x.release(2);

// If both signals are non-sinusoidal, these two behaviors occur simultaneously, and the result becomes even more complex:

(
x = {
	var sig, mod, modHz;
	modHz = XLine.kr(1, [250, 475, 700], 8);
	mod = SinOsc.ar(modHz).range(0, 1).sum;
	sig = SinOsc.ar(
		freq: [200, 700, 1200],
		mul:[1, 0.5, 0.25]
	).sum;
	sig = sig * mod;
	sig = sig * 0.1 ! 2;
}.play;
)

x.release(2);

// When carrier/modulator frequency form a simple ratio, the output contains frequecies that are integer multiples of a common fundamental, and the spectrum will likely be perceived as harmonic, with a coherent pitch center. The following simple example produces the frequencies 200, 400, and 600 Hz:

(
x = {
	var sig, mod;
	mod = SinOsc.ar(200).range(0, 1);
	sig = SinOsc.ar(400) * mod;
	sig = sig * 0.2 ! 2;
}.play
)

x.release(2);

// In the following more complex example, the carrier contains six frequencies, and the modulator contains two. Each component in the carrier thus produces four sidebands, for a total of 30 harmonics. The modulator/carrier ratios are configured such that all spectral components will have a greatest common divisor of 50. Therefore, the output signal gives a strong sense of a pitch center at 50 Hz.

(
x = {
	var sig, mod;
	mod = SinOsc.ar([50, 250]).range(0, 1).sum;
	sig = SinOsc.ar(
		freq: [200, 400, 500, 900, 1300, 2000],
		mul: [1, 0.6, 0.4, 0.3, 0.08, 0.02]
	).sum;
	sig = sig * mod;
	sig = sig * 0.1 ! 2;
}.play
)

x.release(2);

// If all of these frequency values are slightly and randomly detuned, the overall result will still sound harmonic, but will have an additional layer of subtle amplitude beating produced from interference patterns:

(
x = {
	var sig, mod, carHz;
	carHz = [200, 400, 500, 900, 1300, 2000];
	carHz = carHz * ({ ExpRand(0.99, 1.01) } ! 6);
	mod = SinOsc.ar([50, 250]).range(0, 1).sum;
	sig = SinOsc.ar(
		freq: carHz,
		mul: [1, 0.6, 0.4, 0.3, 0.08, 0.02]
	).sum;
	sig = sig * mod;
	sig = sig * 0.1 ! 2;
}.play
)

x.release(2);

// If carrier/modulator frequency are subjected to a greater degree of randomness, the result will be a drone-like texture with no clear pitch center, perhaps reminiscent of background ambience in iconic space-themed films and television shows. This code will be substantially different on each evaluation.

(
x = {
	var sig, mod, carHz, modHz;
	carHz = { ExpRand(30,2000) } ! 8;
	modHz = { ExpRand(10,200) } ! 3;
	mod = SinOsc.ar(modHz).range(0, 1).sum;
	sig = SinOsc.ar(
		freq: carHz,
		mul: Array.geom(8, 1, 0.5);
	).sum;
	sig = sig * mod;
	sig = sig * 0.05 ! 2;
}.play
)

x.release(2);

// It is left as an exercise to the reader to enhance these sounds through the application of envelopes, stereo spatialization techniques, substitutions with other oscillator UGens, etc.