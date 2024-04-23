// Companion Code 4.5
// BufWr and BufRd

s.boot;

// This file explores creative sampling techniques involving BufWr and BufRd. This code uses one of SC's built-in audio files as source material, so we begin by reading it into a buffer, and storing it in an Event named 'b' at a key named 'src'. We also allocate three empty buffers for recording purposes, whose durations are 1/50th of a second, 1/10th of a second, and a quarter of a second.

(
b = ();
b[\src] = Buffer.read(s, Platform.resourceDir ++ "/sounds/a11wlk01-44_1.aiff");
b[\rec50th] = Buffer.alloc(s, s.sampleRate / 50, 2);
b[\rec10th] = Buffer.alloc(s, s.sampleRate / 10, 2);
b[\recQtr] = Buffer.alloc(s, s.sampleRate / 4, 2);
)

// First, we'll create a ping-pong delay — a stereo effect in which the left/right channels are swapped each time an echo occurs — by applying a simple modification to the BufWr overdubbing example from Code Example 4.28. Because multichannel signals are represented with arrays, we can 'reverse' an two-channel array to swap the signals. In the following code, the channel swap occurs just before the stereo signal is written to the quarter-second buffer. As a result, the randomly generated sounds seem to ricochet back and forth across the stereophonic field each time Phasor completes one full cycle. The range of frequencies for the sine wave has been increased to make the ping-pong effect more noticeable:

(
x = {
	var sig, freq, phs, delay;
	freq = TExpRand.ar(80, 2500, Dust.ar(10) ! 2);
	sig = SinOsc.ar(freq.lag(0.02), mul: 0.25);
	sig = sig * Line.kr(0, 1, 0.02);
	phs = Phasor.ar(0, BufRateScale.kr(b[\recQtr]), 0, BufFrames.kr(b[\recQtr]));
	sig = sig + (BufRd.ar(2, b[\recQtr], phs) * 0.5);
	BufWr.ar(sig.reverse, b[\recQtr], phs); // channel swap on each overdub
	sig = sig * 0.25;
}.play;
)

x.release(2);

// Next, we'll create a flanger effect, which produces a sense of resonance that periodically sweeps up and down. A flanger effect involves modulating the delay time of a delayed signal, and summing the delayed signal with the original sound. The crux of the effect involves subtracting a fluctuating value from the pointer signal of BufWr, and using the modified pointer as BufRd's frame index. Any source signal can be used, but we opt for pink noise here because it makes the flanging effect especially clear. In the following code, 'mod' is a sine wave whose output value represents a number of samples, subtracted from the recording pointer. The result is that the playback pointer follows behind the record pointer while "wiggling" back and forth in a sinusoidal manner:

(
x = {
	var sig, phs, mod, delay;
	sig = PinkNoise.ar(0.2 ! 2);
	phs = Phasor.ar(0, BufRateScale.kr(b[\rec10th]), 0, BufFrames.kr(b[\rec10th]));
	BufWr.ar(sig, b[\rec10th], phs);
	mod = SinOsc.ar(0.25).exprange(20, 500);
	delay = BufRd.ar(2, b[\rec10th], phs - mod);
	sig = sig + delay;
	sig = sig * 0.25;
}.play;
)

x.release(2);

// For comparison, here is the same effect, but the pink noise is replaced by looping playback of the built-in audio file. The sweeping resonance is still noticeable (particularly if you focus on the background noise, rather than the voice):

(
x = {
	var sig, phs, mod, delay;
	sig = PlayBuf.ar(1 ! 2, b[\src], BufRateScale.kr(b[\src]), loop: 1);
	phs = Phasor.ar(0, BufRateScale.kr(b[\rec10th]), 0, BufFrames.kr(b[\rec10th]));
	BufWr.ar(sig, b[\rec10th], phs);
	mod = SinOsc.ar(0.25).exprange(20, 500);
	delay = BufRd.ar(2, b[\rec10th], phs - mod);
	sig = sig + delay;
	sig = sig * 0.25;
}.play;
)

x.release(2);

// Why, exactly, does a flanger effect produce sweeping resonance? When a signal is delayed by some number of samples and summed with the original signal, frequency content at (s.sampleRate/delay) Hz will be emphasized, along with all harmonics of this frequency, because summation produces increased amplitudes at these frequencies — the peaks and troughs of the delayed signal will line up with the peaks and troughs in the original signal. At the same time, the frame pointer of the delayed signal alternatingly moves faster and slower than normal, creating pitch deviations in the delayed signal. If the delayed signal is isolated from the original, these fluctuations are almost too subtle to be perceived in most cases, but we can exaggerate these pitch fluctuations by increasing the speed or range of the modulator:

