(

SynthDef(\blip, {
	|freq|
	var env = Env.perc(level:0.1, releaseTime: 0.2).kr(doneAction:2);
	var sig = Pulse.ar(freq:freq, width: 0.05) * env;
	Out.ar(0, [sig, sig]);
}).add;
)

Synth(\blip, [\freq, 440])

(
Pdef (\melody,
	Pbind(
		\instrument, \blip,
		\dur, Pseq([1], inf),
		\degree, Pseq([0, 4, 6, 8], inf),
		\scale, Scale.minor,
		\octave, 5
	)
).play(TempoClock.default, quant:4);
)

(
Pdef (\harmony,
	Pbind(
		\instrument, \blip,
		\dur, Pseq([1], inf),
		\degree, Pseq([3,2,1,0], inf),
		\scale, Scale.major,
		\octave,4
	)
).play(TempoClock.default, quant:4);
)
