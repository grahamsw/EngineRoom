// 14: Forest Murmers (embryonic)
(
~forest_murmers_embryonic_014 = {
	| timeBasis = 0.125, ampBasis = 0.1, transpose = 0, instrument=\default|
	var notes, amps, durs;
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
	],inf), \ctranspose, transpose);

      amps = Pbind(\amp, Pseq([1, 0.8, 0.8, 0.8, 0.9, 0.8, 0.8, 0.8] * ampBasis, inf));

     durs = Pbind(\dur, timeBasis);

    Pchain(Pbind(\instrument, instrument), notes, amps, durs);
}
)

//~forest_murmers_embryonic_014.(transpose:8, timeBasis:0.3,instrument:\def).play