(
x = {
	var sig, phs, mod, delay;
	sig = PlayBuf.ar(1 ! 2, b[\src], BufRateScale.kr(b[\src]), loop: 1);
	phs = Phasor.ar(0, BufRateScale.kr(b[\rec10th]), 0, BufFrames.kr(b[\rec10th]));
	BufWr.ar(sig, b[\rec10th], phs);
	mod = SinOsc.ar(1).exprange(20, 2000); // faster modulator
	delay = BufRd.ar(2, b[\rec10th], phs - mod);
	delay = delay * 0.25; // play only the modulated delayed signal
}.play;
)

x.release(2);

// It's more musically convenient to express the resonance range using frequency values, rather than samples. We can do so by dividing the sample rate by the desired frequency values. In this case, the perceived pitch of the flanger effect now ranges from 500 to 2000 Hz, spanning two octaves:

(
x = {
	var sig, phs, mod, delay;
	sig = PinkNoise.ar(0.5 ! 2);
	phs = Phasor.ar(0, BufRateScale.kr(b[\rec10th]), 0, BufFrames.kr(b[\rec10th]));
	BufWr.ar(sig, b[\rec10th], phs);
	mod = SampleRate.ir / SinOsc.ar(0.25).exprange(500, 2000);
	delay = BufRd.ar(2, b[\rec10th], phs - mod);
	sig = sig + (delay * 0.5);
	sig = sig * 0.25;
}.play;
)

x.release(2);

// This paramater can also be expressed through MIDI note numbers:

(
x = {
	var sig, phs, mod, delay;
	sig = PinkNoise.ar(0.5 ! 2);
	phs = Phasor.ar(0, BufRateScale.kr(b[\rec10th]), 0, BufFrames.kr(b[\rec10th]));
	BufWr.ar(sig, b[\rec10th], phs);
	mod = SampleRate.ir / SinOsc.ar(0.25).range(60, 72).midicps;
	delay = BufRd.ar(2, b[\rec10th], phs - mod);
	sig = sig + (delay * 0.5);
	sig = sig * 0.25;
}.play;
)

x.release(2);

// SinOsc is a sensible option for modulating a frame pointer and smoothly changing the pitch of the delayed signal, but it's not the only option. Any waveform with a continuous shape will produce a similarly smooth but different result, e.g. LFDNoise3 is a good choice for random behavior. Discontinuous waveforms, e.g. sawtooth and square waves, will produce clicks at discontinuities and are less useful. Experimentation is encouraged.

// We've seen that BufWr and BufRd can be used to fluctuate the pitch of a signal by modulating a frame pointer, which raises a question: is it possible to alter the pitch of a signal so that it's fixed at a constant value? In other words, can we create a harmonizer effect? We can't just subtract a constant from the record pointer and use the result for the playback pointer — this would merely reproduce the input signal at its original pitch, some amount of time later (a basic echo effect). Instead, we must intentionally run the playback pointer at a speed that is constant, but different from the record pointer speed.

// In the following code, we loop-record the built-in audio file into our shortest buffer, and read from that buffer at a speed that corresponds to a reduction by three semitones. The sum of the original signal with the speed-modulated version produces a minor third interval, but the audio is littered with clicks. These clicks are produced because there is always a discontinuity in the recording buffer, between the oldest and newest sample in the buffer (the frame index of this point is determined by 'phsWr' in the following code). Because the recording and playback pointers are running at different speeds, the playback process regularly encounters this discontinuity and produces a click (compare this to the earlier flanger effect, in which the playback pointer stays within some range that is always slightly behind the recording pointer, never actually crossing the discontinuity).

(
x = {
	var sig, phsWr, phsRd, delay;
	sig = PlayBuf.ar(1 ! 2, b[\src], BufRateScale.kr(b[\src]), loop: 1);
	phsWr = Phasor.ar(
		rate: BufRateScale.kr(b[\rec50th]),
		start: 0,
		end: BufFrames.kr(b[\rec50th])
	);
	BufWr.ar(sig, b[\rec50th], phsWr);
	phsRd = Phasor.ar(
		rate: BufRateScale.kr(b[\rec50th]) * -3.midiratio,
		start: 0,
		end: BufFrames.kr(b[\rec50th])
	);
	delay = BufRd.ar(2, b[\rec50th], phsRd);
	sig = sig + delay;
	sig = sig * 0.25;
}.play;
)

