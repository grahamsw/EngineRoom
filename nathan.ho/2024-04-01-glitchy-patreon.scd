(
var lfo;

lfo = { |rate = 1|
	Select.ar(ToggleFF.ar(Dust.ar(rate)), [LFNoise2.ar(rate).fold2, TRand.ar(-1, 1, Dust.ar(rate * 3))]);
};

SynthDef(\kick, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(60 * (1 + (3 * Env.perc(0, 0.19, curve: -6).ar)) * (1 + (2 * Env.perc(0, 0.01).ar)) * XLine.ar(1, 0.7, 0.3));
	snd = snd * (1 + (5 * Env.perc(0, 0.05).ar));
	snd = snd * (1 + (5 * Env.perc(0, 0.003).ar));
	snd = snd.tanh;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 8320, 0.3) * Env.perc(0.001, 0.01).ar * 5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 16320, 0.3) * Env.perc(0.02, 0.05).ar * -1.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 7320, 0.3) * Env.perc(0.0, 0.05).ar * 3.dbamp);
	snd = snd * (1 + (2 * Env.perc(0, 0.05).ar));
	snd = snd.clip2;
	snd = snd * Env.perc(0, 0.5).ar;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -17.dbamp, 0.1, [0.045, 0.065]), 100), 3000);
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\ghostKick, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(60 * (1 + (2 * Env.perc(0, 0.19, curve: -6).ar)) * (1 + (1 * Env.perc(0, 0.01).ar)) * XLine.ar(1, 0.7, 0.3));
	snd = snd * (1 + (5 * Env.perc(0, 0.05).ar));
	snd = snd * (1 + (5 * Env.perc(0, 0.003).ar));
	snd = snd.tanh;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 8320, 0.3) * Env.perc(0.001, 0.01).ar * 5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 16320, 0.3) * Env.perc(0.02, 0.05).ar * -1.dbamp);
	snd = snd.clip2;
	snd = snd * Env.perc(0.01, 0.5).ar;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -20.dbamp, 0.1, [0.045, 0.065]), 100), 3000);
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\snare, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(220 * XLine.ar(1, 0.9, 0.3) * XLine.ar(2, 1, 0.02));
	snd = snd * Env.perc(0.001, 0.1).ar;
	snd = snd + (SinOsc.ar(XLine.ar(3000, 100, 0.01)) * Env.perc(1e-3, 0.02).ar);
	snd = snd + (SinOsc.ar(XLine.ar(8000, 1000, 0.02)) * Env.perc(1e-3, 0.02).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2320, 0.3) * Env.perc(0.01, 0.05).ar * 3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 3320, 0.3) * Env.perc(0.07, 0.3).ar * 4.dbamp);
	snd = snd.clip2;
	snd = snd * Env.perc(0, 0.5).ar;
	snd = snd + PitchShift.ar(snd, 0.023, 1.5);
	snd = snd + PitchShift.ar(snd, 0.01, 1.2);
	snd = snd + PitchShift.ar(snd * -5.dbamp, 0.045, [2.3, 2.4]);
	snd = snd + FreqShift.ar(CombC.ar(snd * -1.dbamp, 0.2, 1 / (230 * XLine.kr(1, 0.5, 0.3)), 0.1), 70);
	snd = snd * (1 + (5 * Env.perc(0, 0.05).ar));
	snd = snd.tanh;
	snd = snd + LPF.ar(HPF.ar(DelayC.ar(snd * -20.dbamp, 0.1, [0.035, 0.055]), 200), 3000);
	snd = snd + GVerb.ar(snd.sum * -40.dbamp, 30, damping: 0.1);
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\glitch1, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = Hasher.ar(Sweep.ar(Impulse.ar(60)) + [0, 1]);
	snd = FreqShift.ar(snd, 32);
	snd = snd * Env([1, 0, 1], duration * [1, 1].normalizeSum, [-4, 4]).ar;
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\glitch2, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = Hasher.ar(Sweep.ar(Impulse.ar(42)) + [0, 1]);
	snd = RHPF.ar(snd, XLine.kr(700, 2000, duration), 0.3);
	snd = snd * (1 + (3 * Env.perc(0, 0.01).ar));
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -15.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;


