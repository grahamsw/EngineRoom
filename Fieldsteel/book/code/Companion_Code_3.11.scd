// Companion Code 3.11
// Waveform Distortion Techniques

// We begin with an enveloped sine wave, amplified beyond nominal level and folded between ± 1. By using a random UGen to control the amount of amplification, the waveshape is slightly different for each Synth. The oscilloscope and spectrum analyzer provide visual aids to help understand the synthesis concepts more clearly.

s.boot;

(
s.scope;
FreqScope.new;
)

(
SynthDef(\dist, {
	arg atk = 0.02, rel = 3, gate = 1,
	freq = 300, amp = 0.1, out = 0;
	var sig, env;
	env = EnvGen.kr(
		Env.asr(atk, 1, rel),
		gate,
		doneAction: 2
	);
	sig = SinOsc.ar(freq);
	sig = sig * ExpRand.new(1.1, 1.9);
	sig = Fold.ar(sig, -1, 1);
	sig = sig * env;
	sig = sig * amp ! 2;
	Out.ar(out, sig);
}).add;
)

x = Synth(\dist);

x.set(\gate, 0);

// The spectrum is filled with an assortment of harmonic partials, but the timbre remains static. By modulating the amount of amplification, we give the waveform a dynamically changing shape and timbre:

(
SynthDef(\dist, {
	arg atk = 0.02, rel = 3, gate = 1,
	freq = 300, amp = 0.1, out = 0;
	var sig, env, ampmod;
	env = EnvGen.kr(
		Env.asr(atk, 1, rel),
		gate,
		doneAction: 2
	);
	sig = SinOsc.ar(freq);
	ampmod = LFNoise2.kr(0.5).exprange(1.1, 1.9);
	sig = sig * ampmod;
	sig = Fold.ar(sig, -1, 1);
	sig = sig * env;
	sig = sig * amp ! 2;
	Out.ar(out, sig);
}).add;
)

x = Synth(\dist);

x.set(\gate, 0);

// Modulating the folding boundaries is also possible, but causes the peak amplitude of the output signal to fluctuate. As the folding boundaries get closer to zero, the overall amplitude, too, moves closer to zero.

(
SynthDef(\dist, {
	arg atk = 0.02, rel = 3, gate = 1,
	freq = 300, amp = 0.1, out = 0;
	var sig, env, ampmod, foldmod;
	env = EnvGen.kr(
		Env.asr(atk, 1, rel),
		gate,
		doneAction: 2
	);
	sig = SinOsc.ar(freq);
	ampmod = LFNoise2.kr(0.5).exprange(1.1, 1.9);
	foldmod = LFNoise2.kr(0.5).range(0.2, 1);
	sig = sig * ampmod;
	sig = Fold.ar(sig, foldmod.neg, foldmod);
	sig = sig * env;
	sig = sig * amp ! 2;
	Out.ar(out, sig);
}).add;
)

x = Synth(\dist);

x.set(\gate, 0);

// We can compensate for these fluctuations by dividing the folded signal by the folding boundary value. For example, if the folding is constrained between ± 0.2, then the peak amplitude will be 0.2. Dividing the signal by this value is equivalent to multiplying by 5, which returns the peak values to a nominal level of ± 1:

(
SynthDef(\dist, {
	arg atk = 0.02, rel = 3, gate = 1,
	freq = 300, amp = 0.1, out = 0;
	var sig, env, ampmod, foldmod;
	env = EnvGen.kr(
		Env.asr(atk, 1, rel),
		gate,
		doneAction: 2
	);
	sig = SinOsc.ar(freq);
	ampmod = LFNoise2.kr(0.5).exprange(1.1, 1.9);
	foldmod = LFNoise2.kr(0.5).range(0.2, 1);
	sig = sig * ampmod;
	sig = Fold.ar(sig, foldmod.neg, foldmod) / foldmod;
	sig = sig * env;
	sig = sig * amp ! 2;
	Out.ar(out, sig);
}).add;
)

