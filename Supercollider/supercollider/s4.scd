(

p = {
	r = Line.kr(1,20, 60);
	r = LFTri.kr(1/10) * 3 + 7;
	t = Impulse.kr(r);
	//t = Dust.kr(r);
	e = Linen.kr(t, 0, 0.5, 1/r);
	//f = TRand.kr(1,10, t);
	f = e + 1 * 4;
	Blip.ar(f * 100, f, e)
}.play
)

p.free;
