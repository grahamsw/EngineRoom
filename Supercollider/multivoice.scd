
s.makeGui
s.plotTree

(
SynthDef(\multi, {
	var sig, amp, env;
	env= EnvGen.kr(Env([0,1,0], [10, 10], [1, -1]), doneAction: 2);
	amp = SinOsc.kr({ExpRand(0.2, 12)}!8).range(0,1);
	sig = SinOsc.ar({ExpRand(50,1200)}!8);
	sig = sig * amp * env;
	Out.ar(0, Splay.ar(sig) * 0.1);

}).add;
)

a = Synth(\multi);

(
p = Pbind(
    \instrument, \multi,
    \dur, Pwhite(0.05, 0.5, inf),
	\freq, Pexprand(50, 1200, inf).round(12).trace,
    \atk, Pwhite(2.0, 3.0, inf),
    \rel, Pwhite(5.0, 10.0, inf),
    \amp, Pexprand(0.01, 0.2, inf),
    \pan, Pwhite(-0.8, 0.8, inf),
    ).play;
)

p.stop

{(
	SinOsc.ar(400, 0, 0.4) +
	SinOsc.ar(200, 0, SinOsc.kr(SinOsc.kr(0.1).range(2, 6)))
)* 0.3}.play