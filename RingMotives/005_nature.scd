(
// 5: Nature

~nature_005 = {
	| timeBasis = 0.125, ampBasis = 0.1, transpose = 0, instrument=\default|

~midi_005_nature = [39, 46] ++ [51, 55] ++ [58, 63] ++ [67];
~durs_005_nature = [5, 1].dup(3).flat ++ [6];

	Pbind(
	\midinote, Pseq(~midi_005_nature, inf),
	\dur, Pseq(~durs_005_nature* timeBasis, inf),
		\ctransponse, transpose
);
	}
)

~nature_005.().play