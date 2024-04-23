(
/*
Sine with downward pitch sweep + boost the inital transient + white noise burst + distortion + percussive envelope + little bit of slapback delay.
*/
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(60 * (1 + (4 * Env.perc(0, 0.1).ar)) * (1 + (4 * Env.perc(0, 0.01).ar)));
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 9320, 0.3) * Env.perc(0.01, 0.02).ar);
	snd = snd.clip2 + (snd.fold2 * -7.dbamp);
	snd = snd * Env.perc(0.001, 0.4).ar;
	snd = snd + DelayC.ar(snd * -20.dbamp, 0.1, [0.03, 0.045]);
	snd = snd * Env.linen(0.0, 0.5, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -6.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/*
Copy-paste of the above kick with some more muted settings.
*/
SynthDef(\ghostKick, {
	var snd;
	snd = SinOsc.ar(60 * (1 + (2 * Env.perc(0, 0.1).ar)) * (1 + (2 * Env.perc(0, 0.01).ar)));
	snd = snd * (1 + (1 * Env.perc(0, 0.01).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 9320, 0.3) * Env.perc(0.01, 0.02).ar);
	snd = snd.clip2 + (snd.fold2 * -7.dbamp);
	snd = snd * Env.perc(0.001, 0.4).ar;
	snd = snd + DelayC.ar(snd * -20.dbamp, 0.1, [0.03, 0.045]);
	snd = snd * Env.linen(0.0, 0.5, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/*
Three sine waves at inharmonic ratios, different envelopes and amplitudes on each partial, sum together, add a chirp, various bandpassed noise bursts with envelopes. Note the line with "1 + SinOsc.ar(16)" -- that one has a kind of rectangular envelope with a bit of tremolo, and it's quieter than the others, it adds a kind of weird "rattle" that I like a lot. Boost the initial transient, put it through heavy distortion, add some reverb, slapback delay, a ton of parallel pitch shifters to make it really clank, boost the initial transient again, LPF so I can do a filter sweepy thing if I want to.
*/
SynthDef(\snare, {
	var snd, scale;
	scale = \scale.kr(1);
	snd = SinOsc.ar(270 * (1 + (0.5 * Env.perc(0, 0.01).ar)) * [1, 2.4, 4.8] * scale);
	snd = snd * Env.perc([0.01, 0.02, 0.03], [0.07, 0.05, 0.01]).ar;
	snd = snd * [0, -5, -10].dbamp;
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(3000, 100, 0.01)) * Env.perc(0.001, 0.03).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2720, 0.3) * Env.perc(0.03, 0.19).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7720, 0.3) * Env.linen(0.01, 0.3, 0.01).ar * (1 + SinOsc.ar(16)) * -23.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1720, 0.2) * Env.perc(0.03, 0.15).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 920, 0.3) * Env.perc(0.001, 0.11).delay(0.025).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 4720, 0.2) * Env.perc(0.03, 0.2).ar);
	snd = snd * (1 + (1 * Env.perc(0, 0.05).ar));
	snd = snd * 5.dbamp;
	snd = snd.clip2 + (snd.fold2 * -7.dbamp);
	snd = snd + GVerb.ar(snd * -15.dbamp, 30, 3, 0.9);
	snd = snd + DelayC.ar(snd * -20.dbamp, 0.1, [0.03, 0.045]);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.03, 2.8);
	snd = snd + PitchShift.ar(snd * -10.dbamp, 0.1, 1.6);
	snd = snd + PitchShift.ar(snd * -9.dbamp, 0.06, 2.3);
	snd = snd + PitchShift.ar(snd * -3.dbamp, 0.02, 1.4);
	snd = snd * (1 + (0.5 * Env.perc(0, 0.01).ar));
	snd = LPF.ar(snd, \filter.kr(16e3));
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;


