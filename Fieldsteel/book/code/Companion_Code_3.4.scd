// Companion Code 3.4
// Basics of FM Synthesis

// We start with a simple FM example:

s.boot;

(
x = {
	var sig, mod;
	mod = SinOsc.ar(250, mul: 250);
	sig = SinOsc.ar(250 + mod);
	sig = sig * 0.2 ! 2;
}.play;
)

x.release(2);

// It's instructive to transform this simple example into a SynthDef with argument controls that enable musical expression on a more practical level. In particular, we'd like to be able to specify musical parameters, such as pitch clarity, timbral color, etc., rather than having to mentally translate these parameters to raw frequencies, amplitudes, and ratios. In this first SynthDef, only the essential arguments are declared:

(
SynthDef(\fm, {
	arg sigHz = 250, modHz = 250, modAmp = 250, amp = 0.2, out = 0;
	var sig, mod;
	mod = SinOsc.ar(modHz, mul: modAmp);
	sig = SinOsc.ar(sigHz + mod);
	sig = sig * amp ! 2;
	Out.ar(out, sig);
}).add;
)

x = Synth(\fm);

x.free;

// As discussed in the book, a simple carrier/modulator ratio tends to produce a harmonic spectrum with a relatively clear pitch center. From a musical perspective, it is more practical to express these values as a frequency and a ratio, rather than two independent values. In the following example, the 'ratio' argument will represent the modulator-to-carrier frequency ratio:

(
SynthDef(\fm, {
	arg freq = 250, ratio = 1, modAmp = 250, amp = 0.2, out = 0;
	var sig, mod;
	mod = SinOsc.ar(freq * ratio, mul: modAmp);
	sig = SinOsc.ar(freq + mod);
	sig = sig * amp ! 2;
	Out.ar(out, sig);
}).add;
)

x = Synth(\fm);

x.free;

// We also know that the approximate number of audible sideband pairs is determined by the index of modulation (the ratio of modulator amplitude to modulator frequency). Therefore, it's similarly convenient to define an argument for the index of modulation, and restructure the code so that modulator amplitude always equals modulator frequency multiplied by this index:

(
SynthDef(\fm, {
	arg freq = 250, ratio = 1, index = 1, amp = 0.2, out = 0;
	var sig, mod;
	mod = SinOsc.ar(freq * ratio, mul: freq * ratio * index);
	sig = SinOsc.ar(freq + mod);
	sig = sig * amp ! 2;
	Out.ar(out, sig);
}).add;
)

// Now, we can freely manipulate the carrier frequency to change the perceived pitch without disrupting the timbre:

x = Synth(\fm);
x.set(\freq, 450);
x.set(\freq, 600);
x.set(\freq, 200);
x.free;

// We also have the ability to independently alter the modulator-to-carrier ratio and/or index of modulation. The ratio affects timbral color by respacing sideband pairs, while the index influences spectral brightness/darkness by adding or removing sidebands.

x = Synth(\fm);
x.set(\ratio, 2, \index, 1);
x.set(\ratio, 3, \index, 1);
x.set(\ratio, 3, \index, 2);
x.set(\ratio, 3, \index, 3);
x.set(\ratio, 1, \index, 1);
x.free;

// Irreducible ratios of larger integers will tend to produce inharmonic spectra:

x = Synth(\fm, [ratio: 17/11]);
x.free;

// As the index increases into double-digits, the timbre becomes significantly harsher and brighter:

x = Synth(\fm, [amp: 0.05]);
x.set(\index, 10);
x.set(\index, 20);
x.set(\index, 40);
x.free;

// Despite the ease with which we can express FM parameters, the sound remains static and flat. An amplitude envelope improves the character of the sound by giving it a sense of beginning and end:

(
SynthDef(\fm, {
	arg freq = 250, ratio = 1, index = 1, amp = 0.4, out = 0,
	atk = 0.01, dec = 0.2, sus = 0.3, rel = 1, gate = 1;
	var sig, mod, env;
	env = EnvGen.ar(
		Env.new(
			[0, 1, sus, sus, 0],
			[atk, dec, 0.01, rel],
			[1, -2, 0, -2],
			3
		),
		gate,
		doneAction: 2
	);
	mod = SinOsc.ar(freq * ratio, mul: freq * ratio * index);
	sig = SinOsc.ar(freq + mod);
	sig = sig * env;
	sig = sig * amp ! 2;
	Out.ar(out, sig);
}).add;
)

