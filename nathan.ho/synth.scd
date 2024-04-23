SynthDef(\synth, {
    | intensity = 1, timbre = 1, gate=1, freq=400|
	var snd, freq, n, env;
	timbre = timbre + (intensity * 0.1);
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