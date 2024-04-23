(
var lfo;

lfo = { |rate|
	Select.ar(ToggleFF.ar(Dust.ar(rate)), [
		LFNoise2.ar(rate),
		TRand.ar(-1, 1, Dust.ar(rate * 3)),
	]);
};

SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(
		60 * (1 + (3 * Env.perc(0.001, 0.1).ar))
		* (1 + (16 * Env.perc(0.0, 0.01).ar))
	);
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = snd.fold2;
	snd = snd * Env.perc(0, 0.9).ar;
	snd = snd * (1 - Env.perc(0.001, 0.01).ar);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd + GVerb.ar(snd.sum * -25.dbamp, 30, 1);
	snd = snd * Env.perc(0, 1.2).ar(Done.freeSelf);
	snd = snd * -6.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\snare, {
	var snd;
	snd = SinOsc.ar(
		260 * (1 + (3 * Env.perc(0.001, 0.01).ar))
		* (1 + (1 * Env.perc(0.0, 0.01).ar))
		* [1, 3.4, 7.8, 12.3]
	);
	snd = snd * [0, -9, -12, -14].dbamp;
	snd = snd * Env.perc(0, [1.0, 0.1, 0.05, 0.01]).ar;
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = snd.fold2;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2310, 0.3) * Env.perc(0.05, 0.1).ar * 5.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd + GVerb.ar(snd.sum * -25.dbamp, 30, 1);
	snd = snd + PitchShift.ar(snd, 0.02, 1.3);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.013, 1.9);
	snd = snd.blend(CombC.ar(snd, 0.2, 1 / 120, 0.3), \comb.kr(0));
	snd = (snd * 5.dbamp).tanh;
	snd = snd * Env.perc(0.0, 0.3).ar;
	snd = snd * Env.linen(0.001, 0.1, 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -9.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\snare2, {
	var snd;
	snd = SinOsc.ar(
		290 * (1 + (3 * Env.perc(0.001, 0.01).ar))
		* (1 + (1 * Env.perc(0.0, 0.01).ar))
		* [1, 1.4, 2.8, 6.3]
	);
	snd = snd * [0, -9, -12, -14].dbamp;
	snd = snd * Env.perc(0, [1.0, 0.1, 0.05, 0.01]).ar;
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = snd.fold2;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2310, 0.3) * Env.perc(0.05, 0.1).ar * 5.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd + GVerb.ar(snd.sum * -25.dbamp, 30, 1);
	snd = snd + PitchShift.ar(snd, 0.02, 1.3);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.013, 1.9);
	snd = snd.blend(CombC.ar(snd, 0.2, 1 / 90, 0.1), \comb.kr(0));
	snd = (snd * 5.dbamp).tanh;
	snd = snd * Env.perc(0.0, 0.3).ar;
	snd = snd * Env.linen(0.001, 0.5, 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -9.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\hat, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), [6230, 7330, 12310], 0.03) * 8.dbamp;
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(8000, 100, 0.03)) * Env.perc(0.001, 0.03).ar);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.linen(0.001, 0.04, 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -12.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\clap, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), 1350, 0.3) * 9.dbamp;
	snd = RLPF.ar(snd, XLine.kr(6000, 500, 1.0), 0.3);
	snd = snd ! 2;
	snd = snd * Env([0, 1, 0.5, 1, 0.5, 1, 0], [0.001, 0.02, 0.001, 0.01, 0.001, ExpRand(0.1, 1.0)], curve: -6).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass, {
	var snd, freq, duration;
	duration = \duration.kr(1);
	freq = \freq.kr(440);
	snd = LFSaw.ar(freq * [-0.1, 0, 0.1].midiratio, { Rand(0, 2) } ! 3);
	snd = Splay.ar(snd);
	snd = CombC.ar(snd, 0.3, (LFNoise2.kr(ExpRand(1, 10) ! 2) * 1).midiratio / 100, 0.3);
	snd = snd.fold2;
	snd = LPF.ar(snd, ExpRand(100, 3000));
	snd = MoogFF.ar(snd, LFNoise2.kr(ExpRand(1, 8)).linexp(-1, 1, 1000, 16000), 3) * 6.dbamp;
	snd = snd * Env.linen(0.05, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -6.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass2, {
	var snd, freq, duration;
	duration = \duration.kr(1);
	freq = \freq.kr(440);
	snd = Pulse.ar(freq * (TIRand.ar(1, 2, Dust.ar(8)))) ! 2;
	snd = LPF.ar(snd, ExpRand(100, 200)) + HPF.ar(snd, ExpRand(7e3, 16e3));
	snd = snd.tanh;
	snd = snd * Env.linen(0.05, duration, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\pad, {
	var snd, freq, duration;
	duration = \duration.kr(1);
	freq = \freq.kr(440);
	snd = Saw.ar(freq * [-0.1, 0, 0.1].midiratio * [1, 2, 1]);
	snd = RLPF.ar(snd, LFNoise2.kr(3).linexp(-1, 1, 100, 3000), 0.3);
	snd = (snd * 1.3).tanh;
	snd = snd * Env.linen(0.3, duration, 0.3, curve: -4).ar(Done.freeSelf);
	snd = snd * -25.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\pad2, {
	var snd, freq, duration;
	duration = \duration.kr(1);
	freq = \freq.kr(440) * XLine.kr(ExpRand(0.1, 10), 1, ExpRand(0.001, 0.5));
	snd = Pulse.ar(freq * (LFNoise2.kr(1 ! 8) * 0.3).midiratio, Rand(0.1, 0.9));
	snd = Splay.ar(snd);
	snd = RLPF.ar(snd, LFNoise2.kr(3).linexp(-1, 1, 100, 3000), 0.3);
	snd = (snd * Rand(0, 10).dbamp).tanh;
	snd = snd * Env.perc(0.01, 5.0, curve: -4).ar(Done.freeSelf);
	snd = snd * -25.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\metal, {
	var snd, ratio, duration, velocity;
	velocity = \velocity.kr(1);
	ratio = \ratio.kr(1);
	duration = \duration.kr(1);
	snd = SinOsc.ar(
		2060 * (1 + (3 * Env.perc(0.001, 0.01).ar))
		* [1, 3.4, 6.8, 3.3]
		* ratio;
	);
	snd = snd * Env.perc(0.001, [0.3, 0.1, 0.05, 0.03]).ar;
	snd = snd.sum;
	snd = snd * (1 + (SinOsc.ar(312) * Env.perc(0, 0.3).ar));
	snd = snd * 5.dbamp * velocity;
	snd = snd.tanh;
	snd = snd * (1 + Env.perc(0, 0.03).ar);
	snd = LPF.ar(snd, velocity.linexp(0, 1, 100, 8000));
	snd = snd + PitchShift.ar(snd, 0.03, Hasher.kr(ratio).linexp(0, 1, 0.5, 2));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.perc(0.0, 1.0, curve: -4).ar(Done.freeSelf);
	snd = snd * -19.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\crazyNoise, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = SinOsc.ar(lfo.(ExpRand(1, 60)).linexp(-1, 1, 100, 8000)) * lfo.(ExpRand(1, 60)).linlin(-1, 1, 0, 8120);
	snd = SinOsc.ar(lfo.(ExpRand(1, 60)).linexp(-1, 1, 100, 8000));
	snd = GVerb.ar(snd, ExpRand(3, 30), Rand(1, 8));
	snd = Latch.ar(snd, Impulse.ar(lfo.(ExpRand(1, 60)).linexp(-1, 1, 1000, 16e3)));
	snd = snd * SinOsc.ar(lfo.(ExpRand(1, 60)).linexp(-1, 1, 100, 8000));
	snd = snd.clip2;
	snd = snd * Env.linen(0.01, 1.0, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -30.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\crazyNoise2, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = SinOsc.ar(lfo.(ExpRand(1, 60)).linexp(-1, 1, 100, 8000)) * lfo.(ExpRand(1, 60)).linlin(-1, 1, 0, 8120);
	snd = SinOsc.ar(lfo.(ExpRand(1, 60)).linexp(-1, 1, 100, 8000));
	snd = GVerb.ar(snd, ExpRand(3, 30), Rand(1, 8));
	snd = CombC.ar(snd, 0.1, (lfo.(ExpRand(1, 10)) * 10).midiratio / 100, ExpRand(0.1, 1.0));
	snd = MoogFF.ar(snd, lfo.(ExpRand(1, 10)).linexp(-1, 1, 100, 1320), Rand(0, 3));
	snd = snd.clip2;
	snd = snd.tanh;
	snd = snd * Env.linen(0.01, 1.0, 0.1, curve: -4).ar(Done.freeSelf);
	snd = snd * -30.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\chip, {
	var snd, duration;
	duration = \duration.kr(1);
	snd = LFPulse.ar(\freq.kr(440)) - 0.5;
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.linen(0.0, duration, 0.0).ar(Done.freeSelf);
	snd = snd * -19.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\vocalBass, {
	var snd, freq, duration, rate;
	rate = ExpRand(1, 10);
	duration = \duration.kr(1);
	freq = \freq.kr(440);
	snd = SinOsc.ar(lfo.(rate).linexp(-1, 1, 1000, 3000) + ((LFPulse.ar(freq) - 0.5) * lfo.(rate).linlin(-1, 1, 100, 3000))) ! 2;
	snd = snd * Env.linen(0.0, duration, 0.0, curve: -4).ar(Done.freeSelf);
	snd = snd * -15.dbamp;
	snd = snd * \amp.kr(1);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\fx, {
	var snd, dry, fb;
	snd = In.ar(\out.kr(0), 2);

	20.do {
		snd = BPeakEQ.ar(snd, LFNoise2.kr(0.3).linexp(-1, 1, 100, 1000), 0.3, LFNoise2.kr(1));
	};

	snd = snd + PitchShift.ar(LPF.ar(snd, 3000) * -6.dbamp, 0.1, 2.0);
	snd = snd + PitchShift.ar(LPF.ar(snd, 3000) * -6.dbamp, 0.06, 0.5);

	dry = snd;
	snd = LPF.ar(snd, lfo.(1).lag(0.05).linexp(-1, 1, 1000, 16e3));
	snd = HPF.ar(snd, lfo.(1).lag(0.05).linexp(-1, 1, 60, 1200));
	snd = SelectX.ar((lfo.(1) > 0.2).lag(0.1), [snd, CombC.ar(snd, 0.2, lfo.(3).linexp(-1, 1, 1, 2) / 100, 1.0) * -7.dbamp]);
	snd = Sanitize.ar(snd);

	fb = LocalIn.ar(2);
	fb = fb + snd;
	fb = fb * ({ lfo.(10).lag(0.1) } ! 2).linlin(-1, 1, -20, -5).dbamp;
	fb = DelayC.ar(fb, 4.0, [1.0, 3.0]);
	fb = fb + PitchShift.ar(LPF.ar(fb, 3000) * -6.dbamp, 0.3, 2.0);
	fb = fb + PitchShift.ar(LPF.ar(fb, 3000) * -6.dbamp, 0.01, 0.5);
	fb = LPF.ar(fb, 3000);
	fb = HPF.ar(fb, 100);
	fb = fb.tanh;
	fb = Sanitize.ar(fb);
	LocalOut.ar(fb);
	snd = snd + fb;

	snd = DelayC.ar(snd, 3.0, TRand.ar(0, 3, Dust.ar(1 / lfo.(0.1).linexp(0, 1, 1, 10))));

	snd = SelectX.ar((lfo.(1) * 10).tanh.linlin(-1, 1, 0, 1).lag(0.01), [snd, dry * 5.dbamp]);
	snd = snd + GVerb.ar(snd.sum * -25.dbamp, 30);
	snd = LeakDC.ar(snd);
	snd = Limiter.ar(snd);
	ReplaceOut.ar(\out.kr(0), snd);
}).add;
)

(
var s, noteToFreq, root;
s = Server.default;

root = 1;

noteToFreq = { |note, octave = 0|
	var scale, freq;
	scale = [0, 2, 3, 5, 7, 8, 11];
	freq = (60 + root).midicps * scale.wrapAt(note).midiratio * (2 ** ((note / scale.size).floor + octave));
	1 / ((1 / freq) + 1e-6)
};

Routine({
	var play, playChord, speed;

	s.bind { Synth.tail(nil, \fx) };

	speed = 1.0;

	Routine({
		loop {
			speed = exprand(0.5, 1.6);
			10.wait;
		};
	}).play;

	play = { |synthDef, duration, args = #[]|
		var actualDuration;
		actualDuration = duration * speed;
		s.bind { Synth(synthDef, [duration: actualDuration] ++ args) };
		actualDuration.wait;
	};

	playChord = { |synthDef, duration, freqs, args = #[]|
		var actualDuration;
		actualDuration = duration * speed;
		s.bind {
			freqs.do { |freq|
				Synth(synthDef, [duration: actualDuration, freq: freq] ++ args)
			};
		};
		actualDuration.wait;
	};

	Routine({
		loop {
			var multiplier;
			rrand(3, 10).do {
				play.(\chip, exprand(0.01, 0.2), [freq: noteToFreq.([0, 1, 2, 3, 4, 5].choose, [2, 3].choose)]);
			};
			(rrand(1.0, 10.0) * speed).wait;
		};
	}).play;

	Routine({
		loop {
			var multiplier;
			multiplier = exprand(0.3, 5.0);
			play.(\crazyNoise, multiplier);
			(exprand(1.0, 20.0) * speed).wait;
		};
	}).play;

	Routine({
		loop {
			var multiplier;
			multiplier = exprand(0.3, 5.0);
			play.(\crazyNoise2, multiplier);
			(exprand(1.0, 20.0) * speed).wait;
		};
	}).play;

	Routine({
		loop {
			[2.0, 1.0, 0.5, 0.3, 0.2].do { |multiplier|
				var snareSynthDef;
				snareSynthDef = [\snare, \snare2].choose;
				multiplier = rrand(0.3, 1.0);
				if(0.5.coin) {
					rrand(0, 10).do {
						play.(\kick, 0.1 * multiplier);
					};
				};
				play.(\kick, 0.95 * multiplier);
				play.(snareSynthDef, 0.2 * multiplier, [comb: 1.0.rand]);
				[rrand(1, 5), rrand(20, 30)].do {
					var ratio;
					play.(\hat, 0.1 * multiplier);
					play.(snareSynthDef, 0.3 * multiplier, [amp: -6.dbamp, comb: 1.0.rand]);
					if(0.3.coin) {
						ratio = exprand(0.3, 1.5);
						rrand(5, 20).do {
							play.(\metal, rrand(0.06, 0.09), [ratio: ratio, velocity: rrand(0.5, 1.0)]);
						};
					};
				};
				play.(\clap, 0.3);
				(rrand(1.0, 2.0) * speed).wait;
			};
		};
	}).play;

	Routine({
		loop {
			[
				[0, 2, 4],
				[2, 3, 4, 7],
				[4, 7, 8],
				[4, 7, 8, 9],
				[0, 1, 2, 3, 4],
				[0, 4, 9]
			].do { |chord|
				playChord.(
					\pad,
					[
						rrand(0.3, 1.0),
						rrand(1.0, 4.0)
					].choose,
					noteToFreq.(chord, octave: rrand(0, 2))
				);
				(rrand(1, 20.0) * speed).wait;
			};
		};
	}).play;

	Routine({
		loop {
			[
				[0, 2, 4],
				[2, 3, 4, 7],
				[4, 7, 8],
			].do { |chord|
				playChord.(\pad2, rrand(0.3, 1.0), noteToFreq.(chord, octave: rrand(0, 2)));
				(exprand(0.1, 20.0) * speed).wait;
			};
		};
	}).play;

	Routine({
		loop {
			var sequence, multiplier;
			multiplier = rrand(0.3, 2.0);
			sequence = [
				[0, 4, 5],
				[-2, 2, 0],
				[0, -2, -3],
				[2, -2, 0],
				[0, 7, 0, -3],
				[2, 6, 7, 4],
			].choose;
			sequence.do { |note|
				play.([
					\bass, \bass2, \bass, \bass2, \bass, \bass2, \bass, \bass2, \vocalBass
				].choose, rrand(0.3, 1.0) * multiplier, [freq: noteToFreq.(note, -2)]);
			};
			(exprand(0.1, 3.0) * speed).wait;
		};
	}).play;
}).play;
)