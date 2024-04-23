(
SynthDef(\kick, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(
		40
		* ([-1, 0, 1] * 0.3).midiratio
		* (1 + (Env.perc(0, 0.003).ar * 8 * velocity))
		* (1 + (Env.perc(0, 0.06).ar * 3))
		* (1 + (Env.perc(0, 0.3).ar * 1))
	);
	snd = snd * (1 + (10 * Env.perc(0.001, 0.1).ar));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7230, 0.3) * Env.perc(0.01, 0.03).ar * 8.dbamp);
	snd = (snd * 4.dbamp).clip2;
	snd = Splay.ar(snd, 0.3);
	snd = snd * velocity.sqrt;
	snd = snd * Env.perc(0.001, 1.0).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\hat, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 1000 * [3.1, 6.4, 4.5, 6.7, 7.8, 9.3, 10.3], 0.05) * 15.dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0.0, 0.3).ar;
	snd = (snd * 3).clip2;
	snd = RHPF.ar(snd, 9320, 0.2) * 6.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.perc(0.001, 0.05).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 1200 * [0.9, 1, 1.3], 0.2) * 30.dbamp;
	snd = snd * Env.perc(0.001, 0.2).delay([0, 4, 2] * 1e-2).ar;
	snd = Splay.ar(snd, 0.4);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 12345), 10320, 0.3) * Env.perc(0.03, 0.1).ar * 20.dbamp);
	snd = snd * Env.perc(0.0, 0.6, curve: -7).ar(Done.freeSelf);
	snd = snd.clip2;
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\clap2, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 1300 * [0.9, 1, 1.3], 0.3) * 30.dbamp;
	snd = snd * Env.perc(0.001, 0.2).delay([0, 4, 2] * 1.3e-2).ar;
	snd = Splay.ar(snd, 0.4);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + 12345), 10320, 0.3) * Env.perc(0.03, 0.1).ar * 20.dbamp);
	snd = snd * Env([0, 1, 0.1, 0], [0.0, 1, 0.3, 0.6], curve: -7).ar(Done.freeSelf);
	snd = snd.clip2;
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass1, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = Pulse.ar(\freq.kr(60), [0.46, 0.51]);
	snd = MoogFF.ar(snd, XLine.kr(16000, 100, duration), 0);
	snd = (snd * 3.dbamp).tanh;
	snd = snd * Env.linen(0.1, duration, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\key, {
	var snd, freq, duration;
	duration = \duration.kr(1);
	freq = \freq.kr(440);
	snd = Saw.ar(freq * (LFNoise2.kr(3 ! 8) * 0.3).midiratio);
	snd = Splay.ar(snd);
	snd = Latch.ar(snd, Impulse.ar(XLine.kr(16000, 1000, duration)));
	snd = snd * Env.perc(0.001, duration, curve: -8).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass1, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = Pulse.ar(\freq.kr(60), [0.46, 0.51]);
	snd = MoogFF.ar(snd, XLine.kr(16000, 100, duration), 0);
	snd = (snd * 3.dbamp).tanh;
	snd = snd * Env.linen(0.01, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass2, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = Pulse.ar(\freq.kr(60), [0.46, 0.51]);
	snd = MoogFF.ar(snd, XLine.kr(ExpRand(100, 3000), ExpRand(300, 8000), duration), 2) * 5.dbamp;
	snd = (snd * 10.dbamp).tanh;
	snd = snd * Env.linen(0.05, duration - 0.05, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass3, {
	var snd, duration, freq;
	duration = \duration.kr(1);
	freq = \freq.kr(60);
	snd = SinOsc.ar(freq * [-0.1, 0.1].midiratio);
	snd = snd * SinOsc.ar(2) * Line.kr(1, 0, duration);
	snd = ((snd * 3) + 0.2).fold2 + ((snd.sign - snd) * -10.dbamp);
	snd = HPF.ar(snd, 500);
	snd = snd.tanh;
	snd = snd + (SinOsc.ar(freq) * -3.dbamp);
	snd = BLowShelf.ar(snd, 100, 1, 5);
	snd = Limiter.ar(snd, 1, 0.001);
	snd = snd * Env.linen(0.1, duration - 0.1, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\snare, {
	var snd, velocity;
	velocity = \velocity.kr(1);
	snd = SinOsc.ar(
		260
		* [1, 2.3, 7.5, 9.8]
		* (1 + (2 * Env.perc(0, 0.03).ar))
	);
	snd = snd * Env.perc(0, [1, 0.2, 0.1, 0.03]).ar * [0, -5, -8, -10].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2130, 0.3) * Env.perc(0.03, 0.1).ar * 8.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7130, 0.8) * Env.perc(0.08, 0.2).ar * -1.dbamp);
	snd = (snd * (1 + Env.perc(0, 0.1).ar)).clip2;
	snd = snd + Splay.ar(PitchShift.ar(snd, 0.03, [1.5, 1.8]), 0.6);
	snd = snd * velocity;
	snd = snd * Env.perc(0.001 / (1 + velocity), 0.2).ar(Done.freeSelf);
	snd = snd * -1.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass4, {
	var snd, duration, freq;
	duration = \duration.kr(1);
	freq = \freq.kr(60);
	snd = Saw.ar(freq * [1, 2]).sum;
	snd = RLPF.ar(snd, XLine.kr([1200, 800], [1400, 3200], duration), 0.1);
	snd = snd.sum;
	snd = snd.tanh;
	snd = snd ! 2;
	snd = snd * Env.linen(0.001, duration - 0.05, 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass5, {
	var snd, duration, freq;
	duration = \duration.kr(1);
	freq = \freq.kr(60);
	snd = Saw.ar(freq * [1, 2]).sum;
	snd = RLPF.ar(snd, XLine.kr([2200, 600], [4200, 600], duration), 0.1);
	snd = snd.sum;
	snd = snd.tanh;
	snd = snd ! 2;
	snd = snd * Env.linen(0.001, duration - 0.05, 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\wub, {
	var snd, freq, duration;
	duration = \duration.kr(1);
	freq = \freq.kr(440);
	snd = Saw.ar(freq * (LFNoise2.kr(3 ! 8) * 0.5).midiratio);
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, 1000);
	snd = snd * Env.linen(0.03, duration, 0.03, curve: -8).ar(Done.freeSelf);
	snd = snd * -6.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\lead, {
	var snd, freq, duration;
	freq = \freq.kr(440).cpsmidi.lag(0.05).midicps;
	snd = Saw.ar(freq * [-0.1, -12, 0.1].midiratio * (SinOsc.ar(3, [0, 0.5pi, 1pi]) * 0.3).midiratio);
	snd = Splay.ar(snd);
	snd = BPeakEQ.ar(snd, 3120, 0.1, 3.3);
	snd = BPeakEQ.ar(snd, 6120, 0.1, 5.3);
	snd = BPeakEQ.ar(snd, 4120, 0.1, 7.3);
	snd = BPeakEQ.ar(snd, 1120, 0.1, 8.3);
	snd = (snd * 5).tanh;
	snd = CombC.ar(snd, 0.2, 1 / [60, 63], 1);
	snd = LPF.ar(snd, 3000) + HPF.ar(snd, 8e3);
	snd = snd * Env.asr(0.1, 1, 3, curve: -8).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * -25.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\vocal, {
	var snd, freq, duration;
	duration = \duration.kr(1);
	freq = \freq.kr(440) * (LFNoise2.kr(3) * 0.1).midiratio;
	snd = SinOsc.ar(freq * [8, 11, 13]) * 4000 * (1 + Env.perc(0, 1).ar);
	snd = SinOsc.ar(freq + snd).sum * -8.dbamp;
	snd = snd + GVerb.ar(snd * -10.dbamp);
	snd = snd * Env.perc(0.001, duration, curve: -8).ar(Done.freeSelf);
	snd = snd * -15.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\fx, {
	var snd;
	snd = In.ar(\out.kr(0), 2);

	snd = SelectX.ar(\filter.ar(0).lag(0.01), [snd, BPF.ar(snd, LFNoise2.kr(3).linexp(-1, 1, 300, 4200), 0.3) * 15.dbamp]);
	snd = SelectX.ar(\filter2.ar(0).lag(0.01), [snd, MoogFF.ar(snd, LFNoise2.kr(0.5).linexp(-1, 1, 300, 2200), 3) * 10.dbamp]);
	snd = SelectX.ar(\comb.ar(0).lag(0.01), [snd, CombC.ar(snd, 0.2, 1 / LFNoise0.kr(1).linexp(-1, 1, 30, 100), 0.1)]);
	snd = SelectX.ar(\pitch.ar(0).lag(0.01), [snd, snd + PitchShift.ar(snd, 0.1, 2.0)]);
	snd = SelectX.ar(\pitch2.ar(0).lag(0.01), [snd, snd + PitchShift.ar(snd, 0.13, 2.0)]);
	snd = SelectX.ar(\crush.ar(0).lag(0.01), [snd, Latch.ar(snd, Impulse.ar(8000 * (LFNoise2.kr(3) * 12).midiratio))]);
	snd = SelectX.ar(\gate.ar(0).lag(0.01), [snd, snd * Env.perc(0.001, 0.2).ar(Done.none, \trigger.tr(1))]);

	snd = snd + GVerb.ar(HPF.ar(snd.sum, 800) * -25.dbamp, 50, 1, damping: 0.9);
	snd = snd * 10.dbamp;
	snd = LeakDC.ar(snd);
	snd = BLowShelf.ar(snd, 300, 1, 3);
	snd = Limiter.ar(snd);
	snd = snd * -1.dbamp;
	ReplaceOut.ar(\out.kr(0), snd);
}).add;

SynthDef(\pad, {
	var snd, freq, duration;
	duration = \duration.kr(1);
	freq = \freq.kr(440);
	snd = Saw.ar(freq * (LFNoise2.kr(3 ! 8) * 0.5).midiratio * [1, 2, 4, 2, 2, 4, 2, 1]);
	snd = BPF.ar(snd, LFNoise2.kr(3).linexp(-1, 1, 500, 1200), 0.3);
	snd = Splay.ar(snd);
	snd = snd * LFNoise2.kr(1).linlin(-1, 1, -5, 0).dbamp;
	snd = snd * Env.linen(1, duration, 1, curve: -8).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)
Synth(\vocal);

Synth(\snare);

Synth(\kick);
Synth(\hat);
Synth(\clap);
Synth(\bass1);

(
var s, bpm, beat, root, degreeToFreq;
s = Server.default;

bpm = 140;
beat = 60 / bpm;

root = 61;

degreeToFreq = { |note, octave = 0|
	var scale;
	scale = [0, 2, 3, 5, 7, 8, 10];
	(root + scale.wrapAt(note) + (12 * ((note / scale.size).floor + octave))).midicps;
};

Routine({
	var play, playOneShot, fx;
	s.bind { fx = Synth.tail(nil, \fx) };

	Routine({
		loop {
			var repeats;
			repeats = [2, 2, 4, 4, 8, 16].choose;
			2.do {
				repeats.do {
					s.bind {
						fx.set(
							\trigger, 1
						);
					};
					(beat / repeats).wait;
				};
			};
		};
	}).play;

	Routine({
		loop {
			var probability;
			probability = [0, 0, 0.1, 0.2].choose;
			2.do {
				s.bind {
					fx.set(
						\crush, probability.coin,
						\comb, probability.coin,
						\filter, probability.coin,
						\filter2, probability.coin,
						\pitch, probability.coin,
						\pitch2, probability.coin,
						\gate, probability.coin,
					);
				};
				(beat * 2).wait;
			};
		};
	}).play;

	Routine({
		loop {
			[
				[0, 1, 2, 4],
				[-2, 0, 3, 6],
				[1, 2, 4, 7],
				[-1, 2, 4, 8],
			].do { |chord|
				if(0.3.coin) {
					chord.do { |note|
						playOneShot.(\pad, beat * 4, [freq: degreeToFreq.(note, 0)]);
					};
				};
				(beat * 8).wait;
			};
		};
	}).play;

	playOneShot = { |synthDef, duration, args = #[]|
		s.bind { Synth(synthDef, [duration: duration] ++ args) };
	};
	play = { |synthDef, duration, args = #[]|
		s.bind { Synth(synthDef, [duration: duration] ++ args) };
		duration.wait;
	};

	loop {
		play.(\kick, 0);
		play.(\bass1, beat, [freq: degreeToFreq.(0, -2)]);
		play.(\kick, 0, [velocity: 0.7]);
		play.(\bass1, beat, [freq: degreeToFreq.(0, -2)]);
		play.(\clap, 0);
		8.do {
			play.(\hat, beat / 8);
		};
		2.do {
			play.(\hat, beat / 2);
		};
		[2, 0, -2, -3].do { |note|
			playOneShot.(\key, 3.0, [freq: degreeToFreq.(note, 2)]);
			(beat / 4).wait;
		};

		play.(\kick, 0);
		play.(\bass1, beat / 2, [freq: degreeToFreq.(0, -2), velocity: 0.7]);
		play.(\kick, 0);
		play.(\bass2, beat / 2, [freq: degreeToFreq.(-2, -1), velocity: 0.7]);
		(beat / 2).wait;

		play.(\kick, 0);
		play.(\bass2, beat / 2, [freq: degreeToFreq.(0, -2)]);
		2.do {
			play.(\kick, 0, [velocity: 0.7]);
			play.(\bass2, beat / 2, [freq: degreeToFreq.(-3, -2)]);
		};

		play.(\kick, 0);
		play.(\bass3, beat * 2, [freq: degreeToFreq.(-2, -2)]);
		playOneShot.(\clap, 0);
		7.do {
			play.(\hat, beat / 7);
		};
		2.do {
			play.(\hat, beat / 2);
		};
		Routine({
			var velocity;
			velocity = 1;
			8.do {
				play.(\snare, beat * (3 / 4), [velocity: velocity]);
				velocity = velocity * 0.6;
			};
		}).play;
		beat.wait;

		(beat / 2).wait;

		play.(\kick, 0);
		play.(\bass4, beat / 2, [freq: degreeToFreq.(-4, -2)]);
		play.(\kick, 0);
		play.(\bass4, beat / 4, [freq: degreeToFreq.(-3, -2)]);
		(beat / 4).wait;
		play.(\kick, 0, [velocity: 0.3]);
		play.(\bass5, beat / 2, [freq: degreeToFreq.(-3, -2)]);
		play.(\kick, 0);
		play.(\bass4, beat / 4, [freq: degreeToFreq.(-3, -2)]);
		(beat / 4).wait;
		play.(\kick, 0, [velocity: 0.3]);
		play.(\bass5, beat / 2, [freq: degreeToFreq.(-3, -2)]);

		play.(\kick, 0);
		play.(\bass2, beat / 2, [freq: degreeToFreq.(2, -3)]);
		(beat / 2).wait;
		play.(\kick, 0, [velocity: 0.7]);
		play.(\bass1, beat / 2, [freq: degreeToFreq.(2, -2)]);
		play.(\kick, 0);
		play.(\bass5, beat / 2, [freq: degreeToFreq.(0, -2)]);
		play.(\clap2, 0);
		[2, 3, 4, 8].do { |note|
			playOneShot.(\wub, beat * 3, [freq: degreeToFreq.(note, 1)]);
		};
		beat.wait;
		play.(\kick, beat / 8, [velocity: 1]);
		play.(\kick, beat / 8, [velocity: 1]);
		play.(\kick, beat / 4, [velocity: 0.5]);
		play.(\kick, beat / 2, [velocity: 0.5]);
		playOneShot.(\kick, beat);
		9.do {
			play.(\hat, beat / 9);
		};
		play.(\hat, beat / 2);
		Routine({
			var synth;
			s.bind { synth = Synth(\lead, [freq: degreeToFreq.(2, 1)]) };
			(beat / 2).wait;
			[2, 1, 0, -1].do { |note|
				s.bind { synth.set(\freq, degreeToFreq.(note, 2)); };
				(beat / 2).wait;
			};
			s.bind { synth.set(\freq, degreeToFreq.(-3, 2)); };
			beat.wait;
			s.bind { synth.set(\gate, 0) };
		}).play;
		(beat / 2).wait;
		play.(\snare, beat);
		play.(\clap, beat);

		play.(\kick, 0);
		play.(\bass1, beat, [freq: degreeToFreq.(-2, -2)]);
		play.(\kick, 0);
		play.(\bass1, beat / 2, [freq: degreeToFreq.(-2, -1)]);
		play.(\kick, 0);
		playOneShot.(\bass1, beat, [freq: degreeToFreq.(-3, -1)]);
		(beat / 2).wait;

		Routine({
			[0, 2, 3, 4, 6, 4, 7, 4, 5, 4, 3, 2].do { |note|
				playOneShot.(\vocal, beat * 4, [freq: degreeToFreq.(note, 2)]);
				(beat / 2).wait;
			};
		}).play;

		beat.wait;
		play.(\clap, beat / 2);
		play.(\clap2, beat);
		play.(\snare, beat / 2);
		8.do {
			play.(\kick, beat / 8, [velocity: 0.3]);
		};
		play.(\kick, 0);
		play.(\bass3, beat * 2, [freq: degreeToFreq.(-3, -2)]);
	};
}).play;
)