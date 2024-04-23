().play

{16 * (2 ** (LFNoise2.kr(3) * 0.3))}.plot(10)

{~lfo2.(4)}.plot(5)
(

var lfo2;

lfo2 = { |rate|
	LFNoise2.kr(rate * 0.1) + (LFNoise2.kr(rate) / 4) + TRand.kr(-1, 1, Dust.kr(rate * 0.5)).lag(0.01);
};

~lfo2 = lfo2;

SynthDef(\guitar2, {
	var snd, fb, trigger, exciter;
	trigger = Impulse.ar(16 * (2 ** (LFNoise2.kr(3) * 0.3)));
	exciter = SinOsc.ar(Env.perc(0, 0.01).ar(gate: trigger).linexp(0, 1, 100, TExpRand.ar(3000, 16000, trigger))) * Env.perc(0.0, 0.05).ar(gate: trigger);
	snd = Pluck.ar(exciter, trigger, 0.2, 1 / (\freq.kr(50) * [1, 2, 3] * (({ lfo2.(1) } ! 3) * 0.1).midiratio), 3.0, 0.5);
	snd = snd * [0, -5, -8].dbamp;
	snd = snd.sum;
	snd = snd ! 2;
/*
	fb = LocalIn.ar(2);
	fb = DelayC.ar(fb, 0.2, 0.01 * (lfo2.(1) * 3).midiratio * TExpRand.ar(0.1, 1.0, Dust.ar(5)));
	fb = fb * lfo2.(0.3).linlin(-1, 1, 0, -30).dbamp;
	snd = snd + fb;

	snd = LeakDC.ar(snd);
	snd = snd * Line.ar(0, 1, 30).squared;

	snd = BLowShelf.ar(snd, 200 * ExpRand(0.7, 1.0), 1, -5 + lfo2.(0.1));
	snd = BHiShelf.ar(snd, 3200 * ExpRand(0.7, 1.0), 1, -5 + lfo2.(0.1));
	snd = (snd * 60).tanh + snd.fold2;
	snd = BLowShelf.ar(snd, 200 * ExpRand(0.7, 1.0), 1, 3 + lfo2.(0.1));
	snd = BHiShelf.ar(snd, 3000 * ExpRand(0.7, 1.0), 1, 5 + lfo2.(0.1));

	snd = DelayC.ar(snd, 0.2, LFNoise2.kr(3 ! 2).linlin(-1, 1, 0, 1) * 1e-3 * ExpRand(0.7, 1.0)) + GVerb.ar(snd.sum * -10.dbamp, ExpRand(10, 20), 3, 0.7);
	LocalOut.ar(snd);

	snd = BLowShelf.ar(snd, 200, 1, 5);
	snd = BHiShelf.ar(snd, 2200, 1, -5);
	snd = BHiShelf.ar(snd, 7200, 1, -10);

	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));

	snd = snd * -30.dbamp;
    */
	Out.ar(\out.kr(0), snd);
}).add;


)

g = Synth(\guitar2)

