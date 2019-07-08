(
SynthDef(\lpf, {
	|in, passFreq = 1000, out = 0|
	Out.ar(out, LPF.ar(In.ar(in), passFreq));
}).add;
)
/*
(
SynthDef(\sn, {
	|out = 0|
	Out.ar(out, WhiteNoise.ar);
}).add
)

(
b = Bus.audio(s);
l = Synth(\lpf, [\in, b, \passFreq, 800]);
l.map(\passFreq, c);
Synth(\sn, [\out, b]);
)
{Out.kr(c, MouseX.kr(200, 800))}.play

c = Bus.control
l.set(\passFreq, 600)

*/
