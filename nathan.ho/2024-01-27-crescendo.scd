(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(50 * (1 + (1 * Env.perc(0, 0.5, curve: -8).ar)) * (1 + (2 * Env.perc(0, 0.05, curve: -8).ar)) * [1, 2.3, 4.8]);
	snd = snd * [0, -20, -30].dbamp;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 10e3, 0.3) * Env.perc(0.01, 0.01).ar * -6.dbamp);
	snd = snd + (SinOsc.ar(XLine.ar(3000, 200, 0.01)) * Env.perc(0, 0.01).ar);
	snd = snd + (SinOsc.ar(XLine.ar(1000, 100, 0.005)) * Env.perc(0, 0.005).ar);
	snd = BPeakEQ.ar(snd, 600, 0.3, -5.0);
	snd = BPeakEQ.ar(snd, 720, 0.2, -5.0);
	snd = BPeakEQ.ar(snd, 1300, 0.14, -5.0);
	snd = snd * 1.dbamp;
	snd = (snd * (1 + (3 * Env.perc(0, 0.01).ar))).tanh;
	snd = snd * (1 + Env.perc(0, 0.05).ar);
	snd = LPF.ar(snd, 1200);
	snd = snd * Env([0, 1, 0.4, 0.9, 0], [0.01, 0.05, 0.09, 3.0], curve: -4).ar;
	snd = snd + LPF.ar(GVerb.ar(snd * -10.dbamp, 90, 1, damping: 0.9), 500);
	snd = snd * Env.linen(0, 3, 1, curve: -4).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;


