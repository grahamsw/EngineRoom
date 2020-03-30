(

SynthDef("someGrains", { arg centerFreq = 777, freqDev = 200, grainFreq = 2;

	var gate;

	gate = Impulse.kr(grainFreq);

	Out.ar(

		0,

		SinOsc.ar(

			LFNoise0.kr(4, freqDev, centerFreq),

			0,

			EnvGen.kr(Env.sine(0.1), gate, 0.1)

		)

	)

}).load(s);



SynthDef("aDelay", { arg delay = 0.25;

	Out.ar(

		1,

		DelayN.ar(

			In.ar(0, 1),

			delay,

			delay

		)

	)

}).load(s);

)

// make 2 groups, the 1st for sources and the 2nd for effects

(

~source = Group.head(s);

~effects = Group.tail(s);

)



// place grains into the delay ... source is on the left and delayed source is on the right

(

Synth.head(~source, "someGrains");

Synth.head(~effects, "aDelay");

)

(

{

	CombN.ar(

		SinOsc.ar(500.rrand(1000), 0, 0.2) * Line.kr(1, 0, 0.1),

		0.3,

		0.5,

		10

	)

}.scope;

)

(

{



		SinOsc.ar(500.rrand(1000), 0, 0.2) * Line.kr(1, 0, 0.1)

}.scope;

)

(

{

	AllpassN.ar(

		SinOsc.ar(500.rrand(1000), 0, 0.2) * Line.kr(1, 0, 0.1),

		0.3,

		0.25,

		6

















	)

}.scope;

)


(
{
    z = WhiteNoise.ar(0.2);
    z + AllpassN.ar(z, 0.01, XLine.kr(0.0001, 0.01, 20), 0.2)
}.play)

(
{
    z = WhiteNoise.ar(0.2);
    z + AllpassL.ar(z, 0.01, XLine.kr(0.0001, 0.01, 20), 0.2)
}.play)

(
{
    z = WhiteNoise.ar(0.2);
    z + AllpassC.ar(z, 0.01, XLine.kr(0.0001, 0.01, 20), 0.2)
}.play)

// used as an echo - doesn't really sound different than Comb,
// but it outputs the input signal immediately (inverted) and the echoes
// are lower in amplitude.
{ AllpassN.ar(Decay.ar(Dust.ar(1,0.5), 0.2, WhiteNoise.ar), 0.2, 0.2, 3) }.play;






(

{

var s, z, y;

	// 10 voices of a random sine percussion sound :

s = Mix.ar(Array.fill(10, { Resonz.ar(Dust.ar(0.2, 50), 200 + 3000.0.rand, 0.003)}) );

	// reverb predelay time :

z = DelayN.ar(s, 0.048);

	// 7 length modulated comb delays in parallel :

y = Mix.ar(Array.fill(7,{ CombL.ar(z, 0.1, LFNoise1.kr(0.1.rand, 0.04, 0.05), 15) }));

	// two parallel chains of 4 allpass delays (8 total) :

4.do({ y = AllpassN.ar(y, 0.050, [0.050.rand, 0.050.rand], 1) });

	// add original sound to reverb and play it :

s+(0.2*y)

}.scope

)