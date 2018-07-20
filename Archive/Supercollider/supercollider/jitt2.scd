
(
SynthDef(\wave, {
	| out = 0, freq = 440, amp = 0.1, sustain = 0.1, mod = 0.2|
	OffsetOut.ar(out,
		EnvGen.ar(Env.perc(ExpRand(0.001, 0.05), sustain, amp), doneAction:2)
		*
		SinOsc.ar(freq, SinOsc.ar(sustain.reciprocal * 8, [0, Rand(0, pi)], mod))
	)
}).add
)
(
Pdef(\x,
	Pbind(
		\instrument, \wave,
		\mod, Pseq([1,0,1,0], inf),
		\dur, Pn(1/2, 8),
		\note, 7
	)
)
)


(
Pdef(\y,
	Pbindf(
	Pdef(\x),
	\amp, 0.2,
	\note, Pshuf([0, 2, 3, 5], 2) + Prand([0, 5, [0,4]], inf),
	\dur, Pseq([1,3,2,3], inf) /6
	)
)
)

(
Pdef(\z, Pbindf(Pdef(\y), \dur, 1/4))
)

(
Pdef(\b, Pbindf(Pdef(\y), \ctranspose, 2))
)

(
Pdef(\a2,
	Pmul(\dur, Pwhite(-0.02, 0.02) + 1,
		Psym(Pseq([[\x, \y], \x, \y, \z, [\x, \b]], inf).trace)
	)
).play
)

PdefGui(Pdef(\a2))

Pdef(\a2).stop
(
Pdef(\a,
	Pmul(\dur, Pwhite(-0.02, 0.02) + 1,
		Pseq([
			Ppar([Pdef(\x), Pdef(\y)]),
			Pdef(\x),
			Pdef(\y),
			Pdef(\z),
			Ppar([Pdef(\x), Pbindf(Pdef(\y), \ctranspose, 2)])
	]), inf)
)
)

Pdef(\a).play

(
Pdef(\x,
	Pbind(
		\instrument, \wave,
		\dur, Pseq([1,3,2, Prand([3,2])], inf)/6,
		\octave, [6,4]
	)
)
)


(
Pdef(\x,
	Pbind(
		\instrument, \wave,
		\dur, Pseq([1,3, 2, Prand([3,2])], 1) / 6,
		\octave, [2, 8]
	)
)
)

Pdef(\a).stop

s.plotTree

(instrument: \x, type: \phrase).play

(
Pbind(
	\type, \phrase,
	\instrument, \x,
	\legato, 2.5,
	\note, Pseq([0,5,7], inf)
).play
)



(
Pdef(\x, {
	|note = 0, n = 6, step = 3, modulo = 15, sustain = 1|
	Pbind(
		\instrument, \wave,
		\note, note.value + (Pseries(1, step, n) % modulo) + 7,
	    \dur, sustain.value / n
	)
})
)

(
Pdef( \a,
	Pbind(
		\type, \phrase,
		\instrument, \x,
		\note, Pseq([0,5,4,8,0], inf),
		\n, 5,
		\modulo, Pseq([3, [4,3,5], [13,15]], inf),
		\dur, Pseq([1,2,0.5,1.5], inf)
	)
).play
)
Pdef(\a).stop
(
Pdef(\a,
	Pbind(
		\type, \phrase,
		\instrument, \x,
		\note, Pseq([0, 5, 4, 8, 0], inf),
		\n, 5,
		\modulo, Prand([3, [4, 3, 5], [13, 15]], inf),
		\recursionLevel, 1,
		\dur, Pseq([1,2,0.5, 1.5], inf) * 2
	)
).play
)


