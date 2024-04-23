(
SynthDef(\kick, {
	var snd, clickDuration, velocity;
	velocity = \velocity.kr(1);
	clickDuration = 2e-3;
	snd = SinOsc.ar(59 * [-1, 1].midiratio * (1 + (7 * Env.perc(0.001, 0.03).ar * velocity)) * (1 + (0.5 * Env.perc(0.001, 0.5).ar * velocity)));
	snd = Select.ar(Sweep.ar > clickDuration, [Hasher.ar(Sweep.ar), DelayC.ar(snd, clickDuration, clickDuration)]);
	snd = (snd * (1 + (3 * Env.perc(0, 0.1).ar * velocity))).tanh;
	snd = snd + (GVerb.ar(snd.sum, 12, 3, damping: 0.3) * -28.dbamp);
	snd = (snd * (1 + (0.3 * Env.perc(0, 0.1).ar))).tanh;
	snd = snd * Env.perc(0.0, 1 * velocity.sqrt).ar(Done.freeSelf);
	snd = snd * \amp.kr(1) * -7.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, [1320, 1120, 1200], 0.3) * 15.dbamp;
	snd = snd * Env([0, 8, 0.4, 0], [0.001, 0.01, 0.3], curve: -4).delay([0, 2, 1.3] * 17e-3).ar;
	snd = (snd * 3).clip2;
	snd = Splay.ar(snd, spread: 0.4);
	snd = snd + (GVerb.ar(snd.sum, 20, 5, damping: 0.3) * -12.dbamp);
	snd = snd * Env.perc(0.0, 1).ar(Done.freeSelf);
	snd = snd * \amp.kr(1) * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass, {
	var snd, freq, buzz, gate;
	gate = \gate.kr(1);
	freq = \freq.kr(40) * (1 + Env([0, 1, 1, 0], [0.3, 0.2, 1.2], [4, 0, -4]).ar);
	snd = SinOsc.ar(freq);
	buzz = snd;
	buzz = buzz + (BPF.ar({ WhiteNoise.ar } ! 2, 8210, 0.3) * -10.dbamp);
	buzz = (buzz + 0.3).sign - buzz;
	buzz = buzz + DelayC.ar(buzz, 0.2, SinOsc.ar(0.3, [0, pi]).linlin(-1, 1, 0, 1) * 1e-3);
	buzz = buzz * Env.asr(0, 1, 0.5).ar(Done.none, gate);
	buzz = (buzz * 1).wrap2;
	buzz = LeakDC.ar(buzz);
	buzz = HPF.ar(buzz, 800) * -16.dbamp;
	buzz = BPeakEQ.ar(buzz, 3120, 0.3, 3);
	snd = (snd * 5 * [1, -1]).tanh + buzz;
	snd = snd * Env.asr(0.13, 1, 1, curve: 4).ar(Done.freeSelf, Impulse.kr(0) + gate);
	snd = snd * \amp.kr(1) * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\metallic, {
	var snd, ratio, velocity;
	velocity = \velocity.kr(1);
	ratio = \transpose.kr(1).midiratio;
	snd = SinOsc.ar(720 * ratio * [1, 1.6, 2.3, 7.8]);
	snd = snd * Env.perc(0.003, [1, 0.3, 0.1, 0.03] * velocity).ar;
	snd = snd.sum * SinOsc.ar(1820 * ratio * [1, 1.4, 2.8, 3.8]).sum;
	snd = snd * (1 + (3 * Env.perc(0.0, 0.03).ar * velocity));
	snd = snd.tanh;
	snd = snd ! 2;
	snd = snd + PitchShift.ar(snd, 0.03, 1.3, pitchDispersion: 0.01);
	snd = snd + PitchShift.ar(snd, 0.07, 1.6, pitchDispersion: 0.01);
	snd = snd + PitchShift.ar(snd * -3.dbamp, 0.01, 0.6, pitchDispersion: 0.01);
	snd = snd * Env.perc(0.001, 0.4 * velocity.sqrt, curve: -2).ar(Done.freeSelf);
	snd = snd * velocity.linlin(0, 1, 0.8, 1);
	snd = snd * \amp.kr(1) * -13.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\woo, {
	var snd, duration;
	duration = \duration.kr(0.6);
	snd = Pulse.ar(1000 * Env([-6, 12, -24], [3, 4].normalizeSum * duration, [-2, 4]).ar.midiratio);
	[800, 1320, 3320].do { |freq|
		snd = BPeakEQ.ar(snd, freq, 0.1, 5);
	};
	snd = LPF.ar(snd, 8000);
	snd = snd * Env.asr(0.01, 1, 0.01).ar(Done.none, \gate.kr(1) + Impulse.kr(0));
	snd = snd + (GVerb.ar(snd, 3, 8, damping: 0.4) * -8.dbamp);
	snd = Latch.ar(snd, Impulse.ar(XLine.kr(3000, 16e3, 2)));
	snd = snd * Env.asr(0.01, 1, 2).ar(Done.freeSelf, \gate.kr(1) + Impulse.kr(0));
	snd = snd * \amp.kr(1) * -23.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass2, {
	var snd, freq, gate, period, gate2;
	gate = \gate.kr(1);
	period = \period.kr(0.3);
	gate2 = LFPulse.ar(1 / period);
	freq = \freq.kr(40) * (1 + Env([0, 1, 1, 0], [0.3, 0.2, 1.2], [4, 0, -4]).ar);
	snd = Pulse.ar(freq);
	snd = MoogFF.ar(snd, Env.adsr(0.001, 0.03, 0.1, 0.03).ar(Done.none, gate2).linexp(0, 1, 400, 16000), 2.3) * 8.dbamp;
	snd = snd * gate2.lagud(0.01, 0.04);
	snd = (snd * 1.3).fold2;
	snd = snd * Env.asr(0.13, 1, 0.1, curve: 4).ar(Done.freeSelf, Impulse.kr(0) + gate);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(1) * -9.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\random, {
	var snd, random, randomState;
	randomState = \seed.kr(0);
	random = {
		randomState = Hasher.kr(randomState);
		randomState;
	};
	snd = SinOsc.ar(random.().linexp(-1, 1, 100, 8000)) * 3000 * Env.perc(0.01, random.()).ar.linexp(-1, 1, 0.03, 0.3);
	snd = SinOsc.ar(random.().linexp(-1, 1, 100, 8000) + snd) * 8000 * Env.perc(0.01, random.()).ar.linexp(-1, 1, 0.03, 0.3);
	snd = SinOsc.ar(random.().linexp(-1, 1, 1200, 3000) + snd);
	snd = snd * Env.linen(0.001, \duration.kr(0.03), 0.01).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(1) * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\alarm, {
	var snd;
	snd = LFPulse.ar(Duty.ar(0.03, 0, Dseq([900, 1400]))) - (1 / 2);
	snd = FreqShift.ar(snd, 63);
	snd = snd * Env.perc(0.001, 0.2, curve: 0).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * (\velocity.kr(1) ** 3);
	snd = snd * \amp.kr(1) * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

(
var s, bpm, beat, root;
s = Server.default;
bpm = 130;
beat = 60 / bpm;

root = 61;

Routine({
	var play;

	play = { |synthDef, duration, args|
		var synth;
		s.bind { synth = Synth(synthDef, args ++ [duration: duration]) };
		duration.wait;
		s.bind { synth.set(\gate, 0) };
	};

	loop {
		2.do { |hyperBar|
			if(hyperBar == 0) {
				Routine({
					play.(\bass, beat * 7, [freq: (root + (12 * -3)).midicps]);
				}).play;
				Routine({
					(beat * 3).wait;
					7.do { |j|
						s.bind { Synth(\random, [seed: j % 3]) };
						(beat / 3).wait;
					};
				}).play;
			} {
				Routine({
					play.(\bass2, beat * 7, [freq: (root + (12 * -3)).midicps, period: beat / 3]);
				}).play;
			};
			2.do { |i|
				s.bind { Synth(\kick) };
				(beat * 2).wait;
				s.bind { Synth(\clap) };
				(beat * 2).wait;
				beat.wait;
				if(i == 0) {
					s.bind { Synth(\kick, [velocity: 0.5]) };
				} {
					Routine({
						3.do { |j|
							s.bind { Synth(\kick, [velocity: [0.9, 0.3, 0.4].wrapAt(j)]) };
							(beat / 3).wait;
						};
					}).play;
				};
				beat.wait;
				s.bind { Synth(\clap) };
				(beat * 1).wait;
				if(i == 0) {
					if(hyperBar == 0) {
						Routine({
							[
								0, 1, 2, 0, \, 0, \, 0, 0,
								1, \, 1, \, 1, 2, 0
							].do { |i, j|
								if(i != \) {
									s.bind { Synth(\metallic, [transpose: i, velocity: [1, 0.3, 0.5].wrapAt(j)]) };
								};
								(beat / 3).wait;
							};
						}).play;
					} {
						Routine({
							(beat * 2).wait;
							(6..0).normalize.do { |velocity|
								s.bind { Synth(\alarm, [velocity: velocity]) };
								(2 * beat / 3).wait;
							};
						}).play;
					};
				};
				if(i == 1) {
					Routine({
						play.(\woo, beat * 1);
					}).play;
				};
				beat.wait;
			};
		};
	};
}).play;
)