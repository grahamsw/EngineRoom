// Companion Code 3.10
// Modal Synthesis Ideas

// We begin with the Ringz example from the book, in which a single-sample impulse generator drives a resonant filter, producing an 800 Hz resonance that decays by 60 dB over one-third of a second. When using function-dot-play, a default attack time of 0.02 seconds is applied, which interferes with the first impulse. We can bypass this envelope by setting the fadeTime to zero.

s.boot;

(
x = {
	var sig, exc;
	exc = Impulse.ar(1);
	sig = Ringz.ar(exc, 800, 1/3);
	sig = sig * 0.2 ! 2;
}.play(fadeTime: 0);
)

x.free;

// A denser stream of impulses and/or longer decay times are possible, but with sufficiently high values, the output may accumulate, increasing the amplitude and possibly distorting the signal. This is partly dependent on the phase relationships between overlapping resonances, which is determined by the rate of impulse generation and the resonance frequency of the filter.

(
x = {
	var sig, exc;
	exc = Impulse.ar(5);
	sig = Ringz.ar(exc, 800, 5);
	sig = sig * 0.1 ! 2;
}.play(fadeTime: 0);
)

x.free;

// If the frequency of Impulse is zero, it will generate exactly one impulse. A UGen with a doneAction (e.g. Line) is an appropriate addition to free the Synth after a sufficient amount of time. The duration of Line in this case is slightly longer than the Ringz decay time, ensuring that full decay is heard. However, setting these two durations to be equal is reasonable as well.

(
{
	var sig, exc;
	Line.kr(0, 0, 1/2, doneAction: 2);
	exc = Impulse.ar(0);
	sig = Ringz.ar(exc, 800, 1/3);
	sig = sig * 0.2 ! 2;
}.play(fadeTime: 0);
)

// As discussed, excitation signals longer than one sample will increase output gain. A burst of white noise that is 20 samples long, for instance, is roughly equivalent to a rapid-fire discharge of 20 impulses. To demonstrate, we can use Trig to extend the initial single-sample impulse for some amount of time, specified as a number of samples. This extended impulse is effectively a rectangular envelope that can be multiplied by WhiteNoise to create a short noise burst, plotted here:

(
{
	// A 12-sample burst of white noise
	var exc = Impulse.ar(0);
	exc = Trig.ar(exc, SampleDur.ir * 12);
	exc = WhiteNoise.ar(1) * exc;
}.plot(50 / s.sampleRate);
)

// With a Trig duration of zero or one samples, the result is nearly identical to the first example in this file (the amplitude now varies a bit because of the randomness of white noise). By increasing the Trig duration by a few samples at a time, you will notice the amplitude increases. Around 40-50 samples, the signal begins to clip. Keep in mind that this example scales the output signal down by a factor of 0.2 before playing. Left at full amplitude, clipping would occur at even smaller Trig durations.

s.meter;

(
{
	var sig, exc;
	Line.kr(0, 0, 1/2, doneAction: 2);
	exc = Impulse.ar(0);

	// change 0 to 10, 20, 30, etc.
	exc = Trig.ar(exc, SampleDur.ir * 0);

	exc = WhiteNoise.ar(1) * exc;
	sig = Ringz.ar(exc, 800, 1/3);
	sig = sig * 0.2 ! 2;
}.play(fadeTime: 0);
)

// The takeaway is that single-sample impulses are the safest thing to feed into Ringz. With a bit of randomness, multichannel expansion, and spatial positioning, we can begin to create sounds with complex and interesting combinations of vibrational modes. In the following example, we randomly generate frequencies, amplitudes, and decays for 16 vibrational modes, and sort the data so that the lowest modes are the loudest and the longest (a formula that imitates many real-world examples of complex resonance combinations). These 16 modes are distributed across a narrow, central region of the stereo field in order to provide a slight sense of width. The sound will be different with each evaluation.

(
{
	var sig, exc, freqs, amps, decays;

	freqs = Array.exprand(16, 150, 20000).sort;
	amps = Array.exprand(16, 0.002, 0.8).sort.reverse;
	decays = Array.exprand(16, 1, 4).sort.reverse;

	Line.kr(0, 0, 4, doneAction: 2);

	exc = Impulse.ar(0);
	sig = Ringz.ar(exc, freqs, decays);
	sig = sig * amps;
	sig = Splay.ar(sig, 0.2);
}.play(fadeTime: 0);
)

