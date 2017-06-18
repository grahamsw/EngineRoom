(
SynthDef(\thunk, {
	|baseFreq = 200, freq = 500, startAmp= 0.5, dur = 2 |
	Out.ar(1, LFNoise1.ar(baseFreq) * SinOsc.ar(freq, 0, XLine.kr(startAmp, 0.00001, dur, doneAction:2)));
}).add;
)

Synth(\thunk);
(
Pbind(
	\instrument, \thunk,
	\freq, Pwhite(200, 500, inf).round(50),
	\dur, Prand([0.1, 0.2, 0.05], inf)
).play
)

{LFNoise1.ar(200) * SinOsc.ar(300) }.plot(4)