/* This is just a modified version of the above snare, but was forked off from an earlier version of it. Softer distortion, envelope, fewer noise bursts.
*/
SynthDef(\ghostSnare, {
	var snd, scale;
	scale = \scale.kr(1);
	snd = SinOsc.ar(270 * (1 + (0.5 * Env.perc(0, 0.01).ar)) * [1, 2.4, 4.8] * scale);
	snd = snd * Env.perc([0.01, 0.02, 0.03], [0.07, 0.05, 0.01]).ar;
	snd = snd * [0, -5, -10].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2720, 0.3) * Env.perc(0.03, 0.15).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1720, 0.2) * Env.perc(0.03, 0.05).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 920, 0.3) * Env.perc(0.001, 0.01).delay(0.025).ar);
	snd = snd * (1 + (1 * Env.perc(0.03, 0.02).ar));
	snd = snd * 1.dbamp;
	snd = snd.clip2 + (snd.fold2 * -7.dbamp);
	snd = snd + GVerb.ar(snd * -17.dbamp, 30, 1, 0.9);
	snd = snd + PitchShift.ar(snd * -9.dbamp, 0.03, 2.8);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.02, 1.6);
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -13.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/* A bunch of trivial modifications to the original snare. */
SynthDef(\snare2, {
	var snd;
	snd = SinOsc.ar(370 * (1 + (1 * Env.perc(0, 0.01).ar)) * [1, 2.3, 7.8]);
	snd = snd * Env.perc([0.02, 0.01, 0.05], [0.07, 0.05, 0.01]).ar;
	snd = snd * [0, -5, -13].dbamp;
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(3000, 100, 0.01)) * Env.perc(0.001, 0.03).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 6720, 0.3) * Env.perc(0.003, 0.04).delay(0.005).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3720, 0.2) * Env.perc(0.001, 0.02).delay(0.01).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 4020, 0.3) * Env.perc(0.001, 0.01).delay(0.025).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1720, 0.2) * Env.perc(0.03, 0.2).ar);
	snd = snd * (1 + (1 * Env.perc(0, 0.05).ar));
	snd = snd * 15.dbamp;
	snd = snd.clip2 + (snd.fold2 * -7.dbamp);
	snd = snd + GVerb.ar(snd * -17.dbamp, 20, 1, 0.9);
	snd = snd * (1 + (2 * Env.perc(0, 0.01).ar));
	snd = LPF.ar(snd, \filter.kr(16e3));
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -7.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/* Again, trivial modifications to the original snare. */
SynthDef(\snare3, {
	var snd;
	snd = SinOsc.ar(290 * (1 + (0.5 * Env.perc(0, 0.01).ar)) * [1, 3.4, 6.8]);
	snd = snd * Env.perc([0.01, 0.02, 0.03], [0.07, 0.05, 0.01]).ar;
	snd = snd * [0, -5, -10].dbamp;
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(3000, 100, 0.01)) * Env.perc(0.001, 0.01).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2720, 0.3) * Env.perc(0.01, 0.029).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1720, 0.2) * Env.perc(0.01, 0.045).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 920, 0.3) * Env.perc(0.02, 0.31).delay(0.025).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 4720, 0.2) * Env.perc(0.01, 0.4).ar);
	snd = snd * (1 + (1 * Env.perc(0, 0.05).ar));
	snd = snd * 5.dbamp;
	snd = snd.clip2 + (snd.fold2 * -7.dbamp);
	snd = snd + GVerb.ar(snd * -15.dbamp, 50, 3, 0.9);
	snd = snd + DelayC.ar(snd * -20.dbamp, 0.1, [0.03, 0.045]);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.15, 1.8 * XLine.kr(1, 2, 0.1));
	snd = snd + PitchShift.ar(snd * -10.dbamp, 0.13, 1.1);
	snd = snd + PitchShift.ar(snd * -9.dbamp, 0.127, 1.3);
	snd = snd + PitchShift.ar(snd * -3.dbamp, 0.024, 1.4);
	snd = snd * (1 + (0.5 * Env.perc(0, 0.01).ar));
	snd = LPF.ar(snd, \filter.kr(16e3));
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;


