{SinOsc.ar(LFNoise0.kr(12, mul:600, add:1000), mul:0.3)}.play

{RLPF.ar(Dust.ar([60, 80]), LFNoise1.ar(1/[3,4], 1500, 1600), 0.012)}.play

(
{
	var sines = 20, speed = 20;
	Mix.fill(sines,
		{
			|x|
		 	Pan2.ar(
				SinOsc.ar( (x + 1) * 100,
				mul: max(0, LFNoise1.kr(speed) +
						Line.kr(1,-1, 30) * 1/(x + 1)
				)
			), rand2(1.0))
})/3}.play
)
//sfsf


rand(11.0,12.0)

rrand(4,7)

{exprand(1.0,100.0 )}.dup(100).plot
{rrand(1.0, 1000.0)}.dup(100).sort.plot
({exprand(1.0, 1000.0)}!100).round(10).sort.plot

1760.cpsmidi
(93+12).midicps / 8


PMOsc