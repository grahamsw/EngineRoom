/*

Today I am attempting to cover/soundalike a track:
Fallen Matter - Proxy Game 3.0

*/

(
/*
Standard sine sweep kick formula. A few notes:
- Note the Env.percs in the SinOsc.ar line. Normally I set the attacks to 0, but some have a nonzero attack so there's a bit of an upward sweep before the downward sweep. This adds some rubberiness.
- A trick I use a lot here: boost the transient and then soft clip it with tanh.
- snd * Env(...) line adds multiple transients.
- LPF/HPF/DelayC is a slapback delay, adds a little more space to it and is less obtrusive than a reverb.
*/
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(Env.perc(0, 0.33, curve: -7).ar.linexp(0, 1, 54, 700) * (1 + Env.perc(0.001, 0.01).ar) * (1 + (0.1 * Env.perc(0.02, 0.02).ar)) * XLine.ar(1, 0.7, 0.2));
	snd = snd * (1 + (4 * Env.perc(0, 0.01).ar));
	snd = snd + (SinOsc.ar(XLine.ar(800, 100, 0.005)) * Env.perc(0.01, 0.005).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3120, 0.2) * Env.perc(0, 0.01).ar * 10.dbamp);
	snd = snd * Env([1, 0.7, 1, 0.7, 1], [0.01, 0.03, 0.01, 0.1]).ar;
	snd = snd.tanh;
	snd = snd * Env.linen(0.001, 0.2, 0.3, curve: -4).ar;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -30.dbamp, 0.2, [60e-3, 74e-3]), 300), 1000);
	snd = snd * -3.dbamp;
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/* Just sine chirps, nothing crazy. */
SynthDef(\laser1, {
	var snd;
	snd = SinOsc.ar(XLine.ar(5000, 100, 0.05));
	snd = snd * Env.perc(0.02, 0.03).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\laser2, {
	var snd;
	snd = SinOsc.ar(XLine.ar(4000, 100, 0.01));
	snd = snd * Env.perc(0.001, 0.01).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\laser3, {
	var snd;
	snd = SinOsc.ar(XLine.ar(8000, 100, 0.03));
	snd = snd * Env.perc(0.001, 0.03).ar(Done.freeSelf);
	snd = Pan2.ar(snd, 0.67);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/*
Multiple sine chirps created using an LFSaw. LFSaw goes from -1 to 1, then I map it so it goes from 1 to 0, then I use pow to curve it towards 0, then remap it back to the frequencies I want. Bandpassed white noise adds some gesture.
*/
SynthDef(\lasers, {
	var snd;
	snd = SinOsc.ar(LFSaw.ar(XLine.kr(10, 60, 0.5)).linlin(-1, 1, 1, 0).pow(3).linlin(0, 1, 200, 8000)) * -5.dbamp;
	snd = snd + (BPF.ar(WhiteNoise.ar, XLine.kr(1320, 7320, 0.3), 0.5) * Env.perc(0, 0.5).ar);
	snd = snd.tanh;
	snd = RHPF.ar(snd, 320, 0.7);
	snd = snd * Env.linen(0.001, \duration.kr(1), 0.03, curve: -4).ar(Done.freeSelf);
	snd = Pan2.ar(snd, 0);
	snd = snd * -17.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/* Triangle wave with inharmonic detuning and alternate L/R panning. I had to lag the pan signal a bit to avoid clicks. */
SynthDef(\ring, {
	var snd;
	snd = LFTri.ar(4000);
	snd = FreqShift.ar(snd, -120);
	snd = HPF.ar(snd, 3000);
	snd = Pan2.ar(snd, LFPulse.ar(16).linlin(0, 1, -0.6, 0.6).lag(0.001));
	snd = snd * Env.linen(0.001, \duration.kr(1.0), 0.001).ar(Done.freeSelf);
	snd = snd * -37.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/* Throwing various effects at stereo white noise to try to make it interesting. */
SynthDef(\wash, {
	var snd;
	snd = Hasher.ar(Sweep.ar + [0, 1]);
	snd = CombC.ar(snd, 0.2, 1 / 60, 0.3);
	snd = FreqShift.ar(snd, 33.4);
	snd = HPF.ar(snd, 600);
	snd = LPF.ar(snd, 8000);
	snd = BRF.ar(snd, 1320, 0.1);
	snd = BRF.ar(snd, 6320, 0.1);
	snd = BRF.ar(snd, 3320, 0.1);
	snd = BPeakEQ.ar(snd, 620 * Latch.ar(XLine.ar(1, 3, 0.3), Impulse.ar(8)), 0.3, 6);
	snd = LPF.ar(snd, XLine.kr(1000, 8000, 0.01));
	snd = snd * -17.dbamp;
	snd = snd * Env.linen(0.03, 1.0, 0.01, curve: -4).ar(Done.freeSelf);
	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/* Bandpassed white noise. Bandpass cutoff is modulated. Many parameters randomized including pan. */
SynthDef(\scratch, {
	var snd;
	snd = WhiteNoise.ar;
	snd = BPF.ar(snd, ExpRand(2320, 8320) * XLine.kr(1, Rand(0.7, 1.3), ExpRand(0.01, 0.1)), ExpRand(0.1, 0.3));
	snd = Pan2.ar(snd, Rand(-0.9, 0.9));
	snd = snd * Env.perc(0.001, ExpRand(0.005, 0.07)).ar(Done.freeSelf);
	snd = snd * -12.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/*
Additive synthesis with different envelopes for every partial, so that in general the lower partials come in slower than the higher ones, making a sort of "shing" sound. To fatten up the partials I use alternating layers of distortion and frequency shifting. I just sort of came up with that idea on the spot and was kind of surprised at how well it worked.
*/
SynthDef(\sword, {
	var snd, ratios;
	ratios = [1.0, 2.3, 4.6, 9.3, 7.4];
	snd = SinOsc.ar(3220 * ratios);
	snd = snd / ratios;
	snd = snd * Env.perc([0.3, 0.02, 0.05, 0.1, 0.003], 0.05).ar;
	snd = snd.sum;
	snd = (snd * 10.dbamp).tanh;
	snd = FreqShift.ar(snd, -30);
	snd = (snd * 10.dbamp).tanh;
	snd = FreqShift.ar(snd, 64);
	snd = snd * -7.dbamp;
	snd = snd * Env.perc(0.005, 0.1).ar;
	snd = snd + GVerb.ar(snd * -7.dbamp, 30, 1);
	snd = snd * Env.perc(0.005, 2.0).ar(Done.freeSelf);
	snd = snd * -17.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\swordReverse, {
	var snd, ratios, duration;
	duration = \duration.kr(0.05);
	ratios = [1.0, 2.3, 4.6, 9.3, 7.4];
	snd = SinOsc.ar(4320 * ratios);
	snd = snd.sum;
	snd = (snd * 20.dbamp).tanh;
	snd = FreqShift.ar(snd, -30);
	snd = (snd * 10.dbamp).tanh;
	snd = FreqShift.ar(snd, 64);
	snd = snd * -25.dbamp;
	snd = snd + GVerb.ar(snd * -7.dbamp, 30, 1);
	snd = snd * Env.perc(duration, 0.01, curve: 4).ar(Done.freeSelf);
	snd = snd * -12.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/* 8-voice FM with random detuning. */
SynthDef(\pad, {
	var snd, ratios, duration, freq;
	duration = \duration.kr(3.0);
	freq = 160 * (LFNoise2.kr(6 ! 8) * 0.1).midiratio;
	snd = SinOsc.ar(freq * 1) * 2000;
	snd = SinOsc.ar(freq + snd);
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, 300);
	snd = snd * Env.linen(0.2, duration, 0.2, curve: -4).ar(Done.freeSelf);
	snd = snd * -30.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/* Sine wave, main interesting thing here is the envelope. A trigger-rate signal (.tr) is converted to an audio-rate signal, which causes a standard percussive envelope to activate. A percussive envelope goes from 0 to 1, so 1 - x makes it go from 1 to 0. It sounds best if the curve parameter is positive, otherwise it recovers too quickly. */
SynthDef(\sub, {
	var snd;
	snd = SinOsc.ar(60);
	snd = snd ! 2;
	snd = snd * (1 - Env.perc(0.001, 0.2, curve: 4).ar(gate: T2A.ar(\kick.tr(1))));
	snd = snd * Env.asr(0.01, 1, 0.01).ar(Done.freeSelf);
	snd = snd * -20.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/* Tremolo'd white noise with some EQ. */
SynthDef(\wash2, {
	var snd;
	snd = Hasher.ar(Sweep.ar + [0, 1]);
	snd = snd * SinOsc.ar(30).linlin(-1, 1, 0.5, 1);
	snd = LPF.ar(snd, XLine.kr(8000, 3000, 0.5));
	snd = (snd * 3).clip2;
	snd = snd * -27.dbamp;
	snd = snd * Env.linen(0.03, 1.0, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/*
Uh... let's see. White noise put into two bandpass filters that move outward to mimic formants in the human voice. A little comb filtering to add some nice resonances, then sine wave chirps to enhance the transient, then another bit of colored noise also to enhance the transient, then distortion and parallel pitch shifting and slapback delay. Simple!
*/
SynthDef(\snarey, {
	var snd, ratio;
	ratio = \bend.kr(0).midiratio;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, [820, 1320] * XLine.kr(1, [0.7, 1.3], 0.5) * ratio, 0.1) * 10.dbamp;
	snd = (snd * [0, -5].dbamp).sum;
	snd = snd + CombC.ar(snd, 0.1, 1 / (90 * ratio), 0.05);
	snd = snd + (SinOsc.ar(XLine.ar(3000, 100, 0.04) * ratio) * Env.perc(0.001, 0.04).ar * 3.dbamp);
	snd = snd + (SinOsc.ar(XLine.ar(8000, 100, 0.01) * ratio) * Env.perc(0.01, 0.01).ar * 3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1320 * ratio, 0.3) * Env.perc(0.01, 0.02).ar * 3.dbamp);
	snd = snd.tanh;
	snd = snd + PitchShift.ar(snd, 0.03, 1.2);
	snd = snd * Env.perc(0.001, 0.3, curve: -4).ar(Done.freeSelf);
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -30.dbamp, 0.2, [60e-3, 74e-3]), 300), 1000);
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -17.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/*
Similar to above but with many parameters randomized.
*/
SynthDef(\snarey2, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, ({ ExpRand(100, 8000) } ! 2) * XLine.kr(1, [0.7, 1.3], 0.3), 0.1) * 10.dbamp;
	snd = (snd * [0, -5].dbamp).sum;
	snd = snd + CombC.ar(snd, 0.1, 1 / ExpRand(30, 120), 0.05);
	snd = snd + (SinOsc.ar(XLine.ar(ExpRand(3000, 8000), 100, 0.04)) * Env.perc(0.001, 0.04).ar * 3.dbamp);
	snd = snd + (SinOsc.ar(XLine.ar(8000, 100, 0.01)) * Env.perc(0.01, 0.01).ar * 3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 1320, 0.3) * Env.perc(0.01, 0.02).ar * 3.dbamp);
	snd = snd.tanh;
	snd = snd + PitchShift.ar(snd, 0.03, 1.2);
	snd = snd * Env.linen(0.001, Rand(0.01, 0.07), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -30.dbamp, 0.2, [60e-3, 74e-3]), 300), 1000);
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -21.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/*
EQ'd white noise, bleh.
*/
SynthDef(\wash3, {
	var snd;
	snd = Hasher.ar(Sweep.ar + [0, 1]);
	snd = HPF.ar(snd, 3120);
	snd = snd * -20.dbamp;
	snd = snd * Env.linen(0.03, 1.0, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/*
Exponential FM with two sine wave operators. Some EQ, distortion, frequency shifting, and a fixed-filter bank (BPF) to put it in a room a bit.
*/
SynthDef(\squiggle, {
	var snd;
	snd = SinOsc.ar(SinOsc.ar(43).linexp(-1, 1, [100, 300], 16000)) * -8.dbamp;
	snd = snd.sum;
	snd = RHPF.ar(snd, 720, 0.9);
	snd = snd.tanh;
	snd = FreqShift.ar(snd, 73);
	snd = HPF.ar(snd, 120);
	snd = BPF.ar(snd, (0..16).normalize.linexp(0, 1, 100, 8000), 0.07).sum;
	snd = snd * Env.linen(0.001, \duration.kr(1), 0.03, curve: -4).ar(Done.freeSelf);
	snd = Pan2.ar(snd, 0);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/* Sine wave ping, random quivery frequency modulation and amplitude modulation too, and some reverb. */
SynthDef(\sonar, {
	var snd;
	snd = SinOsc.ar(740 * (LFNoise2.kr(100) * 0.06).midiratio) * -5.dbamp;
	snd = snd * LFNoise2.kr(16).linlin(-1, 1, 0.5, 1);
	snd = snd + GVerb.ar(snd, 60, 1);
	snd = snd * Env.perc(0.01, 1, curve: -4).ar(Done.freeSelf);
	snd = snd * -23.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

/* Standard clap formula. I've gotten to the point where I basically type this out from memory and it usually sounds like a clap on the first try. */
SynthDef(\clap, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 1430, 0.3) * 10.dbamp;
	snd = snd * Env([0, 1, 0.1, 1, 0.1, 1, 0], [0.001, 0.02, 0.001, 0.01, 0.001, 0.3], curve: -4).ar;
	snd = snd * Env.perc(0.01, 1, curve: -4).ar(Done.freeSelf);
	snd = snd ! 2;
	snd = snd * -17.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\fx, {
	var snd;
	snd = In.ar(\out.kr(0), 2);
	snd = snd + GVerb.ar(snd.sum * -50.dbamp, 30, 1);
	ReplaceOut.ar(\out.kr(0), snd);
}).add;
)

(
var s, bpm, beat, tatum;

bpm = 154;
beat = 60 / bpm;
tatum = beat / 4;

s = Server.default;

Routine({
	var wait, play, sub, duckSub, playKick;

	s.bind { Synth.tail(nil, \fx) };

	wait = { |durationInTatums| (tatum * durationInTatums).wait; };
	play = { |synthDef, durationInTatums, args = #[]|
		s.bind { Synth(synthDef, [duration: durationInTatums * tatum] ++ args); };
		(tatum * durationInTatums).wait;
	};

	s.bind {
		sub = Synth(\sub, [freq: 60]);
	};

	duckSub = {
		s.bind { sub.set(\kick, 1) };
	};

	playKick = { |durationInTatums|
		duckSub.();
		play.(\kick, durationInTatums);
	};

	inf.do {
		Routine({
			play.(\pad, 4 * 4 * 4);
		}).play;
		Routine({
			wait.(4);
			play.(\laser1, 1);
			play.(\laser2, 1);
			play.(\ring, 3);
		}).play;
		playKick.(3);
		playKick.(3);
		Routine({
			wait.(1);
			play.(\wash, 1);
			wait.(2);
			play.(\laser3, 1);
			play.(\wash, 1, [pan: -0.3]);
			play.(\wash, 4, [pan: 0.3]);
		}).play;
		playKick.(2);
		playKick.(4);
		wait.(4);

		Routine({
			16.do {
				play.(\scratch, 1);
			};
		}).play;
		Routine({
			wait.(4);
			play.(\lasers, 4);
			play.(\sword, 4);
			play.(\swordReverse, 4);
		}).play;
		playKick.(3);
		playKick.(3);
		playKick.(2);
		playKick.(4);
		wait.(4);

		Routine({
			16.do {
				play.(\scratch, 1);
			};
		}).play;
		Routine({
			play.(\wash2, 4);
			wait.(3);
			play.(\snarey, 1, [bend: 0]);
			wait.(1);
			play.(\snarey, 1, [bend: -3]);
		}).play;
		playKick.(3);
		playKick.(3);
		playKick.(2);
		playKick.(4);
		wait.(4);

		Routine({
			16.do {
				play.(\scratch, 1);
			};
		}).play;
		Routine({
			wait.(2);
			play.(\snarey2, 1, [bend: 0]);
			play.(\snarey2, 1, [bend: -3]);
			play.(\snarey2, 1, [bend: -1]);
			play.(\snarey2, 1, [bend: 3]);
			play.(\wash3, 2);
			play.(\squiggle, 4);
			play.(\clap, 1);
			play.(\sonar, 3);
		}).play;
		playKick.(3);
		playKick.(3);
		playKick.(2);
		playKick.(4);
		wait.(4);
	};
}).play;
)