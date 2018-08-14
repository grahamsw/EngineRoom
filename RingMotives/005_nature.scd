(
~midi_005_nature = [39, 46] ++ [51, 55] ++ [58, 63] ++ [67];
~durs_005_nature = [5, 1].dup(3).flat ++ [6];
)

(
Pdef(\pattern_005_nature, Pbind(
	\midinote, Pseq(~midi_005_nature, inf),
	\dur, Pseq(~durs_005_nature* 0.2, inf)
));
)

//Pdef(\pattern_005_nature).play