// This combination of Impulse and Ringz produces a signal that begins with a noticeable click, which may sound a unnatural or unpleasant. A non-zero fade time offers a quick fix. Even a few samples' worth of time can be enough to soften the edge:

(
{
	var sig, exc, freqs, amps, decays;

	freqs = Array.exprand(16, 150, 20000).sort;
	amps = Array.exprand(16, 0.002, 0.8).sort.reverse;
	decays = Array.exprand(16, 1, 4).sort.reverse;

	Line.kr(0, 0, 4, doneAction: 2);

	exc = Impulse.ar(0);
	sig = Ringz.ar(exc, freqs, decays);
	sig = sig * amps;
	sig = Splay.ar(sig, 0.2);
}.play(fadeTime: 3/s.sampleRate);
)

// A more robust solution involves marginally extending the excitation signal so that its amplitude has a more percussive shape, with a very small attack and release. Decay and Decay2 are useful for this purpose. Decay transforms a single-sample impulse into a signal that exponentially decays over a period of time. This nicely shapes the release of the excitation signal, but the attack is still instantaneous:

(
{
	var exc;
	exc = Impulse.ar(0);
	exc = Decay.ar(exc, SampleDur.ir * 200);
}.plot(400/s.sampleRate);
)

// Decay2 transforms a single-sample impulse into a percussive shape with an attack and a release:

(
{
	var exc;
	exc = Impulse.ar(0);
	exc = Decay2.ar(exc, SampleDur.ir * 20, SampleDur.ir * 200);
}.plot(400/s.sampleRate, bounds: Rect(100, 100, 800, 300));
)

// Internally, Decay2 works by subtracting one Decay from another. The following code visualizes the subtraction process. Notice how the 3rd and 4th plots are identical.

(
{
	var atk, dec, exc;
	atk = SampleDur.ir * 20; // four-sample attack
	dec = SampleDur.ir * 200; // twenty-sample decay
	exc = Impulse.ar(0); // initial excitation impulse
	[
		Decay.ar(exc, atk),
		Decay.ar(exc, dec),
		Decay.ar(exc, dec) - Decay.ar(exc, atk),
		Decay2.ar(exc, atk, dec)
	]
}.plot(400/s.sampleRate, bounds: Rect(100, 100, 800, 800));
)

// Decay2 has a few quirks. The nature of its implementation prevents impulses in which the attack is longer than the decay. An attempt to create a decayed impulse where 'atk'>'dec' will result in an attack whose duration equals 'dec,' and whose decay equals 'atk,' and the polarity of the signal will be inverted (a polarity-reversed impulse fed to Ringz will not have a consequential effect on the sound).

(
{
	var atk, dec, exc;
	atk = SampleDur.ir * 20;
	dec = SampleDur.ir * 200;
	exc = Impulse.ar(0);
	[
		Decay2.ar(exc, atk, dec),
		Decay2.ar(exc, dec, atk)
	]
}.plot(400/s.sampleRate, bounds: Rect(100, 100, 600, 400));
)

// Because of its subtractive nature, Decay2 has the unfortunate side-effect of producing silence if its attack and decay are equal, and becomes nearly silent if the attack and decay are nearly equal:

(
{
	var atk, dec, exc;
	atk = SampleDur.ir * 100;
	dec = SampleDur.ir * 100;
	exc = Impulse.ar(0);
	[
		Decay2.ar(exc, atk, dec), // constant zero
	]
}.plot(400/s.sampleRate, bounds: Rect(100, 100, 600, 400));
)

// Using Decay2, we can soften the onset of our resonator signal while preserving a Synth fade time of 0 seconds. Recognizing that an extended excitation signal will increase the amplitude of Ringz, it is sensible to compensate in some way. Here, the signal is scaled by a factor of 0.05. The onset of this new signal is not quite so abrupt, and is more suggestive of stimulation with a hard yarn mallet, rather than a cold, digital click. You can experiment with the duration parameters of Decay2 to find the desired amount of "hardness."

(
{
	var sig, exc, freqs, amps, decays;

	freqs = Array.exprand(16, 150, 20000).sort;
	amps = Array.exprand(16, 0.002, 0.8).sort.reverse;
	decays = Array.exprand(16, 1, 4).sort.reverse;

	Line.kr(0, 0, 4, doneAction: 2);

	exc = Impulse.ar(0);
	exc = Decay2.ar(exc, SampleDur.ir * 20, SampleDur.ir * 200);
	sig = Ringz.ar(exc, freqs, decays);
	sig = sig * amps * 0.05;
	sig = Splay.ar(sig, 0.2);
}.play(fadeTime: 0);
)

