(
a = 	Pbind(
		\note, Pser([0,2,4,5,7,9,11,12], inf).trace,
		\gtranspose, 0,
		\stepsPerOctave, 80,
	\dur, 0.02,
	\legato, 0.1,

	\amp, 0.1
);

b = Pbind(
	\note, Pser([0,2,4,5,7,9,11,12], inf).trace,
		\gtranspose, 5,
		\stepsPerOctave, 80,
	\dur, 1,
	\legato, 0.1,

	\amp, 0.6
);

Ppar([a, b]).play;
)

