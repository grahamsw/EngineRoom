().play

Synth(\synth, [\trigger, 1, \intensity, 0.2, \pan, 0])
(
SynthDef(\synth, {
	var snd, freq, trigger, timbre, n, env, intensity;
	intensity = \intensity.kr(0);
	timbre = \timbre.kr(1) + (intensity * 0.1);
	trigger = T2A.ar(\trigger.tr(0));
	freq = \freq.kr(440) * (1 + (0.3 * intensity * Env.perc(0, 0.008 * intensity).ar(Done.none, trigger)));
	env = Env.perc(0.01, freq.expexp(260, 1000, 2.0, 0.7) * intensity.linlin(0, 1, 0.5, 1), curve: -6).ar(Done.none, trigger);
	n = (1..16);
	snd = SinOsc.ar(freq * n * (1 + ((n - 1) * freq.expexp(100, 1000, 1e-3, 1e-4)))) * (n ** TRand.ar(-0.8, -1, trigger).lag(0.01));
	snd = snd * (TRand.ar(0.3, 1, trigger ! 8) ** 2).lag(0.001);
	snd = snd * ((n * 0.9 * ((LFNoise2.kr(1) * 3) + (-7 * env)).midiratio).cos);
	snd = snd.sum;
	snd = snd * -8.dbamp;
	snd = snd * env;
	snd = snd * intensity.linlin(0, 1, -10, 0).dbamp;
	snd = BHiShelf.ar(snd, 3000, 1, intensity.linlin(0, 1, -3, 0).dbamp);
	snd = snd * (1 + (TRand.ar(0.1, 0.5, trigger) * Env.perc(0.001, 0.01).ar(Done.none, trigger)));
	snd = snd.tanh;
	snd = snd * freq.linlin(260, 3000, 0, -10).dbamp;
	snd = snd + CombC.ar(snd * -3.dbamp, 1 / 50, timbre / 50, 0.1);
	snd = snd + CombC.ar(snd * -3.dbamp, 1 / 120, timbre / 120, 0.03);
	snd = snd * Env.asr(0.01, 1, 0.05).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\lfo, {
	Out.kr(\out.kr, LFNoise2.kr(0.3).linlin(-1, 1, 0, 1));
}).add;

SynthDef(\fx, {
	var snd, wet;
	snd = In.ar(\out.kr(0), 2);
	wet = snd;
	wet = wet + DelayC.ar(LocalIn.ar(2) * -6.dbamp, 0.3, [0.3, 0.25]);
	wet = AllpassC.ar(wet, 0.03, 0.03, 0.1);
	wet = AllpassC.ar(wet, 0.07, 0.07, 0.1);
	wet = AllpassC.ar(wet, 0.01, 0.01, 0.1);
	wet = AllpassC.ar(wet, 0.2, 0.1 * LFNoise2.kr(1 ! 2).midiratio, 0.5);
	wet = wet + PitchShift.ar(wet * -3.dbamp, 0.1, 2.0, 0.001, 0.001);
	wet = wet + PitchShift.ar(wet * -8.dbamp, 0.05, 0.5, 0.001, 0.001);
	wet = wet.tanh;
	wet = LPF.ar(wet, 1000);
	wet = HPF.ar(wet, 200);
	wet = wet.tanh;
	LocalOut.ar(wet);
	wet = wet * -3.dbamp;
	snd = snd + wet;
	snd = snd * -2.dbamp;
	snd = Limiter.ar(snd);
	ReplaceOut.ar(\out.kr(0), snd);
}).add;
)


(
var s, toFreq, bpm, beat, tatum;
s = Server.default;

toFreq = { |note, transpose = 0|
	var scale, midiNote, freq;
	scale = [0, 2, 4, 5, 7, 9, 11];
	midiNote = 60 + transpose + scale.wrapAt(note) + (12 * (note / scale.size).floor);
	freq = midiNote.midicps;
	freq;
};

bpm = 90;
beat = 60 / bpm;
tatum = beat / 4;

Routine({
	var intensityBus;
	var synths, key;
	var synthPatterns, indices;
	var logDurations;
	var setSynthPattern;
	s.bind { Synth.tail(nil, \fx) };
	s.bind {
		intensityBus = Bus.control(nil, 1);
		Synth.tail(nil, \lfo, [out: intensityBus]);
	};
	s.bind {
		synths = { |i|
			Synth(\synth, [
				pan: [-0.3, 0.3][i],
				timbre: [1, 1.2][i],
				intensity: intensityBus.asMap
			])
		} ! 2
	};
	key = 0;

	logDurations = [1, 1];
	synthPatterns = [
		[0],
		[0],
	];
	indices = [0, 1];

	setSynthPattern = { |side, newPattern, logDuration = 1|
		indices[side] = 0;
		synthPatterns[side] = newPattern;
		logDurations[side] = logDuration;
	};

	Routine({
		var row, wait;
		row = [5, 4, 2, 3].normalizeSum;
		key = 4;

		wait = { (rrand(10, 53) * tatum).wait };

		setSynthPattern.(0, -2 + [0]);
		setSynthPattern.(1, -2 + [0]);
		wait.();
		setSynthPattern.(0, -2 + [0, 0, 4]);
		wait.();
		setSynthPattern.(1, -2 + [-1, 0]);
		wait.();
		setSynthPattern.(0, -2 + [0, 4]);
		setSynthPattern.(1, -2 + [-3, 0, 0]);
		wait.();
		setSynthPattern.(0, -2 + [0, 1, 4]);
		wait.();
		setSynthPattern.(1, -2 + [-3, 0]);
		wait.();
		setSynthPattern.(1, -2 + [-2, 0]);
		wait.();
		setSynthPattern.(0, -2 + [0, 2, 6]);
		wait.();
		setSynthPattern.(0, -2 + [0, 2, 6, 4]);
		wait.();
		setSynthPattern.(1, -2 + [-1, 0]);
		wait.();
		setSynthPattern.(0, -2 + [0, 2, 6, 7, 4]);
		wait.();
		setSynthPattern.(1, -2 + [-3, -2, -1, 0]);
		wait.();
		setSynthPattern.(0, -2 + [0, 3, 4, 7, 6]);
		wait.();
		setSynthPattern.(1, -2 + [-4, -3, -1, 0]);
		wait.();
		setSynthPattern.(0, -2 + [0, 4, 7, 6, 4]);
		wait.();
		setSynthPattern.(1, -2 + [-7, 0, 1]);
		wait.();
		setSynthPattern.(1, -2 + [-7, 0, 1, -3]);
		wait.();
		setSynthPattern.(0, -2 + [0, 4, 7, 9, 8, 4]);
		wait.();
		setSynthPattern.(1, -2 + -4 + [-7, -3, 0, 1, 2, 3]);
		wait.();
		setSynthPattern.(1, -2 + [-14, -7, -3, 0, 1, 2, 3, 4]);
		wait.();
		setSynthPattern.(0, -2 + [0, 4, 7, 7 + 4, 7 + 1, 7 + 2]);
		wait.();
		setSynthPattern.(0, -2 + [0, 4, 7, 7 + 4, 7 + 1, 7 + 2], 0);
		wait.();
		setSynthPattern.(1, -2 + [-14, -7, -3, -1, 0, 1, 2, 3, 0]);
		wait.();
		setSynthPattern.(0, -2 + 7 + [0, 2, 3, 4, 7, 8, 7], 0);
		setSynthPattern.(1, -2 + [0, 2, 3, 4, 7, 8, 7], 0);
		wait.();
		setSynthPattern.(0, -2 + 7 + [-2, 0, 1, 2, 4]);
		setSynthPattern.(1, -2 + [0, 1, 2, 1]);
		wait.();
		setSynthPattern.(0, -2 + 7 + [0, 2, 3, 4, 7, 8, 7], 0);
		setSynthPattern.(1, -2 + [0, 2, 3, 4, 7, 8, 7], 0);
		wait.();
		setSynthPattern.(1, -2 + [-7, 0, 1, -3]);
		wait.();
		setSynthPattern.(0, -2 + [0, 4, 7, 9, 8, 4]);
		wait.();
	}).play;
	0.01.wait;

	inf.do {
		var notes;
		indices = indices.collect { |index, side|
			var division;
			division = (2 ** logDurations[side]).asInteger;
			index = index + 1;
			index = index % (synthPatterns[side].size * division);
			index;
		};
		notes = indices.collect { |index, side|
			var division;
			division = (2 ** logDurations[side]).asInteger;
			if((index % division) == 0) {
				synthPatterns[side][index.div(division)];
			} {
				nil;
			};
		};
		notes.do { |note, i|
			if(note.notNil) {
				Routine({
					((1.0.rand ** 2) * 0.01).wait;
					s.bind {
						synths[i].set(\freq, toFreq.(note, key), \trigger, 1);
					};
				}).play;
			};
		};
		(tatum / 2).wait;
	};
}).play;
)