// As an alternative to Decay2, Formlet is a variation on Ringz in which the desired attack and decay of the resonant output can be specified directly. An apt analogy for the interrelationship of these UGens is:

/*  Decay : Decay2  ::  Ringz : Formlet  */

// In other words, Formlet is the result of subtracting one Ringz from another, just as Decay2 is the result of subtracting one Decay from another. As such, Formlet has the same problem of outputting silence if its attack and decay are equal. Furthermore, the subtractive nature of this operation means that the implicitly created shaped impulse will have a peak amplitude that is less than one. Therefore, the need to compensate for high output gain from Formlet is less severe (here, the amplitude downscaling has been removed):

(
{
	var sig, exc, freqs, amps, decays;

	freqs = Array.exprand(16, 150, 20000).sort;
	amps = Array.exprand(16, 0.002, 0.8).sort.reverse;
	decays = Array.exprand(16, 1, 4).sort.reverse;

	Line.kr(0, 0, 4, doneAction: 2);

	exc = Impulse.ar(0);
	sig = Formlet.ar(exc, freqs, SampleDur.ir * 150, decays);
	sig = sig * amps;
	sig = Splay.ar(sig, 0.2);
}.play(fadeTime: 0);
)

// As discussed, Resonz is nearly identical to BPF. The differences (if there are any) are subtle enough to be of no practical concern to the creative musician. Here is the first BPF example from Companion Code 3.9, in which BPF has been replaced with Resonz.

