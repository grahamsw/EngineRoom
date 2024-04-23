(
var sieve;

sieve = { |n, period = 4, offset = 0|
	(((n + offset) * 2pi / period).cos.sign + 1) / 2
};

SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(40 * (Env.perc(0.0, 0.1 * [1, 0.3, 0.1] * 4, curve: -8).ar * [30, 40, 10]).midiratio * [1, 2.1, 3.5]);
	snd = snd * [1, Env.perc(0, 0.03).ar, Env.perc(0, 0.01).ar];
	snd = snd * [0, -10, -20].dbamp;
	snd = snd.sum;
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = snd + HPF.ar(GVerb.ar(snd * -30.dbamp, 10), 300);
	snd = snd * Env([0, 2, 0.5, 0], [0.001, 0.03, 0.2], -4).ar(Done.freeSelf);
	snd = (snd * 1.3).clip2 + ((snd * 3.dbamp).fold2 * -7.dbamp);
	snd = snd * -15.dbamp;
	OffsetOut.ar(\out.kr(0), snd);
}).add;

SynthDef(\sieve, {
	var snd, n, duration;
	duration = \duration.kr(1);
	n = (1..90);
	snd = SinOsc.ar(20 * n * (1 + (n.sqrt * 0.4)));
	snd = snd * sieve.(n, \period1.kr(4), \offset1.kr(1));
	snd = snd * (1 - sieve.(n, \period2.kr(4), \offset2.kr(1)));
	snd = snd * (n ** -0.8);
	snd = snd * Env.perc(duration - 0.05, 0.01, curve: (1 + (1 - n.normalize)) * 5).ar(Done.freeSelf);
	snd = snd.sum;
	snd = snd * -15.dbamp;
	snd = snd ! 2;
	OffsetOut.ar(\out.kr(0), snd);
}).add;
)


(
var s;
s = Server.default;

Routine({
	loop {
		[1, 2, 3, 4].do { |disturb|
			[1, 2].do { |offset2|
				[3, 4].do { |offset1|
					[3, 7].do { |period1|
						[5, 9].do { |period2|
							s.bind { Synth(\kick) };
							s.bind { Synth(\sieve, [duration: 0.45, period1: period1, period2: period2 + disturb, offset1: offset1, offset2: offset2]) };
							0.45.wait;
						};
					};
				};
			};
		};
	};
}).play;
)