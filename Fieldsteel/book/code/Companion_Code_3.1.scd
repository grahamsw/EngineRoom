// Companion Code 3.1
// Basics of Additive Synthesis

s.boot;

// We begin with a sum of four sine oscillators. The fundamental frequency is 200 Hz, and the other three oscillators represent the 2nd, 3rd, and 4th harmonics of this fundamental.

(
x = {
	var sig;
	sig = SinOsc.ar(200, mul: 0.2);
	sig = sig + SinOsc.ar(400, mul: 0.1);
	sig = sig + SinOsc.ar(600, mul: 0.05);
	sig = sig + SinOsc.ar(800, mul: 0.025);
	sig = sig ! 2;
}.play
)

x.release(2);

// When the individual frequencies are not integer multiples of a common fundamental, the result is an inharmonic spectrum, which usually fails to produce a coherent pitch sensation and is often described as having "bell-like" qualities:

(
x = {
	var sig;
	sig = SinOsc.ar(200, mul: 0.2);
	sig = sig + SinOsc.ar(417, mul: 0.1);
	sig = sig + SinOsc.ar(673, mul: 0.05);
	sig = sig + SinOsc.ar(926, mul: 0.025);
	sig = sig ! 2;
}.play
)

x.release(2);

// A variation involves selecting frequencies which almost establish a harmonic spectrum, but which are slightly out of tune, producing a subtle undulating sensation. The gray area between harmonicity and inharmonicity is often a rich space for musical exploration.

(
x = {
	var sig;
	sig = SinOsc.ar(200, mul: 0.2);
	sig = sig + SinOsc.ar(405, mul: 0.1);
	sig = sig + SinOsc.ar(596.6, mul: 0.0);
	sig = sig + SinOsc.ar(803.7, mul: 0.025);
	sig = sig ! 2;
}.play
)

x.release(2);

// Another variation involves frequencies that are unevenly clustered around some center value, producing fluctuations in amplitude (called "beating"), which are the result of phase interference patters between individual sine waves:

(
x = {
	var sig;
	sig = SinOsc.ar(200, mul: 0.2);
	sig = sig + SinOsc.ar(202.59, mul: 0.1);
	sig = sig + SinOsc.ar(199.73, mul: 0.05);
	sig = sig + SinOsc.ar(198.07, mul: 0.025);
	sig = sig ! 2;
}.play
)

x.release(2);

// Spatialization can add a sense of width and movement to an additive texture. By rewriting this code as an array of sine waves, we can distribute them across the stereophonic field using Splay, which creates a slightly more interesting result.

(
x = {
	var sig;
	sig = [
		SinOsc.ar(199.73, mul: 0.05),
		SinOsc.ar(202.59, mul: 0.1),
		SinOsc.ar(200, mul: 0.2),
		SinOsc.ar(198.07, mul: 0.025)
	];
	sig = Splay.ar(sig);
}.play
)

x.release(2);

// Here, we create a SynthDef to enhance reuse and flexibility, which includes a gated envelope and a few arguments. Following this, we use iteration to create a cluster of Synths, each of which is the result of four summed sine waves.

(
SynthDef.new(\cluster, {
	arg freq = 200, amp = 0.25, gate = 1, out = 0;
	var sig, detune, env;
	detune = [0.99865, 1.01295, 1, 0.99035];
	env = Env.adsr().kr(2, gate);
	sig = [
		SinOsc.ar(freq * detune[0], mul: 0.05),
		SinOsc.ar(freq * detune[1], mul: 0.1),
		SinOsc.ar(freq * detune[2], mul: 0.2),
		SinOsc.ar(freq * detune[3], mul: 0.025)
	];
	sig = Splay.ar(sig) * amp * env;
	Out.ar(out, sig);
}).add;
)

(
x = [50, 60, 59, 69, 64].collect({ |n|
	Synth.new(\cluster, [\freq, n.midicps]);
});
)

x.do({ |synth| synth.set(\gate, 0) });

// This SynthDef can be written more concisely using multichannel expansion:

(
SynthDef.new(\cluster, {
	arg freq = 200, amp = 0.25, gate = 1, out = 0;
	var sig, detune, env;
	detune = [0.99865, 1.01295, 1, 0.99035];
	env = Env.adsr().kr(2, gate);
	sig = SinOsc.ar(freq * detune, mul: [0.05, 0.1, 0.2, 0.025]);
	sig = Splay.ar(sig) * amp * env;
	Out.ar(out, sig);
}).add;
)

(
x = [50, 60, 59, 69, 64].collect({ |n|
	Synth.new(\cluster, [\freq, n.midicps]);
});
)

x.do({ |synth| synth.set(\gate, 0) });