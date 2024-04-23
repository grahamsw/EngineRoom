(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(Env.perc(0, 0.07).ar.linexp(0, 1, 60, 1000) * XLine.kr(1, 0.5, 0.3)) * -2.dbamp;
	snd = snd + (SinOsc.ar(XLine.ar(900, 90, 0.03)) * Env.perc(0.001, 0.01).ar * 1.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 10312, 0.3) * Env.linen(0.01, 0.03, 0.01, curve: -4).ar * -4.dbamp);
	snd = snd * (1 + (2 * Env.perc(0, 0.03).ar));
	snd = snd.fold2 + snd.tanh;
	snd = snd * Env.perc(0.003, 0.9, curve: -8).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\hat, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), [8312, 12.3e3], 0.1);
	snd = snd * [0, -3].dbamp;
	snd = snd.sum * 6.dbamp;
	snd = snd * Env.linen(0.003, 0.01, 0.02, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\hatOpen, {
	var snd;
	snd = BPF.ar(Hasher.ar(Sweep.ar), [8312, 12.3e3], 0.05);
	snd = snd * [0, -3].dbamp;
	snd = snd.sum * 6.dbamp;
	snd = snd * Env.linen(0.003, 0.04, 0.001, curve: -4).ar(Done.freeSelf);
	snd = snd * -6.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass, {
	var snd, freq, duration;
	duration = \duration.kr(0.2);
	freq = \freq.kr(60);
	snd = Saw.ar(freq * XLine.kr(4, 1, 0.003) * [-0.1, 0.1].midiratio);
	snd = Splay.ar(snd);
	snd = MoogFF.ar(snd, Env.perc(0, duration).ar.linexp(0, 1, 120, 3000), 1) * 10.dbamp;
	snd = (snd * 10.dbamp).tanh;
	snd = snd * (1 + (2 * Env.perc(0, 0.01).ar));
	snd = snd.tanh;
	snd = snd * Env.perc(0.001, duration, curve: -1).ar(Done.freeSelf);
	snd = snd * 3.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass2, {
	var snd, freq, duration;
	duration = \duration.kr(0.2);
	freq = \freq.kr(60);
	snd = Pulse.ar(freq * XLine.kr(4, 1, 0.01) * [-0.01, 0.01].midiratio, [0.45, 0.55]);
	snd = Splay.ar(snd);
	snd = MoogFF.ar(snd, Env.perc(0, duration, curve: -4).ar.linexp(0, 1, 120, 3000), 1) * 20.dbamp;
	snd = (snd * 2.dbamp).tanh;
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = snd.tanh;
	snd = snd * Env.perc(0.001, duration, curve: -2).ar(Done.freeSelf);
	snd = snd * 3.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\lead, {
	var snd, freq, duration;
	duration = \duration.kr(0.2);
	freq = \freq.kr(60);
	snd = SinOsc.ar(freq * IRand(2, 4) * XLine.kr(2, 1, 0.01)) * Rand(1000, 4000);
	snd = SinOsc.ar(freq + snd);
	snd = MoogFF.ar(snd, 5000, 0) * 12.dbamp;
	snd = snd * Env.adsr(0.001, 0.01, 0.3, 0.05, curve: -10).ar(Done.freeSelf, \gate.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -3.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\perc1, {
	var snd;
	snd = SinOsc.ar(420 * [1, 2.4, 2.8, 3.8]);
	snd = snd * [0, -10, -10, -20].dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0, [0.1, 0.03, 0.001, 0.03]).ar;
	snd = snd * (1 + (10 * Env.perc(0, 0.001).ar * \velocity.kr(1)));
	snd = snd.clip2;
	snd = snd * \velocity.kr(1).sqrt;
	snd = LPF.ar(snd, \velocity.kr(1).linexp(0, 1, 1000, 16e3));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3120, 0.3) * Env.perc(0, 0.01).ar * 8.dbamp);
	snd = snd * Env.perc(0.005, 0.12 * \velocity.kr(1), curve: -9).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * 0.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\perc2, {
	var snd;
	snd = SinOsc.ar(820 * [1, 2.4, 2.8, 3.8]);
	snd = snd * [0, -5, -10, -20].dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0, [0.1, 0.01, 0.001, 0.03]).ar;
	snd = snd * (1 + (10 * Env.perc(0, 0.001).ar * \velocity.kr(1)));
	snd = snd.clip2;
	snd = snd * \velocity.kr(1).sqrt;
	snd = LPF.ar(snd, \velocity.kr(1).linexp(0, 1, 1000, 16e3));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7120, 0.3) * Env.perc(0, 0.003).ar * 8.dbamp);
	snd = snd * Env.perc(0.005, 0.09 * \velocity.kr(1), curve: -8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * 0.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\perc3, {
	var snd;
	snd = SinOsc.ar(1020 * [1, 2.4, 2.8, 3.8]);
	snd = snd * [0, -5, -10, -20].dbamp;
	snd = snd.sum;
	snd = snd * Env.perc(0, [0.1, 0.01, 0.001, 0.03]).ar;
	snd = snd * (1 + (10 * Env.perc(0, 0.001).ar * \velocity.kr(1)));
	snd = snd.clip2;
	snd = snd * \velocity.kr(1).sqrt;
	snd = LPF.ar(snd, \velocity.kr(1).linexp(0, 1, 1000, 16e3));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7120, 0.3) * Env.perc(0, 0.003).ar * 8.dbamp);
	snd = snd * Env.perc(0.005, 0.09 * \velocity.kr(1), curve: -8).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\acid, {
	var snd, freq, duration;
	duration = \duration.kr(0.2);
	freq = \freq.kr(60);
	snd = Saw.ar(freq * [1, 2] * XLine.ar(2, 1, 0.01)).sum;
	snd = MoogFF.ar(snd, 400 * ExpRand(0.5, 2) * (Env.perc(0, duration * Rand(0.3, 3), curve: -4).ar * 12 * Rand(3, 8)).midiratio, 2) * 5.dbamp;
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd.tanh;
	snd = snd * 5.dbamp;
	snd = snd * Env.linen(0.001, duration, 0.3, curve: -8).ar(Done.freeSelf, \gate.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * 0.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\acid2, {
	var snd, freq, duration;
	duration = \duration.kr(0.2);
	freq = \freq.kr(60);
	snd = Pulse.ar(freq * XLine.ar(2, 1, 0.01) * [1, 2]);
	snd = (snd * [1, 0.5]).sum;
	snd = MoogFF.ar(snd, { ExpRand(1000, 8000) } ! 3 * XLine.kr(2, 1, ExpRand(0.1, 0.9)), 3.4).sum * 7.dbamp;
	snd = snd.fold2;
	snd = snd * (1 + Env.perc(0.0, 0.01).ar);
	snd = snd.tanh;
	snd = snd * Env.linen(0.001, duration, 0.01, curve: -8).ar(Done.freeSelf, \gate.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -3.dbamp;
	Out.ar(\reverbBus.kr(0), snd);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\reverb, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	snd = LPF.ar(GVerb.ar(snd.sum, 120, 5, damping: 0.8), 2000) * -20.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\lead2, {
	var snd, freq, duration, trigger, env;
	duration = \duration.kr(0.2);
	trigger = \trigger.tr(0);
	env = Env.perc(0.001, 1, curve: -8).kr(gate: trigger);
	freq = \freq.kr(60).cpsmidi.lag(0.1).midicps * XLine.kr(0.1, 1, 0.02);
	snd = Saw.ar(freq * (2 ** [[-1, -2, 2]]) * (LFNoise2.kr(3 ! 7) * 0.15).midiratio);
	snd = snd * (1 + env);
	snd = snd.tanh;
	snd = snd.flat.sum;
	snd = MoogFF.ar(snd, env.linexp(0, 1, 100, 16e3), 2);
	snd = snd * env.sqrt;
	snd = snd * Env.asr(0.001, 1.0, 0.01, curve: -8).ar(Done.freeSelf, \gate.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -9.dbamp;
	Out.ar(\reverbBus.kr(0), snd);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\fx, {
	var snd;
	snd = In.ar(\out.kr(0), 2);
	snd = snd * -10.dbamp;
	snd = snd + LPF.ar(LPF.ar(HPF.ar(GVerb.ar(snd.sum * -30.dbamp, 40, 1, 0.9), 100), 3000), 3000);
	snd = Limiter.ar(snd);
	ReplaceOut.ar(\out.kr(0), snd);
}).add;
)

(
var s, bpm, beat, root;
s = Server.default;

bpm = 146;
beat = 60 / bpm;

root = 58;

Routine({
	var play, reverbBus;
	var schedulePercs, scheduleDrums, scheduleHats;

	play = { |synthDef, duration, args = #[], sustain = 0.5|
		var synth;
		s.bind { synth = Synth(synthDef, args ++ [duration: duration * sustain, reverbBus: reverbBus]) };
		(duration * sustain).wait;
		s.bind { synth.set(\gate, 0) };
		(duration * (1 - sustain)).wait;
	};

	s.bind {
		reverbBus = Bus.audio(nil, 2);
		Synth.tail(nil, \reverb, [in: reverbBus, out: 0]);
		Synth.tail(nil, \fx);
	};

	scheduleDrums = {
		schedulePercs.();
		Routine({
			16.do {
				s.bind { Synth(\kick) };
				beat.wait;
			};
		}).play;
		scheduleHats.();
	};

	scheduleHats = {
		Routine({
			16.do {
				s.bind { Synth(\hat) };
				(beat / 4).wait;
				s.bind { Synth(\hat) };
				(beat / 4).wait;
				s.bind { Synth(\hatOpen) };
				(beat / 2).wait;
			};
		}).play;
	};

	schedulePercs = {
		Routine({
			0.01.wait;
			4.do {
				s.bind { Synth(\perc3, [pan: 0.3, velocity: 0.4]) };
				(beat * 3 / 4).wait;
				s.bind { Synth(\perc3, [pan: -0.3, velocity: 0.5]) };
				(beat * 3 / 4).wait;
				s.bind { Synth(\perc3, [pan: 0.3, velocity: 0.3]) };
				(beat * 2 / 4).wait;
				(beat / 2).wait;
				s.bind { Synth(\perc3, [pan: -0.3, velocity: 0.5]) };
				(beat / 2).wait;
				s.bind { Synth(\perc3, [pan: 0.3, velocity: 0.7]) };
				beat.wait;
			};
		}).play;
		Routine({
			0.003.wait;
			3.do {
				s.bind { Synth(\perc1, [pan: -0.5]) };
				(beat / 2).wait;
				s.bind { Synth(\perc1, [pan: 0.5, velocity: 0.7]) };
				(beat / 2).wait;
				s.bind { Synth(\perc1, [pan: -0.5]) };
				(beat / 2).wait;
				s.bind { Synth(\perc2, [pan: 0.5, velocity: 0.7]) };
				(beat / 2).wait;
				s.bind { Synth(\perc1, [pan: -0.5]) };
				(beat / 2).wait;
				(beat / 4).wait;
				s.bind { Synth(\perc1, [pan: 0.5]) };
				(beat / 4).wait;
				s.bind { Synth(\perc1, [pan: -0.5, velocity: 0.7]) };
				(beat / 2).wait;
				s.bind { Synth(\perc2, [pan: 0.5]) };
				(beat / 2).wait;
			};
			s.bind { Synth(\perc1, [pan: -0.5]) };
			(beat / 2).wait;
			s.bind { Synth(\perc1, [pan: 0.5, velocity: 0.7]) };
			(beat / 2).wait;
			4.do {
				s.bind { Synth(\perc1, [pan: -0.5, velocity: 0.3]) };
				(beat / 2 / 4).wait;
			};
			s.bind { Synth(\perc2, [pan: 0.5]) };
			(beat / 2).wait;
			s.bind { Synth(\perc1, [pan: -0.5, velocity: 0.7]) };
			(beat / 2).wait;
			s.bind { Synth(\perc2, [pan: 0.5]) };
			(beat / 2).wait;
			s.bind { Synth(\perc2, [pan: -0.5, velocity: 0.7]) };
			(beat / 4).wait;
			s.bind { Synth(\perc2, [pan: 0.5, velocity: 0.5]) };
			(beat / 2).wait;
			s.bind { Synth(\perc2, [pan: -0.5, velocity: 0.75]) };
			(beat / 4).wait;
		}).play;
	};

	// 1

	2.do {
		scheduleHats.();
		schedulePercs.();

		Routine({
			[
				0, 24, \, 24, 12, \, 24 + 7, \,
				\, \, \, \, \, \, \, \,
				-4 + [0, 12, 24], \, \, \, \, \,
				7, \, \, \, 12 + 2, \, 12 + 3, \,
			].flat.do { |note|
				if(note != \) {
					play.(\acid2, beat / 4, [freq: (root + note + (12 * -2)).midicps, reverbOut: -10.dbamp], 0.75);
				} {
					(beat / 4).wait;
				};
			};
		}).play;
		(beat * 16).wait;
	};

	Routine({
		{
			var synth;
			[
				0, \, \, 0, 5, 8, \, 7,
				\, \, \, \, \, 2, 3, 7,
				2, \, \, 0, \, \, 2, -5,
				\, \, \, -1, 2, 11, 8, 7,
				12, \, \, 0, 5, 8, \, 7,
				\, \, \, \, \, 2, 3, 7,
				2, \, \, 0, \, \, 2, -5,
				\, \, \, -1, 2, 7, 11, 14,
				12,
			].do { |note|
				if(note == \) {
					if(synth.notNil) {
						s.bind { synth.set(\gate, 0) };
					};
					synth = nil;
				} {
					if(synth.isNil) {
						s.bind { synth = Synth(\lead2, [reverbBus: reverbBus]) };
					};
					s.bind { synth.set(\freq, (root + note).midicps, \trigger, 1) };
				};
				(beat / 2).wait;
			};
			if(synth.notNil) {
				s.bind { synth.set(\gate, 0) };
			};
		}.();
	}).play;

	scheduleDrums.();
	(beat * 16).wait;
	scheduleDrums.();
	(beat * 16).wait;

	2.do {
		scheduleDrums.();

		Routine({
			[
				0, 24, \, 24, 12, \, 24 + 7, \,
				\, \, \, \, \, \, \, \,
				-4 + [0, 12, 24], \, \, \, \, \,
				7, \, \, \, 12 + 2, \, 12 + 3, \,
			].flat.do { |note|
				if(note != \) {
					play.(\acid2, beat / 4, [freq: (root + note + (12 * -2)).midicps, reverbOut: -10.dbamp], 0.75);
				} {
					(beat / 4).wait;
				};
			};
		}).play;
		(beat * 16).wait;
	};

}).play;
)