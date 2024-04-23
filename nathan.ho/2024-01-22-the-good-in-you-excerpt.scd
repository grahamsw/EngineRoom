(
SynthDef(\string, {
	var snd, freq, intensity;
	intensity = ((LFNoise2.kr(0.3) * 0.3) + In.kr(\intensityBus.kr)).clip(0, 1);
	freq = \freq.kr(440);
	freq = freq.cpsmidi.lag(\lag.kr(0.045)).midicps * (LFNoise2.kr(3) * 0.05).midiratio * (SinOsc.kr(LFNoise2.kr(3).linexp(-1, 1, 3, 9)) * 0.35 * (Sweep.kr(Changed.kr(freq)) / 0.7).min(1) * intensity).midiratio;
	freq = freq * (2 ** ((Env([0, 0, 1, 1], [7.3, 1.2, 1], \sin).ar * \bend.kr(0)) / 5));
	snd = Pulse.ar(freq, LFNoise2.kr(1).linlin(-1, 1, 0.05, 0.15));
	snd = LeakDC.ar(snd);
	snd = snd * Env.adsr(0.01, 0.2, 0.7, ExpRand(0.1, 0.5)).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * intensity;
	2.do {
		snd = snd + CombL.ar(snd, 0.1, 1 / ExpRand(40, 90) + (LFNoise2.kr(0.8) * 1e-3), 0.01);
	};
	snd = snd + (BPF.ar(WhiteNoise.ar, ExpRand(2000, 4000), 0.3) * Env.perc(0.02, 0.05).ar * 1.dbamp);
	snd = MoogFF.ar(snd, intensity.linexp(0, 1, 4000, 10000), 0.5) * 5.dbamp;
	snd = snd * intensity.linlin(0, 1, -5, 0).dbamp;

	snd = BPeakEQ.ar(snd, ExpRand(800, 1200), 0.3, 4);
	snd = BPeakEQ.ar(snd, ExpRand(300, 500), 0.3, -4);
	snd = BPeakEQ.ar(snd, ExpRand(2200, 3200), 0.3, 4);

	snd = (snd * -8.dbamp).tanh;
	snd = BHiShelf.ar(snd, 7000, 1, -10);
	snd = LeakDC.ar(snd);
	snd = snd * Env.asr(0.001, 1, 0.5).ar(Done.none, \gate.kr(1));
	snd = snd * -6.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;


SynthDef(\lfo, {
	var snd;
	snd = LFNoise2.kr(0.3).linlin(-1, 1, 0.6, 0.9);
	Out.kr(\out.kr(0), snd);
}).add;

SynthDef(\fx, {
	var snd;
	snd = In.ar(\out.kr(0), 2);

	snd = snd + HPF.ar(GVerb.ar(snd.sum * -25.dbamp * \enableReverb.kr(0, 0.01), 20, 3), 100);
	snd = LeakDC.ar(snd);
	snd = Limiter.ar(snd, dur: 0.01);
	ReplaceOut.ar(\out.kr(0), snd);
}).add;
)


(
var s, intensityBus, transpose, timeScale, noteToFreq, pans, randomMelody;
var playSectionA;
var themeBeginning, themeEnd;
s = Server.default;


transpose = { |melody, amount = 0|
	melody.collect { |row|
		[row[0] + amount] ++ row[1..];
	};
};

timeScale = { |melody, amount = 1|
	melody.collect { |row|
		[row[0]] ++ [max(row[1] * amount, 0.04)] ++ [row[2..]];
	};
};

noteToFreq = { |note|
	470 * (2 ** (note / 5))
};

pans = (0..3).linlin(0, 3, -0.8, 0.8);

themeBeginning = [
	[-5, 0.03],
	[0, 0.1],
	[5, 2.9],
	[\, 1.45],
	[6, 0.2],
	[5, 0.2],
	[6, 0.2],
	[4, 1.8],
	[\, 1.65],
	[2, 0.12],
	[3, 0.22],
	[4, 0.07],
	[5, 0.06],
	[4, 3.4],
	[\, 1.74],
	[0, 0.07],
	[5, 0.07],
	[6, 0.04],
	[5, 0.07],
	[3, 0.13],
	[2, 0.23],
	[1, 1.2],
	[2, 0.13],
	[1, 0.08],
	[0, 0.23],
	[1, 2.8],
];


Routine({
	var fx;
	var playString, playGrosse;

	playString = { |notesAndDurations, args, octave = 0|
		var synth;
		notesAndDurations.do { |pair|
			var freq, note, duration, additionalArgs;
			# note, duration, additionalArgs = pair;
			if(note == \) {
				if(synth.notNil) {
					s.bind { synth.set(\gate, 0); };
					synth = nil;
				};
				duration.wait;
			} {
				if(synth.isNil) {
					s.bind { synth = Synth(\string, [intensityBus: intensityBus]); };
				};
				freq = noteToFreq.(note) * (2 ** octave);
				s.bind { synth.set(\freq, freq, \duration, duration, *args ++ additionalArgs) };
				duration.wait;
			};
		};
		if(synth.notNil) {
			s.bind { synth.set(\gate, 0); };
		};
	};

	playGrosse = { |theme, withClicks = false|
		s.bind { fx.set(\enableReverb, 1) };
		4.do { |i|
			Routine({
				playString.(theme, args: [pan: pans[i]], octave: i * -1);
			}).play;
		};
		theme.flop[1].sum.wait;
		1.0.wait;
	};

	s.bind { intensityBus = Bus.control(nil, 1) };
	s.bind { Synth(\lfo, [out: intensityBus]); };
	s.bind {
		fx = Synth.tail(nil, \fx);
	};

	playGrosse.(themeBeginning);
}).play;
)