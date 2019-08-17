(
SynthDef(\sonifier_sustain,
	{
		|freq = 400, attack = 0.1, decay = 0.1, sustain = 0.8, release = 0.1,    mul = 0.5, harmonics=#[1, 1.5], amps = #[0.5, 0.5], gate = 1, out = 0|
		var env, sig;
		env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);

		 sig = Klang.ar(`[harmonics, amps], freqscale:freq) * env;
		Out.ar(0, sig);
}).add;
)
/*
Synth(\sonifier_sustain);
(
Pdef(\poo,
	Pbind(
		\instrument, \sonifier_sustain,
		\dur, 0.07,
		\midinote, Pseq([80, 63, 65, 71], inf),
);).play(quant:0.5);

)

Pdef(\poo).play.quant(1)

*/