x.release(2);

// To eliminate these clicks, we'll walk through a step-by-step solution. First, we know that a click will occur when the two pointers coincide, i.e. when they output the same frame value. At these moments, the difference between the pointer signals will be zero. To visualize, we can plot the difference and note the zero-crossings to obtain a rough idea of where these clicks will occur.

(
x = {
	var sig, phsWr, phsRd;
	sig = PlayBuf.ar(1 ! 2, b[\src], BufRateScale.kr(b[\src]), loop: 1);
	phsWr = Phasor.ar(
		rate: BufRateScale.kr(b[\rec50th]),
		start: 0,
		end: BufFrames.kr(b[\rec50th])
	);
	BufWr.ar(sig, b[\rec50th], phsWr);
	phsRd = Phasor.ar(
		rate: BufRateScale.kr(b[\rec50th]) * -3.midiratio,
		start: 0,
		end: BufFrames.kr(b[\rec50th])
	);
	(phsWr - phsRd);
}.plot(0.5);
)

// Because the Phasor signals move at different rates and snap back to 0 when they reach their end, the value of the difference periodically "jumps" up or down by a value equal to the number of samples in the buffer, and the plot is confusing. We can tidy it up by using a modulo operation to constrain the values between 0 and the final frame index of the buffer, and we can more clearly see that zero values occur approximately every 0.125 seconds:

(
x = {
	var sig, phsWr, phsRd;
	sig = PlayBuf.ar(1 ! 2, b[\src], BufRateScale.kr(b[\src]), loop: 1);
	phsWr = Phasor.ar(
		rate: BufRateScale.kr(b[\rec50th]),
		start: 0,
		end: BufFrames.kr(b[\rec50th])
	);
	BufWr.ar(sig, b[\rec50th], phsWr);
	phsRd = Phasor.ar(
		rate: BufRateScale.kr(b[\rec50th]) * -3.midiratio,
		start: 0,
		end: BufFrames.kr(b[\rec50th])
	);
	(phsWr - phsRd) % BufFrames.kr(b[\rec50th]);
}.plot(0.5);
)

// The simplest way to eliminate these clicks is to fade out the delayed signal as a click approaches, and fade the signal back in once each click has passed. Our modulo-difference expression at the bottom of the function already provides an oscillating ramp signal, perfectly synchronized with the clicks. So, we can use this value, scaled between 0 and 2pi, to drive a cosine function, to be used as a periodic envelope generator. First, let's simply plot the resulting cosine signal:

(
x = {
	var sig, phsWr, phsRd, cosIndex;
	sig = PlayBuf.ar(1 ! 2, b[\src], BufRateScale.kr(b[\src]), loop: 1);
	phsWr = Phasor.ar(
		rate: BufRateScale.kr(b[\rec50th]),
		start: 0,
		end: BufFrames.kr(b[\rec50th])
	);
	BufWr.ar(sig, b[\rec50th], phsWr);
	phsRd = Phasor.ar(
		rate: BufRateScale.kr(b[\rec50th]) * -3.midiratio,
		start: 0,
		end: BufFrames.kr(b[\rec50th])
	);
	cosIndex = (phsWr - phsRd) % BufFrames.kr(b[\rec50th]);
	cosIndex = cosIndex.linlin(0, BufFrames.kr(b[\rec50th]), 0, 2pi); // scale between 0-2pi
	cos(cosIndex);
}.plot(0.5);
)

// By comparing this plot to the sawtooth plot from one example earlier, we see that cosine maxima coincide with points where clicks occur. This is not quite what we want — instead, we want cosine minima to coincide with clicks. We also want the range to be unipolar (between 0 and 1), rather than bipolar (between ± 1). We can map the cosine output to this desired range using linlin:

