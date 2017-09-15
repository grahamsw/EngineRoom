(
SynthDef(\noise, {
	|freq = 440, rq = 1, mul = 0.25, pos = 0, out = 0|
	var snd = /* EnvGen.kr(Env([1,1], [1]), doneAction:2) * */ BPF.ar(WhiteNoise.ar(mul), freq, rq);

	Out.ar(out, Pan2.ar(snd, pos));
}
).add;
)

(
p =
Pdef(\poo,
Pmono(
	 \noise,
	\freq, Pseq([440, 440], inf),
	\rq, Pseq([1, 10], inf),
		\dur, Pseq([4, 0.05], inf),
	\mul, Pseq([0.25, 0.5], inf)

));


)

p.play

Pmono