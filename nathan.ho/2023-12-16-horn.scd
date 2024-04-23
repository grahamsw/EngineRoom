(
SynthDef(\horn, {
	var snd, intensity, freq, fb, wet;
	// deterministic version
	freq = Env(60 + [5 - 0.5, 5 - 0.5, 5 + 0.3, 0, 2.6, 3.0 - 0.1, 3.0 + 0.7], [0.3, 0.4, 0.3, 0.3, 0.3, 0.7, 1.0], curve: -4).ar.midicps;
	intensity = Env([0, 1, 1, 0, 0, 1, 1, 0], [0.1, 0.4, 0.1, 0.1, 0.3, 1.5], curve: -4).ar;
	snd = Saw.ar(freq);
	snd = FreqShift.ar(snd, 0.7);
	snd = MoogFF.ar(snd, intensity.linexp(0, 1, 200, 4000) * LFNoise2.kr(3).midiratio, 0);
	snd = BPeakEQ.ar(snd, 300 * (intensity * 12).midiratio, 0.2, 5);
	snd = BPeakEQ.ar(snd, 650 * (intensity * 6).midiratio, 0.1, -6);
	snd = BPeakEQ.ar(snd, 1340 * (intensity * 4).midiratio, 0.1, 6);
	snd = BPeakEQ.ar(snd, 640 * (intensity * 4).midiratio, 0.1, 6);
	snd = snd * intensity;
	snd = snd ! 2;

	fb = snd;
	fb = AllpassC.ar(fb, 0.04, [0.014, 0.2], 0.05);
	fb = AllpassC.ar(fb, 0.04, [0.004, 0.064], 0.05);
	fb = AllpassC.ar(fb, 0.04, [0.0034, 0.006], 0.05);
	fb = AllpassC.ar(fb, 0.04, [0.0012, 0.003], 0.05);
	fb = fb + LocalIn.ar(2);
	fb = DelayC.ar(fb, 0.04, 0.04);
	fb = AllpassC.ar(fb, 0.2, [0.04, 0.06] * (LFNoise2.kr(3 ! 2) * 0.6).midiratio, 0.4);
	fb = AllpassC.ar(fb, 0.04, [0.04, 0.03], 0.2);
	fb = AllpassC.ar(fb, 0.04, [0.014, 0.01], 0.05);
	fb = fb * -2.dbamp;
	fb = LPF.ar(fb, 4000);
	fb = HPF.ar(fb, 100);
	wet = fb.reverse;

	fb = DelayC.ar(fb, 0.06, 0.06);
	fb = AllpassC.ar(fb, 0.2, [0.03, 0.05] * (LFNoise2.kr(3 ! 2) * 0.7).midiratio, 0.4);
	fb = AllpassC.ar(fb, 0.04, [0.04, 0.03], 0.2);
	fb = AllpassC.ar(fb, 0.04, [0.024, 0.004], 0.05);
	fb = fb * -2.dbamp;
	fb = LPF.ar(fb, 4000);
	fb = HPF.ar(fb, 100);
	wet = wet + fb;

	LocalOut.ar(fb.reverse);

	snd = LPF.ar(snd, 1000) + wet;

	snd = snd * -14.dbamp;
	Out.ar(\out.kr(0), snd);
}).play;
)