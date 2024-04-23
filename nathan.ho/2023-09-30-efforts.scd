// my laptop hates me whenever I do both OBS and SC but let's gooooo

(
SynthDef(\perc, {
	var snd, freqs, ratio, velocity;
	velocity = \velocity.kr(1);
	ratio = \ratio.kr(1);
	freqs = [320, 400, 730, 1.32e6] * ratio;
	snd = SinOsc.ar(freqs * XLine.ar(2, 1, ExpRand(0.001, 0.004)));
	snd = snd * Env.perc(0.001, [0.1, 0.03, 0.04, 0.08] * 6 / ratio.squared).ar;
	snd = snd * ({ Rand(0, -7) } ! snd.size).dbamp;
	snd = snd.sum;
	snd = snd * -6.dbamp;
	snd = snd * (1 + (SinOsc.ar(Hasher.kr(ratio).linexp(-1, 1, 1000, 4000)) * Env.perc(0.001, 0.3).ar * velocity));
	snd = snd + (BPF.ar(WhiteNoise.ar, 1320 * ratio, 0.1) * Env.perc(0.003, 0.03).ar * 3.dbamp);
	snd = snd * Env([0, 1, 0.6, 0.9, Rand(0.1, 0.9), 1, 0], [0.001, 0.003 * Rand(1, 2), 0.001 * Rand(1, 2), 0.01 * Rand(0.3, 1), 0.001, 1], -4).ar;
	snd = snd * (1 + (Env.perc(0.001, 0.03).ar * 5));
	snd = snd * velocity.sqrt;
	snd = snd * Rand(1, 5);
	snd = snd.tanh;
	snd = snd + PitchShift.ar(snd, 0.07, Hasher.kr(ratio + 1.3).linexp(0, 1, 1, 2));
	snd = snd + PitchShift.ar(snd * -6.dbamp, 0.06, 0.7);
	snd = CombC.ar(snd, 0.2, (Hasher.kr(ratio + 1) * 10).midiratio / 100, 0.1);
	snd = CombC.ar(snd, 0.2, (Hasher.kr(ratio + 1) * 20).midiratio / 100, 0.03);
	snd = Pan2.ar(snd, \pan.kr(0)) + GVerb.ar(HPF.ar(snd, 200) * -14.dbamp, 3);
	snd = snd * Env.perc(velocity.linlin(0, 1, 0.01, 0.001), 1).ar(Done.freeSelf);
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\fx, {
	var snd;
	snd = In.ar(\out.kr(0), 2);
	snd = snd + GVerb.ar(LPF.ar(snd.sum, 2000) * -20.dbamp, 60, 1);
	snd = snd * -6.dbamp;
	snd = Limiter.ar(snd);
	ReplaceOut.ar(\out.kr(0), snd);
}).add;
)

(
var s, prime, row, n;
s = Server.default;

prime = [0, 2, 1, 3, 6, 7, 2, 4, 3, 5, 7, 6];
n = prime.maxItem + 1;

row = { |transpose, type = \prime|
	(
		switch(
			type,
			\prime, prime,
			\retrograde, prime.reverse,
			\inverse, prime.neg,
			\retrogradeInverse, prime.reverse.neg
		) + transpose
	) % prime.size;
};

Routine({
	s.bind { Synth.tail(nil, \fx) };
	3.do { |j|
		Routine({
			10.do {
				[
					row.(n.rand, [\prime, \retrograde, \inverse, \retrogradeInverse].choose).normalize.linexp(0, 1, 0.7, 3),
					row.(n.rand, [\prime, \retrograde, \inverse, \retrogradeInverse].choose).normalize,
					row.(n.rand, [\prime, \retrograde, \inverse, \retrogradeInverse].choose).normalize.linexp(0, 1, 1.0, 2.0),
					row.(n.rand, [\prime, \retrograde, \inverse, \retrogradeInverse].choose),
				].flop.do { |spec|
					var ratio, velocity, duration, subdivide;
					# ratio, velocity, duration, subdivide = spec;
					subdivide.do { |i|
						s.bind {
							Synth(\perc, [ratio: ratio, velocity: velocity * [0.7, 1].wrapAt(i) * rrand(0.7, 1.0), pan: [-0.7, 0, 0.7][j]])
						};
						(duration / subdivide).wait;
					};
				};
			};
		}).play;
	};
}).play;
)