(
var lfo;

lfo = { |rate|
	LFNoise2.kr(rate * 0.1) + (LFNoise2.kr(rate) / 4) + TRand.kr(-1, 1, Dust.kr(rate * 0.5)).lag(0.01);
};

SynthDef(\guitar, {
	var snd, fb, trigger, exciter;
	trigger = Impulse.ar(16 * (2 ** (LFNoise2.kr(3) * 0.3)));
	exciter = SinOsc.ar(Env.perc(0, 0.01).ar(gate: trigger).linexp(0, 1, 100, TExpRand.ar(3000, 16000, trigger))) * Env.perc(0.0, 0.05).ar(gate: trigger);
	snd = Pluck.ar(exciter, trigger, 0.2, 1 / (\freq.kr(50) * [1, 2, 3] * (({ lfo.(1) } ! 3) * 0.1).midiratio), 3.0, 0.5);
	snd = snd * [0, -5, -8].dbamp;
	snd = snd.sum;
	snd = snd ! 2;

	fb = LocalIn.ar(2);
	fb = DelayC.ar(fb, 0.2, 0.01 * (lfo.(1) * 3).midiratio * TExpRand.ar(0.1, 1.0, Dust.ar(5)));
	fb = fb * lfo.(0.3).linlin(-1, 1, 0, -30).dbamp;
	snd = snd + fb;

	snd = LeakDC.ar(snd);
	snd = snd * Line.ar(0, 1, 30).squared;

	snd = BLowShelf.ar(snd, 200 * ExpRand(0.7, 1.0), 1, -5 + lfo.(0.1));
	snd = BHiShelf.ar(snd, 3200 * ExpRand(0.7, 1.0), 1, -5 + lfo.(0.1));
	snd = (snd * 60).tanh + snd.fold2;
	snd = BLowShelf.ar(snd, 200 * ExpRand(0.7, 1.0), 1, 3 + lfo.(0.1));
	snd = BHiShelf.ar(snd, 3000 * ExpRand(0.7, 1.0), 1, 5 + lfo.(0.1));

	snd = DelayC.ar(snd, 0.2, LFNoise2.kr(3 ! 2).linlin(-1, 1, 0, 1) * 1e-3 * ExpRand(0.7, 1.0)) + GVerb.ar(snd.sum * -10.dbamp, ExpRand(10, 20), 3, 0.7);
	LocalOut.ar(snd);

	snd = BLowShelf.ar(snd, 200, 1, 5);
	snd = BHiShelf.ar(snd, 2200, 1, -5);
	snd = BHiShelf.ar(snd, 7200, 1, -10);

	snd = Balance2.ar(snd[0], snd[1], \pan.kr(0));

	snd = snd * -30.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass, {
	var snd, trigger, exciter, fb;
	trigger = Impulse.ar(0);
	exciter = SinOsc.ar(Env.perc(0, 0.01).ar(gate: trigger).linexp(0, 1, 50, TExpRand.ar(12000, 16000, trigger))) * Env.perc(0.0, 0.01).ar(gate: trigger);
	snd = Pluck.ar(exciter, trigger, 0.2, 1 / (\freq.kr(50)), 30.0, 0.9);
	snd = snd ! 2;

	snd = snd + HPF.ar((snd * 10).tanh * -10.dbamp, 300);
	snd = snd + CombC.ar(snd, 0.2, 1 / 63, 0.03);
	snd = snd + CombC.ar(snd, 0.2, 1 / 95, 0.03);
	snd = LeakDC.ar(snd);
	snd = BRF.ar(snd, \freq.kr(50) * 2, 0.01);

	snd = snd * (1 + (BPF.ar({ WhiteNoise.ar } ! 2, 10120, 0.1) * -10.dbamp));
	snd = (snd * 10).tanh;
	snd = LPF.ar(snd, XLine.kr(8000, 1000, 0.1));

	snd = (snd * -1.dbamp) + (SinOsc.ar(\freq.kr(50) * XLine.ar(8, 1, 0.001)) * Env.perc(0.001, 3.0).ar);

	snd = snd + LocalIn.ar(2);
	fb = snd;
	fb = DelayC.ar(fb, 0.9, [0.7, 0.6]);
	fb = fb * -0.1.dbamp;
	fb = LeakDC.ar(fb);
	fb = LPF.ar(fb, 8000);
	fb = HPF.ar(fb, 100);
	fb = (fb * 3.dbamp).tanh;
	fb = fb + DelayC.ar(fb.reverse * -10.dbamp, 0.05, 0.05);
	LocalOut.ar(fb);
	snd = snd + HPF.ar((snd * 2).tanh * -10.dbamp, 3000);

	snd = LPF.ar(snd * 5.dbamp, 100) + HPF.ar(snd, 3000);
	snd = snd + HPF.ar(LPF.ar(GVerb.ar(snd.sum * -10.dbamp, 50, 3, damping: 0.7), 3000), 100);

	snd = snd * Env.perc(0, 10.0).ar(Done.freeSelf);

	snd = snd * -1.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\tremoloRiff, {
	var snd, fb, trigger, exciter, freq, env;
	env = Env.linen(0.01, 1.5, 0.6, curve: -3).ar;
	freq = \freq.kr(67.midicps) * Env(
		[-5, -5, 0, 0, 7, 7 - 0.1, 6.4],
		[0.3, 0.3, 0.4, 0.3, 0.4, 0.1],
		curve: -3
	).ar.midiratio * (LFNoise2.kr(1) * 0.1).midiratio;
	trigger = Impulse.ar(19 * (2 ** (LFNoise2.kr(3) * 0.3)));
	exciter = SinOsc.ar(Env.perc(0.002, 0.01).ar(gate: trigger).linexp(0, 1, 100, TExpRand.ar(3000, 16000, trigger))) * Env.perc(0.001, 0.01).ar(gate: trigger);
	snd = Pluck.ar(exciter, trigger, 0.2, 1 / freq, 3.0, 0.5);
	snd = snd * [0, -5, -8].dbamp;
	snd = snd.sum;
	snd = snd ! 2;

	// these envelopes are really fiddly, one of many cases where graphical automations would help
	// but I haaaate making and using GUIs in SC
	snd = snd * env;

	snd = snd + LPF.ar(LocalIn.ar(2) * -5.dbamp * env, 1000);
	snd = LeakDC.ar(snd);
	snd = BLowShelf.ar(snd, 200 * ExpRand(0.7, 1.0), 1, -5 + lfo.(0.1));
	snd = BHiShelf.ar(snd, 3200 * ExpRand(0.7, 1.0), 1, -5 + lfo.(0.1));
	snd = (snd * 30).tanh + LPF.ar((snd * 3).fold2, 3000);
	snd = BLowShelf.ar(snd, 200 * ExpRand(0.7, 1.0), 1, 3 + lfo.(0.1));
	snd = BHiShelf.ar(snd, 3000 * ExpRand(0.7, 1.0), 1, 5 + lfo.(0.1));
	snd = snd + HPF.ar(LPF.ar(GVerb.ar(snd.sum * -20.dbamp, 50, 3, damping: 0.7), 3000), 100);
	LocalOut.ar(snd);
	snd = snd * Env.linen(0, 4.0, 3.0, curve: -4).ar(Done.freeSelf);

	snd = snd * -22.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\tremoloRiff2, {
	var snd, fb, trigger, exciter, freq, env;
	env = Env.linen(0.1, 1.5, 3.0, curve: -3).ar;
	freq = \freq.kr(67.midicps) * Env(
		[2.0, 3, 3 - 0.1, 2.4],
		[0.3, 0.5, 0.3],
		curve: -3
	).ar.midiratio * (LFNoise2.kr(1) * 0.1).midiratio;
	trigger = Impulse.ar(19 * (2 ** (LFNoise2.kr(3) * 0.3)));
	exciter = SinOsc.ar(Env.perc(0.002, 0.01).ar(gate: trigger).linexp(0, 1, 100, TExpRand.ar(3000, 16000, trigger))) * Env.perc(0.001, 0.01).ar(gate: trigger);
	snd = Pluck.ar(exciter, trigger, 0.2, 1 / freq, 3.0, 0.5);
	snd = snd ! 2;

	snd = snd * env;

	snd = snd + LPF.ar(LocalIn.ar(2) * -5.dbamp * env.linlin(0, 1, -5, 0).dbamp, 1000);
	snd = LeakDC.ar(snd);
	snd = BLowShelf.ar(snd, 200 * ExpRand(0.7, 1.0), 1, -5 + lfo.(0.1));
	snd = BHiShelf.ar(snd, 3200 * ExpRand(0.7, 1.0), 1, -5 + lfo.(0.1));
	snd = (snd * 30).tanh + LPF.ar((snd * 3).fold2, 3000);
	snd = BLowShelf.ar(snd, 200 * ExpRand(0.7, 1.0), 1, 3 + lfo.(0.1));
	snd = BHiShelf.ar(snd, 3000 * ExpRand(0.7, 1.0), 1, 5 + lfo.(0.1));
	snd = snd + HPF.ar(LPF.ar(GVerb.ar(snd.sum * -30.dbamp, 20, 3, damping: 0.7), 3000), 100);
	LocalOut.ar(snd);

	snd = snd + HPF.ar(LPF.ar(GVerb.ar(snd.sum * -20.dbamp, 50, 3, damping: 0.7), 3000), 100);
	snd = snd * Env.linen(0, 1.0, 3.0, curve: -4).ar(Done.freeSelf);

	snd = snd * -22.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\fx, {
	var snd;
	snd = In.ar(\out.kr(0), 2);
	snd = LeakDC.ar(snd);
	snd = snd + GVerb.ar(snd.sum * -30.dbamp, 60, 1, damping: 0.7);
	snd = Limiter.ar(snd);
	ReplaceOut.ar(\out.kr(0), snd);
}).add;
)

(
var s, root;
s = Server.default;

root = 50;
Routine({
	s.bind { Synth.tail(nil, \fx) };
	(0..5).normalize.linlin(0, 1, -0.7, 0.7).do { |pan, i|
		s.bind { Synth(\guitar, [pan: pan, freq: root * [1, 4, 1, 4 * 1.midiratio, 2, 1][i]]) };
	};
	20.0.wait;
	2.do {
		s.bind { Synth(\bass, [freq: root]) };
		8.0.wait;
		s.bind { Synth(\bass, [freq: root * -4.midiratio]) };
		4.0.wait;
	};
	inf.do {
		s.bind { Synth(\bass, [freq: root]) };
		3.0.wait;
		s.bind { Synth(\tremoloRiff, [freq: root * (2 ** 3)]) };
		3.0.wait;
		s.bind { Synth(\bass, [freq: root * -4.midiratio]) };
		1.0.wait;
		s.bind { Synth(\tremoloRiff2, [freq: root * (2 ** 3)]) };
		3.0.wait;
	};
}).play;
)


(
    {
    var pitch = MouseY.kr(200, 1000).round(50);
    Pluck.ar(WhiteNoise.ar(0.1), Impulse.kr(2), pitch.reciprocal, pitch.reciprocal, 10,
        coef:MouseX.kr(-0.999, 0.999))
    }.play(s)
)
   