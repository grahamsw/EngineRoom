// Companion Code 3.9
// Subtractive Synthesis

// We begin with a SynthDef that passes brown noise through a band-pass filter. Some of the examples in this compapnion code include relatively low frequencies which most laptop speakers struggle to reproduce. Use good quality headphones or monitors if possible!

s.boot;

(
SynthDef(\bpf_brown, {
	arg freq = 200, rq = 0.0025, gate = 1, atk = 1,
	rel = 4, pan = 0, amp = 0.5, out = 0;
	var sig, env;
	env = EnvGen.kr( Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = BrownNoise.ar(1);
	sig = BPF.ar(sig, freq, rq, 1 / rq.sqrt);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

x = Synth(\bpf_brown);

x.set(\gate, 0);

// To start, we can modulate the center frequency of the filter, to create variations in the perceived pitch. LFNoise1 or LFNoise2 are interpolating noise generators, and will cause the pitch to randomly slide around:

(
SynthDef(\bpf_brown, {
	arg freq = 200, rq = 0.005, gate = 1, atk = 1,
	rel = 4, pan = 0, amp = 0.5, out = 0;
	var sig, env;
	freq = freq * LFNoise2.kr(1).exprange(0.5, 2);
	env = EnvGen.kr( Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = BrownNoise.ar(1);
	sig = BPF.ar(sig, freq, rq, 1 / rq.sqrt);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

x = Synth(\bpf_brown);

x.set(\gate, 0);

// By fine-tuning a few parameters and creating multiple Synths, we can produce a howling wind effect. First, we add arguments to the SynthDef (freqdevHz and freqdev) to control the speed and range of the frequency deviation. 'freqdev' is represented as a value in semitones that determines a bipolar range for LFNoise2, which is converted to a frequency ratio and multiplied by the base frequency argument.

(
SynthDef(\bpf_brown, {
	arg freq = 200, rq = 0.005, freqdevHz = 2, freqdev = 3,
	gate = 1, atk = 1, rel = 4, pan = 0, amp = 0.5, out = 0;
	var sig, env, dev;
	dev = LFNoise2.kr(freqdevHz).bipolar(freqdev);
	freq = freq * dev.midiratio;
	env = EnvGen.kr( Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = BrownNoise.ar(1);
	sig = BPF.ar(sig, freq, rq, 1 / rq.sqrt);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

// With default arguments, the sound is not much different from the previous example, but we'll develop these ideas as we continue.

x = Synth(\bpf_brown);

x.set(\gate, 0);

// Next, an interation block that creates 16 Synths. The 16 base frequencies are exponentially distributed between 150 to 5000 Hz, and each filter has a random quality. The pitch of each howl can deviate between ±1 to ±6 semitones, varying at a rate between 0.3 and 0.8 Hz. The higher howls have a lower amplitude so that they are not quite so piercing, and each howl is alternatingly panned left/right (the expression [1, -1].at(n % 2) returns 1 when n is even and -1 when n is odd). The result emulates the mild resonances of wind blowing across an imagined landscape:

(
var num = 16; // number of Synths
x = num.collect({ |n|
	Synth(
		\bpf_brown,
		[
			freq: n.linexp(0, num - 1, 150, 5000),
			rq: exprand(0.05, 0.12),
			freqdevHz: exprand(0.3, 0.8),
			freqdev: rrand(1.0, 6.0),
			amp: n.linexp(0, num - 1, 0.25, 0.03),
			pan: rrand(0, 0.4) * [1, -1].at(n % 2)
		]
	);
});
)

x.do({ |synth| synth.set(\gate, 0, \rel, rrand(6.0, 9.0)) });

// What if we wanted to produce discrete random pitches, instead of a pitch-sliding effect? LFNoise0 generates non-interpolated noise and is a good starting point:

(
SynthDef(\bpf_brown, {
	arg freq = 200, rq = 0.005, freqdevHz = 2, freqdev = 3,
	gate = 1, atk = 1, rel = 4, pan = 0, amp = 0.5, out = 0;
	var sig, env, dev;
	dev = LFNoise0.kr(freqdevHz).bipolar(freqdev);
	freq = freq * dev.midiratio;
	env = EnvGen.kr( Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = BrownNoise.ar(1);
	sig = BPF.ar(sig, freq, rq, 1 / rq.sqrt);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

x = Synth(\bpf_brown, [freqdevHz: 8, freqdev: 12]);

x.set(\gate, 0);

// Discontinuous changes in a filter's frequency parameter may create unwanted artifacts. At best, the overall amplitude of the signal is inconsistent, and at worst, loud pops or dramatic amplitude spikes may occur, particularly for large, sudden changes. A limiter would be reasonably appropriate here, to constrain the output level:

(
SynthDef(\bpf_brown, {
	arg freq = 200, rq = 0.005, freqdevHz = 2, freqdev = 3,
	gate = 1, atk = 1, rel = 4, pan = 0, amp = 0.5, out = 0;
	var sig, env, dev;

	dev = LFNoise0.kr(freqdevHz).bipolar(freqdev);
	freq = freq * dev.midiratio;

	env = EnvGen.kr( Env.asr(atk, 1, rel), gate, doneAction:2);

	sig = BrownNoise.ar(1);
	sig = BPF.ar(sig, freq, rq, 1 / rq.sqrt);
	sig = sig * env;
	sig = Pan2.ar(sig, pan);
	sig = Limiter.ar(sig) * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth(\bpf_brown, [freqdevHz: 8, freqdev: 12]);

x.set(\gate, 0);

// As an alternative (or addition), we can use the Lag UGen to force exponential interpolation onto the frequency parameter, causing a pitch slide (in this case, 0.03 seconds for each frequency change) each time a new frequency is chosen. This slightly helps temper amplitude artifacts from sudden frequency changes.

(
SynthDef(\bpf_brown, {
	arg freq = 200, rq = 0.005, freqdevHz = 2, freqdev = 3,
	gate = 1, atk = 1, rel = 4, pan = 0, amp = 0.5, out = 0;
	var sig, env, dev;
	dev = LFNoise0.kr(freqdevHz).bipolar(freqdev);
	dev = Lag.kr(dev, 0.03);
	freq = freq * dev.midiratio;
	env = EnvGen.kr( Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = BrownNoise.ar(1);
	sig = BPF.ar(sig, freq, rq, 1 / rq.sqrt);
	sig = sig * env;
	sig = Pan2.ar(sig, pan);
	sig = Limiter.ar(sig) * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth(\bpf_brown, [freqdevHz: 8, freqdev: 12]);

x.set(\gate, 0);

// As a side note, Lag (and related classes Lag2, Lag3, VarLag, LagUD) are designed to smooth out a jagged or discontinuous signal by imposing an interpolation algorithm:

(
{
	var sig = LFNoise0.ar(50);
	[sig, Lag.ar(sig, 0.01)]
}.plot(0.2);
)

// It may not be immediately obvious that Lag is technically a type of low-pass filter, though it is rarely treated as a proper substitute on account of the fact that a cutoff frequency cannot be provided explicitly. Instead, the cutoff frequency can only be indirectly specified via the lag time:

{ WhiteNoise.ar(0.05 ! 2) }.play;

{ Lag.ar(WhiteNoise.ar(0.05 ! 2), 0.003) }.play;

// Returning to our brown noise example, what if we wanted to elicit discrete and specific pitches? For this idea, we can use TChoose, a signal that selects a random value from an array when triggered. In this example, we can delete our freqdevHz and freqdev arguments, and replace the LFNoise0 with a TChoose that contains an array of semitone transpositions. We can then "drive" this TChoose by feeding it an impulse generator signal.

(
SynthDef(\bpf_brown, {
	arg freq = 200, rq = 0.005,
	gate = 1, atk = 1, rel = 4, pan = 0, amp = 0.5, out = 0;
	var sig, env, trig, dev, intervals;
	trig = Impulse.kr(8);
	intervals = [-12, -5, -2, 0, 5, 9, 10, 17];
	dev = TChoose.kr(trig, intervals);
	dev = Lag.kr(dev, 0.03);
	freq = freq * dev.midiratio;
	env = EnvGen.kr( Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = BrownNoise.ar(1);
	sig = BPF.ar(sig, freq, rq, 1 / rq.sqrt);
	sig = sig * env;
	sig = Pan2.ar(sig, pan);
	sig = Limiter.ar(sig) * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth(\bpf_brown);

x.set(\gate, 0);

// Suppose we want randomly occurring pitch changes that preserve the underlying rhythmic grid of 8 triggers per second. Phrased another way, how can we skip or ignore random triggers from Impulse? One solution is to use Boolean logic to compare a separate random signal against some constant, and multiply the result by the trigger signal. In the SC language, a Boolean expression returns 'true' or 'false,' but on the audio server this expression is technically a signal that has a value of 1.0 if true and 0.0 if false. Through multiplication, a trigger passes if true, and is silenced if false. 'thresh' defaults to 0.4, which means approximately 40% of the triggers from the impulse generator will be allowed to pass.

(
SynthDef(\bpf_brown, {
	arg freq = 200, rq = 0.005, thresh = 0.4,
	gate = 1, atk = 1, rel = 4, pan = 0, amp = 0.5, out = 0;
	var sig, env, trig, dev, intervals;
	trig = Impulse.kr(8);
	trig = trig * (LFNoise0.kr(8).unipolar(1) < thresh);
	intervals = [-12, -5, -2, 0, 5, 9, 10, 17];
	dev = TChoose.kr(trig, intervals);
	dev = Lag.kr(dev, 0.03);
	freq = freq * dev.midiratio;
	env = EnvGen.kr( Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = BrownNoise.ar(1);
	sig = BPF.ar(sig, freq, rq, 1 / rq.sqrt);
	sig = sig * env;
	sig = Pan2.ar(sig, pan);
	sig = Limiter.ar(sig) * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth(\bpf_brown);

x.set(\gate, 0);

// Additionally, we can apply a mild percussive envelope to the signal each time a new pitch is selected, to emphasize these changes with subtle amplitude shaping. Since we already have a named impulse generator driving the pitch changes, we can use that same generator to perform the secondary function of triggerring the enevelope. The result is a melodic sequence that is rhythmically quantized, with an indeterminate arrangement of notes and rests.

(
SynthDef(\bpf_brown, {
	arg freq = 200, rq = 0.005, thresh = 0.4,
	gate = 1, atk = 1, rel = 4, pan = 0, amp = 0.5, out = 0;
	var sig, env, tenv, trig, dev, intervals;
	trig = Impulse.kr(8);
	trig = trig * (LFNoise0.kr(8).unipolar(1) < thresh);
	intervals = [-12,-5,-2,0,5,9,10,17];
	dev = TChoose.kr(trig, intervals);
	dev = Lag.kr(dev, 0.03);
	freq = freq * dev.midiratio;
	env = EnvGen.kr( Env.asr(atk, 1, rel), gate, doneAction:2);
	tenv = EnvGen.kr(
		Env([0.01, 1, 0.01], [0.001, 2], [1, -8]),
		trig
	);
	sig = BrownNoise.ar(1);
	sig = BPF.ar(sig, freq, rq, 1 / rq.sqrt);
	sig = sig * env * tenv;
	sig = Pan2.ar(sig, pan);
	sig = Limiter.ar(sig) * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth(\bpf_brown);

x.set(\gate, 0);

// A continuation for the adventurous reader: Instead of thinking in terms of 12 equal tempered semitones, it can often be worthwhile to step into a different realm of pitch, such as composing with frequency ratios. Here, the set of intonation ratios [ 1, 3/2, 2, 9/4, 5/2, 81/32, 21/8 ] determines the available musical intervals. If we conceive the fundamental as a pitch class C, then these ratios roughly correspond to G, C, D, E, a slightly sharp E, and F. The reliance on integer ratios gives the tuning of these intervals a subtly different flavor than 12-tone equal temperament. To round out the spectrum of the overall sound, a low-pass filter attenuates spectral content above 800 Hz, intended to create a darker, mellower feel.

(
SynthDef(\bpf_brown, {
	arg freq = 200, rq = 0.005, thresh = 0.4, gate = 1,
	atk = 2, rel = 4, t_gate = 1, pan = 0, amp = 0.5, out = 0;
	var sig, env, tenv, trig, dev, intervals;
	trig = Impulse.kr(8);
	trig = trig * (LFNoise0.kr(8).unipolar(1) < thresh);
	intervals = [ 1, 3/2, 2, 9/4, 5/2, 81/32, 21/8 ];
	dev = TChoose.kr(trig, intervals).lag(0.03);
	freq = freq * dev; // no need for 'midiratio'; dev is already a ratio
	env = EnvGen.kr( Env.asr(atk, 1, rel), gate, doneAction:2 );
	tenv = EnvGen.kr(
		Env([0.01, 1, 0.01], [0.001, 2], [1, -8]),
		trig
	);
	sig = BrownNoise.ar(1);
	sig = BPF.ar(sig, freq, rq, 1 / rq.sqrt);
	sig = LPF.ar(sig, 800);
	sig = sig * env * tenv;
	sig = Pan2.ar(sig, pan);
	sig = Limiter.ar(sig) * amp;
	Out.ar(out, sig);
}).add;
)

Synth(\bpf_brown, [freq: 80]);

// Why stop with only one Synth? In the following iteration block, we create five Synths, each panned to a unique stereophonic position, and each based on a different fundamental, all of which are related to 80 Hz by a different integer ratio. These ratios, [4/3, 1, 129/64, 43/32, 31/32], represent a justly-tuned fourth, a unison, a slightly sharp octave, a slightly sharp justly-tuned fourth, and a slightly flat unison. A random sequence of tones based on these ratios is created for each of these five fundamentals, creating serendipitous interactions of rhythm, space, and pitch relationships. Because there are five Synths instead of one, the threshold for allowing triggers to pass has been lowered by a factor of 5 (from 0.4 to 0.08) to preserve the overall note density.

(
~synths = [4/3, 1, 129/64, 43/32, 31/32].collect({ |ratio, i|
	Synth(
		\bpf_brown,
		[
			freq: 80 * ratio,
			thresh: 0.08,
			pan: i.linlin(0, 4, -0.5, 0.5)
		]
	)
});
)

~synths.do({ |synth| synth.set(\gate, 0, \rel, exprand(8, 12)) });