(
SynthDef(\bpf_brown, {
	arg freq = 200, rq = 0.0025, gate = 1, atk = 1,
	rel = 4, pan = 0, amp = 0.5, out = 0;
	var sig, env;
	env = EnvGen.kr( Env.asr(atk, 1, rel), gate, doneAction: 2);
	sig = BrownNoise.ar(1);
	sig = Resonz.ar(sig, freq, rq, 1 / rq.sqrt);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

x = Synth(\bpf_brown);

x.set(\gate, 0);

// Klank and DynKlank offer a few additional creative options. Here, the Klank function from the book (Code Example 3.27) has been converted to a SynthDef:

(
SynthDef(\klank, {
	arg out = 0;
	var sig, exc, freqs, amps, decays;
	freqs = [ 211, 489, 849, 857, 3139, 4189, 10604, 15767 ];
	amps = [ 0.75, 0.46, 0.24, 0.17, 0.03, 0.019, 0.002, 0.001 ];
	decays = [ 3.9, 3.4, 3.3, 2.5, 2.2, 1.5, 1.3, 1.0 ];
	exc = Impulse.ar(0.5);
	sig = Klank.ar(
		`[freqs, amps, decays],
		exc,
	);
	sig = sig * 0.25 ! 2;
	Out.ar(out, sig);
}).add;
)

x = Synth(\klank);

x.free;

// Some enhancements are possible, like additional arguments for shifting and scaling the modal frequencies and decay times. In the following example, we add an amplitude envelope, we use Dust instead of Impulse to generate random impulses, and we also add arguments for pan position and overall amplitude. The harsh onsets of Dust triggers are softened with Decay2.

(
SynthDef(\klank, {
	arg freqscale = 1, freqoffset = 0, decayscale = 1,
	atk = 0, rel = 4, gate = 1, dens = 1, pan = 0, amp = 1, out = 0;
	var sig, exc, env, freqs, amps, decays;
	freqs = [ 211, 489, 849, 857, 3139, 4189, 10604, 15767 ];
	amps = [ 0.75, 0.46, 0.24, 0.17, 0.03, 0.019, 0.002, 0.001 ];
	decays = [ 3.9, 3.4, 3.3, 2.5, 2.2, 1.5, 1.3, 1.0 ];
	exc = Dust.ar(dens);
	exc = Decay2.ar(exc, SampleDur.ir * 20, SampleDur.ir * 100);
	env = EnvGen.kr( Env.asr(atk, 1, rel), gate, doneAction: 2 );
	sig = Klank.ar(
		`[freqs, amps, decays],
		exc,
		freqscale,
		freqoffset,
		decayscale
	);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env * 0.05;
	Out.ar(out, sig);
}).add;
)

x = Synth(\klank);

x.set(\gate, 0);

// It is now possible to create a choir of resonant voices, each with a unique set of vibrational modes that have been randomly scaled and shifted away from their initial configuration, each with a unique stereophonic position:

(
x = 16.collect({
	Synth(\klank, [
		dens: 0.2,
		freqscale: exprand(0.5, 2.25),
		freqoffset: rrand(-100.0, 1000.0),
		decayscale: exprand(0.75, 1.8),
		pan: rrand(-0.5, 0.5),
		amp: 0.7,
	]);
});
)

x.do({ |synth| synth.set(\gate, 0) });

// Switching to DynKlank enables the use of control signals to modulate frequencies and decay times, at the cost of requiring slightly more processing power. Here, DynKlank's arguments are replaced by low-frequency noise generators.

(
SynthDef(\dynklank, {
	arg atk = 0, rel = 4, gate = 1, dens = 1, pan = 0, amp = 1, out = 0;
	var sig, exc, env, freqs, amps, decays;
	freqs = [ 211.6, 488.8, 849.0, 856.9, 3138.6, 4189.0, 10603.9, 15766.9 ];
	amps = [ 0.75, 0.46, 0.24, 0.17, 0.03, 0.019, 0.002, 0.001 ];
	decays = [ 3.9, 3.4, 3.3, 2.5, 2.2, 1.5, 1.3, 1.0 ];
	exc = Dust.ar(dens);
	exc = Decay2.ar(exc, SampleDur.ir * 20, SampleDur.ir * 100);
	env = EnvGen.kr( Env.asr(atk, 1, rel), gate, doneAction: 2 );
	sig = DynKlank.ar(
		`[freqs, amps, decays],
		exc,
		LFNoise2.kr(0.01).exprange(0.67, 1.5),
		LFNoise2.kr(0.02).range(-100, 500),
		LFNoise2.kr(0.1).exprange(0.2, 2.5)
	);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env * 0.05;
	Out.ar(out, sig);
}).add;
)

// The result is a spatial choir of imaginary resonating bodies whose vibrational modes slowly change over time, as if their physical forms were in a state of flux.

(
x = 16.collect({
	Synth(\dynklank, [
		dens: 0.1,
		pan: rrand(-0.5, 0.5),
		amp: 0.7
	]);
});
)

x.do({ |synth| synth.set(\gate, 0) });

// Finally, we use Klank to emulate the sound of a real-world instrument: an orchestral triangle being struck. The spectrum is inharmonic, with no clear pitch center. The frequencies range from around 500 Hz to the upper threshold of human hearing (although some of the very highest frequencies have been omitted on account of having negligibly low amplitudes and short decay times). Interestingly, most of the energy is clustered in the 4-8 kHz range, and although the lowest frequencies are not as present, they take the longest amount of time to fully decay. The real-time analyzer used to derive this data displayed amplitude information in decibels, transcribed as-is into SC and converted to amplitude values using 'dbamp'.

(
SynthDef(\triangle, {
	arg amp = 1, out = 0;
	var exc, sig, freqs, amps, decays;
	freqs = [
		556,   675,   1004,  1030,  1167,  1182,  1995,  2220,
		2541,  2665,  3126,  3262,  3630,  4519,  4566,  5410,
		5470,  6004,  6176,  6807,  7502,  7560,  8373,  9759,
		9941,  10607, 10892, 12052, 12257, 12709, 13132, 14323
	];
	amps = [
		-66, -50, -45, -34, -36, -33, -40, -29,
		-35, -37, -44, -27, -44, -21, -28, -13,
		-20, -24, -11, -20, -24, -17, -30, -36,
		-30, -33, -27, -36, -39, -32, -27, -29
	].dbamp;
	decays = [
		9,     8.5,   9,     8.8,  8.7,    9,     8.8,   9,
		8.6,   8.7,   8.1,   8.6,  8.4,    8,     8,     5.7,
		5.4,   4,     5.2,   5.3,  3,      3.3,   2.6,   1.6,
		2.2,   2.7,   1.5,   2.3,  2.3,    2.7,   2,     1.4
	];
	Line.kr(0, 0, 9, doneAction: 2);
	exc =  Impulse.ar(0);
	exc = Decay2.ar(exc, SampleDur.ir * 80, SampleDur.ir * 800);
	exc = exc * WhiteNoise.ar(1 ! 2);
	sig = Klank.ar(
		`[freqs, amps, decays],
		exc,
	);
	sig = sig * amp * 0.2;
	Out.ar(out, sig);
}).add;
)

// When emulating real-world sounds made up of exponentially decaying harmonics, those with the patience to transcribe the spectral data will find that modal synthesis is a remarkably effective tool, capable of surprisingly realistic results!

Synth(\triangle);