x = Synth(\dist);

x.set(\gate, 0);

// Iteration facilitates the application of multiple folding operations in series, which can have interesting results, especially if each distortion application is unique. The result is a more jagged and irregular waveform, much brighter than the previous example, so the amplitude is reduced when the Synth is created.

(
SynthDef(\dist, {
	arg atk = 0.02, rel = 3, gate = 1,
	freq = 300, amp = 0.1, out = 0;
	var sig, env, ampmod, foldmod;
	env = EnvGen.kr(
		Env.asr(atk, 1, rel),
		gate,
		doneAction: 2
	);
	sig = SinOsc.ar(freq);
	4.do({
		ampmod = LFNoise2.kr(0.5).exprange(1.1, 1.9);
		foldmod = LFNoise2.kr(0.5).range(0.2, 1);
		sig = sig * ampmod;
		sig = Fold.ar(sig, foldmod.neg, foldmod) / foldmod;
	});
	sig = sig * env;
	sig = sig * amp ! 2;
	Out.ar(out, sig);
}).add;
)

x = Synth(\dist, [amp: 0.05]);

x.set(\gate, 0);

// We can dull the timbre by over-amplifying the signal by a smaller amount, and keeping the folding boundaries closer to ±1:

(
SynthDef(\dist, {
	arg atk = 0.02, rel = 3, gate = 1,
	freq = 300, amp = 0.1, out = 0;
	var sig, env, ampmod, foldmod;
	env = EnvGen.kr(
		Env.asr(atk, 1, rel),
		gate,
		doneAction: 2
	);
	sig = SinOsc.ar(freq);
	4.do({
		ampmod = LFNoise2.kr(0.5).exprange(1.05, 1.3);
		foldmod = LFNoise2.kr(0.5).range(0.6, 1);
		sig = sig * ampmod;
		sig = Fold.ar(sig, foldmod.neg, foldmod) / foldmod;
	});
	sig = sig * env;
	sig = sig * amp ! 2;
	Out.ar(out, sig);
}).add;
)

x = Synth(\dist, [amp: 0.05]);

x.set(\gate, 0);

// To counteract high spectral content more aggressively, we can apply a low-pass filter, and it can be convenient to express the cutoff frequency value as a multiple of the fundamental frequency, i.e., a harmonic number. To avoid dangerous filter values, we also clip the value within a sensible range.

(
SynthDef(\dist, {
	arg atk = 0.02, rel = 3, gate = 1,
	freq = 300, cutoff_harm = 8, amp = 0.1, out = 0;
	var sig, env, ampmod, foldmod;
	env = EnvGen.kr(
		Env.asr(atk, 1, rel),
		gate,
		doneAction: 2
	);
	sig = SinOsc.ar(freq);
	4.do({
		ampmod = LFNoise2.kr(0.5).exprange(1.05, 1.3);
		foldmod = LFNoise2.kr(0.5).range(0.6, 1);
		sig = sig * ampmod;
		sig = Fold.ar(sig, foldmod.neg, foldmod) / foldmod;
		sig = LPF.ar(sig, (freq * cutoff_harm).clip(20, 20000));
	});
	sig = sig * env;
	sig = sig * amp ! 2;
	Out.ar(out, sig);
}).add;
)

x = Synth(\dist);

x.set(\gate, 0);

// Multichannel expansion and spatialiazaion are always reliable options for enriching sound. Here, we also select a more colorful collection of pitches, instead only the default 300 Hz tone:

