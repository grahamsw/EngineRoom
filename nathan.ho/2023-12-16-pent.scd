(
SynthDef(\pluck, {
	var snd, freq, puffDuration, puff;
	freq = \freq.kr(440) + 1;
	puffDuration = 0.01;
	puff = BPF.ar(PinkNoise.ar, ExpRand(500, 16e3 ! 3), 0.6).sum * Env.perc(puffDuration, 0.001, curve: -4).ar * -20.dbamp;
	snd = Pluck.ar(RLPF.ar(PinkNoise.ar, ExpRand(1200, 8200), 0.3), Impulse.ar(0), 1 / 60, 1 / freq, decaytime: 3 * (220 / freq), coef: 0.82);
	snd = RLPF.ar(snd, ExpRand(440, 780), 0.3);
	snd = snd + Splay.ar(SinOsc.ar(ExpRand(3320, 8e3 ! 6)) * Env.perc(0.0, ExpRand(1e-3, 3e-2 ! 6)).ar * -20.dbamp);
	snd = LeakDC.ar(snd);
	snd = puff + DelayC.ar(snd, puffDuration, puffDuration);
	5.do {
		snd = BPeakEQ.ar(snd, ExpRand(650, 3300), 0.2, 5);
	};
	snd = snd * Env.linen(0, 1, 0.5, curve: -4).ar(Done.freeSelf);
	snd = snd * -1.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

(
var s;
s = Server.default;

Routine({
	3.do {
		[3, 3, 4, 2, 2, 4].do { |beats|
			((60 - 6) + [0, 3, 12]).do { |note|
				s.bind { Synth(\pluck, [freq: note.midicps]) };
			};
			(beats * 0.15).wait;
		};
	};
}).play;
)
