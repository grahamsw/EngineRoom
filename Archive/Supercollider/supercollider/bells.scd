(
{
	var scale, specs, freqs, amps, rings,
	numRes = 5, bells = 20, pan;

	scale = [60, 62, 67, 69].midicps;
	Mix.fill(bells,
		{
			freqs = Array.fill(numRes, {rrand(1, 15) * (scale.choose)});
			amps = Array.fill(numRes, {rrand(0.3, 0.9)});
			rings = Array.fill(numRes, {rrand(1.0, 4.0) });
			specs =  [freqs, amps, rings].round(0.01);

			pan = (LFNoise1.kr(rrand(3,6)) * 2).softclip;
			Pan2.ar(
				Klank.ar(
					`specs,
				Dust.ar(1/6, 0.03)), pan)
	})
}.play;
)
