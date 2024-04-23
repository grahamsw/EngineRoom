(
SynthDef(\mallet, {
	var snd, freq, velocity;
	velocity = \velocity.kr(1);
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq * [1, 2.03, 3.3, 5.4, 7.9] * ([0] ++ (Hasher.kr(freq + [0, 1, 2]) * [0.1, 0.2, 0.3])).midiratio);
	snd = snd * Env.perc(0, [1, 0.2, 0.1, 0.003, 0.01]).ar;
	snd = snd * [0, -10, -3, -5, -8].dbamp * ({ Rand(0.5, 1) } ! 2);
	snd = snd.sum;
	snd = snd + (BPF.ar(WhiteNoise.ar, 5120, 0.7) * Env.perc(0.001, 0.01).ar * -10.dbamp);
	snd = snd.tanh;
	snd = snd * (1 + (1 * Env.perc(0, 0.01).ar));
	snd = snd * Env.perc(ExpRand(0.001, 0.005), 0.2 * (440 / freq).squared * velocity * Rand(1, 3)).ar(Done.freeSelf);
	snd = snd * velocity.sqrt;
	snd = snd * -15.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\pad1, {
	var snd, freq, velocity;
	velocity = \velocity.kr(1);
	freq = \freq.kr(440) * (LFNoise2.kr(8 ! 8) * 0.1).midiratio;
	snd = SinOsc.ar(freq, Rand(0, 2pi ! 8)) * Rand(500, 2000 ! freq.size);
	snd = SinOsc.ar(freq + snd);
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, 500 * (2 ** LFNoise2.kr(3))) + BPF.ar(snd * -9.dbamp, 1320 * ExpRand(0.5, 2), 0.3);
	snd = snd * Line.ar(0, 1, 0.1);
	snd = snd * Env.linen(0, \duration.kr(1), 5, curve: -8).ar(Done.freeSelf);
	snd = snd * velocity.sqrt;
	snd = snd * -22.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\pad2, {
	var snd, freq, velocity;
	velocity = \velocity.kr(1);
	freq = \freq.kr(440) * (LFNoise2.kr(8 ! 8) * 0.1).midiratio;
	snd = SinOsc.ar(freq, Rand(0, 2pi ! 8)) * Rand(500, 2000 ! freq.size);
	snd = SinOsc.ar(freq + snd);
	snd = Splay.ar(snd);
	snd = BPF.ar(snd, LFNoise2.kr(1).linexp(-1, 1, 100, 3000), 0.1);
	snd = snd * LFNoise2.kr(8 ! 2);
	snd = snd * Line.ar(0, 1, 0.1);
	snd = snd * Env.linen(0, \duration.kr(1), 2, curve: -8).ar(Done.freeSelf);
	snd = snd * velocity.sqrt;
	snd = snd * -23.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass, {
	var snd, freq, velocity;
	velocity = \velocity.kr(1);
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq * [1, 2, 4] * (XLine.ar(1.5, 1, 0.02 * velocity) ** velocity), 0.5pi);
	snd = snd * [0, velocity.linlin(0, 1, -5, -10), -10].dbamp;
	snd = snd.sum;
	snd = snd.tanh;
	snd = snd * Line.ar(0, 1, 0.001);
	snd = snd * (1 + Env.perc(0.001, 0.01).ar);
	snd = snd * (1 + Env.perc(0.0, 0.1).ar);
	snd = snd * Env.linen(0.001, \duration.kr(1), 0.3 * (60 / freq), curve: -4).ar(Done.freeSelf);
	snd = snd * velocity.sqrt;
	snd = snd * -12.dbamp;
	snd = Pan2.ar(snd, 0);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\guitar, {
	var snd, freq, velocity;
	velocity = \velocity.kr(1);
	freq = \freq.kr(440);
	snd = Pluck.ar(PinkNoise.ar + (SinOsc.ar(XLine.ar(ExpRand(4000, 8000), 100, 0.01)) * -10.dbamp), Impulse.ar(0), 0.1, 1 / freq, 3.0, Rand(0.1, 0.9));
	snd = LeakDC.ar(snd);
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = (snd * -3.dbamp).tanh;
	snd = BHiShelf.ar(snd, ExpRand(1000, 3000), 0.3, -5);
	3.do {
		snd = snd + CombC.ar(snd, 0.1, 1 / ExpRand(50, 200), 0.01);
	};
	snd = LeakDC.ar(snd);
	snd = snd.tanh;
	snd = LPF.ar(snd, XLine.ar(3000, 100, 0.3));
	snd = snd * Env.linen(0, \duration.kr(1), 0.03, curve: -4).ar(Done.freeSelf);
	snd = snd * velocity.sqrt;
	snd = snd * -15.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\perc, {
	var snd, freq, velocity;
	velocity = \velocity.kr(1);
	freq = \freq.kr(440);
	snd = SinOsc.ar(freq * [1, 2.63, 4.7, 6.4, 8.9] * ([0] ++ (Hasher.kr(freq + (1..4)) * 3)).midiratio);
	snd = snd * Env.perc(0, [1, 0.2, 0.1, 0.03, 0.01]).ar;
	snd = snd * [0, -10, -3, -5, -8].dbamp * ({ Rand(0.1, 1) } ! snd.size);
	snd = snd.sum;
	snd = snd * (1 + (SinOsc.ar(Hasher.kr(freq).linlin(-1, 1, 100, 420)) * Env.perc(0, 0.1).ar));
	snd = snd + (BPF.ar(WhiteNoise.ar, 5120, 0.7) * Env.perc(0.001, 0.01).ar * -8.dbamp);
	snd = snd.tanh;
	snd = snd + CombC.ar(snd, 0.1, 1 / ExpRand(50, 200), 0.01);
	snd = snd * freq.explin(500, 1000, 0, -5).dbamp;
	snd = snd * Env.perc(ExpRand(0.001, 0.01), 0.1 * velocity * Rand(1, 3)).ar(Done.freeSelf);
	snd = snd * velocity.sqrt;
	snd = snd * -15.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\warble, {
	var snd, freq, velocity, duration, env, rate;
	duration = \duration.kr(1);
	velocity = \velocity.kr(1);
	rate = XLine.ar(1, 2, 1);
	freq = \freq.kr(440);
	env = Env.linen(0.03, duration, duration, curve: -4).ar(Done.freeSelf);
	snd = SinOsc.ar(freq * 4.01) * 2000 * (1 + env + (2 * LFNoise2.kr((3 * rate) ! 2)));
	snd = SinOsc.ar(freq + snd);
	snd = snd * env;
	snd = snd * LFNoise2.kr(8 * rate ! 2).linlin(-1, 1, 0.7, 1.0);
	snd = snd.tanh;
	snd = BHiShelf.ar(snd, 2120, 1, -10);
	snd = snd * velocity.sqrt;
	snd = snd * -21.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\delay, {
	var snd, fb;
	snd = In.ar(\in.kr(0), 2);
	snd = snd + LocalIn.ar(2);
	fb = snd;
	fb = DelayC.ar(fb, 1.0, 0.7 + (1e-3 * SinOsc.ar(1, [0, pi])));
	fb = fb * -3.dbamp;
	fb = fb + PitchShift.ar(fb * -5.dbamp, 0.2, 2.0, 1e-3, 1e-3);
	fb = fb + PitchShift.ar(fb * -5.dbamp, 0.2, 0.5, 1e-3, 1e-3);
	fb = HPF.ar(fb, 100);
	fb = LPF.ar(fb, 3000);
	fb = fb.tanh;
	LocalOut.ar(fb);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\fx, {
	var snd;
	snd = In.ar(\out.kr(0), 2);
	snd = snd + HPF.ar(GVerb.ar(snd.sum * -30.dbamp, 40, 1, damping: 0.5), 200);
	snd = Limiter.ar(snd);
	ReplaceOut.ar(\out.kr(0), snd);
}).add;
)

(
var root, noteToFreq;
var s, bpm, beat, tatum;
s = Server.default;
bpm = 96;
beat = 60 / bpm;
tatum = beat / 4;

noteToFreq = { |note|
	var result, root;
	root = (60 - 6 + 2).midicps;
	result = root * (2 ** (note.div(12))) * [
		1,
		1.midiratio,
		9 / 8,
		6 / 5,
		5 / 4,
		4 / 3,
		6.midiratio,
		3 / 2,
		8.midiratio,
		5 / 3,
		10.midiratio,
		15 / 8,
	][note % 12];
	1 / ((1 / result) + 1e-6);
};

Routine({
	var warbleBus;
	var playMallet, playPad, playBass, playPerc, playGuitar, playWarble, playPad2;
	var launchMallets, launchBass, launchDrums, launchGuitar, launchMelody;

	s.bind {
		warbleBus = Bus.audio(nil, 2);
		Synth.tail(nil, \delay, [in: warbleBus, out: 0]);
		Synth.tail(nil, \fx);
	};

	playMallet = { |note, velocity, delay = 0, pan = 0.0|
		Routine({
			delay.wait;
			s.bind { Synth(\mallet, [freq: noteToFreq.(note), velocity: velocity, pan: pan]) };
		}).play;
	};

	playPad = { |duration, notes, velocity, delay = 0, pan = 0.0|
		playPad2.(duration, notes);
		Routine({
			delay.wait;
			notes.do { |note|
				s.bind { Synth(\pad1, [duration: duration * beat, freq: noteToFreq.(note), velocity: velocity, pan: pan]) };
			};
		}).play;
	};

	playPad2 = { |duration, notes, velocity, delay = 0, pan = 0.0|
		Routine({
			delay.wait;
			notes.do { |note|
				s.bind { Synth(\pad2, [duration: duration * beat, freq: noteToFreq.(note) * 2, velocity: velocity, pan: pan]) };
			};
		}).play;
	};

	playBass = { |duration, note, velocity|
		s.bind { Synth(\bass, [duration: duration * beat, freq: noteToFreq.(note) * (2 ** (-2)), velocity: velocity]) };
	};

	playPerc = { |duration, note, velocity|
		if((1 / 30).coin) {
			Routine({
				var args;
				args = [freq: [430, 900, 930].choose, pan: [-0.5, 0, 0.5].choose];
				[1, 0.5, 0.2, 0.3, 1.0].do { |velocityScale|
					s.bind { Synth(\perc, args ++ [velocity: velocity * velocityScale * 0.7]) };
					(tatum / 4).wait;
				};
			}).play;
		} {
			Routine({
				rrand(0, 0.01).wait;
				s.bind { Synth(\perc, [freq: [100, 230, 600, 830].choose, velocity: velocity, pan: [-0.5, 0, 0.5].choose]) };
			}).play;
		};
	};

	playGuitar = { |duration, note, velocity = 0.5, delay = 0|
		Routine({
			delay.wait;
			s.bind { Synth(\guitar, [duration: duration, freq: noteToFreq.(note), velocity: velocity, pan: [-0.3, 0.3].choose]) };
		}).play;
	};


	launchMallets = { |chord, length = 20|
		Routine({
			length.do { |i|
				var probability;
				probability = [9, 6, 3, 9, 2, 6, 9, 4, 9, 3, 9, 4, 9, 3].wrapAt(i) / 10;
				3.do {
					if(probability.coin) {
						playMallet.(chord.choose, probability * rrand(0.5, 1.0), rrand(0, 0.01), pan: rrand(-1.0, 1.0) * 0.5);
					};
				};
				tatum.wait;
			};
		}).play;
	};

	launchBass = { |notes|
		Routine({
			notes.do { |note, i|
				if(note != \) {
					playBass.(
						if((notes.wrapAt(i + 1) == \) and: { (i % 2) == 0 }, tatum * [1, 2].choose, tatum * [0.5, 0.9].choose),
						note,
						rrand(0.5, 1) * [1, 0.3, 0.9, 0.3].wrapAt(i)
					);
				};
				tatum.wait;
			};
		}).play;
	};

	launchDrums = { |length = 20|
		Routine({
			length.do { |i|
				var probability;
				probability = [9, 6, 3, 9, 2, 6, 9, 4, 9, 3, 9, 4, 9, 3].wrapAt(i) / 10;
				4.do {
					if(probability.coin) {
						playPerc.(duration: tatum, velocity: probability);
					};
				};
				tatum.wait;
			};
		}).play;
	};

	launchGuitar = { |chord, length = 20|
		Routine({
			length.do { |i|
				var probability;
				probability = [9, 6, 3, 9, 2, 6, 9, 4, 9, 3, 9, 4, 9, 3].wrapAt(i) / 10;
				3.do {
					if(probability.coin) {
						playGuitar.(tatum, chord.choose, probability * rrand(0.5, 1.0), rrand(0, 0.02));
					};
				};
				tatum.wait;
			};
		}).play;
	};

	launchMelody = {
		var wait, playWarble, playGrace;

		wait = { |duration|
			(duration * beat).wait;
		};

		playWarble = { |duration, note, velocity = 0.5, delay = 0|
			s.bind { Synth(\warble, [duration: duration * beat, freq: noteToFreq.(note) * (2 ** 2), velocity: velocity, out: warbleBus]) };
			(duration * beat).wait;
		};

		playGrace = { |duration, notes|
			notes.do { |note, i|
				playWarble.(if(i == (notes.size - 1), duration - (0.1 * (notes.size - 1)), 0.1), note);
			};
		};

		Routine({

			// Phrase 1
			wait.(5);
			playGrace.(6, [9, 7, 4]);
			playWarble.(4, -1);
			playGrace.(5, [0, 2, 0, -5]);

			// Phrase 2
			wait.(5);
			playGrace.(5, [-5, 0, 2, 4, 7, 4]);
			playWarble.(3, -1);
			playGrace.(2, [0, 2, 0, -3]);
			playWarble.(5, -5);

			// Phrase 3
			playGrace.(1, [-5, 0]);
			wait.(1);
			playGrace.(3, [9, 7, 4]);
			playGrace.(3, [7, 2]);
			wait.(2);
			playGrace.(5, [9, 7, 4, 2, 0, -5]);
			wait.(2);
			playGrace.(5, [-5, 2, 0]);

			// Turnaround thing
			wait.(1);
			playGrace.(4, 2 + [-12 + 3, -7, -5, -2, 0]);
			wait.(1);
			playGrace.(2, [4, 2]);
			wait.(1);
			playGrace.(1 + 1, [4, 2]);
			playGrace.(4, [4, -5]);
			playGrace.(5, [0, 2, 4, 0]);
			// G-flat chord starts here
			wait.(5);
			playGrace.(5, [2, 4, 7]);
			playGrace.(5, [9, 5]);
		}).play;
	};

	launchMelody.();

	3.do {
		launchDrums.();
		launchGuitar.([0, 7, 12, 12 + 2, 12 + 4]);
		launchBass.([0, \, 7, 12, \, 7, 0, \, 12, \, 7, \, 0, \, 12 + 2, 12, \, 7, 0, \]);
		launchMallets.([0, 4, 7, 12, 12 + 4]);
		playPad.(5, notes: [0, 12], velocity: 0.5);
		(beat * 5).wait;

		launchDrums.();
		launchGuitar.([0, 7, 12, 12 + 2, 12 + 4]);
		launchBass.(4 + [0, \, 7, 12, \, 7, 0, \, 12, \, 7, \, 0, \, 7, 12, \, 7, 0, \]);
		launchMallets.([0, 4, 7, 12 - 1, 12, 12 + 2, 12 + 4]);
		playPad.(5, notes: [7, 12 - 1, 12], velocity: 0.5);
		(beat * 5).wait;

		launchDrums.();
		launchGuitar.([0, 7, 12, 12 + 2, 12 + 4]);
		launchBass.(5 + [0, \, 7, 12 + 2, \, 7, 0, \, 12 + 2, \, 7, \, 0, \, 12 + 2, 12, \, 0, 7, \]);
		launchMallets.([0, 4, 7, 12 - 1, 12, 12 + 2, 12 + 4]);
		playPad.(5, notes: [12 - 3, 12], velocity: 0.5);
		(beat * 5).wait;

		launchDrums.();
		launchGuitar.([0, 7, 12, 12 + 2, 12 + 4]);
		launchBass.(5 + [0, \, 7, 12 + 2, \, 7, 0, \, 12, \, 7, \, 0, \, 12 + 7, 12 + 4, 12 + 2, 7 + 2, 7, 2]);
		launchMallets.([0, 5, 7, 12 - 1, 12, 12 + 2, 12 + 4]);
		playPad.(5, notes: 5 + [4, 7, 11], velocity: 0.5);
		(beat * 5).wait;
	};

	// Not sure about this part
	/*
	launchDrums.();
	launchGuitar.([0, 7, 12, 12 + 2, 12 + 4], length: 10);
	launchBass.([0, \, 7, 12, \, 7, 0, \, 12, \]);
	launchMallets.([0, 4, 7, 12, 12 + 4], length: 10);
	(beat * 5 / 2).wait;
	launchGuitar.(5 + [0, 2, 7], length: 10);
	launchBass.(5 + [0, \, 7, 12, \, 2, 0, \, 7, \]);
	launchMallets.([0, 5, 7, 12, 12 + 4], length: 10);
	(beat * 5 / 2).wait;

	launchDrums.();
	launchGuitar.([0, 7, 12, 12 + 2, 12 + 4], length: 10);
	launchBass.(4 + [0, \, 7, 12, \, 7, 0, \, 12, \]);
	launchMallets.([0, 4, 7, 12 - 1, 12, 12 + 2, 12 + 4], length: 10);
	(beat * 5 / 2).wait;
	launchGuitar.(4 + [0, 3, 7, 8], length: 10);
	launchBass.(-3 + [12, \, 0, 10, 0, \, 7, 12, \, 7]);
	launchMallets.([0, 4, 7, 12 - 1, 12, 12 + 2, 12 + 4], length: 10);
	(beat * 5 / 2).wait;
	*/

	launchDrums.();
	launchGuitar.(2 + [0, 7, 12, 12 + 2, 12 + 3]);
	launchBass.(2 + [0, \, 7, 12, \, 7, 0, \, 12, \, 12 + 2, 12, \, 0, 7, \, 0, \, 12, 7]);
	launchMallets.([0, 4, 7, 12, 12 + 4]);
	playPad.(5, notes: 2 + [0, 7, 12 - 2, 12 + 3], velocity: 0.5);
	(beat * 5).wait;

	launchDrums.();
	launchGuitar.(7 + [-5, 0, 4, 5, 7]);
	launchBass.(7 + [0, \, 7, 12, \, 7, 0, \, 12, \, 12 + 2, 12, \, 0, 7, \, 0, \, 12, 7]);
	launchMallets.(7 + [0, 4, 7, 12, 12 + 4]);
	playPad.(5, notes: 7 + [0, 4, 7, 12 - 2], velocity: 0.5);
	(beat * 5).wait;

	launchDrums.();
	launchGuitar.([0, 7, 12, 12 + 2, 12 + 4]);
	launchBass.([0, \, 7, 12, \, 7, 0, \, 12, \, 7, \, 0, \, 12 + 2, 12, \, 7, 0, \]);
	launchMallets.([0, 4, 7, 12, 12 + 4]);
	playPad.(5, notes: [0, 7, 12 - 1, 12 + 4], velocity: 0.5);
	(beat * 5).wait;

	launchDrums.();
	launchGuitar.(5 + [0, 2, 7]);
	launchBass.(5 + [0, \, 7, 12, \, 7, 0, \, 12, \, 7, \, 0, \, 12 + 2, 12, \, 7, 0, \]);
	launchMallets.([0, 5, 7, 12, 12 + 4]);
	playPad.(5, notes: 5 + [0, 4, 7, 12 - 1], velocity: 0.5);
	(beat * 5).wait;

	// G-flat
	launchDrums.();
	launchGuitar.(-2 + [0, 7, 12, 12 + 4]);
	launchBass.(-2 + [0, \, 7, 12, \, 7, 0, \, 12, \, 7, \, 0, \, 12 + 2, 12, \, 7, 0, \]);
	launchMallets.(-2 + [0, 7, 12, 12 + 4]);
	playPad.(5, notes: -2 + [0, 7, 12 - 1, 12 + 4], velocity: 0.5);
	(beat * 5).wait;

	launchDrums.();
	launchGuitar.(-2 + [0, 7, 12, 12 + 4]);
	launchBass.(-2 + [0, \, 12, 12 + 7, \, 7, 0, \, 12, \, 7, \, 0, \, 12 + 7, 12, \, 7, 0, \]);
	launchMallets.(-2 + [0, 7, 12, 12 + 4]);
	playPad.(5, notes: -2 + [0, 7, 12 - 1, 12 + 4], velocity: 0.5);
	(beat * 5).wait;

	2.do {
		launchDrums.();
		launchGuitar.(-2 + [0, 7, 12, 12 + 4]);
		launchMallets.(-2 + [0, 7, 12, 12 + 4]);
		(beat * 5).wait;
	};
}).play;
)
