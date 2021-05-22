// 14: Forest Murmers (embryonic)


(
~forest_murmers_embryonic_014 = {
	var notes, durs;
	notes = Pbind(\midinote,
		Pseq([
			[41, 50], [45, 52], [41, 50], [45, 52],
			[41, 50], [45, 52], [41, 50], [45, 52],
			[50, 53], [46, 55], [50, 53], [46, 55],
			[50, 53], [46, 55], [50, 53], [46, 55],
			[53, 57], [50, 58], [53, 57], [50, 58],
			[53, 57], [50, 58], [53, 57], [57, 60],
			[62, 65], [58, 67], [62, 65], [58, 67],
			[62, 65], [58, 67], [62, 65], [57, 64],
			[53, 62], \rest, \rest, \rest,
			\rest, \rest, \rest, \rest
	],inf));



     durs = Pbind(\dur, 0.1);

    Pchain( notes, durs);
}.()
)


~forest_murmers_embryonic_014.play
