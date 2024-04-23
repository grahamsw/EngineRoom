// Companion Code 3.7
// Blending Wavetables with VOsc

s.boot;

// The following example, based on Code Examples 3.16 and 3.17, uses VOsc to smoothly interpolate across four different wavetables, producing a 200 Hz tone that undergoes a periodic spectral morph. The waveform scope and spectral analyzer serve as excellent supplementary visual aids.

(
b = Buffer.allocConsecutive(4, s, 16384);
~wt = [
	Signal.sineFill(8192, 1 ! 4, [0]),
	Signal.sineFill(8192, 1 / (1..50), 0 ! 50),
	Signal.sineFill(8192, [1 / (1,3..50), 0 ! 25].lace(50), 0 ! 50),
	Signal.sineFill(
		8192,
		Array.exprand(50, 0.001, 1).sort.reverse,
		{ rrand(0, 2pi) } ! 50
	),
];
b[0..3].do({ |buf, i| buf.loadCollection(~wt[i].asWavetable) });
)

(
x = {
	var sig, bufmod;
	bufmod = SinOsc.kr(0.05, 3pi/2).range(0,2.999);
	sig = VOsc.ar(b[0].bufnum + bufmod, 200);
	sig = sig * 0.1!2;
}.play;

FreqScope.new;
s.scope(zoom: 0.852);
)

x.release(2);

// To begin enhancing this sound, we'll create a larger and more interesting collection of 16 wavetables using Env methods:

(
~wt = [

	// First, we create eight complex wavetables. Each has between 8 and 12 segments, with mostly random levels, normalized to guarantee full-amplitude, bipolar wavetables. The segment durations and curvatures are also chosen randomly. The resulting wavetables have busy, jagged shapes, likely to produce bright, dense spectra.
	8.collect({ |i|
		var segs = rrand(8, 12);
		Env.new(
			levels: [0] ++ Array.rand(segs-1, -1.0, 1.0).normalize(-1, 1) ++ [0],
			times: Array.exprand(segs, 0.02, 1),
			curve: Array.fill(segs, { [\sine, rrand(-6.0, 6.0)].choose })
		).asSignal(8192);
	}),

	// Another collection of eight wavetables follows, simpler in shape than the previous eight. Segments are fewer, their durations are random within a smaller range, and the segment curves are either linear or sinusoidal. This produces wavetables with simpler smoother shapes, likely to produce spectra with less high frequency energy.
	8.collect({ |i|
		var segs = rrand(3, 5);
		Env.new(
			levels: [0] ++ Array.rand(segs-1, -1.0, 1.0).normalize(-1, 1) ++ [0],
			times: Array.exprand(segs, 0.2, 1),
			curve: { [0, \sine].choose } ! segs
		).asSignal(8192);
	})

	// These two arrays are stored in an outer array named ~wt.
];

// 'lace' interleaves the contents of these two arrays, so that the order of the final wavetable collection alternates between complex and simple wavetables.
~wt = ~wt.lace(16);

// Finally, we convert to wavetable format and load the data into buffers.
b = Buffer.allocConsecutive(16, s, 16384);
b.do({ |buf, i| buf.loadCollection(~wt[i].asWavetable) });
)

// (optional) plot for visual reference:
~wt.do({ |n| n.plot });

// Next, a SynthDef to play these wavetables. A triangle wave modulates the wavetable index, slowly sweeping across the 16 wavetables. The initial phase of the triangle wave is random, so the starting position within the wavetables is unique with each Synth. LeakDC is used to compensate for potential DC offset.

(
SynthDef(\vosc, {
	arg buf, freq = 80, atk = 0.001, rel = 3, gate = 1, amp = 0.15, out = 0;
	var sig, env, bufmod;
	env = EnvGen.kr(
		Env.asr(atk, 1, rel, -2),
		gate,
		doneAction: 2
	);
	bufmod = LFTri.kr(1 / 32, Rand(0, 4.0)).range(0, 14.999);
	sig = VOsc.ar(buf + bufmod, freq);
	sig = LeakDC.ar(sig);
	sig = sig * env;
	sig = sig * amp ! 2;
	Out.ar(out, sig);
}).add;
)

