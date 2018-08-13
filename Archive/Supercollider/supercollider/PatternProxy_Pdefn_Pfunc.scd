// three ways to vary patterns while playing: PatternProxy, Pdefn, and Pfunc

(

~a = PatternProxy(Pn(Pseq([1],inf)));
a = 	Pbind(
		\note, Pser([0,2,4,5,7,9,11,12], inf).trace,
	    \dur, ~a,
	    \amp, 0.1
);

a.play

)

~a.source = Pseq([0.1], inf);


(
Pdefn(\dur, Pseq([1], inf));
c = 	Pbind(
		\note, Pser([0,2,4,5,7,9,11,12], inf),
	    \dur, Pdefn(\dur),
	    \amp, 0.1
);
c.play
)

Pdefn(\dur, Pseq([0.1], inf))


(
~val = 1;
d = 	Pbind(
		\note, Pser([0,2,4,5,7,9,11,12], inf).trace,
	    \dur, Pfunc({~val}),
	    \amp, 0.1
);
d.play;
)

~val = 0.1;
