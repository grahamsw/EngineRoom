(
var compressor, multiband;

compressor = { |snd, attack, release, threshold, ratio|
	var amplitudeDb, gainDb;
	amplitudeDb = Amplitude.ar(snd.sum / snd.size.sqrt, attack, release).ampdb;
	gainDb = ((amplitudeDb - threshold) * (1 / ratio - 1)).min(0);
	snd * gainDb.dbamp;
};

multiband = { |snd, ratio = 2|
    var low, mid, high;
    var lowFreq, highFreq;

    lowFreq = 300;
    highFreq = 3200;
    low = LPF.ar(LPF.ar(snd, lowFreq), lowFreq);
    snd = snd - low;
    mid = LPF.ar(LPF.ar(snd, highFreq), highFreq);
    high = snd - mid;

    low = compressor.(low, 0.01, 0.1, -20, ratio);
    mid = compressor.(mid, 0.01, 0.1, -20, ratio);
    high = compressor.(high, 0.01, 0.1, -20, ratio);

    low + mid + high;
};


{
	var snd, fb, amp, trigger;
	trigger = Dust.ar(3);
	snd = SinOsc.ar(
		TExpRand.ar(100, 1000, trigger)
		* (Env.perc(0.001, TExpRand.ar(0.1, 1, trigger)).ar * TRand.ar(1, 100, trigger)).midiratio
	);
	snd = Pan2.ar(snd, TRand.ar(-1, 1, trigger).lag(0.01));
	snd = snd * Env.perc(0.001, 0.1, curve: -4).ar(Done.none, trigger);
	snd = snd.tanh;
	snd = snd + GVerb.ar(snd.sum * -35.dbamp, 60, revtime: 1, damping: 0.9);
	snd = snd * 10.dbamp;

	snd = snd + LocalIn.ar(2);
	fb = snd;

	// Fake Dolby noise reduction, compressor stage
	fb = multiband.(fb);

	fb = MoogFF.ar(fb, 12e3, 0);

	// Delay line mod
	fb = DelayC.ar(
		fb,
		2.0,
		TExpRand.ar(0.01, 0.3, trigger).cpsmidi.lag(0.03).midicps + (SinOsc.ar(1).linlin(-1, 1, 0, 1) * 0.5e-3)
		+ (LPF.ar(PinkNoise.ar, 6) * 0.5e-3)
	);
	// Drive feedback
	fb = fb * TRand.ar(-1, 10, trigger).lag(0.01).dbamp;
	// Noise
	fb = fb + (({ PinkNoise.ar } ! 2) * (0.6 + (0.3 * LFNoise2.kr(8))) * -40.dbamp);
	// Saturation
	fb = fb.tanh;
	// Crossover
	fb = fb.blend(fb.pow(2), 0.5);
	// DC remover
	fb = HPF.ar(fb, 50);
	// Head bump
	fb = BPeakEQ.ar(fb, 60, 0.5, 4);
	// Box tone
	fb = BPeakEQ.ar(fb, 120, 0.3, -1.0);
	fb = BPeakEQ.ar(fb, 620, 0.3, 1.0);
	fb = BPeakEQ.ar(fb, 1320, 0.3, -1.0);

	// HF loss in response to amplitude
	amp = Amplitude.ar(fb, 0.01, 0.2).sum / fb.size.sqrt;
	fb = LPF.ar(fb, amp.linexp(0, 0.9, 16e3, 3000));

	// Fake Dolby noise reduction, expander stage
	fb = multiband.(fb, 1/2);

	// Saturation
	fb = (fb + Line.ar(0, 0.05, 0.1)).tanh;
	// DC remover
	fb = LeakDC.ar(fb);

	LocalOut.ar(fb);

	snd = Limiter.ar(snd);
	snd = snd * -5.dbamp;
	snd;
}.play(fadeTime: 0);
)