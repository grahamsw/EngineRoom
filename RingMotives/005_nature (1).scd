(
// 5: Nature

~nature_005 = {
	var midi_005_nature = [39, 46] ++ [51, 55] ++ [58, 63] ++ [67];
	var durs_005_nature = [5, 1].dup(3).flat ++ [6];

	Pbind(
	    \midinote, Pseq(midi_005_nature, inf),
		\dur, Pseq(durs_005_nature , inf)
	    );
}.()

)

~nature_005.play