(
x = {
	var sig, phsWr, phsRd, cosIndex;
	sig = PlayBuf.ar(1 ! 2, b[\src], BufRateScale.kr(b[\src]), loop: 1);
	phsWr = Phasor.ar(
		rate: BufRateScale.kr(b[\rec50th]),
		start: 0,
		end: BufFrames.kr(b[\rec50th])
	);
	BufWr.ar(sig, b[\rec50th], phsWr);
	phsRd = Phasor.ar(
		rate: BufRateScale.kr(b[\rec50th]) * -3.midiratio,
		start: 0,
		end: BufFrames.kr(b[\rec50th])
	);
	cosIndex = (phsWr - phsRd) % BufFrames.kr(b[\rec50th]);
	cosIndex = cosIndex.linlin(0, BufFrames.kr(b[\rec50th]), 0, 2pi);
	cos(cosIndex).linlin(-1, 1, 1, 0); // flip the sign, scale between 0 and 1
}.plot(0.5);
)

// By bringing the audio signals back into this UGen function, and applying this cosine signal as an amplitude envelope, each click is successfully faded out:

(
x = {
	var sig, phsWr, phsRd, cosIndex, delay;
	sig = PlayBuf.ar(1 ! 2, b[\src], BufRateScale.kr(b[\src]), loop: 1);
	phsWr = Phasor.ar(
		rate: BufRateScale.kr(b[\rec50th]),
		start: 0,
		end: BufFrames.kr(b[\rec50th])
	);
	BufWr.ar(sig, b[\rec50th], phsWr);
	phsRd = Phasor.ar(
		rate: BufRateScale.kr(b[\rec50th]) * -3.midiratio,
		start: 0,
		end: BufFrames.kr(b[\rec50th])
	);
	delay = BufRd.ar(2, b[\rec50th], phsRd);
	cosIndex = (phsWr - phsRd) % BufFrames.kr(b[\rec50th]);
	cosIndex = cosIndex.linlin(0, BufFrames.kr(b[\rec50th]), 0, 2pi);
	delay = delay * cos(cosIndex).linlin(-1, 1, 1, 0);
	sig = sig + delay;
	sig = sig * 0.25;
}.play;
)

x.release(2);

// We're not quite finished — we've merely replaced each click with a fade, yielding audible amplitude pulsations. To produce a steady amplitude, the solution involves summing the delayed signal with a second delayed signal whose playback frame pointer is one half-cycle out of phase with the first playback frame pointer. In this case, the clicks will occur in alternating fashion, and from these two frame pointers, we can calculate two cosine signals that are one half-cycle (π radians) out of phase with each other. Thus, as one click is faded out, the other delayed signal is faded in to compensate for the silence. Multichannel expansion greatly facilitates the expression of this configuration.

// (Note that we used a very similar technique of creating two out-of-phase signals that complement each other toward the end of Companion Code 4.2, in the process of sustaining a metal pipe sample.)

// The out-of-phase cosine envelope signals are demonstrated and plotted in the following code:

(
x = {
	var sig, phsWr, phsRd, cosIndex;
	sig = PlayBuf.ar(1 ! 2, b[\src], BufRateScale.kr(b[\src]), loop: 1);
	phsWr = Phasor.ar(
		rate: BufRateScale.kr(b[\rec50th]),
		start: 0,
		end: BufFrames.kr(b[\rec50th])
	);
	BufWr.ar(sig, b[\rec50th], phsWr);
	phsRd = Phasor.ar(
		rate: BufRateScale.kr(b[\rec50th]) * -3.midiratio,
		start: 0,
		end: BufFrames.kr(b[\rec50th])
	);

	// an array of two playback pointers, half a cycle out of phase with each other
	phsRd = phsRd - [0, BufFrames.kr(b[\rec50th]) / 2];

	// the following operations are applied to both signals in the phsRd array:
	cosIndex = (phsWr - phsRd) % BufFrames.kr(b[\rec50th]);
	cosIndex = cosIndex.linlin(0, BufFrames.kr(b[\rec50th]), 0, 2pi);
	cos(cosIndex).linlin(-1, 1, 1, 0);
}.plot(0.5);
)

// Here is the auditory result:

(
x = {
	var sig, phsWr, phsRd, cosIndex, delay;
	sig = PlayBuf.ar(1 ! 2, b[\src], BufRateScale.kr(b[\src]), loop: 1);
	phsWr = Phasor.ar(
		rate: BufRateScale.kr(b[\rec50th]),
		start: 0,
		end: BufFrames.kr(b[\rec50th])
	);
	BufWr.ar(sig, b[\rec50th], phsWr);
	phsRd = Phasor.ar(
		rate: BufRateScale.kr(b[\rec50th]) * -3.midiratio,
		start: 0,
		end: BufFrames.kr(b[\rec50th])
	);
	phsRd = phsRd - [0, BufFrames.kr(b[\rec50th]) / 2];
	delay = BufRd.ar(2, b[\rec50th], phsRd);
	cosIndex = (phsWr - phsRd) % BufFrames.kr(b[\rec50th]);
	cosIndex = cosIndex.linlin(0, BufFrames.kr(b[\rec50th]), 0, 2pi);
	delay = delay * cos(cosIndex).linlin(-1, 1, 1, 0);
	sig = sig + (delay.sum); // all three signals are added together)
	sig = sig * 0.25;
}.play;
)

