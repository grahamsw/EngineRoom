(
~row = [0, 2, 7, 3, 1, 8, 10, 6, 4, 9, 11, 5];
Pbind(\note, Pseq(row, 1), \dur, 0.2, \amp, 0.4).play

)

(
~myMatrix ={
	|row|
	row.collect({
		|item|
		((((12-item)%12) + ~row)%12).postln
	})
};
)

~myMatrix.([0,1,2,3,4,5,6,7,8,9,10,11])
~mtx = ~myMatrix.( ~row)
(
p = Pbind(
	\instrument, \default,
	\row, Pstutter(3, Pseries())%12,
	\column, (Pseq([0, 1, 2], inf) + Pkey(\row))%12,
	\note, Pfunc({|e| ~mtx[e.row][e.column]}),

	\dur, 0.25);
)
p.trace.play


(
q = Pbind(
	\instrument, \default,
	\row, Pseries()%12,
	\column, (Pseq([0, 1, 2], inf) + Pkey(\row))%12,
	\note, Pfunc({|e| 3.collect{|i| ~mtx[e.row][(e.row + i)%12]}}),

	\dur, 0.5);
)

q