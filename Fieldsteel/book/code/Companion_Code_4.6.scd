// Companion Code 4.6
// Granular Synthesis Techniques

// Here, we explore some creative techniques involving granular synthesis. GrainBuf is used throughout, but these techniques can be mimicked with TGrains or Warp1 relatively easily. All examples assume that the server is booted and that a monophonic sound file has been loaded into buffer 'b':

s.boot;

b = Buffer.read(s, Platform.resourceDir ++ "/sounds/a11wlk01.wav");

b.play;

// As mentioned in the book, one of the more valuable applications of granular synthesis is its ability to independently manipulate the timing and pitch of an audio file, offering a freedom of sonic exploration that is difficult to achieve with simpler tools.

/*-------------------------------------------*/
/* Manipulating Pitch Without Affecting Time */
/*-------------------------------------------*/

// To manipulate pitch while leaving durational aspects alone, we use the rate argument to determine pitch, while the position argument should move the grain pointer through the file at normal speed. To avoid gaps in the sound, the grains should be dense enough to ensure some amount of overlap between consecutive grains. If using Impulse to generate grains, a sensible grain duration is twice the reciprocal of the trigger frequency, which ensures 50% grain overlap. A terminating doneAction can be included with the UGen that determines buffer position, so that the grain pointer doesn't get "stuck" at the end of the file while the grains play on. The following example reduces the pitch by five semitones, while preserving the original duration.

