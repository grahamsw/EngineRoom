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

~nature_005.play(TempoClock(2)).quant(4)

(

Pdef( \nature_5,
	Pbind(
		\midinote, Pseq([39, 51, 58, 67], inf),
		\dur, Pseq([1], inf)
	)
);
)

(

Pdef( \nature_6,
	Pbind(
		\midinote, Pseq([39, 47, 34, 37], inf),
		\dur, Pseq([1], inf)
	)
);
)


t = TempoClock(12);

t.tempo = 2


	Pdef(\nature_5).play(t, quant:4)

	Pdef(\nature_6).play(t, quant: 4)


Pdef(\nature_5).stop
(

Pdef( n1,
	Pbind(
		\midinote, Pseq([39, 46] ++ [51, 55] ++ [58, 63] ++ [67], inf),
		\dur, Pseq([5, 1].dup(3).flat ++ [6], inf)
	)
);
)