(
SynthDef(\dist, {
	arg atk = 0.02, rel = 3, gate = 1,
	freq = 300, cutoff_harm = 8, amp = 0.1, out = 0;
	var sig, sig_array, env, ampmod, foldmod;
	env = EnvGen.kr(
		Env.asr(atk, 1, rel),
		gate,
		doneAction: 2
	);
	sig_array = 8.collect({
		sig = SinOsc.ar(
			freq * LFNoise1.kr(0.3).bipolar(0.1).midiratio
		);
		ampmod = LFNoise2.kr(0.5).exprange(1.05, 1.3);
		foldmod = LFNoise2.kr(0.5).range(0.6, 1);
		sig = sig * ampmod;
		sig = Fold.ar(sig, foldmod.neg, foldmod) / foldmod;
		sig = LPF.ar(sig, (freq * cutoff_harm).clip(20, 20000));
	});
	sig = Splay.ar(sig_array);
	sig = sig * env;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

(
x = [37, 44, 53, 61, 65, 68, 70, 79].collect({ |n, i|
	Synth(
		\dist,
		[
			freq: n.midicps,
			atk: 5,
			amp: 0.2 / (i + 1)
		]
	)
});
)

x.do({ |synth| synth.set(\gate, 0, \rel, 6) });

// We can easily darken or brighten the overall sound by manipulating the cutoff frequency. A value of one means the cutoff frequency of the low-pass filter is equal to the fundamental frequency, which will filter out a majority of the upper partials.

(
x = [41, 56, 58, 63, 72, 75, 82].collect({ |n, i|
	Synth(
		\dist,
		[
			freq: n.midicps,
			atk: 5,
			amp: 0.3 / (i + 1),
			cutoff_harm: 1
		]
	)
});
)

x.do({ |synth| synth.set(\gate, 0, \rel, 6) });

// A value of 50, for example, means the filter passes the fundamental and the 49 harmonics immediately above, and our clipping operation keeps the cutoff frequency within a safe range. Without clipping, the 50th harmonic of MIDI note 81 (880 Hz) is 880 * 50 = 44000 Hz. If not clipped to 20000, this could be a dangerous value to plug into a filter!


(
x = [31, 43, 50, 58, 60, 65, 76, 81].collect({ |n, i|
	Synth(
		\dist,
		[
			freq: n.midicps,
			atk: 5,
			amp: 0.2 / (i + 1),
			cutoff_harm: 50
		]
	)
});
)

x.do({ |synth| synth.set(\gate, 0, \rel, 6) });

// Fold can be swapped out for Clip or Wrap at any time, with negligible risk of unwanted surprises, though some minor amplitude adjustment may be appropriate. The main result of such a swap will be a different timbre. Clip tends to be the mellowest, while Wrap tends to be the brightest.

// Gentler distortion methods can also be used, but their output range is fixed between ± 1 and cannot be modulated. So, in the following example involving 'tanh', our 'foldmod' signal has been removed.

(
SynthDef(\dist, {
	arg atk = 0.02, rel = 3, gate = 1,
	freq = 300, cutoff_harm = 8, amp = 0.1, out = 0;
	var sig, sig_array, env, ampmod;
	env = EnvGen.kr(
		Env.asr(atk, 1, rel),
		gate,
		doneAction: 2
	);
	sig_array = 8.collect({
		sig = SinOsc.ar(
			freq * LFNoise1.kr(0.3).bipolar(0.1).midiratio
		);
		ampmod = LFNoise2.kr(0.5).exprange(1.05, 1.3);
		sig = sig * ampmod;
		sig = sig.tanh;
		sig = LPF.ar(sig, (freq * cutoff_harm).clip(20, 20000));
	});
	sig = Splay.ar(sig_array);
	sig = sig * env;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

// Although we have lost one of our modulator signals, the result is still quite nice.

(
x = [39, 56, 58, 61, 67, 68, 72].collect({ |n, i|
	Synth(
		\dist,
		[
			freq: n.midicps,
			atk: 5,
			amp: 0.2 / (i + 1)
		]
	)
});
)

x.do({ |synth| synth.set(\gate, 0, \rel, 6) });

// Dozens of creative avenues remain unexplored. For instance, we can substitute SinOsc with a different sound source, make changes to any of our low-freuqency noise modulators, or increase (within reason) the iteration count governing the number of serial distortion effects. Further experimentation is left as an open exercise for the reader.