(
SynthDef(\granular, {
	arg buf = 0, trigHz = 8, pch = 0, amp = 0.3, out = 0;
	var sig;
	sig = GrainBuf.ar(
		numChannels: 2,
		trigger: Impulse.kr(trigHz),
		dur: 2 / trigHz,
		sndbuf: buf,
		rate: pch.midiratio,
		pos: Line.kr(0, 1, BufDur.ir(b), doneAction: 2)
	);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

Synth(\granular, [buf: b, pch: -5]);

// Multiple Synths can create harmony:

[-7, -2, 0].do({ |n| Synth(\granular, [buf: b, pch: n]) });

// Phasor can replace Line for looping playback. Compared to its use with BufRd, a bit of additional math is required to map the values to the expected range between 0 and 1. In the following SynthDef, we create a conventional frame pointer for buffer 'b', and use division to scale the result to the necessary range.

(
SynthDef(\granular, {
	arg buf = 0, trigHz = 8, pch = 0, amp = 0.3, out = 0;
	var sig, startPos;
	startPos = Phasor.ar(0, BufRateScale.ir(buf), 0, BufFrames.ir(buf));
	startPos = startPos / BufFrames.ir(buf);
	sig = GrainBuf.ar(
		numChannels: 2,
		trigger: Impulse.kr(trigHz),
		dur: 2 / trigHz,
		sndbuf: buf,
		rate: pch.midiratio,
		pos: startPos
	);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth(\granular, [buf: b, pch: 4]);

x.free;

// Using random pitch values from a small range creates interesting "cluster" effects:

(
x = Array.rand(8, -10.0, -7.0).collect({ |n|
	Synth(\granular, [buf: b, pch: n, amp: 0.1]);
});
)

x.do({ arg synth; synth.free; });

// The rate at which grains are created can sometimes interfere with the pitch of the sound. If grains overlap by 50%, using the default bell curve grain envelope, these problems are unlikely to occur so long as the grain playback rate is not altered. In fact, this is a reliable recipe for a near-perfect reconstruction of the original audio file, regardless of grain size:

x = Synth(\granular, [buf: b, trigHz: 4, pch: 0]);

x.free;

x = Synth(\granular, [buf: b, trigHz: 20, pch: 0]);

x.free;

x = Synth(\granular, [buf: b, trigHz: 90, pch: 0]);

x.free;

// However, a relatively high grain frequency will produce aliasing effects. This occurs because the impulse generator is running at the control rate and loses precision at higher frequencies:

x = Synth(\granular, [buf: b, trigHz: 500, pch: 0]);

x.free;

// But, if we run the impulse generator at the audio rate, its frequency can be significantly higher without causing aliasing:

(
SynthDef(\granular, {
	arg buf = 0, trigHz = 8, pch = 0, amp = 0.3, out = 0;
	var sig, startPos;
	startPos = Phasor.ar(0, BufRateScale.ir(buf), 0, BufFrames.ir(buf));
	startPos = startPos / BufFrames.ir(buf);
	sig = GrainBuf.ar(
		numChannels: 2,
		trigger: Impulse.ar(trigHz), // <- audio rate
		dur: 2 / trigHz,
		sndbuf: buf,
		rate: pch.midiratio,
		pos: startPos
	);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth(\granular, [buf: b, trigHz: 500, pch: 0]);

x.free;

// In general, running all granular parameters at the audio rate is worth considering, to ensure a cleaner, higher-resolution sound, particularly if these parameters are meant to change or oscillate rapidly. The additional CPU cost is a relatively small price to pay.

// However, even with an audio-rate impulse generator, high grain densities coupled with a shift in pitch will produce artifacts which resemble the sideband-producing behavior of amplitude and ring modulation. These artifacts occur because the assembled grains no longer mimic the original audio file; each grain has been stretched/squashed, but they are pieced together with original timing. Thus, the grain summation process will produce patterns of waveform interference which alter the quality of the sound.

// For example, a relatively low grain density produces a relatively clean pitch shift:

x = Synth(\granular, [buf: b, trigHz: 10, pch: -6]);

x.free;

// But, a higher grain density begins to distort the spectrum and blur the harmonic precision:

x = Synth(\granular, [buf: b, trigHz: 200, pch: -6]);

x.free;

// In the case of an unusually high grain density, the grains become so short that the amount of pitch shift is inconsequential. The sonic result is much closer to the original file than the transposed version:

x = Synth(\granular, [buf: b, trigHz: 1500, pch: -6]);

x.free;

// The bottom line is that a clean pitch shift is usually best achieved using relatively large, sparse grains, while ensuring sufficent grain overlap. In fact, we might want add an additional argument to determine the degree of overlap:

(
SynthDef(\granular, {
	arg buf = 0, trigHz = 8, overlaps = 2, pch = 0, amp = 0.3, out = 0;
	var sig, startPos;
	startPos = Phasor.ar(0, BufRateScale.ir(buf), 0, BufFrames.ir(buf));
	startPos = startPos / BufFrames.ir(buf);
	sig = GrainBuf.ar(
		numChannels: 2,
		trigger: Impulse.ar(trigHz),
		dur: overlaps / trigHz, // <- mimicking behavior of Warp1's 'overlaps' argument
		sndbuf: buf,
		rate: pch.midiratio,
		pos: startPos
	);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

// For example, a granular pitch shift might be improved with a slightly higher degree of grain overlap:

x = Synth(\granular, [buf: b, trigHz: 8, overlaps: 3, pch:  -6]);

x.free;

// Adjusting other parameters, such as grain envelope shape and the type of resampling interpolation, may also offer slight improvements. Whether a granular pitch-shifting effect is considered "successful" is ultimately a matter of taste and context. As parameters are pushed to extremes, artifacts will emerge more prominently and persistently. However, artifacts can often be recontextualized as "special effects." The following two examples offer a glimpse into these ideas:

(
x = 4.collect({
	Synth(
		\granular,
		[
			buf: b,
			trigHz: rrand(2.0, 3.0),
			overlaps: rrand(16, 20),
			pch: rrand(-15.0, -12.0),
			amp: 0.15
		]
	);
});
)

x.do({ |synth| synth.free });

(
x = 4.collect({
	Synth(
		\granular,
		[
			buf: b,
			trigHz: 40,
			overlaps: rrand(0.35, 0.5),
			pch: rrand(10, 15),
			amp: 0.15
		]
	);
});
)

x.do({ |synth| synth.free });

// On the topic of granular pitch-shifting, the PitchShift UGen is available for this purpose. Although it is technically a granulator, it is designed with a distinct focus on pitch-shifting, rather than open-ended granular effects. Specific restrictions include a non-modulatable grain size, a non-alterable triangle-shaped grain envelope, and a fixed overlap ratio of 4:1. Interpolation is always linear, and the pitch shift ratio is bounded between 0 and 4 (a maximum of two octaves up). Additionally, PitchShift operates on a live signal, rather than samples stored in a buffer, so selection of grains from points in the past or future are cumbersome, if not outright impossible. PitchShift includes pitch and time "dispersion" parameters whose general goal is to create a "blurred" effect that masks artifacts. All things considered, PitchShift is a decent pitch-shifter. Whether it sounds "good" is a matter of context, left for the coder to determine.

(
x = {
	var sig;
	sig = PlayBuf.ar(1, b, BufRateScale.ir(b), loop: 1);
	sig = PitchShift.ar(
		in: sig,
		windowSize: 0.2,
		pitchRatio: -5.midiratio,
		pitchDispersion: 0.01,
		timeDispersion: 0.01
	);
	sig = sig * 0.5 ! 2;
}.play;
)

x.free;

// It's virtually impossible to produce a "perfect" granular pitch shift, free of undesirable artifacts. The act of using granular synthesis to deconstruct/reconstruct an audio file influences the sound in a particular way. As an analogy, consider taking the pieces of a jigsaw puzzle, and slightly enlarging the image printed on each piece, while leaving the size and shape of the pieces unchanged. It will still be possible to physically fit all the pieces back together, and the composite image may even exhibit a vague "zoomed in" effect, but image content will be misaligned at the border of every pair of adjacent pieces, and the composite image will be slightly distorted and irregular.

/*-------------------------------------------*/
/* Manipulating Time Without Affecting Pitch */
/*-------------------------------------------*/

// To manipulate durational aspects of a file while leaving pitch unaffected, the grain playback rate should remain at 1, while the rate at which the pos value advances should be adjusted accordingly. The addition of a new argument for this purpose (posRate) is recommended.

(
SynthDef(\granular, {
	arg buf = 0, trigHz = 8, overlaps = 2, posRate = 1, pch = 0, amp = 0.3, out = 0;
	var sig, startPos;
	startPos = Phasor.ar(0, posRate * BufRateScale.ir(buf), 0, BufFrames.ir(buf));
	startPos = startPos / BufFrames.ir(buf);
	sig = GrainBuf.ar(
		numChannels: 2,
		trigger: Impulse.ar(trigHz),
		dur: overlaps / trigHz,
		sndbuf: buf,
		rate: pch.midiratio,
		pos: startPos
	);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth(\granular, [buf: b, posRate: 0.5]); // pointer speed halved (double duration)

x.set(\posRate, 2);

x.free;

// Our jigsaw puzzle analogy tentatively holds here as well: in this case, the size and shape of the pieces have been altered, but the image printed on each piece has not, so the pieces can no longer be perfectly reassembled.

// When increasing pointer speed, content in the original file may be dropped if the speed is sufficiently high and the grains are sufficiently sparse:

x = Synth(\granular, [buf: b, posRate: 4]);

x.free;

// This problem can usually be corrected by increasing the grain density. Recall that in our SynthDef, grain duration is dependent on grain density; as density increases, grain duration proportionally decreases to preserve the degree of grain overlap:

x = Synth(\granular, [buf: b, posRate: 4, trigHz: 100]);

x.free;

// If the pointer speed is very high, the buffer content flies by in a blur, which may or may not be desirable:

x = Synth(\granular, [buf: b, posRate: 16, trigHz: 100]);

x.free;

// And, if the pointer speed is ultra-high (e.g. in the thousands or even tens of thousands), even an audio-rate Phasor signal will fall victim aliasing. You may, however, encounter interesting results from unique combinations of pointer speed and grain density (although this represents a significant devation from conventional granular time stretching):

x = Synth(\granular, [buf: b, posRate: 1000, trigHz: 100]);

x.free;

// To demonstrate these oddities more clearly and dynamically, we can temporarily replace the posRate argument with an XLine UGen, which slowly ramps into extreme territory over 8 seconds.

(
SynthDef(\granular, {
	arg buf = 0, trigHz = 8, overlaps = 2, pch = 0, amp = 0.3, out = 0;
	var sig, startPos, posRate;
	posRate = XLine.ar(0.1, 3000, 8);
	startPos = Phasor.ar(0, posRate * BufRateScale.ir(buf), 0, BufFrames.ir(buf));
	startPos = startPos / BufFrames.ir(buf);
	sig = GrainBuf.ar(
		numChannels: 2,
		trigger: Impulse.ar(trigHz),
		dur: overlaps / trigHz,
		sndbuf: buf,
		rate: pch.midiratio,
		pos: startPos
	);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

// The effects are especially weird if grains generate at a relatively high density:

x = Synth(\granular, [buf: b, trigHz: 500]);

x.free;

// Returning to the previous version of this SynthDef: in the case of reducing the speed of the grain pointer, there is a sort of "echo" effect, particularly noticeable on hard consonants and plosives. The effect becomes more exaggerated as the speed of the grain pointer is further reduced:

(
SynthDef(\granular, {
	arg buf = 0, trigHz = 8, overlaps = 2, posRate = 1, pch = 0, amp = 0.3, out = 0;
	var sig, startPos;
	startPos = Phasor.ar(0, posRate * BufRateScale.ir(buf), 0, BufFrames.ir(buf));
	startPos = startPos / BufFrames.ir(buf);
	sig = GrainBuf.ar(
		numChannels: 2,
		trigger: Impulse.ar(trigHz),
		dur: overlaps / trigHz,
		sndbuf: buf,
		rate: pch.midiratio,
		pos: startPos
	);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth(\granular, [buf: b, posRate: 0.2]);

x.free;

// For audio files that contain human speech and other types of vocalizations, an ideal solution involves stretching only the vowel sounds, while leaving consonants alone. In practice, this is a non-trivial task that would require either sophisticated real-time analysis tools, or a massive amount of manual labor. A more practical solution is to temper this echo effect as much as possible, and embrace whatever artifacts remain.

// A sensible approach is to favor high-density generation of relatively long grains. However, with our SynthDef in its current state, this approach presents a new problem, encountered often in granular synthesis: a sense of resonance emerges at harmonics of the grain generation frequency. The exact content of the source file and other granular parameters may influence this resonance, but it remains present at low pointer speeds and grain generation frequencies within the audible spectrum:

x = Synth(\granular, [buf: b, posRate: 0.2, trigHz: 50, overlaps: 2]);

x.free;

// One of the simplest solutions for attenuating this resonance involves a non-periodic trigger for grain generation, e.g., substituting Dust for Impulse. In doing so, grains are generated arrhythmically, and the sense of resonance is diffused.

(
SynthDef(\granular, {
	arg buf = 0, trigHz = 8, overlaps = 2, posRate = 1, pch = 0, amp = 0.3, out = 0;
	var sig, startPos;
	startPos = Phasor.ar(0, posRate * BufRateScale.ir(buf), 0, BufFrames.ir(buf));
	startPos = startPos / BufFrames.ir(buf);
	sig = GrainBuf.ar(
		numChannels: 2,
		trigger: Dust.ar(trigHz),
		dur: overlaps / trigHz,
		sndbuf: buf,
		rate: pch.midiratio,
		pos: startPos
	);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

// In the following sound, the resonance is gone, but the sound is choppy.

x = Synth(\granular, [buf: b, posRate: 0.2, trigHz: 50, overlaps: 2]);

x.free;

// For a smoother, more consistent sound, we can decouple grain duration from grain density, since the randomness of Dust prevents us from being able to guarantee consistent grain overlap. In the following SynthDef, these two parameters are independent of each other:

(
SynthDef(\granular, {
	arg buf = 0, trigHz = 8, grainDur = 0.1, posRate = 1, pch = 0, amp = 0.3, out = 0;
	var sig, startPos;
	startPos = Phasor.ar(0, posRate * BufRateScale.ir(buf), 0, BufFrames.ir(buf));
	startPos = startPos / BufFrames.ir(buf);
	sig = GrainBuf.ar(
		numChannels: 2,
		trigger: Dust.ar(trigHz),
		dur: grainDur,
		sndbuf: buf,
		rate: pch.midiratio,
		pos: startPos
	);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

// A high grain density, with sufficiently large grains, should produce an acceptable time-stretching effect. In the following Synth, the average density is 300 grains per second, and the duration of each grain is 0.1 seconds. Thus, on average, there are about 30 overlapping grains at any given moment (300 * 0.1 = 30). With such a high degree of overlap comes an overall increase in level, so the amplitude has been reduced to compensate:

(
x = Synth(
	\granular,
	[
		buf: b,
		posRate: 0.2,
		trigHz: 300,
		grainDur: 0.1,
		amp: 0.1
	]
);
)

x.free;

// Adding a bit of randomness to the grain pointer position is a common technique that helps blur the sound and, arguably, embraces the spirit of time-streching effects. In the following SynthDef, we add a noise generator to the start position, allowing deviation of the frame index in either direction by a default value of 4000 frames. GrainBuf automatically wraps its buffer position between 0 and 1, so there is no need to deal with with out-of-range values.

(
SynthDef(\granular, {
	arg buf = 0, trigHz = 8, grainDur = 0.1, posRate = 1,
	frameDev = 4000, pch = 0, amp = 0.3, out = 0;
	var sig, startPos;
	startPos = Phasor.ar(0, posRate * BufRateScale.ir(buf), 0, BufFrames.ir(buf));
	startPos = startPos + LFDNoise0.kr(500).bipolar(frameDev);
	startPos = startPos / BufFrames.ir(buf);
	sig = GrainBuf.ar(
		numChannels: 2,
		trigger: Dust.ar(trigHz),
		dur: grainDur,
		sndbuf: buf,
		rate: pch.midiratio,
		pos: startPos
	);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

(
x = Synth(
	\granular,
	[
		buf: b,
		posRate: 0.2,
		trigHz: 300,
		grainDur: 0.1,
		amp: 0.1
	]
);
)

x.free;

// We can bypass pointer randomization by setting the deviation amount to zero:

(
x = Synth(
	\granular,
	[
		buf: b,
		posRate: 0.2,
		frameDev: 0, // <- bypass pointer randomness
		trigHz: 300,
		grainDur: 0.1,
		amp: 0.1
	]
);
)

x.free;

// On the other hand, extreme frameDev values (e.g. a total deviation equal to half the size of the buffer), will obliterate coherency and continuity from the sound, and is almost indistinguishable from selecting grains completely at random:

(
x = Synth(
	\granular,
	[
		buf: b,
		posRate: 0.2,
		frameDev: b.numFrames/4,
		trigHz: 300,
		grainDur: 0.1,
		amp: 0.1
	]
);
)

x.free;

// Last, we conclude with a more sophisticated and flexible granular SynthDef, based on core elements of the SynthDefs used though this file, capable of a wide range of pitch-shifting and time-stretching effects. Augmentations include randomization options for more parameters, the ability to dynamically switch between synchronous and asychronous grains (Impulse vs. Dust), and an ability to start granulation at any point in the audio file, not just the beginning. Comments are included in the SynthDef for further clarification.

(
SynthDef(\granular, {
	arg buf = 0, sync = 1, trigHz = 30, grainDur = 0.1, grainDurDev = 1,
	initPos = 0, posRate = 1, frameDev = 0, pch = 0, pchDev = 0,
	pan = 0, panDev = 0, interp = 2, grainEnv = -1,
	atk = 0.01, sus = 8, rel = 0.01, amp = 0.3, out = 0;

	var sig, env, startPos, grainDurRand, pchRand, panRand;

	// An envelope controls the overall amplitude of the sound. This envelope has a finite duration and cannot be sustained, but can easily be swapped with a sustaining alternative, such as Env.adsr().
	env = Env.new([0, 1, 1, 0], [atk, sus, rel], \lin).kr(2);

	// These three generators represent the random deviations in grain duration, grain pitch, and pan position. The frequency value (500) is mostly arbitrary, but values that are too low may not produce a sufficient amount of random "activity."
	grainDurRand = LFDNoise0.kr(500).exprange(1/grainDurDev, grainDurDev);
	pchRand = LFDNoise0.kr(500).bipolar(pchDev);
	panRand = LFDNoise0.kr(500).bipolar(panDev);

	startPos = Phasor.ar(0, posRate * BufRateScale.ir(buf), 0, BufFrames.ir(buf));

	// The grain pointer position is offset by an initial starting value, which allows granulation to begin on any frame, instead of being restricted to starting on the 0th frame.
	startPos = startPos + initPos;
	startPos = startPos + LFDNoise0.kr(500).bipolar(frameDev);
	startPos = startPos / BufFrames.ir(buf);

	sig = GrainBuf.ar(
		numChannels: 2,

		// Select is a UGen which outputs one UGen selected from an array, using its first input as an array index. When sync is 0, Select outputs Dust, and when sync is 1, it outputs Impulse. The index value of Select ('sync') can be dynamically modulated.
		trigger: Select.ar(
			sync,
			[
				Dust.ar(trigHz),
				Impulse.ar(trigHz)
			]
		),


		// The random deviation signals are applied here. Additional arguments have been added for specifying the source buffer, the interpolation type, and the grain envelope.
		dur: grainDur * grainDurRand,
		sndbuf: buf,
		rate: (pch + pchRand).midiratio,
		pos: startPos,
		interp: interp,
		pan: (pan + panRand).clip(-1, 1),
		envbufnum: grainEnv
	);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

// We conclude with several demonstration Synths:

// By specifying only the bufnum and an envelope duration equal to the length of the buffer, the source file is reconstructed with minimal artifacts:

(
Synth(
	\granular,
	[
		buf: b,
		atk: 0.01,
		sus: b.duration - 0.02,
		rel: 0.01
	]
);
)

// A pitch-shifting example:

(
Synth(
	\granular,
	[
		buf: b,
		pch: -8,
		atk: 0.01,
		sus: b.duration - 0.02,
		rel: 0.01
	]
);
)

// A time-stretching example. Note the asynchronous grain generation, and that the envelope duration is extended by the reciprocal of the grain pointer speed, so that its duration matches the stretched duration of the source buffer:

(
Synth(
	\granular,
	[
		buf: b,
		sync: 0, // <- asynchronous grains
		posRate: 0.25,
		grainDur: 0.5,
		amp: 0.1,
		atk: 0.01,
		sus: b.duration * 4 - 0.02, // <- sustain = 1/posRate
		rel: 0.01
	]
);
)

// An example in which the grain pointer is frozen one-third of the way though the file and grains are generated at a regular frequency, producing a distinct resonant tone. Envelope parameters have also been adjusted to create a longer fade-in and fade-out:

(
Synth(
	\granular,
	[
		buf: b,
		sync: 1,
		trigHz: 60, // <- perceived tone frequency (Hz)
		grainDur: 0.05,
		initPos: b.numFrames / 3,
		posRate: 0,
		amp: 0.3,
		atk: 3,
		sus: 3,
		rel: 3
	]
);
)

// By allowing the pointer to slowly advance through the buffer, the timbre of the tone will slowly morph:

(
Synth(
	\granular,
	[
		buf: b,
		sync: 1,
		trigHz: 60,
		grainDur: 0.05,
		initPos: b.numFrames / 3,
		posRate: 0.05, // <- moving at 1/20th normal speed
		amp: 0.3,
		atk: 3,
		sus: 5,
		rel: 3,
	]
);
)

// A more chaotic example, with significant amounts of random deviation on all parameters for which this is an option:

(
Synth(
	\granular,
	[
		buf: b,
		sync: 0,
		trigHz: 100,
		grainDur: 0.05,
		grainDurDev: 4,
		initPos: 0,
		posRate: 0.5,
		frameDev: b.numFrames / 10,
		pch: -2,
		pchDev: 7,
		pan: 0,
		panDev: 0.4,
		atk: 2,
		sus: 8,
		rel: 2,
		amp: 0.3,
		out: 0
	]
);
)