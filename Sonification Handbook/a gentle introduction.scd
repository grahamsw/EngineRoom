(
~pat = {
	| start = 0, dur = 0.1, leg = 0.1|

Pbind(
	\degree, Pseries(start,1, 8), //( Pseq([0, -1, -2, -3, 4, -3, 7, 11, 4, 2, 0, -3], 5),
	\dur, dur, //Pseq([0.2, 0.1, 0.1], inf),
	\amp, Pseq([0.7, 0.5, 0.3, 0.2], inf),
	\legato, leg
)
}
)

f = ~pat.(0, 0.01, 1)

f.play

g = ~pat.(8, 0.1, 2)

Ppar([f, g]).play



(
Pbind(
		\note, Pser([0,2,3,5,7,8,11,12], 4),
		\dur, 0.15;
	).trace.play;
)


(
Pbind(
		\note, Pshuf([0,2,3,5,7,8,11,12], 4),
		\dur, 0.15;
	).trace.play;
)


(
Pbind(
		\degree, Pslide([0,1,2,3,4,5,6,7,8,9].reverse, 7,4,1),
	\dur, Pseq([0.2, 0.1, 0.1, 0.1], inf);
	).trace.play;
)

(
Pbind(
	\note, Pseq([0, Pn(2,3), 3, Pn(5,3), 7, Pn(8,3), 11, 12], 1),
	\dur, 0.05
).trace.play
)




(
var a, b;
a = Pser([1, 2, 3], 5);    // return 5 items
b = a.asStream;
6.do({ b.next.postln; });
)


(
Pbind(
	\note, Pser([0,2,3,5,7,8,11,12], 11),
	\ctranspose, -7,
	\dur, 0.15
).play
)

Pbind(\note, Pseq([0, 0.5, 1, 1.5, 1.75, 2, 1], 1)).play

Pbind(\midinote, Pseq([60, 69, 68.5, 60.25, 70], 1)).play

{LFPulse.ar(width:MouseX.kr(0.01,0.99, lag:1).poll)}.scope




























