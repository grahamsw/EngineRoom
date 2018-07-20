
{WhiteNoise.ar}.play
{PinkNoise.ar}.play
{BrownNoise.ar}.play
{GrayNoise.ar}.play

(


{
var env = EnvGen.kr(Env([0.001, 1, 0.001], [2.5, 7.5], \exp), doneAction:2);
		PinkNoise.ar(env);
}.play;
)


/* wow and flutter */
(
SynthDef(\wow, {
	|freq = 440, wow = 0, wowsps=1, dur=1|
	var freqenv, ampenv, out;
	freqenv = EnvGen.kr(Env(freq*[1, 1 + wow, 1,1,1], [wow/2, wow/2, 1-wow, 0]/wowsps, \lin, 3, 0));
	ampenv = EnvGen.kr(Env([0,1,1,0], [0.05, dur-0.1, 0.05]), doneAction:2);
	out = SinOsc.ar(freqenv, mul:ampenv);
	Out.ar(0, out);
}).add;
)
(
var freq = 300, wowsps=4, dur=2;
var wow = [0.02, 0.1];
Pbind(
	\instrument, \wow,
	\freq, freq,
	\wowsps, wowsps,
	\dur, dur,
	\wow, Pseq(wow)
).play;
)

/* R2D2 */
(
SynthDef(\sine, {|freq=440, dur=1|
	var env = EnvGen.kr(Env.linen(0.01, dur=0.02, 0.01, 0.707), doneAction:2);
	Out.ar(0, SinOsc.ar(freq, mul:env));
}).add;
)
(
var freqs, notedur = 1/10, songdur = 5;
freqs = {exprand(1000, 4000)}!(songdur/notedur);
Pbind(
	\instrument, \sine,
	\freq, Pseq(freqs),
	\dur, notedur
).play;
)

/* random melody */
(
var maj, min, chr, lotto;
maj=[0,2,4,5,7,9,11].scramble;
min = [0,2,3,5,6,9,11].scramble;
chr = (0..11).scramble.keep(7);
lotto = Scale.choose.postln.semitones.postln;
Pbind(
	\note, Pseq(maj++min++chr++lotto),
	\dur, 1/5
).play;
)