// Even without any detuning, spatialization, or other enhancements, the automated wavetable crossfades alone create a somewhat interesting sound.

x = Synth(\vosc, [buf: b[0].bufnum]);

x.set(\gate, 0);

// We should nevertheless consider some improvements. We can scale the fundamental frequency by an array of 8 random numbers between 0.99 and 1.01, and use Splay to spread the channels across the stereo field.

(
SynthDef(\vosc, {
	arg buf, freq = 80, atk = 0.001, rel = 3, gate = 1, amp = 0.15, out = 0;
	var sig, env, freqs, bufmod;
	env = EnvGen.kr(
		Env.asr(atk, 1, rel, -2),
		gate,
		doneAction: 2
	);
	freqs = freq * { ExpRand(0.99, 1.01) }.dup(8);
	bufmod = LFTri.kr(1 / 32, Rand(0, 4.0)).range(0, 14.999);
	sig = VOsc.ar(buf + bufmod, freqs);
	sig = Splay.ar(sig);
	sig = LeakDC.ar(sig);
	sig = sig * env;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth(\vosc, [buf: b[0].bufnum]);

x.set(\gate, 0);

// The very beginning of this sound exhibits a subtle sweeping phase effect and a relatively high amplitude burst, a result of all eight VOsc UGens starting in perfect phase alignment. We can remove this phase alignment by supplying VOsc with an array of eight random initial phases.

(
SynthDef(\vosc, {
	arg buf, freq = 80, atk = 0.001, rel = 3, gate = 1, amp = 0.15, out = 0;
	var sig, env, freqs, bufmod;
	env = EnvGen.kr(
		Env.asr(atk, 1, rel, -2),
		gate,
		doneAction: 2
	);
	freqs = freq * { ExpRand(0.99, 1.01) }.dup(8);
	bufmod = LFTri.kr(1 / 32, Rand(0, 4.0)).range(0, 14.999);
	sig = VOsc.ar(buf + bufmod, freqs, { Rand(0, 2pi) }.dup(8));
	sig = Splay.ar(sig);
	sig = LeakDC.ar(sig);
	sig = sig * env;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth(\vosc, [buf: b[0].bufnum]);

x.set(\gate, 0);

// The detuning effect provides tonal color, but the singular triangle wave is used as the same wavetable index for all eight oscillators. Creating an array of eight random phase values for LFTri helps diffuse the timbral "sameness":

(
SynthDef(\vosc, {
	arg buf, freq = 80, atk = 0.001, rel = 3, gate = 1, amp = 0.2, out = 0;
	var sig, env, freqs, bufmod;
	env = EnvGen.kr(
		Env.asr(atk, 1, rel, -2),
		gate,
		doneAction: 2
	);
	freqs = freq * { ExpRand(0.99, 1.01) }.dup(8);
	bufmod = LFTri.kr(1 / 32, { Rand(0, 4.0) } ! 8).range(0, 14.999);
	sig = VOsc.ar(buf + bufmod, freqs, { Rand(0, 2pi) }.dup(8));
	sig = Splay.ar(sig);
	sig = LeakDC.ar(sig);
	sig = sig * env;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth(\vosc, [buf: b[0].bufnum]);

x.set(\gate, 0);

// As an alternative, we can substitute eight linearly-interpolating noise generators for the triangle waves. Using a noise signal for the wavetable indices produces a somewhat more uniform texture, but the change is quite subtle.

(
SynthDef(\vosc, {
	arg buf, freq = 80, atk = 0.001, rel = 3, gate = 1, amp = 0.2, out = 0;
	var sig, env, freqs, bufmod;
	env = EnvGen.kr(
		Env.asr(atk, 1, rel, -2),
		gate,
		doneAction: 2
	);
	freqs = freq * { ExpRand(0.99, 1.01) }.dup(8);
	bufmod = LFNoise1.kr(1 / 32 ! 8).range(0, 14.999);
	sig = VOsc.ar(buf + bufmod, freqs, { Rand(0, 2pi) }.dup(8));
	sig = Splay.ar(sig);
	sig = LeakDC.ar(sig);
	sig = sig * env;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth(\vosc, [buf: b[0].bufnum]);

x.set(\gate, 0);

// Instead of using this sound to create sustained musical chords, as featured in other companion code files, we can utilize modulation concepts to create a rhythmic pattern by modulating the amplitude with an appropriate waveform. LFSaw is a sensible place to start:

(
SynthDef(\vosc, {
	arg buf, freq = 80, atk = 0.001, rel = 3, gate = 1, amp = 0.2, out = 0;
	var sig, env, freqs, bufmod;
	env = EnvGen.kr(
		Env.asr(atk, 1, rel, -2),
		gate,
		doneAction: 2
	);
	freqs = freq * { ExpRand(0.99, 1.01) }.dup(8);
	bufmod = LFNoise1.kr(1 / 32 ! 8).range(0, 14.999);
	sig = VOsc.ar(buf + bufmod, freqs, { Rand(0, 2pi) }.dup(8));
	sig = Splay.ar(sig);
	sig = LeakDC.ar(sig);
	sig = sig * LFSaw.kr(6, iphase: 1).unipolar(1);
	sig = sig * env;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth(\vosc, [buf: b[0].bufnum]);

x.set(\gate, 0);

// The default shape of LFSaw consists of ascending ramps, but we can invert the shape with 'linlin'. It may also be desirable to raise the sawtooth wave to an exponent, which has the effect of bending the ramp segments closer to zero, producing a more natural-sounding amplitude decay:

(
SynthDef(\vosc, {
	arg buf, freq = 80, atk = 0.001, rel = 3, gate = 1, amp = 0.2, out = 0;
	var sig, env, freqs, bufmod;
	env = EnvGen.kr(
		Env.asr(atk, 1, rel, -2),
		gate,
		doneAction: 2
	);
	freqs = freq * { ExpRand(0.99, 1.01) }.dup(8);
	bufmod = LFNoise1.kr(1 / 32 ! 8).range(0, 14.999);
	sig = VOsc.ar(buf + bufmod, freqs, { Rand(0, 2pi) }.dup(8));
	sig = Splay.ar(sig);
	sig = LeakDC.ar(sig);
	sig = sig * LFSaw.kr(6, 1).unipolar(1).linlin(0, 1, 1, 0).pow(3);
	sig = sig * env;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth(\vosc, [buf: b[0].bufnum]);

x.set(\gate, 0);

// By declaring arguments for the frequency of LFSaw, and the exponent to which it is raised, we can then use iteration to create an interesting rhythmic/melodic texture:

(
SynthDef(\vosc, {
	arg buf, freq = 80, sawHz = 6, expon = 3,
	atk = 0.001, rel = 3, gate = 1, amp = 0.2, out = 0;
	var sig, env, freqs, bufmod;
	env = EnvGen.kr(
		Env.asr(atk, 1, rel, -2),
		gate,
		doneAction: 2
	);
	freqs = freq * { ExpRand(0.99, 1.01) }.dup(8);
	bufmod = LFNoise1.kr(1 / 32 ! 8).range(0, 14.999);
	sig = VOsc.ar(buf + bufmod, freqs, { Rand(0, 2pi) }.dup(8));
	sig = Splay.ar(sig);
	sig = LeakDC.ar(sig);
	sig = sig * LFSaw.kr(sawHz, 1).unipolar(1).linlin(0, 1, 1, 0).pow(expon);
	sig = sig * env;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

(
x = [29, 41, 53, 56, 58, 60, 63, 67, 68].collect({ |n, i|
	Synth(\vosc,
		[
			buf: b[0].bufnum,
			freq: n.midicps,

			// The iteration index determines the frequency of LFSaw, which determines the number of pulses per second for each note. Pulses become less frequent as index increases.
			sawHz: 4 / (i + 1),

			// Manipulating the target minimum/maximum (here, 2.5 and 4) to be different positive values alters the decay time of the notes. Certain combinations will create long decays for low notes and short decays for high notes, and other combinations will have the opposite effect. Negative numbers must not be used here! A near-zero value raised to a negative exponent produces a very large value, which in this case is directly used to influence signal amplitude.
			expon: i.linexp(0, 8, 2.5, 4),

			// Higher pitches have lower amplitudes in order to create a slightly darker and more balanced spectrum.
			amp: 0.4 / (i + 1),
		]
	);
});
)

x.do({ |synth| synth.set(\gate, 0) });