SynthDef(\snare, {
	var snd;
	snd = SinOsc.ar(170 * XLine.ar(3, 1, 0.01)) * Env.perc(0.001, 0.1).ar;
	snd = snd + (SinOsc.ar(460 * XLine.ar(3, 1, 0.01)) * Env.perc(0.001, 0.1).ar * -6.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2430 * XLine.ar(1, 0.9, 0.1), 0.3) * Env.perc(0.05, 0.1, curve: -1).ar * 5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 4430 * XLine.ar(0.9, 1, 0.1), 0.3) * Env.perc(0.09, 0.03).ar * 1.dbamp);
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd * 6.dbamp;
	snd = snd + DelayC.ar(Latch.ar(snd * -10.dbamp, Impulse.ar(1300)), 0.01, 0.01);
	snd = snd + DelayC.ar(Latch.ar(snd * -10.dbamp, Impulse.ar(8300)), 0.02, 0.013);
	snd = snd.tanh;
	snd = snd * Env([0, 1, 0], [0.001, 1.0], curve: -4).ar;
	snd = (snd * -9.dbamp) + HPF.ar(GVerb.ar(snd * -10.dbamp, 40, 3, 0.7), 100);
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd * Env.linen(0.0, 3, 0.01, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\ride, {
	var snd, freqs, velocity;
	velocity = \velocity.kr(1);
	freqs = ((0..50) ** 0.9).normalize.linexp(0, 1, 4120, 10400);
	snd = Ringz.ar(Hasher.ar(Sweep.ar + freqs) * Env.perc(0.001, 0.01).ar, freqs, 10 * ((freqs.minItem / freqs) ** 1.5) * ExpRand(1, 2 ! freqs.size));
	snd = snd * (freqs.minItem / freqs).squared;
	snd = snd * (1 + LFNoise2.ar(50 * (freqs / freqs.minItem) * (1 + (2 * velocity))));
	snd = snd * (1 + (SinOsc.ar(4000 + (3000 * freqs.sin)) * Env.perc(0, ExpRand(0.5, 2 ! snd.size)).ar));
	snd = snd.sum;
	snd = snd * -35.dbamp;
	snd = snd.tanh;
	snd = snd + (Hasher.ar(Sweep.ar) * Env.perc(0, 0.01).ar * velocity);
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * -17.dbamp * Env.perc(0.05, 0.5).ar, 3200, 0.3);
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * -17.dbamp * Env.perc(0.1, 0.9).ar, 5200, 0.1);
	snd = RHPF.ar(snd, 9120 * ExpRand(0.9, 1.1), 0.4);
	snd = LPF.ar(snd, velocity.linexp(0, 1, 6000, 16200));
	snd = snd + PitchShift.ar(snd, ExpRand(0.05, 0.04), ExpRand(0.7, 0.75));
	snd = snd + PitchShift.ar(snd, 0.1, 0.6);
	snd = snd + GVerb.ar(snd * -20.dbamp, 10, 3);
	snd = snd * velocity;
	snd = snd * Env.perc(velocity.linexp(0, 1, 0.01, 0.001), 2.0, curve: -2).ar;
	snd = snd * Env.linen(0.0, \duration.kr(1.0), 0.03, curve: -4).ar(Done.freeSelf);
	snd = snd * -7.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\organ, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(\freq.kr(440) * [1, 2, 4] * (LFNoise2.kr(10 ! 3) * 0.1).midiratio);
	snd = snd * Env.perc(0, [5, 10, 1]).ar;
	snd = snd * [-5, 0, -9].dbamp;
	snd = snd * (1 + (0.3 * LFNoise2.kr(16 ! snd.size)));
	snd = snd.sum;
	snd = LPF.ar(snd, XLine.ar(8000, 100, 3.0));
	snd = snd * Select.ar(Sweep.ar > 0.02, [ToggleFF.ar(Dust.ar(200)), DC.ar(1)]);
	snd = snd + GVerb.ar(snd * -20.dbamp, 10, 3, damping: 0.2);
	snd = snd * Env.linen(0.0, duration, 0.0, curve: -4).ar(Done.freeSelf);
	snd = snd * -24.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\lead, {
	var snd, freq, n, intensity;
	freq = \freq.kr(440).lag(0.02);
	intensity = LFNoise2.kr(3).linlin(-1, 1, 0, 1) * Line.kr(0, 1, 10);
	n = (1..32);
	snd = SinOsc.ar(freq * n * (LFNoise2.kr(8 * (1 + intensity)) * 0.5 * intensity).midiratio);
	snd = snd * (n.pow(1.3) * (LFNoise2.kr(1).linexp(-1, 1, 1, 1.1)) + (3 * LFNoise2.ar(intensity.linexp(0, 1, 1, 2)))).cos.pow(10);
	snd = snd * (1 + LFNoise2.ar(3 * n.sqrt));
	snd = snd / n;
	snd = snd.sum;
	snd = LPF.ar(snd, intensity.linexp(0, 1, 1000, 16e3));
	snd = snd * (1 + (LFNoise2.ar(LFNoise2.ar(3).linexp(-1, 1, 1, 16)) * 0.5));
	snd = snd * intensity.linlin(-1, 1, 0.2, 1);
	snd = snd * 10.dbamp;
	snd = snd.tanh;
	snd = PitchShift.ar(snd, 0.3, 0.5) * 10.dbamp;
	snd = snd + GVerb.ar(snd * -10.dbamp, 10, 3, damping: 0.2);
	snd = snd * Env.asr(0.5, 1.0, 3.0, curve: -4).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * -25.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

(
var s, bpm, beat, noteToFreq;
s = Server.default;

bpm = 90;
beat = 60 / bpm;

noteToFreq = { |note|
	var scale;
	scale = [
		1,
		9 / 8,
		6 / 5,
		4 / 3,
		3 / 2,
		13 / 8,
		2 * (15 / 16),
	];
	198 * (2.0 ** (note.div(scale.size))) * scale.wrapAt(note);
};

Routine({
	var playRide;

	playRide = { |duration, velocity = 1.0|
		Routine({
			rrand(0.0, 0.02).wait;
			s.bind { Synth(\ride, [duration: duration * beat, velocity: velocity]) };
		}).play;
		(duration * beat).wait;
	};

	Routine({
		loop {
			[
				[
					[8, 10],
					[7, 1.2],
					[9, 1.4],
					[6, 0.5],
					[7, 0.1],
					[5, 0.5],
					[4, 3],
				],
				[
					[8, 10],
					[7 + 2, 1.2],
					[7 + 4, 1.4],
					[7 + 2, 0.5],
					[7 + 1, 3],
					[7, 3],
				],
				{
					var result;
					result = [];
					30.do {
						result = result.add([7 + 7, rrand(0.1, 0.2)]);
						result = result.add([7 + 7 - 1, rrand(0.1, 0.2)]);
					};
					20.do {
						result = result.add([7 + 4, rrand(0.1, 0.2)]);
						result = result.add([7 + 4 + 1, rrand(0.1, 0.2)]);
					};
					result;
				}.(),
			].do { |melody|
				var synth;
				(3 * beat).wait;
				s.bind { synth = Synth(\lead) };
				melody.do { |spec|
					var note, duration;
					# note, duration = spec;
					s.bind { synth.set(\freq, noteToFreq.(note)); };
					(duration * beat).wait;
				};
				s.bind { synth.set(\gate, 0); };
				(3 * beat).wait;
			};
		};
	}).play;

	loop {
		[
			(notes: [0, 2, 4 - 7]),
			(notes: [0, 1, 5]),
			(notes: [0, 2, -7]),
			(notes: [-1, 1, 3, -7 - 2]),
			(notes: [4, 4 - 7], short: true),
		].do { |spec|
			var numBeats, short;
			short = spec[\short] ? false;
			spec[\notes].do { |note|
				Routine({
					rrand(0, 0.2).wait;
					s.bind { Synth(\organ, [freq: noteToFreq.(note), duration: beat * numBeats]) };
				}).play;
			};
			numBeats = if(short, 2, [4, 5, 6].choose);
			Routine({
				numBeats.do {
					if(0.7.coin) {
						playRide.(1, velocity: rrand(0.5, 1.0));
					} {
						playRide.(3 / 5, velocity: rrand(0.9, 1.0));
						playRide.(2 / 5, velocity: rrand(0.5, 1.0));
					};
				};
			}).play;
			s.bind { Synth(\kick, [duration: beat * 3]) };
			(beat * numBeats.min(3)).wait;
			if(numBeats > 3) {
				s.bind { Synth(\snare, [duration: beat * 2]) };
				(beat * (numBeats - 3)).wait;
			};
		};
	};
}).play;
)