(
a = ["C", "C#", "D", "Eb", "F", "F#", "G", "Ab", "A", "Bb", "B",];
"event, midi, pitch, octave".postln;
r = Task({
	inf.do ({
		arg coun;
		var midi, oct, density;
		density = 0.7;
		midi = [0, 2, 3, 5, 6, 8, 9, 11].choose;

		oct = [48, 60, 72].choose;
		if (density.coin,
			{
				"".postln;
				[midi + oct, a.wrapAt(midi),
					(oct/12).round(1)].post;
				Synth("PMCrotale",
					[\midi, midi + oct,
					 \tone, rrand(1,7),
						\art, rrand(0.3, 2.0),
						\amp, rrand(0.3, 0.6),
						\pan, 1.0.rand2]);
			},
			{
				["rest"].post});
		0.2.wait;
	});
}).start
)

r.stop;
				