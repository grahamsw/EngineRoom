x = {VarSaw.ar(40!2, 0, 0.05)}.play
x.free;

(
SynthDef(\iter,{
	| freq = 40 |
		var temp, sum, env;
		env = EnvGen.kr(
			Env.perc(0.01, 5, 1, -2), doneAction:2);
		sum = 0;
		10.do {
			temp = VarSaw.ar(
				freq * {Rand(0.99, 1.02)}!2,
				{Rand(0.0, 1.0)}!2,
				{ExpRand(0.005, 0.05)}!2
			);
			sum = sum + temp;
		};
		sum = sum * 0.05 * env;
		Out.ar(0, sum);
}).add;
)


Synth(\iter, [\freq, 40])

(
p = Pbind(
    \instrument, \iter,
    \dur, Pwhite(0.2, 2, inf),
	\freq, Pexprand(50, 200, inf).round(12).trace,
    \atk, Pwhite(2.0, 3.0, inf),
    \rel, Pwhite(5.0, 10.0, inf),
    \amp, Pexprand(0.01, 0.2, inf),
    \pan, Pwhite(-0.8, 0.8, inf),
    ).play;
)
