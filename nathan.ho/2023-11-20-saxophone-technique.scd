// Saxophone "teeth on reed" technique
// opening of Ash Fure - "Something to Hunt": https://www.youtube.com/watch?v=XJIFXT2qlXY

(
SynthDef(\saxTeeth, {
	var snd, freq, env, duration;
	duration = 60;
	env = (
		LFNoise2.kr(16)
		+ (LFNoise2.kr(60) * 0.5)
		+ (0.5 * SinOsc.ar(23 * LFNoise2.kr(3).linexp(-1, 1, 0.5, 2)))
		+ (1 * Trig1.ar(Dust.ar(1 / 5), 0.1).lag(0.1))
	).linlin(-2, 2, 0, 2);
	freq = XLine.kr(2200, 3200, duration) * [1, 1, 0.5] * (LFNoise2.kr(3) * 0.3).midiratio * env.midiratio;
	env = env * LFNoise2.kr(3).linlin(-1, 1, 0.03, 1);
	snd = SinOsc.ar(freq) * [1200, 300, 6000] * (1 + (3 * env)) * LFNoise2.kr(8).linlin(-1, 1, 0.5, 1.2);
	snd = SinOsc.ar(freq + snd);
	snd = [
		snd[0],
		HPF.ar(BPF.ar(PinkNoise.ar, freq * 2, 0.04), freq) * 10.dbamp,
		snd[1] * -6.dbamp,
		snd[2] * -22.dbamp,
	];
	snd = SelectX.ar(LFNoise2.kr(16).linlin(-1, 1, 0, snd.size - 1), snd);
	snd = snd * env.pow(4);
	snd = snd ! 2;
	snd = snd * Env.linen(0.1, duration, 0.1, curve: -4).ar;
	snd = snd + GVerb.ar(snd * -14.dbamp, 30, 5);
	snd = snd * -30.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)
