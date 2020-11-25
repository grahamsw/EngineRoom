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
).quant_(4)
)
(

Pdef(\two,
	Pbind(
		\note, Pseq([1, 1, 0, -2], inf),
		\dur, 1,
		\amp, Pseq( [0.2, Pseq([0.1],3)], inf),
	\stretch, 1
	)
).quant_(4)
)

{SinOsc.ar}.play

t = TempoClock
t.tempo = 1



Pdef(\one).play(t)
Pdef(\two).play(t)
(
Pdef(\a,
	Pbind(
		\degree, Pseq([1,2,3,4],inf),
		\amp, 0.3,
		\dur, 1,
	)
).quant_(4)
)
(
Pdef(\b,
	Pbind(
		\degree, Pseq([3,4,5,6],inf),
		\amp, 0.2,
		\dur, 1,
	)
).quant_(4)
)
(
Pdef(\c,
	Pbind(
		\degree, Pseq(([5,6,7]!4).flatten,inf),
		\amp, Pseq([0.8,0.1,0.1],inf),
		\dur, Pseq([5,4,4].normalizeSum /3, inf)
	)
).quant_(4)
)
t = TempoClock(1)
t.tempo = 0.2
Pdef(\a).stop//play

Pdef(\b).stop//play

Pdef(\c).stop//play(t)

{SinOsc.ar}.play




