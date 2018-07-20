p = ProxySpace.push;

~a = {Lag.ar(LFClipNoise.ar(2 ! 2, 0.5, 0.5), 0.2) };
(
~b = {
	var c, d;
	c = Dust.ar(20!2);
	d = Decay2.ar(c, 0.01, 0.02, SinOsc.ar(11300));
		d + BPF.ar(c*5, ~a.ar * 3000 + 1000, 0.1)
}
);

~b.play;

(
~a = {
	var a;
	a = Lag.ar(LFClipNoise.ar(2!2, 0.5, 0.5), 0.2);
		BPF.ar(~c.ar * 5, a * 3000 + 1000, 0.1)
	}
);

~c = {Dust.ar(20!2)};
}SinOsc.ar(11300))};

~b = ~a + ~d;

~b.play

s.makeGui.top_=true

{PMOsc.ar(Line.kr(300, 800, 20), Line.kr(400, 100, 20), Line.kr(1, 12, 20), mul:Line.kr(1, 0, 25  ))}.play

(
{
	Blip.ar(TRand.kr(100, 1000, Impulse.kr(Line.kr(1,29, 60))),
		    TRand.kr(1, 20, Impulse.kr(Line.kr(1,29, 60))),
			Linen.kr(
				Impulse.kr(Line.kr(1, 20, 60)),
				0,
				0.5,
					1/Line.kr(1, 20, 60))
			)
}.play;
	)

	{Impulse.kr(Line.kr(15, 20, 10))}.plot(10)
	{Dust.kr(10)}.plot(0.5)

	{TRand.kr(1, 10, Impulse.kr(Line.kr(10, 50, 1)))}.plot(1)

(
		p = {
			r = Line.kr(1,20,60);
			t = Impulse.kr(r);
			e = Linen.kr(t, 0, 0.5, 1/r);
			f = TRand.kr(1, 10, t);
			//f = e + 1 * 4;
			Blip.ar(f*100, f, e)
		}.play;

	)


	{Blip.ar(400, Line.kr(1, 200, 10))}.scope
		