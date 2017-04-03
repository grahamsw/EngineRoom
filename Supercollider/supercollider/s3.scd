Server.default = s = Server.internal.boot

play({SinOsc.ar(LFNoise0.kr(12, mul:600, add:1000), 0.3)})]

play({RLPF.ar(Dust.ar(9), LFNoise1.ar(1/3, 500,600), 0.02)})

play({
	var sines = 15, speed = 6;
	Mix.fill(sines,
		{arg x;
			Pan2.ar(SinOsc.ar(x + 1 * 100,
				              mul: max(0,
					LFNoise1.kr(speed) + Line.kr(1, -1, 30)
				)
), rand2(1.0))})/sines})


thisThread.randSeed = 666; {rand(u100)} ! 10

[0,3,5,6].reverse;

[1,2,3,4,5,6].scramble;

[1,2,3,4].rotate(-1);
~aa = [1,2,3,4,5,6];
~aa.choose ! 7


(0.125 * ~aa).choose;
~aa.permute(3);

dup({exprand(1, 1000.0)}, 5)


{LFNoise0.ar}.play

{LFNoise0.ar(10000)}.plot
{LFNoise0.ar(10000)}.scope
{100.rand}.dup(10)
{100.rand} ! 10
{100.rand}.dup(10).postln.plot
{100.rand}.dup(100).sort.plot

1 /[1, 2, 3]

{Blip.ar(25, LFNoise0.kr(5, 12, 14), 0.3)}.play
{Blip.ar(25, LFNoise0.kr([5, 10], 12, 14), 0.3)}.scope


{ Blip.ar(XLine.kr(20000,200,6),100,0.2) }.play;

{ Blip.ar(200,Line.kr(1,100,20),0.2) }.play;

{ Blip.ar(200,Line.kr(1,100,20),0.2) }.play;

{ PMOsc.ar(Line.kr(600, 900, 5), 600, 3, 0, 0.1) }.scope;

scope({ PMOsc.ar(300, Line.kr(600, 900, 5), 3, 0, 0.1) });


{PMOsc.ar(440, Line.kr(1, 50, 5), 7)}.scope;



MouseY.kr(1,550)postln;



({Blip.ar(
	TRand.kr(
		100, 1000,
		Impulse.kr(Line.kr(1,20,60))),
	TRand.kr(
		1, 10,
		Impulse.kr(Line.kr(1,20,60))),
	Linen.kr(
		Impulse.kr(Line.kr(1,20,60)),
		0,
		0.5
		,1/Line.kr(1,20,60))
	)
}.play)

(
{
	PMOsc.ar(
	Line.kr(200, 800, 5),
	Line.kr(100, 40, 5),
	Line.kr(0, 3.14159 * 2, 5),
	0,
	0.5
	)
}.play;
)

{Line.kr(5,10,200)}.plot

{TRand.kr(
		100, 1000,
	Impulse.kr(Line.kr(1,20,60)))}.plot;

{1/Line.kr(1, 20, 60)}.plot;


(
{
	r = MouseX.kr(1/3, 10);
	SinOsc.ar(mul:Linen.kr(Impulse.kr(r), 0,1,1/r))
}.scope;
)

(
{
	r = MouseX.kr(1/3, 10);
	Linen.kr(Impulse.kr(r), 0,1,1/r)
}.plot;
)


	