x.release(2);

// The result is a reasonably clean harmonization effect, in which a bit of clever math allows us to essentially bypass the otherwise inseparable relationship between pitch and time, while using normal speed variation playback techniques. Drawbacks include a very slight delay in the harmonized signal due (to the its delay-based nature), and there may be some audible phasing/comb filtering in the summed delay signal on account of interference between the two summed signals. From this point, it would sensible to create a SynthDef with some useful arguments and an overall amplitude envelope:

(
SynthDef(\harmonizer, {
	arg pch = 0, buf = 0, sigamp = 0.5, delayamp = 0.5, amp = 0.5, gate = 1, out = 0;
	var sig, env, phsWr, phsRd, cosIndex, delay;
	sig = PlayBuf.ar(1 ! 2, b[\src], BufRateScale.kr(b[\src]), loop: 1);
	env = Env.asr(0.1, 1, 4).kr(2, gate);
	phsWr = Phasor.ar(
		rate: BufRateScale.kr(buf),
		start: 0,
		end: BufFrames.kr(buf)
	);
	BufWr.ar(sig, buf, phsWr);
	phsRd = Phasor.ar(
		rate: BufRateScale.kr(buf) * pch.midiratio,
		start: 0,
		end: BufFrames.kr(buf)
	);
	phsRd = phsRd - [0, BufFrames.kr(buf) / 2];
	delay = BufRd.ar(2, buf, phsRd);
	cosIndex = (phsWr - phsRd) % BufFrames.kr(buf);
	cosIndex = cosIndex.linlin(0, BufFrames.kr(buf), 0, 2pi);
	delay = delay * cos(cosIndex).linlin(-1, 1, 1, 0);
	delay = delay.sum;
	sig = (sig * sigamp) + (delay * delayamp);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

(
b[\rec50th].zero;
x = Synth(\harmonizer, [\buf, b[\rec50th], \pch, -3]);
)

x.set(\gate, 0);

// This effect works best with very small buffers. With larger buffers, the phase drift between frame pointers occupies a larger span of time. As a result, the delay-based aspects of this effect become more exaggerated and obvious:

(
b[\recQtr].zero;
x = Synth(\harmonizer, [\buf, b[\recQtr], \pch, -3]);
)

x.set(\gate, 0);

// If the buffer is too small, the cosine envelope will need to operate at a higher frequency. If the frequency is too high, the envelope will introduce amplitude modulation artifacts (sidebands) into the signal. A buffer duration of 1/50th of a second is a good compromise and a good place to start.

// With a proper SynthDef, it becomes easier to create chords, tone clusters, etc.:

(
b[\rec50th].zero;

// whole-tone scale cluster
x = [-10, -8, -6, -4, -2, 0].collect({ |n, i|
	Synth(
		\harmonizer,
		[
			\buf, b[\rec50th],
			\pch, n,
			\sigamp, (i == 0).asInteger,
			\delayamp, 1,
			\amp, 0.1,
		]
	);
});
)

x.do({ |synth| synth.set(\gate, 0) });

(
b[\rec50th].zero;

// random microtonal cluster
x = Array.rand(6, -2.0, 2.0).collect({ |n, i|
	Synth(
		\harmonizer,
		[
			\buf, b[\rec50th],
			\pch, n,
			\sigamp, (i == 0).asInteger,
			\delayamp, 1,
			\amp, 0.1,
		]
	);
});
)

x.do({ |synth| synth.set(\gate, 0) });

// The source signal in this SynthDef is hard-coded to be looped playback of a built-in audio file, but it can be changed to be anything else, e.g. a sound file of your own, some synthesized signal, or a live microphone signal. You will likely find that some signals work better than others, and the quality of the effect may vary depending on the size of the recording buffer and the amount of pitch transposition. Extreme transposition values (approximately an octave or more) will begin to sound noticeably unrealistic, and may exhibit aliasing or other forms of quality degradation, though the desirability of these side-effects are dependent on taste and context.