/* Copy-paste of snare3 with minor changes to make it a ghost. */
SynthDef(\ghostSnare3, {
	var snd, scale;
	scale = \scale.kr(1);
	snd = SinOsc.ar(290 * (1 + (0.5 * Env.perc(0, 0.01).ar)) * [1, 3.4, 6.8] * scale);
	snd = snd * Env.perc([0.01, 0.02, 0.03], [0.07, 0.05, 0.01]).ar;
	snd = snd * [0, -5, -10].dbamp;
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(3000, 100, 0.01)) * Env.perc(0.001, 0.01).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2720, 0.3) * Env.perc(0.01, 0.029).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1720, 0.2) * Env.perc(0.01, 0.045).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 920, 0.3) * Env.perc(0.02, 0.31).delay(0.025).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 4720, 0.2) * Env.perc(0.01, 0.4).ar);
	snd = snd * (1 + (1 * Env.perc(0, 0.05).ar));
	snd = snd * 0.dbamp;
	snd = snd.clip2 + (snd.fold2 * -7.dbamp);
	snd = snd + GVerb.ar(snd * -15.dbamp, 50, 3, 0.9);
	snd = snd + DelayC.ar(snd * -20.dbamp, 0.1, [0.03, 0.045]);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.08, 1.8 * XLine.kr(1, 2, 0.1));
	snd = snd + PitchShift.ar(snd * -10.dbamp, 0.13, 1.1);
	snd = snd + PitchShift.ar(snd * -9.dbamp, 0.127, 1.3);
	snd = snd + PitchShift.ar(snd * -3.dbamp, 0.024, 1.4);
	snd = LPF.ar(snd, 3000);
	snd = snd * Line.ar(0, 1, 0.01);
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/* Three bandpassed noises across the stereo field, ratchety envelope, bit of reverb cut off by final enveleope. */
SynthDef(\clap, {
	var snd, scale;
	scale = \scale.kr(1);
	snd = BPF.ar(Hasher.ar(Sweep.ar + [0, 1, 2]), [1520, 1320, 1730] * 1.1 * scale, 0.3) * 25.dbamp;
	snd = Splay.ar(snd, 0.5);
	snd = snd * Env([0, 1, 0.2, 1, 0.2, 1, 0], [0.001, 0.01, 0.001, 0.01, 0.001, 0.15] / scale, -4).ar;
	snd = snd + GVerb.ar(snd.sum * -10.dbamp, 30, 1);
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/* This one was really hard to tweak and I'm not quite sure I like it. White noise into bank of 20 bandpass filters in the super-high range, different envelopes on each one, then some pitch shifter and reverb. */
SynthDef(\hat, {
	var snd, n, scale;
	n = (1..20).normalize.squared;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, n.linexp(0, 1, 5000, 16000), 0.005) * 5.dbamp;
	snd = snd * Env.perc(n.linexp(0, 1, 0.02, 0.01), n.linexp(0, 1, 0.07, 0.05)).ar;
	snd = snd.sum;
	snd = snd + PitchShift.ar(snd, 0.013, 0.5);
	snd = snd + GVerb.ar(snd * -5.dbamp, 3, 1, 0.9);
	snd = snd * Env.linen(0.0, \duration.kr(0.1), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -7.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/* Sine wave body which is then branched off into a "high" part which amplitude-modulates it with narrowband noise that adds some really nice EPROM "sizzle." High part is distorted, flanged to give it stereo, then high passed, and added back into a distorted version of the body. Huge hole between the lower and upper frequencies. Line.kr gives it a fade in, which emulates being sidechained to a kick. */
SynthDef(\bass1, {
	var snd, freq, hi;
	freq = \freq.kr(60);
	snd = SinOsc.ar(freq);
	snd = snd * Line.kr(0, 1, 0.1);
	hi = snd * 16;
	hi = hi * (1 + (BPF.ar({ WhiteNoise.ar * (1 + (0.5 * LFNoise2.kr(60))) } ! 2, 10230, 0.3) * -25.dbamp));
	hi = hi.tanh + (hi.fold2 * -20.dbamp);
	hi = hi + DelayC.ar(hi, 0.1, SinOsc.ar(0.5, [0, pi]).linlin(-1, 1, 0, 1) * 1e-3);
	hi = HPF.ar(hi, 2200);
	snd = (snd * 1.5).tanh + hi;
	snd = snd * Env.linen(0.0, \duration.kr(0.5) - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -4.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/* Square wave, cut all highs, fade in. To add sizzle back in I use "snd > x" to turn it into a 1-bit waveform. */
SynthDef(\bass2, {
	var snd, freq, hi;
	freq = \freq.kr(60);
	snd = Pulse.ar(freq);
	snd = LPF.ar(snd, 200);
	snd = snd * Line.kr(0, 1, 0.5);
	snd = snd * 5.dbamp;
	snd = snd.tanh + HPF.ar((snd > [0.1, 0.7]), 8000).fold2;
	snd = snd * Env.linen(0.0, \duration.kr(0.5) - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -4.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/* Nice vocal bass. Square wave source, twin-resonance filter with two parallel RLPFs with cutoffs moving outward. Fixed filter bank of BPFs to give it some roominess. Then cut the mids completely. */
SynthDef(\bass3, {
	var snd, freq, hi;
	freq = \freq.kr(60);
	snd = Pulse.ar(freq);
	snd = RLPF.ar(snd, XLine.kr([800, 1200], [500, 2000], \duration.kr(0.3)), 0.2).sum * 5.dbamp;
	snd = snd * Line.kr(0, 1, 0.5);
	snd = BPF.ar(snd, (0..20).normalize.squared.linexp(0, 1, 100, 16000), 0.2).sum;
	snd = snd.fold2;
	snd = LPF.ar(snd, 200) + HPF.ar(snd * -5.dbamp, 3000);
	snd = snd ! 2;
	snd = snd * Env.linen(0.0, \duration.kr(0.3) - 0.01, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/* 3 voices of 2-op FM with various randomized parameters to make them a little sloppy and ethereal. Notch filters to give it some room. High pass filter sweep. */
SynthDef(\wow, {
	var snd, freq, env;
	env = Env.perc(0.2 * ExpRand(1.0, 2.0), 0.5 * ExpRand(0.5, 2.0), curve: -4).ar(Done.freeSelf);
	freq = \freq.kr(60) * (LFNoise2.kr(8 ! 3) * 0.1).midiratio;
	snd = SinOsc.ar(freq * IRand(1 ! freq.size, 2)) * Rand(200, 3000) * (1 + env);
	snd = SinOsc.ar(freq + snd);
	snd = (snd * 1.2).fold2;
	snd = BRF.ar(snd, 1320, 0.1);
	snd = BRF.ar(snd, 3220, 0.1);
	snd = BRF.ar(snd, 7220, 0.1);
	snd = Splay.ar(snd);
	snd = HPF.ar(snd, XLine.ar(500, 3000, 1.0));
	snd = snd * env;
	snd = snd * -17.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/* The code here is a total mess, there are much better ways to do this. Bunch of triangle waves, different Env on each one, high pass filter sweep, bit of reverb. Reverb is cut off by envelope. */
SynthDef(\reverse1, {
	var snd, duration, n, freqs;
	duration = \duration.kr(1.0);
	freqs = 453 * 0.5 * (2 ** ([0, 13 - 2, 13 + 2, 13 + 3] / 13));
	freqs = (freqs * 2) ++ (freqs * 4) ++ (freqs * 8) ++ (freqs * 16);
	n = (1..freqs.size).normalize;
	snd = LFTri.ar(freqs);
	snd = snd * (Env.perc(duration - 0.01, 0.01, curve: n.linlin(0, 1, 3, 1)).ar);
	snd = snd.sum;
	snd = RHPF.ar(snd, (Line.kr(0, 1, duration) ** 3).linexp(0, 1, 16e3, 100), 0.5);
	snd = snd + GVerb.ar(snd * 5.dbamp, 10);
	snd = snd * Env.perc(duration - 0.01, 0.001, curve: 3).ar(Done.freeSelf);
	snd = snd * -40.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/* Not actually a reverb, just an ordinary delay and a bit of flanger. */
SynthDef(\reverbFx, {
	var snd, fb;
	snd = In.ar(\in.kr(0), 2);
	snd = snd + LocalIn.ar(2);
	fb = snd;
	fb = fb * -8.dbamp;
	fb = DelayC.ar(fb, 3.0, (\beat.kr(1.0) * 3 / 4) + (SinOsc.ar(0.3, [0, 0.5pi]) * 0.002));
	fb = HPF.ar(fb, 200);
	fb = LPF.ar(fb, 3000);
	LocalOut.ar(fb);
	snd = snd + DelayC.ar(snd, 0.1, SinOsc.ar(0.3, [0, pi]).linlin(-1, 1, 0, 1) * 4e-3);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\fx, {
	var snd;
	snd = In.ar(\out.kr(0), 2);
	snd = snd.clip2;
	ReplaceOut.ar(\out.kr(0), snd);
}).add;
)

(
var s, bpm, beat, tatum, noteToFreq;
s = Server.default;

bpm = 144;
beat = 60 / bpm;

noteToFreq = { |note, octave = 0|
	var scale;
	scale = [0, 2, 3, 5, 7, 8, 11];
	453 * (2 ** ((scale.wrapAt(note) / 13) + (note.div(scale.size)) + octave))
};

Routine({
	var reverbBus;
	var play, playParallel, playOneShot, wait;

	s.bind {
		reverbBus = Bus.audio(nil, 2);
		Synth.tail(nil, \reverbFx, [in: reverbBus, out: 0, beat: beat]);
		Synth.tail(nil, \fx);
	};

	wait = { |durationInBeats|
		var duration;
		duration = durationInBeats * beat;
		duration.wait;
	};

	playParallel = { |synthDef, durationInBeats, args = #[]|
		var duration;
		duration = durationInBeats * beat;
		s.bind { Synth(synthDef, [duration: duration] ++ args) };
	};

	play = { |synthDef, durationInBeats, args = #[]|
		var duration;
		duration = durationInBeats * beat;
		s.bind { Synth(synthDef, [duration: duration] ++ args) };
		duration.wait;
	};

	playOneShot = { |synthDef, args = #[]|
		s.bind { Synth(synthDef, args) };
	};

	loop {
		//////////////////////////////////////////////////////////////////////////////////
		// Phrase 1

		Routine({
			0.051.wait;
			[
				[0, 2, 8],
				[0, 6],
				[-1, 1, 7],
			].do { |chord|
				chord.do { |note|
					playOneShot.(\wow, [freq: noteToFreq.(note, 0), out: reverbBus]);
				};
				wait.(2);
			};
		}).play;

		playParallel.(\bass1, 2, [freq: noteToFreq.(0, -3)]);
		play.(\kick, 2);
		play.(\snare, 1 / 2);
		play.(\hat, 1 / 4);
		play.(\ghostSnare, 1 / 4);
		play.(\snare, 1);

		//////////////////////////////////////////////////////////////////////////////////

		playParallel.(\bass2, 2, [freq: noteToFreq.(-2, -3)]);
		play.(\kick, 2);
		playParallel.(\reverse1, 2);
		play.(\snare2, 2);

		//////////////////////////////////////////////////////////////////////////////////

		playParallel.(\bass3, 3 / 4, [freq: noteToFreq.(-3, -3)]);
		play.(\kick, 3 / 4);
		playParallel.(\bass3, 3 / 4, [freq: noteToFreq.(-3, -3)]);
		play.(\kick, 3 / 4);
		playParallel.(\bass3, 2 / 4, [freq: noteToFreq.(-3, -3)]);
		play.(\kick, 2 / 4);
		play.(\snare, 3 / 2);
		play.(\hat, 1 / 4);
		play.(\ghostSnare, 1 / 4);

		//////////////////////////////////////////////////////////////////////////////////

		playParallel.(\bass1, 3 / 4, [freq: noteToFreq.(-3, -3)]);
		play.(\kick, 3 / 4);
		playParallel.(\bass1, 3 / 4, [freq: noteToFreq.(-3, -3)]);
		play.(\kick, 3 / 4);
		playParallel.(\bass1, 2 / 4, [freq: noteToFreq.(-3, -3)]);
		play.(\kick, 2 / 4);
		play.(\snare, 1 / 2);
		play.(\hat, 1 / 4);
		play.(\ghostSnare, 1 / 4);
		play.(\clap, 1);

		//////////////////////////////////////////////////////////////////////////////////
		// Phrase 2

		Routine({
			[
				[0, 2, 9, 11],
				[0, 6],
				[-1, 1, 8],
			].do { |chord|
				chord.do { |note|
					playOneShot.(\wow, [freq: noteToFreq.(note, 0), out: reverbBus]);
				};
				wait.(2);
			};
		}).play;

		playParallel.(\bass3, 3, [freq: noteToFreq.(0, -3)]);
		play.(\kick, 3);
		play.(\snare3, 1 / 2);
		play.(\hat, 1 / 4);
		play.(\ghostSnare3, 1 / 4);

		//////////////////////////////////////////////////////////////////////////////////

		playParallel.(\bass2, 2, [freq: noteToFreq.(-2, -3)]);
		play.(\kick, 2);
		play.(\snare, 1 / 2, [scale: 1.1]);
		2.do {
			play.(\hat, 1 / 4);
			play.(\ghostSnare, 1 / 4, [scale: 1.1]);
		};
		play.(\snare, 1 / 2, [scale: 1.1]);

		//////////////////////////////////////////////////////////////////////////////////

		playParallel.(\bass1, 3 / 4, [freq: noteToFreq.(-3, -3)]);
		play.(\kick, 3 / 4);
		playParallel.(\bass1, 3 / 4, [freq: noteToFreq.(-3, -3)]);
		play.(\kick, 3 / 4);
		playParallel.(\bass1, 2 / 4, [freq: noteToFreq.(-3, -3)]);
		play.(\kick, 2 / 4);
		2.do {
			play.(\snare, 1 / 2);
			play.(\hat, 1 / 4);
			play.(\ghostSnare, 1 / 4);
		};

		//////////////////////////////////////////////////////////////////////////////////

		play.(\hat, 1 / 4);
		play.(\ghostSnare, 1 / 4);
		play.(\ghostKick, 1 / 4);
		play.(\ghostKick, 1 / 4);
		playParallel.(\bass3, 1, [freq: noteToFreq.(-3, -3)]);
		play.(\kick, 1);
		1.do {
			play.(\snare, 1 / 2);
			play.(\hat, 1 / 4);
			play.(\ghostSnare, 1 / 4);
		};
		4.do { |i|
			play.(\snare, 1 / 4, [filter: (i / 4).linexp(0, 1, 500, 8e3)]);
		};
	};
}).play;
)