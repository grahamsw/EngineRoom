(

var h1, h2, h3, a1, a2, a3;
h1 = [1,4,5];
h2 = [2, 3, 4, 5, 6];
h3 = [1, 2, 3, 4, 5];
a1 = [2, 1, 1].normalize;
a2 = [5, 3, 2, 1, 7].normalize;
a3 = [3, 1, 1, 1, 8].normalize;

~mksq = {
	|val1, rep1, val2, rep2|
	((val1!rep1) ++ (val2!rep2)).flat
};

Pbind(
    \instrument, \sonifier,
	 \dur, Pseq([0.01], inf),
	\harmonics, Pseq([h1], inf),
	\amps, Pseq([a1], inf),
	\mul, 0.1,
	\freq, Pseq(~mksq.value(200, 1, 152, 2), inf),
	\attack, Pseq(~mksq.value(0.5, 20, 0.1, 8) , inf),
	\decay, Pseq(~mksq.value(0.3, 20, 0.1, 8), inf),
	\release, Pseq(~mksq.value(0.3, 20, 0.1, 8), inf)
	).play
)