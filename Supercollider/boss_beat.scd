
(
SynthDef(\iter2, {
	| freq = 200, dev = 1.02|
	var temp, sum;
	sum = 0;
	10.do {
		|count|
		temp = SinOsc.ar(freq * (count + 1) * LFNoise1.kr({Rand(0.05, 0.2)}!2).range(dev.reciprocal, dev));
		temp = temp * LFNoise1.kr({Rand(0.5, 8)}!2).exprange(0.01, 1);
		sum = sum + temp;
	};
	sum = sum * 0.05;
	Out.ar(0, sum);
}).add;
)

x = Synth(\iter2, [\freq, 40, \dev, 1.02])
x.free


(
p = Pbind(
    \instrument, \iter2,
    \dur, Pwhite(0.05, 0.5, inf),
	\freq, Pexprand(50, 800, inf).round(12).trace,
    \atk, Pwhite(2.0, 3.0, inf),
    \rel, Pwhite(5.0, 10.0, inf),
    \amp, Pexprand(0.01, 0.2, inf),
    \pan, Pwhite(-0.8, 0.8, inf),
    ).play;
)
