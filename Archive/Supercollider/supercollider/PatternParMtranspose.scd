(
a = Pbind(*[
	scale: Pn(Pstep([[p,2,4,5,7,9,11], [0,1,3,5,6,8,11] ], 5)),
	db: Pn(Pseg([-20, -30, -25, -30], 0.4))
]);

b = Pbind(*[
	degree: Pbrown(0, 6, 1),
	mtranspose: Prand([\rest, Pseq([0], 5.rand)],inf),
	dur: 0.2,
	octave: 6
]);
c = Pbind(*[
	degree: [0, 2, 4],
	mtranspose: Pbrown(0, 6, 1),
	dur: 0.4,
	db: -35
]);

d = Pchain(Ppar([b, c]), a);
d.play;
)

(
Prout({ |ev|
	var pat, refPat;
	refPat = Pbind(*[dur: 0.2, note: Pseq([0, 0, 0, 7, 0, 7])]);
	loop {
		ev = refPat.embedInStream(ev);
		pat = Pbind(*[
			dur: [0.2, 0.4].choose,
			note: Pseq(Array.fill(5, {10.rand }), 3.rand)
		]);
		ev = pat.embedInStream(ev);
	}
}).play
)

(
Prout({|ev|
	(400, 500 .. 800).do { | i |
	ev = (freq: i).embedInStream(ev.copy);
	}
}).play
)

(

~patA = Pbind(*[
	dur: 0.2,
	degree: Prout( { |ev|
		var noteArray = (0..5);
		loop {
			ev = Pseq(noteArray).embedInStream(ev);
			noteArray[6.rand] = 7.rand;
		}
	})
]);

~patB = Prout( {|ev|
	var pat, pats = [
		Pbind(*[degree: Pseq([0, 7]), dur: 0.2]),
		Pbind(*[degree: Pseq([11, 7]), dur: 0.2]),
		Pbind(*[degree: Pseq([16, 7]), dur: 0, 2]),
		(type: \rest, delta:1)
	];
	loop {
		pat = pats.choose;
		ev = pat.embedInStream(ev);
	}
});

Pchain(
	Pbind(*[
		db: Pn(Pstep([-15, -25, -25, -20, -30, -25], 0.2))
		+ Pseg([-30, -5, -10, -40], 12)
	]),
	Ptpar([
		0, ~patA,
		0, ~patA,
		12, ~patB
	])
).play
)
		