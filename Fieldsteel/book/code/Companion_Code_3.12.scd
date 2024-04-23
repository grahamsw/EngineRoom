// Companion Code 3.12
// Synthesizing Percussion Sounds

// Percussion sounds are easily handled by playing back pre-recorded samples, but it can be fun and rewarding to synthesize your own. These three SynthDefs are not meant as "definitive" examples — they are just three possibilites from a sea of variations.

// A kick drum is ultimately just like any other drum: a membrane that vibrates when struck with a mallet. We simply need to fine-tune the recipe. The backbone of a kick synth is some oscillator with a frequency envelope that decends rapidly, and a percussive amplitude envelope. A bit of distortion can help brighten the spectrum and add punchiness.

(
SynthDef(\kick, {
	arg boost = 1.1, pan = 0, amp = 1, out = 0;
	var sig, freqSweep, env;
	freqSweep = Env([3000, 60, 20], [0.025, 1], [-8, -4]).ar;
	env = Env([0, 1, 0], [0.005, 0.5], [1, -12]).ar(2);
	sig = SinOsc.ar(freqSweep);
	sig = (sig * boost).clip(-1, 1);
	sig = sig.distort * 2;
	sig = Pan2.ar(sig, pan, env) * amp;
	Out.ar(out, sig);
}).add;
)

Synth(\kick);

// A snare is a bit more complicated, but not much. In addition to its vibrating membrane, a snare also has a set of coiled springs or wires pressed against its lower membrane, which rattle around to help create its distinctive noisy sound. The membrane can be modeled using one or more oscillators (additive synthesis), and the springs can be modeled with filtered noise (subtractive synthesis). Again, it's just a matter of fine-tuning the algorithm so that it sounds right. In the following example, we sum three sines, each with unique frequency/amplitude envelopes, and combine them with two band-pass filtered white noise generators.

(
SynthDef(\snare, {
	arg amp = 1, out = 0;
	var sig, fenv0, fenv1, fenv2;
	fenv0 = Env([700, 280, 200], [0.01, 0.2], \exp).ar;
	fenv1 = Env([4000, 200], [0.004], \exp).ar;
	fenv2 = Env([1000, 780], [0.02], \exp).ar;
	sig = [
		SinOsc.ar(fenv0) * 0.5,
		SinOsc.ar(fenv1) * Env.perc(0.001, 0.04).ar * 0.2,
		SinOsc.ar(fenv2) * Env.perc(0.001, 0.03).ar * 0.3
	].sum;
	sig = sig * Env.perc(0.0001, 0.18).ar;
	sig = [
		sig,
		BPF.ar(WhiteNoise.ar(1 !2 ), 5000, 0.6, 1) * Env.perc(0.0001, 0.2, 1, -8).ar,
		BPF.ar(WhiteNoise.ar(1 !2 ), 900, 1, 3) * Env.perc(0.0001, 0.2, 1, -8).ar
	].sum;
	sig = sig * Env.perc(0.0001, 0.25, 1, -5).ar(2);
	sig = sig * 0.5 * amp;
	Out.ar(out, sig);
}).add;
)

Synth(\snare);

// A simple approach to synthesizing a hi-hat involves applying an amplitude envelope to white noise. Here, we add a few extra decorations. We apply a band-pass filter to the white noise, and also sum it with two sine waves, one at 12 kHz, and one at 2 kHz.

(
SynthDef(\hihat, {
	arg pan = 0, amp = 1, out = 0;
	var sig;
	sig = BPF.ar(WhiteNoise.ar(1), 9000, 0.5, 1);
	sig = sig * Env.perc(0.0001, 0.1, 1, -7).ar;
	sig = [
		sig,
		SinOsc.ar(12000) * Env.perc(0.001, 0.01).ar * 0.1,
		SinOsc.ar(2000) * Env.perc(0.001, 0.02).ar * 0.02
	].sum;
	sig = sig * Env.perc(0.0001, 0.1, 1, -5).ar(2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

Synth(\hihat);