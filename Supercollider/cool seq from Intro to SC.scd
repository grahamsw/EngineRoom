(

var num = 20;
var pitches = Array.series(num, 0, 4) + 20;
var times = Array.geom(num, 1, 1.01);

num.do {
	|i|
	{inf.do {
		times[i].wait;
		{Pan2.ar(
			in: Pulse.ar(pitches[i].midicps)
			*
			EnvGen.kr(Env.perc, 1, 0.2, doneAction:2),
			pos: i.linlin(0, num-1, -1,1)
		)
		}.play;
}}.fork;};

s.scope;
)
