(
SynthDef(\sin, {
	|freq = 440, dur = 1, mul = 0.1, out = 0|
	var env = Env.perc(dur/10, releaseTime: dur * 9/10);
	var snd = SinOsc.ar(freq: freq, mul:mul) * EnvGen.kr(env, doneAction:2);
	Out.ar(out, snd   );
}).add;

SynthDef(\noise, {
	|freq = 440, rq = 1, mul = 0.25, dur = 1, out = 0|
	var snd = EnvGen.kr(Env.perc(dur * 0.01, dur * (1-0.01)), doneAction:2) *  BPF.ar(WhiteNoise.ar(mul), freq, rq);

	Out.ar(out, snd);
}
).add;
)
Synth(\noise)

(

p = Pdef(\tune,
	Pbind(
		\instrument, \sin,
		\midinote, Pseq([60, 62, 64, 65, 67, 69, 71, 72, \rest], inf),
	//	\midinote, Pseq([60, 60, 65, 65, 72, 72, \rest], inf),
		\transpose, 12,
		\dur, 1,

	    \mul, 0.3
)
)
)

p.play.quant(1)

(

q = Pdef(\tune4,
	Pbind(
		\instrument, \noise,
		\freq, 1000,
		\dur, 1,
		\stretch, 1,
		\rq, 1,
	    \mul, 0.8
)
)
)

q.play.quant(0.01)
q.stop

s.plotTree

