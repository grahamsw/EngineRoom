(
Pdef(\one,
	Pbind(
		\note, Pseq(
			 [
				Pseq([5,7,8], 1),
				Pseq([8,7,5], 1),
				Pseq([12, 11, 8],2)
			],
		inf),
		\dur,  Pseq([2,1,1].normalizeSum ,  inf),
		\amp, Pseq( [0.1, 0.03, 0.02], inf),
	)
);

Pdef(\two,
	Pbind(
		\note, Pseq([1, 1, 0, -2], inf),
		\dur, 1,
		\amp, Pseq( [0.2, Pseq([0.1],3)], inf),
	\stretch, 1
	)
);
)

{SinOsc.ar}.play

t = TempoClock
t.tempo = 0.75

0.75*60


Pdef(\one).fadeTime = 8
Pdef(\two).fadeTime = 8
Pdef(\one).play(t, quant:[4, 3.75])
Pdef(\two).play(t, quant: 4)

[\one, \two].do{|n| Pdef(n).stop}
(
Pdef(\a,
	Pbind(
		\degree, Pseq([1,2,3,4],inf),
		\amp, 0.3,
		\dur, 1,
	)
);

Pdef(\b,
	Pbind(
		\degree, Pseq([3,4,5,6],inf),
		\amp, 0.2,
		\dur, 1,
	)
);

Pdef(\c,
	Pbind(
		\degree, Pseq(([5,6,7]!4).flatten,inf),
		\amp, Pseq([0.8,0.1,0.1],inf),
		\dur, Pseq([5,4,4].normalizeSum /3, inf)
	)
)
)
t = TempoClock(1)
t.tempo = 0.465
Pdef(\a).play(t, quant:4)
Pdef(\b).play(t, quant:4)
Pdef(\c).play(t, quant:4)

Pdef(\c).stop

{SinOsc.ar}.play


~one.play(quant:1)

~two.play(quant:4)

~one.stop
~two.stop



