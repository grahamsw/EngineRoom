(
SynthDef(\sonifier_sustain,
	{
		|freq = 400, attack = 0.1, decay = 0.1, sustain = 0.8, release = 0.1,    mul = 0.5, harmonics=#[1, 1.5], amps = #[0.5, 0.5]|
		var env, out;
		env = Env([0, 1, sustain, sustain, 0] * mul, [attack, decay, 1-(attack + decay + release), release] * dur);

		out = Klang.ar(`[harmonics, amps], freqscale:freq) * EnvGen.kr(env, doneAction:2);
		Out.ar(0, out);
}).add;
)
