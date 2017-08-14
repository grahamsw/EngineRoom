(

t = FloatArray.fill(512, {|i|
	v = i.linlin(0.0, 512.0, -1.0, 1.0);
	if (abs(v) < 0.5) { v * 0.5} { v * 1.25}
}).normalize(-1.0, 1.0);

t.plot;

b = Buffer.sendCollection(s, t);

)


(
{var sig = SinOsc.ar(100, mul:MouseX.kr(0,1));
	Out.ar(0, BufRd.ar(1, bufnum:b,
		phase:sig.linlin(-1.0, 1.0, 0, BufFrames.ir(b)-1)))
}.play
)



// excellent buzzy, static noise
(

t = FloatArray.fill(512, {|i|
	v = i.linlin(0.0, 512.0, -1.0, 1.0);
	v.round(0.125 + (v * 1.4 * (i%4)));
}).normalize(-1.0, 1.0);

t.plot;

b = Buffer.sendCollection(s, t);

)


(
{var sig = SinOsc.ar(100, mul:MouseX.kr(0,1));
	Out.ar(0, LeakDC.ar(
		BufRd.ar(1, bufnum:b,
			phase:sig.linlin(-1.0, 1.0, 0, BufFrames.ir(b)-1))))
}.play
)

// as it should be done
(

t = Signal.fill(513, {|i|
	v = i.linlin(0.0, 512.0, -1.0, 1.0);
	v.round(0.125 + (v * 1.4 * (i%4)));
}).normalize(-1.0, 1.0);

t.plot;
b = Buffer.alloc(s, 1024, 1); // 1024 =( 512-1) * 2
b.sendCollection(t.asWavetableNoWrap);

)


(
{Shaper.ar(b, SinOsc.ar(440, 0, MouseX.kr(0,1))) * 0.75}.scope;
)