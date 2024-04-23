// keywords: techno pop, alice deejay - better off alone, eurodance, disco, trance

(
// Not too much high end on this kick, per reference.
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(
		60
		* (Env.perc(0, 0.1, curve: -4).ar * 30).midiratio
		* (Env.perc(0, 0.03).ar * 5).midiratio
	);
	snd = snd * (1 + (3 * Env.perc(0.0, 0.03).ar));
	snd = (snd * -2.dbamp).tanh * 2.dbamp;
	snd = snd * Env.perc(0.001, 0.2).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass, {
	var snd;
	snd = Pulse.ar(\freq.kr(440) * XLine.kr(1.6, 1, 0.005), 0.13);
	snd = LPF.ar(snd, 120 * (Env.perc(0, 0.3, curve: -8).ar * 30).midiratio);
	snd = snd * (1 + (2 * Env.perc(0.0, 0.01).ar));
	snd = snd.clip2;
	snd = snd + (SinOsc.ar(\freq.kr(440) / 2) * 1.dbamp);
	snd = snd * Env.perc(0.003, 0.23, curve: -4).ar(Done.freeSelf);
	snd = snd * 3.dbamp;
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\hat, {
	var snd;
	snd = Pulse.ar(40 * [2, 3.2, 4.6, 5.8, 6.7, 8.5]);
	snd = snd.sum;
	snd = FreqShift.ar(snd, 73);
	snd = BPF.ar(snd, [9.3e3, 7e3] * 0.9, 0.04).sum * 6.dbamp;
	snd = snd + RHPF.ar(Hasher.ar(Sweep.ar) * 2.dbamp * Env.perc(0.05, 0.1).ar, 11e3, 0.1);
	snd = LPF.ar(snd, 7300);
	snd = HPF.ar(snd, 6e3);
	snd = snd * -8.dbamp;
	snd = snd * Env.perc(0.02, 0.15, curve: -2).ar(Done.freeSelf);
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\quietHat, {
	var snd;
	snd = Pulse.ar(40 * [2, 3.2, 4.6, 5.8, 6.7, 8.5]);
	snd = snd.sum;
	snd = FreqShift.ar(snd, 73);
	snd = BPF.ar(snd, [9.3e3, 7e3] * 0.9, 0.04).sum * 6.dbamp;
	snd = snd + RHPF.ar(Hasher.ar(Sweep.ar) * 2.dbamp * Env.perc(0.05, 0.1).ar, 11e3, 0.1);
	snd = LPF.ar(snd, 7300);
	snd = HPF.ar(snd, 6e3);
	snd = snd * -16.dbamp;
	snd = snd * Env.perc(0.02, 0.05, curve: -2).ar(Done.freeSelf);
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\clap, {
	var snd;
	snd = Hasher.ar(Sweep.ar + [0, 1, 2]);
	snd = BPF.ar(snd, 1200 * [0.9, 1, 1.2], 0.2) * 13.dbamp;
	snd = snd * Env([0, 2, 0.5, 0], [1e-3, 0.02, 0.3], curve: -6).delay([0, 4e-3, 16e-3]).ar;
	snd = snd.clip2;
	snd = snd * -2.dbamp;
	snd = Splay.ar(snd, 0.3);
	snd = snd * Env.perc(0.0, 0.35).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\lead, {
	var snd;
	snd = Saw.ar(\freq.kr(440));
	snd = BHiShelf.ar(snd, 2000, 1, -5);
	snd = LPF.ar(snd, 8000);
	snd = BPeakEQ.ar(snd, 1200, 0.3, -3);
	snd = BPeakEQ.ar(snd, 2300, 0.3, 3);
	snd = (snd * 2.dbamp).tanh;
	snd = snd * Env.adsr(0.01, 0.03, 0.7, 0.01, curve: -4).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * -14.dbamp;
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\reverb, {
	var snd;
	snd = In.ar(\out.kr(0), 2);
	snd = snd + GVerb.ar(snd.sum * -15.dbamp, 50, 3, damping: 0.9);
	ReplaceOut.ar(\out.kr(0), snd);
}).add;

SynthDef(\send, {
	var snd;
	snd = In.ar(\in.kr(0), 2);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\fx, {
	var snd;
	snd = In.ar(\out.kr(0), 2);
	snd = snd + HPF.ar(GVerb.ar(snd.sum * -30.dbamp, 100, 0.1, damping: 0.9), 500);
	snd = snd * -4.dbamp;
	snd = Limiter.ar(snd, dur: 0.01);
	snd = (snd * 1.dbamp).clip2;
	ReplaceOut.ar(\out.kr(0), snd);
}).add;

SynthDef(\sawSweep, {
	var snd;
	snd = Saw.ar((Line.kr(0, 1, 1) ** (1 / 2)).linexp(0, 1, 100, 8000));
	snd = HPF.ar(snd, 500);
	snd = HPF.ar(snd, 500);
	snd = BHiShelf.ar(snd, 1000, 1, -10);
	snd = snd * -12.dbamp;
	snd = snd ! 2;
	snd = snd * Env.asr(0.1, 1, 0.02).ar(Done.freeSelf, \gate.kr(1));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\reverseCymbal, {
	var snd;
	snd = Hasher.ar(Sweep.ar + [0, 1]);
	snd = BPF.ar([snd], 7000 * [1.2, 1.6, 1.3, 1.4], 0.05);
	snd = snd.sum;
	snd = snd * -18.dbamp;
	snd = snd * Env.perc(\duration.kr(1), 3, curve: [4, -16]).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\pad, {
	var snd, scale;
	scale = \scale.kr(1);
	snd = Saw.ar(\freq.kr(440) * (LFNoise2.kr(5 ! 8) * 0.2).midiratio * [1, 2, 1, 2, 2, 1, 2, 1] * scale);
	snd = snd * Line.kr(0, 1, 0.01);
	snd = DelayC.ar(snd, 0, { Rand(0, 1e-3) } ! 8);
	snd = Splay.ar(snd, 0.5);
	snd = LPF.ar(snd, 700 * scale.sqrt);
	snd = LPF.ar(snd, 400 * scale) + BPF.ar([snd], [400, 670, 872, 1023, 2320] * scale, 0.3).sum;
	snd = snd * -17.dbamp;
	snd = snd * Env.asr(2, 1, 1).ar(Done.freeSelf, \gate.kr(1));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\buildupSnare, {
	var snd;
	snd = (SinOsc.ar(210 * [1, 3.2, 4.8, 7.9] * XLine.kr(2, 1, 0.01)));
	snd = snd * [0, -20, -15, -20].dbamp;
	snd = snd.sum * Env.perc(0, 0.1).ar;
	snd = snd + BPF.ar(Hasher.ar(Sweep.ar) * Env.perc(0.05, 0.05).ar, 2310, 0.3);
	snd = LPF.ar(snd, (\cutoff.kr(0) ** (1 / 2)).linexp(0, 1, 100, 8000));
	snd = snd * Env.perc(0.001, 0.07, curve: 2).ar(Done.freeSelf);
	snd = snd * -12.dbamp;
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\buildupCymbal, {
	var snd;
	snd = Pulse.ar(40 * [2, 2.5, 4.3, 3.2, 7.3, 4.6, 5.8, 6.7, 8.5]);
	snd = snd.sum;
	snd = FreqShift.ar(snd, 73);
	snd = snd + Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, 10e3, 0.1);
	snd = HPF.ar(snd, 8e3);
	snd = snd * -4.dbamp;
	snd = snd * Env.perc(0.05, 0.4, curve: -4).ar(Done.freeSelf);
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\intro, {
	var snd;
	snd = Hasher.ar(Sweep.ar + [0, 1]);
	snd = snd * ToggleFF.ar(Impulse.ar(8 / \beat.kr(60 / 136))).lag(0.01);
	snd = BPF.ar(snd, Env([0, 1, 0], [0.1, 0.7] * \duration.kr(1), curve: -2).ar.linexp(0, 1, 400, 4000), 0.1);
	snd = snd * -10.dbamp;
	snd = snd * Env.linen(0.01, \duration.kr(1), 0.01, curve: -4).ar(Done.freeSelf);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\resonantBass, {
	var snd;
	snd = Pulse.ar(\freq.kr(440) * XLine.kr(1.6, 1, 0.005), 0.13);
	snd = RLPF.ar(snd, \cutoff.kr(0).linexp(0, 1, 500, 3000), 0.1);
	snd = snd.tanh;
	snd = snd * -5.dbamp;
	snd = snd * Env.adsr(0.003, 0.05, 0.3, 0.01, curve: -4).ar(Done.freeSelf, \gate.kr(1));
	snd = snd ! 2;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\superSaw, {
	var snd;
	snd = Saw.ar(\freq.kr(440) * ((((-5..5).normalize * 2) - 1) * 0.3).midiratio);
	snd = snd * Line.kr(0, 1, 0.001);
	snd = DelayC.ar(snd, 0.01, { Rand(0, 1e-2) } ! snd.size);
	snd = Splay.ar(snd, 0.5);
	snd = LPF.ar(snd, 3000);
	snd = snd * -10.dbamp;
	snd = snd * Env.asr(0.001, 1, 0.01).ar(Done.freeSelf, \gate.kr(1));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\cutoffEnv, {
	Out.kr(\out.kr(0), Env([0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0], \duration.kr(1) * ([1] ++ ((1 / 2) ! 16))).kr);
}).add;
)

(
var s, bpm, beat, root, reverbBus, reverbGroup, cutoffBus;
s = Server.default;
bpm = 140;
beat = 60 / bpm;
root = 59;
Routine({
	var playRhythmSection, playTransition, playFourCymbals, playReverseCymbal, playSuperSaw;

	s.bind {
		reverbGroup = Group();
		reverbBus = Bus.audio(nil, 2);
		Synth(\reverb, [out: reverbBus], reverbGroup, \addToTail);
		Synth(\send, [in: reverbBus, out: 0], reverbGroup, \addAfter);
		Synth(\fx, [out: 0], nil, \addToTail);
		cutoffBus = Bus.control(nil, 1);
	};

	playReverseCymbal = {
		Routine({
			(beat * 12).wait;
			s.bind { Synth(\reverseCymbal, [duration: beat * 4, out: reverbBus], reverbGroup) };
		}).play;
	};

	playTransition = {
		Routine({
			var synth;
			(beat * 12).wait;
			2.do {
				(beat / 2).wait;
				s.bind { synth = Synth(\sawSweep, [out: reverbBus], reverbGroup); };
				(beat / 4).wait;
				s.bind { synth.set(\gate, 0); };
				(beat / 4).wait;
				s.bind { synth = Synth(\sawSweep, [out: reverbBus], reverbGroup); };
				beat.wait;
				s.bind { synth.set(\gate, 0); };
			};
		}).play;
	};

	playFourCymbals = {
		Routine({
			var synth;
			(beat * 12).wait;
			4.do {
				s.bind { Synth(\buildupCymbal) };
				beat.wait;
			};
		}).play;
	};

	playRhythmSection = { |kick = true, bass = true, hatAndClap = true, transition = false, buildup = false|
		[5, 4, 9, 7].do { |note, measure|
			if((measure == 2) and: buildup) {
				Routine({
					(0..(4 * 8) - 1).normalize.do { |cutoff|
						s.bind { Synth(\buildupSnare, [cutoff: cutoff]) };
						(beat / 4).wait;
					};
				}).play;
			};
			4.do { |i|
				if(((i % 2) == 1) and: hatAndClap) {
					s.bind { Synth(\clap); };
				};
				if(kick and: { (transition and: (measure == 3) and: (i > 0)).not }) {
					s.bind { Synth(\kick); };
				};
				(beat / 2).wait;
				if(hatAndClap) {
					s.bind { Synth(\hat); };
					if((i % 2) == 1) {
						Routine({
							(beat / 4).wait;
							s.bind { Synth(\quietHat); };
						}).play;
					};
				};
				if(bass) {
					s.bind { Synth(\bass, [freq: ((root - (12 * 2)) + note).midicps]); };
				};
				(beat / 2).wait;
			};
		};
	};

	playSuperSaw = {
		Routine({
			var synth;
			2.do {
				[
					[0, -3],
					[-1, -5],
					[0, -3],
					[-1, -5],
				].do { |notes|
					4.do {
						notes.do { |note|
							s.bind { synth = Synth(\superSaw, [freq: (root + (12) + note).midicps, out: reverbBus], reverbGroup) };
							0.1.wait;
							s.bind { synth.set(\gate, 0) };
							((beat / 2) - 0.1).wait;
						};
					};
				};
			};
		}).play;
	};

	s.bind { Synth(\intro, [beat: beat, duration: beat * 4]); };
	s.bind { Synth(\reverseCymbal, [duration: beat * 4]); };
	(beat * 4).wait;

	Routine({
		[
			0, \, \, \, \, \, \, \, \, \, \, \, \, \, \, -1,
			0, \, \, \, \, \, \, \, \, \, \, \, \, \, \, \,
			0, \, \, \, \, \, \, \, \, \, \, \, \, \, \, -1,
			0, \, \, \, \, \, \, \, \, \, \, \, \, \, \, \,

			0, \, 0, -3, \, \, \, \, \, \, \, \, 7, 7, \, 4,
			0, \, 0, -3, \, \, \, \, \, \, \, \, 5, 5, \, 4,
			0, \, 0, -3, \, \, \, \, \, \, \, \, 7, 7, \, 4,
			0, \, 0, -3, \, \, \, \, \, \, \, \, 5, 5, \, 4,

			0, \, 0, -3, \, 0, \, 0, \, -1, \, -5, 7, 7, \, 4,
			0, \, 0, -3, \, 0, \, 0, \, -1, \, -5, 5, 5, \, 4,
			0, \, 0, -3, \, 0, \, 0, \, -1, \, -5, 7, 7, \, 4,
			0, \, 0, -3, \, 0, \, 0, \, -1, \, -5, 5, 5, \, 4,

			0, \, 0, -3, \, 0, \, 0, \, -1, \, -5, 7, 7, \, 4,
			0, \, 0, -3, \, 0, \, 0, \, -1, \, -5, 5, 5, \, 4,
			0, \, 0, -3, \, 0, \, 0, \, -1, \, -5, 7, 7, \, 4,
			0, \, 0, -3, \, 0, \, 0, \, -1, \, -5, 5, 5, \, 4,

			0, \, 0, -3, \, 0, \, 0, \, -1, \, -5, 7, 7, \, 4,
			0, \, 0, -3, \, 0, \, 0, \, -1, \, -5, 5, 5, \, 4,
			0, \, 0, -3, \, 0, \, 0, \, -1, \, -5, 7, 7, \, 4,
			0, \, 0, -3, \, 0, \, 0, \, -1, \, -5, 5, 5, \, 4,
		].do { |note, i|
			if(note == \) {
				(beat / 2).wait;
			} {
				Routine({
					var synth;
					if((i % 16) == 13) {
						(beat / 4).wait;
					};
					s.bind { synth = Synth(\lead, [freq: (root + note + 12).midicps, out: reverbBus], reverbGroup); };
					((beat / 2) * 0.7).wait;
					s.bind { synth.set(\gate, 0); };
				}).play;
				(beat / 2).wait;
			};
		};
	}).play;

	playRhythmSection.(kick: true, bass: true, hatAndClap: false);
	playTransition.();
	playReverseCymbal.();
	playRhythmSection.(kick: true, bass: true, hatAndClap: false, transition: true);
	playRhythmSection.(kick: true, bass: true, hatAndClap: true);
	playTransition.();
	playReverseCymbal.();
	playFourCymbals.();
	playRhythmSection.(kick: true, bass: true, hatAndClap: true, transition: true, buildup: true);

	s.bind { Synth(\kick); };

	{
		2.do { |i|
			playTransition.();
			if(i == 1) {
				playReverseCymbal.();
			};
			[
				[5, 5 + 7, 5 + 12 + 4],
				[4, 4 + 7, 4 + 12 + 3],
				[9, 9 + 7, 9 + 12 + 3],
				[7, 7 + 7, 7 + 12 + 4],
			].do { |chord|
				var synths;
				s.bind {
					synths = chord.collect({ |note|
						[1, 2].collect { |scale|
							Synth(\pad, [freq: (root + note - (12 * 2)).midicps, scale: scale, out: reverbBus], reverbGroup);
						};
					}).flat;
				};
				(beat * 4).wait;
				s.bind {
					synths.do { |synth| synth.set(\gate, 0); };
				};
			};
		};
	}.();

	s.bind { Synth(\kick); };
	s.bind { Synth(\intro, [beat: beat, duration: beat * 4]); };

	Routine({
		(0..(4 * 32) - 1).normalize.do { |cutoff, i|
			var repeats;
			repeats = if(i >= (4 * (32 - 4)), 2, 1);
			repeats.do {
				s.bind { Synth(\buildupSnare, [cutoff: cutoff]) };
				((beat / 4) / repeats).wait;
			};
		};
	}).play;

	Routine({
		(beat * 16).wait;
		playTransition.();
		playReverseCymbal.();
		playFourCymbals.();
	}).play;
	s.bind { Synth(\cutoffEnv, [out: cutoffBus, duration: 32 * beat]); };

	{
		var play, cutoff;
		play = { |note, duration, sustain = 0.1, cutoff = 0|
			var synth;
			s.bind { synth = Synth(\resonantBass, [freq: (root + note - (12 * 2)).midicps, cutoff: cutoffBus.asMap]); };
			sustain.wait;
			s.bind { synth.set(\gate, 0); };
			((duration * beat) - sustain).wait;
		};

		2.do {
			[5, 4, 9, 7].do { |note|
				2.do {
					play.(note, 1 / 2, 0.1);
					play.(note, 1 / 2, 0.2);
					(beat / 4).wait;
					play.(note, 1 / 4, 0.05);
					play.(note, 1 / 2, 0.1);
				};
			};
		};
	}.();

	Routine({
		var play, cutoff;
		play = { |note, duration, sustain = 0.1, cutoff = 0|
			var synth;
			s.bind { synth = Synth(\resonantBass, [freq: (root + note - (12 * 2)).midicps, cutoff: cutoffBus.asMap]); };
			sustain.wait;
			s.bind { synth.set(\gate, 0); };
			((duration * beat) - sustain).wait;
		};

		4.do {
			[5, 4, 9, 7].do { |note|
				2.do {
					play.(note, 1 / 2, 0.1);
					play.(note, 1 / 2, 0.2);
					(beat / 4).wait;
					play.(note, 1 / 4, 0.05);
					play.(note, 1 / 2, 0.1);
				};
			};
		};
	}).play;

	playRhythmSection.(kick: true, bass: false, hatAndClap: true);
	playRhythmSection.(kick: true, bass: false, hatAndClap: true);
	playSuperSaw.();
	playRhythmSection.(kick: true, bass: false, hatAndClap: true);
	playRhythmSection.(kick: true, bass: false, hatAndClap: true);
	s.bind { Synth(\kick); };

}).play;
)