SynthDef(\glitch3, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = Hasher.ar(Sweep.ar(Impulse.ar(90)) + [0, 1]);
	snd = RLPF.ar(snd, [3210, 1440], 0.3).sum * -5.dbamp;
	snd = (snd * 3).fold2;
	snd = snd * Env([1, 0.5, 1], duration * [1, 1].normalizeSum, [-4, 4]).ar;
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\glitchRandom, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = Saw.ar(Env({ Rand(0, 1) } ! 3, [0.5, 0.5] * duration).ar.linexp(0, 1, 100, 8000));
	snd = RLPF.ar(snd, ExpRand(1000, 8000) * XLine.ar(1, 0.5, duration), 0.1);
	snd = (snd * 2).fold2;
	snd = Latch.ar(snd, Impulse.ar(ExpRand(3000, 15e3)));
	snd = BPF.ar(snd, (0..20).normalize.linexp(0, 1, ExpRand(100, 200), ExpRand(8000, 16e3)), 0.2).sum;
	snd = snd * (1 + (1 * Env.perc(0, 0.01).ar));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;


SynthDef(\glitchRandom2, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(ExpRand(100, 8000)) * Rand(8000, 16e3);
	snd = SinOsc.ar(ExpRand(1000, 8000) + snd);
	snd = snd * (1 + (1 * Env.perc(0, 0.01).ar));
	snd = snd + PitchShift.ar(snd, ExpRand(0.005, 0.05), ExpRand(1.5, 3));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass1, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = Pulse.ar(40);
	snd = FreqShift.ar(snd, 13);
	snd = BPF.ar(snd, XLine.ar(100, 2000, duration), 0.5) * 10.dbamp;
	snd = snd.tanh;
	snd = BPF.ar(snd, (0..20).normalize.linexp(0, 1, 100, 3200), 0.1).sum * 7.dbamp;
	snd = snd + DelayC.ar(snd * -10.dbamp, 0.2, [30e-3, 45e-3]);
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -13.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass2, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = Pulse.ar(47);
	snd = BPF.ar(snd, XLine.ar(3000, 100, duration), 0.3) * 22.dbamp;
	snd = BPF.ar(snd, (0..20).normalize.linexp(0, 1, 100, 3200), 0.1).sum;
	snd = snd + DelayC.ar(snd * -10.dbamp, 0.2, [30e-3, 45e-3]);
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -13.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\hat, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = BPF.ar(Hasher.ar(Sweep.ar), 16320, 0.3) * 5.dbamp;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 12320, 0.1) * 3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 9320, 0.1) * -3.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 13320, 0.05) * 3.dbamp);
	snd = snd * (1 + Env.perc(0.0, 0.01).ar);
	snd = snd * Env.perc(0.0, 0.1).ar;
	snd = snd + GVerb.ar(snd, 7, 3);
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\ping, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(1000);
	snd = snd * (1 + Env.perc(0, 0.01).ar);
	snd = snd * Env.perc(0, 0.1).ar ! 2;
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -10.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\clap, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = Hasher.ar(Sweep.ar);
	snd = BPF.ar(snd, [1523, 2230], 0.3).sum * 9.dbamp;
	snd = snd * Env([0, 1, 0, 1, 0, 1, 0], [1e-3, 1e-2, 1e-3, 1e-2, 1e-3, 0.1]).ar;
	snd = snd ! 2;
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -7.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\chirp1, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = LFTri.ar(Env.perc(0, 0.2, curve: -8).ar.linexp(0, 1, 60, 16000));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\chirp2, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = SinOsc.ar(Env.perc(0, 0.1, curve: -8).ar.linexp(0, 1, 60, 16000));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -8.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;