x = Synth(\fm);

x.set(\gate, 0);

// A second envelope can be used to control the index of modulation. In effect, we can treat this as a "spectral" envelope. As it increases/decreases, the timbre will brighten/darken, producing sounds that more accurately model timbral properties of some acoustic instruments. Some instruments, such as brass, bowed strings, and metallic percussion, exhibit momentarily high spectral density as the body of the instrument is initially stimulated and vibrates strongly. As time progresses, the vibration stabilizes or decays, usually accompanied by attenuation in higher partials. In the following code, we create a simple envelope which decays from a higher index of modulation down to 1 over a period of time. Note that this additional envelope does not include doneAction: 2, since its completion does not signify the end of the sound, but rather, only the end of the timbral trajectory.

(
SynthDef(\fm, {
	arg freq = 250, ratio = 1, index = 1, amp = 0.4, out = 0,
	atk = 0.01, dec = 0.2, sus = 0.3, rel = 1, gate = 1,
	idec = 1, icrv = (-6);
	var sig, mod, env, ienv;
	env = EnvGen.ar(
		Env.new(
			[0, 1, sus, sus, 0],
			[atk, dec, 0.01, rel],
			[1, -2, 0, -2],
			3
		),
		gate,
		doneAction: 2
	);
	ienv = EnvGen.ar(
		Env.new([index, 1], [idec], [icrv])
	);
	mod = SinOsc.ar(freq * ratio, mul: freq * ratio * ienv);
	sig = SinOsc.ar(freq + mod);
	sig = sig * env;
	sig = sig * amp ! 2;
	Out.ar(out, sig);
}).add;
)


x = Synth(\fm, [index: 7]);
x.set(\gate, 0);

// Larger, more complex spectral envelopes are possible, and can create more interesting timbral morphing effects. Although perhaps not as common, it is just as reasonable to create a third envelope to control the FM ratio. These ideas are left as exercises for the reader to explore.

// To add slightly more richness and depth, we can add detuning and spatial positioning:

(
SynthDef(\fm, {
	arg freq = 250, ratio = 1, index = 1, amp = 0.4, out = 0,
	atk = 0.01, dec = 0.2, sus = 0.3, rel = 1, gate = 1,
	idec = 1, icrv = (-6), detune = 0.12;
	var sig, mod, env, ienv;
	env = EnvGen.ar(
		Env.new(
			[0, 1, sus, sus, 0],
			[atk, dec, 0.01, rel],
			[1, -2, 0, -2],
			3
		),
		gate,
		doneAction: 2
	);
	ienv = EnvGen.ar(
		Env.new([index, 1], [idec], [icrv])
	);

	// four detune values
	freq = freq * ({ Rand(detune.neg, detune).midiratio } ! 4);
	mod = SinOsc.ar(freq * ratio, mul: freq * ratio * ienv);
	sig = SinOsc.ar(freq + mod);
	sig = sig * env;
	sig = Splay.ar(sig) * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth(\fm, [index: 7]);
x.set(\gate, 0);

// We conclude with a musical FM texture relying on iteration and random number generators. In particular, note the mathematical expression used to generate ratio values. The modulo operator (A % B) takes A divided by B and returns the remainder. It is used here to return a value of 1 or 2 depending on whether the iteration count is even or odd, thus half the voices have an FM ratio of 1:1, and the other half 2:1. This helps spread timbral variety throughout the voices.

(
x = [28, 54, 59, 62, 64, 69].collect({
	arg note, i;
	Synth(\fm, [
		freq: note.midicps,
		ratio: i % 2 + 1,
		atk: exprand(0.2, 0.4),
		dec: exprand(2, 5),
		sus: 0.4,
		index: rrand(4, 8),
		amp: 0.1,
		pan: rrand(-0.25, 0.25),
	]);
})
)

// a chord progression:
[28, 52, 59, 62, 66, 68].do({ |note, i| x[i].set(\freq, note.midicps) });

[30, 52, 57, 61, 64, 68].do({ |note, i| x[i].set(\freq, note.midicps) });

// release the final chord
x.do({ |synth| synth.set(\gate, 0, \rel, exprand(4, 8)) });