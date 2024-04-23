// not my fave patch I've made, but kinda fun
// i like the phasing melodies
// the bass is a little cheesy, not wild about it

(
SynthDef(\perc, {
	var snd, random, state;
	state = \seed.kr(0);
	random = {
		state = Hasher.kr(state);
	};
	snd = SinOsc.ar(
		random.().linexp(-1, 1, 30, 1000)
		* ({ random.().linlin(-1, 1, 0, 12) } ! 3).midiratio
		* (1 + (random.().linlin(-1, 1, 0, 16) * Env.perc(0, random.().linlin(-1, 1, 0.001, 0.05)).ar))
	);
	snd = snd * [0, -10, -20].dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(random.().linexp(-1, 1, 1e-4, 1e-2), random.().linexp(-1, 1, 0.03, 0.5), curve: random.().linlin(-1, 1, 1, -4)).ar;
	snd = snd * (1 + (Env.perc(0, random.().linexp(-1, 1, 0.003, 0.01)).ar * random.().linlin(-1, 1, 0, 5)));
	snd = (snd * random.().linlin(-1, 1, 10, -8).dbamp).clip2;
	snd = Pan2.ar(snd, random.() * 0.5) + GVerb.ar(snd * random.().linlin(-1, 1, -15, -30).dbamp, random.().linexp(-1, 1, 1, 50), random.().linexp(-1, 1, 1, 5));
	snd = snd + PitchShift.ar(snd * 3.dbamp, random.().linexp(-1, 1, 0.002, 0.05), random.().linexp(-1, 1, 0.5, 2));
	snd = snd * Env.perc(0, random.().linexp(-1, 1, 0.2, 0.7)).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass, {
	var snd, duration, freq, time, rate;
	duration = \duration.kr(10);
	freq = \freq.kr(45);
	time = Line.kr(0, 1, duration);
	rate = time.linexp(0, 1, 1, 8);
	snd = Pulse.ar(freq * (LFNoise2.kr(3 ! 8) * 0.2).midiratio);
	snd = BPF.ar(snd, LFNoise2.kr(rate ! snd.size).linexp(-1, 1, 100, 8000), 0.5);
	snd = Latch.ar(snd, Impulse.ar(LFNoise2.kr(rate ! snd.size).linexp(-1, 1, 1000, 16e3)));
	snd = BPF.ar(snd, LFNoise2.kr(rate ! snd.size).linexp(-1, 1, 100, 8000), 0.8);
	snd = Splay.ar(snd);
	snd = (snd * 30.dbamp).tanh;
	snd = MoogFF.ar(snd, (time ** 3).linexp(-1, 1, 100, 3000), 0) * 8.dbamp;
	snd = snd * ((Line.kr(0, 1, duration) ** 1.5) * 3).dbamp;
	snd = snd * Env.asr(1, 1, 0.01, curve: 4).ar(Done.none, \gate.kr(1));
	snd = snd + GVerb.ar(snd.sum * time * -30.dbamp, 20, 3);
	snd = snd * Env.asr(0.05, 1, 3).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * -15.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\key, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = Pulse.ar(freq * [-0.1, 0.1].midiratio, SinOsc.ar(0.4).linlin(-1, 1, 0.1, 0.5));
	snd = Splay.ar(snd, 0.5);
	snd = RLPF.ar(snd, Env.perc(0.01, 0.3).ar.linexp(0, 1, 500, 2000), 0.3);
	snd = snd * (1 + (3 * Env.perc(0, 0.03).ar));
	snd = snd.tanh;
	snd = snd * Env.perc(0.01, 0.3 * ((600 / freq).squared).min(1)).ar(Done.freeSelf);
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\key2, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = Saw.ar(freq * [-0.1, 0.1].midiratio);
	snd = Splay.ar(snd, 0.5);
	snd = RLPF.ar(snd, Env.perc(0.01, 0.1).ar.linexp(0, 1, 1300, 2000), 0.1);
	snd = snd * (1 + (8 * Env.perc(0, 0.03).ar));
	snd = snd.tanh;
	snd = snd * Env.perc(0.01, 0.3 * ((300 / freq).squared).min(1)).ar(Done.freeSelf);
	snd = snd * -12.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass2, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = Pulse.ar(50 * XLine.ar(2, 1, 0.005));
	snd = MoogFF.ar(snd, Env.perc(0.01, 1.0).ar.linexp(-1, 1, 100, 2000), 0.5);
	snd = snd + DelayC.ar(HPF.ar(snd, 500), 0.1, SinOsc.ar(1, [0, pi]).linlin(-1, 1, 0, 1) * 5e-3);
	snd = BHiShelf.ar(snd, 3100, 1, -5);
	snd = snd * (1 + (Env.perc(0, 0.03).ar * 10));
	snd = snd.tanh;
	snd = snd * Env.perc(0.001, 1.2, curve: -2).ar(Done.freeSelf);
	snd = snd * 2.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\fx, {
	var snd, quantize;
	snd = In.ar(\out.kr(0), 2);
	snd = Limiter.ar(snd);
	ReplaceOut.ar(\out.kr(0), snd);
}).add;
)

Synth(\bass2);


(
var s, bpm, beat, measure;
bpm = 140;
beat = 60 / bpm;
measure = (17 * beat) / 4;
s = Server.default;
Routine({
	var play;
	play = { |synthDef, duration, args = #[]|
		var synth;
		s.bind { synth = Synth(synthDef, args ++ [duration: duration]) };
		duration.wait;
		s.bind { synth.set(\gate, 0) };
	};
	s.bind { Synth.tail(nil, \fx) };


	Routine({
		loop {
			"
....
9..8.96..5.6
3..4.32..1.2222.
9..8.96..5.6666
6..5.66..5.6...
...............
5.6.7.56.7.8.6
9..8.96..5.65...
...............
6666.67.6.76.76.76.76.76
........
67676565652.....
23456789...89876566666666
..................
.....
65656.56565.6666...9.898989
........8989
".do { |character|
				var note, freq;
				if(" \n\r".includes(character).not) {
					if(character != $.) {
						note = character.asString.asInteger;
						freq = 440 * (2 ** (note / 5));
						s.bind {
							Synth(\key, [freq: freq]);
							Synth(\key, [freq: freq * (4 / 3)]);
						};
					};
					(beat / 4).wait;
				};
			};
		};
	}).play;


	Routine({
		loop {
			"
....
5666.5666.5666.566674555......
6777.6777.6677....64.4..1.5.3
...325.5....543.6.6.2.653
...
.......
...
4..56.5.6.5..6.4.6.4.5.6.4..
.....
.....
.....
".do { |character|
				var note, freq;
				if(" \n\r".includes(character).not) {
					if(character != $.) {
						note = character.asString.asInteger;
						freq = 220 * (2 ** (note / 5));
						s.bind {
							Synth(\key2, [freq: freq]);
							Synth(\key2, [freq: freq * (4 / 3)]);
						};
					};
					(beat / 4).wait;
				};
			};
		};
	}).play;

	loop {
		Routine({
			(measure * 4).wait;
			if(0.5.coin) {
				play.(\bass, measure * 4, [freq: 45]);
				if(0.9.coin) {
					s.bind { Synth(\bass2); };
				};
			};
			(measure * 4).wait;
			play.(\bass, measure * 4, [freq: 36]);
			if(0.9.coin) {
				s.bind { Synth(\bass2); };
			};
		}).play;
		([0.23, 0.2, 0.1, 0.23, 0.1] + 1.0.rand).do { |offset|
			"
6.9.1234567890001
6.9.1234567890010
6.9.1234567890100
6.9.1234567891111
".do { |character|
				if(" \n\r".includes(character).not) {
					if(character != $.) {
						s.bind {
							Synth(\perc, [seed: character.asString.asInteger + offset]);
						};
					};
					(beat / 4).wait;
				};
			};
		};
	};
}).play;
)