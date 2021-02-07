Pseq(list, repeats, offset)



Prand(list, repeats)
Choose items from the list randomly (same as list.choose).
Pxrand(list, repeats)
Choose randomly, but never repeat the same item twice in immediate succession.
Pshuf(list, repeats)
Shuffle the list in random order, and use the same random order repeats times. Like list.scramble.
~dp.(Pwrand(l, l.normalizeSum, 100))

Choose randomly, according to weighted probabilities (same as list.wchoose(weights)).
~dp.(Pseries(start: -81, step:3, length:29))
Arithmetic series (addition).
~dp.(Pgeom(start:1, grow:0.1, length:50))

Geometric series (multiplication).
~dp.(Pwhite(lo: 1, hi: 5, length:34))
Random numbers, equal distribution ("white noise"). Like rrand(lo, hi) .
~dp.(Pexprand(lo:1, hi:5, length:34))
Random numbers, exponential distribution. Like exprand(lo, hi) .
~dp.(Pbrown(lo:1, hi:100, step:6, length:30))
Brownian motion, arithmetic scale (addition).
~dp.(Pfunc({2}, {"poo".postln}))
a = Pfunc({2}, {"poo".postln}).asStream
a.reset
Get the stream values from a user-supplied function.
~dp.(Pfuncn({[\poo, \plop].choose}, 23))
Get values from the function, but stop after repeats items.
~dp.(Prout({var n = 0;
	loop{
		n = n + 1;
		n.yield;
	}
}))
)

[l,l].flatten

~dp.(Pser(list: l, repeats:23, offset:3))
Play through the list as many times as needed, but output only repeats items.

~dp.(Pslide(list:l, repeats:6, len:3, step:-1, start:1, wrapAtEnd:true))
//Play overlapping segments from the list.

~dp.(Pwalk(list:l, stepPattern: Pseq([1,2], inf), directionPattern: Pseq([1,-1],inf), startPos:0))
// Random walk over the list.

~dp.(Place(list:[[1,2],[3,4,5],[6,7]], repeats:4, offset:1))
//Interlace any arrays found in the main list.

~dp.(Ppatlace([Pseq([1,2,3],1), Pseq([4,5],10)], repeats:2, offset:0))
//Interlace any patterns found in the main list.
Ptuple(list, repeats)
//Collect the list items into an array as the return value.

p = Ppatlace([Pwhite(1, 5, 5), Pgeom(10, 1.01, 10)], inf);
x = p.asStream;
x.all;


(
~dp = {|p|
	var strm = p.asStream;
	strm.nextN(10);
}
)

l = [1,2,3,4,5,6]
~dp.(Pseq([1,2,3], 4, 2))

~dp.(Prand(l, 23))
~dp.(Pxrand(l, 23))
~dp.(Pshuf(l, 2))
(
var a, b;
a = Pseq([1, 2, 3], inf);
b = Pseq([65, 76], inf);
c = Ptuple([a, a, b], inf);
x = c.asStream;
8.do({ x.next.postln; });
)


(
var a, b;
a = Pseq([1, 2, 3], inf);
b = Pseq([65, 76], 3); // stops after 3 cycles
c = Ptuple([a, b], 1); // stops after 4 cycles
~dp.(c)
//x = c.asStream;
//8.do({ x.next.postln; });
)

