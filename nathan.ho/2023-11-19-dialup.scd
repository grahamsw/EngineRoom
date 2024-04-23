/*

most of my videos are pretty off the cuff but this one is thoroughly researched and recreating a patch that I already made before.

*/

(
SynthDef(\sine, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(\freq.kr(440));
	snd = snd * Env.linen(0.001, duration, 0.001).ar(Done.freeSelf);
	snd = snd * -15.dbamp;
	snd = snd * \amp.kr(1.0);
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\fsk, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(
		(Hasher.ar(Stepper.ar(Impulse.ar(300), 0, 0, \periodInBits.kr(1e8)) + \seed.kr(0)) * 2).floor.linlin(0, 1, \freq1.kr(440), \freq2.kr(440))
	);
	snd = snd * Env.linen(0.001, duration, 0.001).ar(Done.freeSelf);
	snd = snd * -20.dbamp;
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\ansam, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(2100 * ((ToggleFF.ar(Impulse.ar(1 / 0.450)) * 2) - 1));
	snd = snd * SinOsc.ar(15).linlin(-1, 1, 0.8, 1.2);
	snd = snd * Env.linen(0.001, duration, 0.001).ar(Done.freeSelf);
	snd = snd * -30.dbamp;
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\dpsk, {
	var snd, duration, freq;
	freq = \freq.kr(2400);
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(
		freq,
		0.5pi + (Hasher.ar(Stepper.ar(Impulse.ar(600), 0, 0, \periodInBits.kr(1e8) - 1) + \seed.kr(0)).floor * pi)
	);
	snd = HPF.ar(snd, freq - 100);
	snd = LPF.ar(snd, freq + 100);
	snd = snd * Env.linen(0.001, duration, 0.001).ar(Done.freeSelf);
	snd = snd * -15.dbamp;
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\lineProbeL1, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(
		150 * ([1, 2, 3, 4, 5, 7, 9, 10, 11, 12, 13, 14, 15] ++ (17..25)),
		[0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0] * pi,
	);
	snd = snd * Env.linen(0.001, duration, 0.001).ar(Done.freeSelf);
	snd = snd * -15.dbamp;
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\lineProbeL1, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(
		150 * ([1, 2, 3, 4, 5, 7, 9, 10, 11, 12, 13, 14, 15] ++ (17..25)),
		[0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0] * pi,
	);
	snd = snd * Env.linen(0.001, duration, 0.001).ar(Done.freeSelf);
	snd = snd * -15.dbamp;
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\lineSignal, {
	var snd, duration, freq;
	freq = \freq.kr(1920);
	duration = \duration.kr(10.0);
	snd = SinOsc.ar(freq, [0, 0.5pi]) * ((2 * TIRand.ar(0, 1, Impulse.ar(\symbolRate.kr(3000) ! 2))) - 1);
	snd = snd.sum;
	snd = BLowShelf.ar(snd, 200, 0.3, -5);
	snd = MoogFF.ar(snd, \symbolRate.kr(3000) * 2, 0);
	snd = snd * Env.linen(0.001, duration, 0.001).ar(Done.freeSelf);
	snd = snd * -20.dbamp;
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\fx, {
	var snd;
	snd = In.ar(\out.kr(0), 2);
	snd = snd + LPF.ar(Impulse.ar(60) * -30.dbamp, 3120);
	snd = snd + LPF.ar(PinkNoise.ar * -40.dbamp, 3230);
	snd = HPF.ar(snd, 200);
	snd = RLPF.ar(snd, 8123, 0.3);
	snd = (snd * 5.dbamp).tanh;
	snd = RLPF.ar(snd, 7123, 0.3);
	snd = snd + (PinkNoise.ar * -40.dbamp);
	snd = MoogFF.ar(snd, 10230, 0);
	snd = snd.tanh;
	snd = Limiter.ar(snd);
	ReplaceOut.ar(\out.kr(0), snd);
}).add;
)

(
var s;
s = Server.default;

Routine({
	var playSines;
	s.bind { Synth.tail(nil, \fx) };

	playSines = { |freqs, duration, gap = 0, args = #[]|
		if(freqs.isArray, freqs, [freqs]).do { |freq|
			s.bind { Synth(\sine, [freq: freq, duration: duration] ++ args) };
		};
		(duration + gap).wait;
	};

	// Dial tone
	playSines.([350, 440], 3.0, gap: -1.0);

	// DTMF
	[1, 8, 0, 0, 5, 5, 5, 1, 2, 7, 3].do { |digit|
		playSines.([[697, 770, 852, 941][digit.div(3)], [1209, 1336, 1477][digit % 3]], 0.1, gap: 0.1);
	};
	3.0.wait;

	playSines.([1375, 2002], 0.400, 0.0, [amp: -8.dbamp]);
	playSines.(400, 0.100, 0.0, [amp: -8.dbamp]);
	playSines.([1529, 2225], 0.400, 0.0, [amp: -8.dbamp]);
	playSines.(1900, 0.100, 0.0, [amp: -8.dbamp]);
	playSines.(1650, 0.100, 0.0, [amp: -8.dbamp]);

	playSines.(1080 - 100, 0.1);
	s.bind { Synth(\fsk, [freq1: 1080 - 100, freq2: 1080 + 100, duration: 0.9]) };
	1.0.wait;
	playSines.(1750 - 100, 0.1);
	s.bind { Synth(\fsk, [freq1: 1750 - 100, freq2: 1750 + 100, duration: 0.7]) };
	0.7.wait;
	playSines.(1080 - 100, 0.1);
	s.bind { Synth(\fsk, [freq1: 1080 - 100, freq2: 1080 + 100, duration: 0.2]) };
	2.0.wait;

	s.bind { Synth(\ansam, [duration: 3.5]) };
	3.1.wait;
	s.bind { Synth(\fsk, [freq1: 1080 - 100, freq2: 1080 + 100, duration: 0.9, periodInBits: 8 * 9]) };
	0.6.wait;
	s.bind { Synth(\fsk, [freq1: 1780 - 100, freq2: 1780 + 100, duration: 0.3, periodInBits: 8 * 9]) };
	0.3.wait;

	s.bind { Synth(\dpsk, [freq: 1200, duration: 0.5]) };
	s.bind { Synth(\sine, [freq: 1800, duration: 0.5]) };
	s.bind { Synth(\dpsk, [freq: 2400, duration: 0.5]) };
	0.5.wait;
	playSines.([1200, 1800, 2400], 0.1);
	s.bind { Synth(\lineProbeL1, [duration: 0.160 * 2]) };
	(0.160 * 2).wait;
	playSines.([1200, 1800, 2400], 0.1);
	s.bind { Synth(\lineProbeL1, [duration: 0.4]) };
	0.4.wait;
	s.bind { Synth(\sine, [freq: 1800, duration: 0.5]) };
	s.bind { Synth(\dpsk, [freq: 1200, duration: 0.25]) };
	0.5.wait;
	s.bind { Synth(\dpsk, [freq: 2400, duration: 0.25]) };
	0.25.wait;
	s.bind { Synth(\lineSignal, [freq: 1920, symbolRate: 3200, duration: 50.0]) };
	s.bind { Synth(\lineSignal, [freq: 1829, symbolRate: 3200, duration: 50.0]) };
	50.0.wait;
}).play;
)