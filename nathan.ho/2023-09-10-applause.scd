(
SynthDef(\clap, {
	var snd, trigger, gate, freqs, ringing;
	gate = \gate.kr(1);
	trigger = Impulse.ar(\rate.kr(5) * (LFNoise2.kr(1) * 3).midiratio, Rand(0, 1));
	trigger = trigger * Env.asr(0, 1, 0, -4).ar(Done.none, gate);
	snd = WhiteNoise.ar;
	freqs = \freqs.kr(1320 ! 3);
	snd = BPF.ar(snd, freqs * (LFNoise2.kr(3 ! 3) * 5).midiratio, freqs.expexp(500, 8000, 1.0, 1.3) * \baseQ.kr(1.0));
	snd = snd * freqs.explin(1000, 8000, 0, -10).dbamp;
	snd = snd * (Env.perc(0.005, \decay.kr(0.05) * [1, 0.1, 0.3], curve: \curve.kr(-8)).ar(Done.none, trigger) ** 1.5);
	snd = (snd * [0, -15, -20].dbamp).sum;
	snd = snd + (BPF.ar(WhiteNoise.ar, \clickFreq.kr(3000), 0.1) * Env.perc(0.001, 0.01).ar(Done.none, trigger));
	snd = (snd * 3).clip2 + snd.fold2;

	// additive synthesis to add "ringing" to initial transient
	ringing = SinOsc.ar({ TExpRand.ar(1000, 8000, trigger) } ! 8);
	ringing = ringing.sum * 5.dbamp;
	ringing = ringing * Env.perc(0.001, 0.01, curve: \curve.kr(-8)).ar(Done.none, trigger);
	ringing = ringing.tanh * -1.dbamp;
	snd = snd + ringing;

	// fake the room response a bit with extra noise puffs
	snd = snd + (
		BPF.ar(WhiteNoise.ar, ExpRand(1200, 4200), 0.3)
		* Env.perc(0.05, 0.1, curve: \curve.kr(-8)).ar(Done.none, trigger)
		* -5.dbamp
	);


	snd = snd * TRand.ar(0.2, 1, trigger).lag(0.01);
	snd = snd * Env.asr(0.001, 1, 0.1, -4).ar(Done.freeSelf, gate);
	snd = Pan2.ar(snd, \pan.kr(0));

	snd = snd * \amp.kr(1);
	snd = snd * -15.dbamp;
	Out.ar(\out.kr(0), snd * \dryAmp.kr(1));
	Out.ar(\room.kr(0), snd * \roomAmp.kr(1));
}).add;

SynthDef(\noise, {
	var snd, gate;
	gate = \gate.kr(1);
	snd = { WhiteNoise.ar } ! 2;
	snd = LPF.ar(snd, 3000);
	snd = HPF.ar(snd, 100);
	snd = snd * Env.asr(1, 1, 1).ar(Done.freeSelf, gate);
	snd = snd * -37.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\fx, {
	var snd, reverb, diffusion;
	snd = In.ar(\out.kr(0), 2);
	reverb = In.ar(\room.kr(0), 2);
	reverb = GVerb.ar(reverb.sum * -10.dbamp, 90, 1);
	reverb = LPF.ar(reverb, 3000);
	snd = snd + reverb;
	snd = Limiter.ar(snd);
	ReplaceOut.ar(\out.kr(0), snd);
}).add;
)

//  welp, I threw everything out of balance
// LET'S FIX IT

// sorry lots of background noise in my space right now
// someone's microwaving dinner

// well, my laptop's getting really hot so I'll have to call this a day
// I'm not super happy with this but it was a fun experiment
// thanks for watching

(
var s, generateClapArgs;
s = Server.default;

generateClapArgs = { |distance|
	// array of functions, one for each possible behavior
	[
		{
			[
				rate: 3.0 * 0.0.gauss(10.0).midiratio,
				freq: [1200, 3420, 2730] * (0.0.gauss(10.0 ! 3)).midiratio,
				clickFreq: 3320 * (0.0.gauss(10.0)).midiratio,
				pan: rrand(-1.0, 1.0) * 0.7,
				decay: exprand(0.02, 0.3),
				curve: rrand(-6.0, -8.0),
				amp: rrand(0.0, -20.0).dbamp * (1 - distance),
				dryAmp: distance,
				roomAmp: 1 - distance,
				baseQ: rrand(0.6, 0.9),
			]
		},
		{
			[
				rate: 2.0 * 0.0.gauss(10.0).midiratio,
				freq: [1200, 5420, 8730] * (0.0.gauss(10.0 ! 3)).midiratio,
				clickFreq: 3320 * (0.0.gauss(10.0)).midiratio,
				pan: rrand(-1.0, 1.0) * 0.7,
				decay: exprand(0.01, 0.3),
				curve: rrand(-6.0, -8.0),
				amp: rrand(0.0, -10.0).dbamp * (1 - distance),
				dryAmp: distance,
				roomAmp: 1 - distance,
				baseQ: rrand(0.6, 0.9),
			]
		},
		{
			[
				rate: 1.0 * 0.0.gauss(10.0).midiratio,
				freq: [3200, 4420, 7730] * (0.0.gauss(10.0 ! 3)).midiratio,
				clickFreq: 3320 * (0.0.gauss(10.0)).midiratio,
				pan: rrand(-1.0, 1.0) * 0.7,
				decay: exprand(0.01, 0.8),
				curve: rrand(-6.0, -8.0),
				amp: rrand(0.0, -10.0).dbamp * (1 - distance),
				dryAmp: distance,
				roomAmp: 1 - distance,
				baseQ: rrand(0.6, 0.9),
			]
		}
	].choose.value;
};

Routine({
	var numSynths, room;

	s.bind { room = Bus.audio(nil, 2) };

	s.bind { Synth.tail(nil, \fx, [out: 0, room: room]) };

	Routine({
		var synth;
		0.5.wait;
		s.bind {
			synth = Synth(\noise);
		};
		3.0.wait;
		s.bind { synth.set(\gate, 0) };
	}).play;

	numSynths = 6;
	numSynths.do { |i|
		var distance;
		distance = i / numSynths; // ensure an even spread of near and far listeners
		Routine({
			var synth, position;
			(0.5 * 0.0.gauss(2.0).midiratio).wait;
			s.bind {
				synth = Synth(\clap, generateClapArgs.(distance) ++ [out: 0, room: room]);
			};
			(5.0 * 0.0.gauss(2.0).midiratio).wait;
			s.bind { synth.set(\gate, 0) };
		}).play;
	};
}).play;
)