SynthDef(\glitchRandom3, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = {
		SinOsc.ar(ExpRand(3000, 16e3) * XLine.ar(2, 1, 0.01))
		* Env.perc(0, ExpRand(0.01, 0.05)).ar
	} ! 4;
	snd = Latch.ar(snd, Impulse.ar(ExpRand(3e3, 7e3)));
	snd = BPF.ar(snd, ExpRand(3e3, 16e3), ExpRand(0.1, 0.8));
	snd = snd * Rand(0, 1);
	snd = snd.sum * 2.dbamp;
	snd = Pan2.ar(snd, Rand(-0.9, 0.9));
	snd = snd * Env.linen(0, duration, 0.005, curve: -4).ar(Done.freeSelf);
	snd = snd * -3.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\reverbyThing, {
	var snd, duration;
	duration = \duration.kr(1.0);
	snd = WhiteNoise.ar;
	snd = BPF.ar(snd, XLine.kr(16320, 100, 3), 0.3);
	snd = snd + PitchShift.ar(snd, 0.03, XLine.kr(1, 2.0, 5));
	snd = snd * (1 + SinOsc.ar(XLine.kr(30, 1, 3)));
	snd = snd + GVerb.ar(snd * -10.dbamp, 30, 3);
	snd = snd + DelayC.ar(snd, 0.2, SinOsc.ar(0.4, [0, pi]).linlin(-1, 1, 0, 1) * 1e-3);
	snd = snd * Env.perc(0.3, 8).ar(Done.freeSelf);
	snd = snd * -18.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;


SynthDef(\fx, {
	var snd, trigger1, trigger2;
	// trigger 1 is fast, trigger 2 is slow
	// probably could have called them triggerFast/triggerSlow whatever
	trigger1 = T2A.ar(\trigger1.tr(0));
	trigger2 = T2A.ar(\trigger2.tr(0));
	snd = In.ar(\out.kr(0), 2);
	snd = snd + DelayC.ar(snd * -20.dbamp, 0.2, Select.ar(Latch.ar(TRand.ar(0, 2, trigger1), trigger1), DC.ar([1e-3, 1.5 * 1e-3])));
	snd = snd + LPF.ar(HPF.ar(GVerb.ar(snd.sum * -35.dbamp, 70, 1), 200), 2000);
	snd = snd + PitchShift.ar(snd * -8.dbamp, 0.03, TExpRand.ar(0.5, 2, trigger2));
	snd = snd + PitchShift.ar(snd * -10.dbamp, 0.01, TExpRand.ar(0.5, 2, trigger1));
	snd = snd.clip2;
	ReplaceOut.ar(\out.kr(0), snd);
}).add;
)

(
var s, bpm, beat, tatum;
s = Server.default;
bpm = 170;
beat = 60 / bpm;
tatum = beat / 4;

Routine({
	var play, playParallel, wait, fx;

	wait = { |tatums|
		(tatum * tatums).wait;
	};

	playParallel = { |synthDef, tatums, args = #[], legato = 1|
		s.bind { Synth(synthDef, [duration: tatum * tatums * legato] ++ args) };
	};

	play = { |synthDef, tatums, args = #[], legato = 1|
		s.bind { Synth(synthDef, [duration: tatum * tatums * legato] ++ args) };
		(tatum * tatums).wait;
	};

	s.bind { fx = Synth.tail(nil, \fx); };

	Routine({
		loop {
			s.bind { fx.set(\trigger1, 1) };
			play.(\glitchRandom3, [1, 2, 4].choose);
		};
	}).play;

	Routine({
		loop {
			s.bind { fx.set(\trigger2, 1) };
			wait.(8);
		};
	}).play;

	inf.do {
		play.(\kick, 2);
		4.do {
			play.(\glitch1, 1, legato: 0.5);
		};
		play.(\snare, 2);
		play.(\glitch2, 1, legato: 0.5);
		play.(\glitch1, 6);
		4.do { |i|
			play.(\glitchRandom, 1, [pan: [-0.7, 0.7].wrapAt(i)], legato: 0.3);
		};
		3.do { |i|
			play.(\glitch3, 1, [pan: [-0.3, 0.3].wrapAt(i)], legato: 0.5);
		};
		play.(\kick, 2);
		playParallel.(\kick, 3);
		play.(\bass1, 3);
		play.(\ghostKick, 1);
		play.(\ghostKick, 1);
		playParallel.(\kick, 4);
		play.(\bass1, 6);
		play.(\snare, 4);
		play.(\hat, 1);
		play.(\ping, 1);

		playParallel.(\ghostKick, 1);
		play.(\bass2, 1);
		playParallel.(\kick, 3);
		play.(\bass2, 3);
		4.do {
			play.(\chirp2, 1 / 2, legato: 1);
		};
		playParallel.(\kick, 3);
		play.(\bass1, 3);
		playParallel.(\kick, 7);
		play.(\bass1, 7);
		play.(\hat, 1);
		play.(\clap, 3);
		play.(\glitch2, 1, legato: 0.5);
		play.(\clap, 1);
		play.(\glitchRandom, 1, legato: 0.3);
		2.do { |i|
			play.(\glitchRandom2, 1, [pan: [-1, 1].wrapAt(i) * 0.5], legato: 0.3);
		};
		play.(\snare, 1);
		play.(\glitchRandom, 1, legato: 0.3);
		play.(\glitch1, 1, legato: 0.5);
		4.do {
			play.(\chirp1, 1, legato: 0.5);
		};
	};
}).play;
)


(
var s, bpm, beat, tatum;
s = Server.default;
bpm = 170;
beat = 60 / bpm;
tatum = beat / 4;

Routine({
	var play, playParallel, wait, fx;

	wait = { |tatums|
		(tatum * tatums).wait;
	};

	playParallel = { |synthDef, tatums, args = #[], legato = 1|
		s.bind { Synth(synthDef, [duration: tatum * tatums * legato] ++ args) };
	};

	play = { |synthDef, tatums, args = #[], legato = 1|
		s.bind { Synth(synthDef, [duration: tatum * tatums * legato] ++ args) };
		(tatum * tatums).wait;
	};

	s.bind { fx = Synth.tail(nil, \fx); };

	Routine({
		loop {
			s.bind { fx.set(\trigger1, 1) };
			play.(\glitchRandom3, [1, 2].choose);
		};
	}).play;

	Routine({
		loop {
			s.bind { fx.set(\trigger2, 2) };
			wait.(4);
		};
	}).play;

	inf.do {
		var fragments;
		fragments = [
			{
				play.(\kick, 2);
				4.do {
					play.(\glitch1, 1, legato: 0.5);
				};
			},
			{
				play.(\snare, 2);
				play.(\glitch2, 1, legato: 0.5);
				play.(\glitch1, 6);
			},
			{
				4.do { |i|
					play.(\glitchRandom, 1, [pan: [-0.7, 0.7].wrapAt(i)], legato: 0.3);
				};
				3.do { |i|
					play.(\glitch3, 1, [pan: [-0.3, 0.3].wrapAt(i)], legato: 0.5);
				};
			},
			{
				play.(\kick, 2);
				playParallel.(\kick, 3);
				play.(\bass1, 3);
				play.(\ghostKick, 1);
				play.(\ghostKick, 1);
			},
			{
				playParallel.(\kick, 4);
				play.(\bass1, 6);
				play.(\snare, 4);
				play.(\hat, 1);
				play.(\ping, 1);
			},
			{
				playParallel.(\ghostKick, 1);
				play.(\bass2, 1);
				playParallel.(\kick, 3);
				play.(\bass2, 3);
			},
			{
				4.do {
					play.(\chirp2, 1 / 2, legato: 1);
				};
			},
			{
				playParallel.(\kick, 3);
				play.(\bass1, 3);
				playParallel.(\kick, 7);
				play.(\bass1, 7);
			},
			{
				play.(\hat, 1);
				play.(\clap, 3);
				play.(\glitch2, 1, legato: 0.5);
				play.(\clap, 1);
			},
			{
				play.(\glitchRandom, 1, legato: 0.3);
				2.do { |i|
					play.(\glitchRandom2, 1, [pan: [-1, 1].wrapAt(i) * 0.5], legato: 0.3);
				};
			},
			{
				play.(\snare, 1);
				play.(\glitchRandom, 1, legato: 0.3);
				play.(\glitch1, 1, legato: 0.5);
				4.do {
					play.(\chirp1, 1, legato: 0.5);
				};
			},
		];

		fragments.scramble.do { |func|
			if(0.1.coin) {
				3.do {
					func.();
				};
			};
			func.();
		};
	};
}).play;
)