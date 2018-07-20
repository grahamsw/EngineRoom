(
SynthDef(\train, {
	|out, xfreq = 15, sustain = 1.0, amp = 0.1, pan|
	Line.ar(1,1,sustain, doneAction:2);
	OffsetOut.ar(out, Pan2.ar(Impulse.ar(xfreq), pan, amp));
}).add;
)

p = ProxySpace.push;

~z.play;

(
~x = Pbind(
	\instrument, \train,
	\xfreq, Pseq([50, Pwhite(30, 800,1), 5, 14, 19], inf),
	\sustain, Pseq([Pwhite(0.01, 0.1, 1), 0.1, 1, 0.5, 0.5], inf),
	\pan, Prand([-1, 1], inf) * 0.3
)
)

(
~y = { Ringz.ar(~x.ar, 5000 * [1, 1.2], 0.01)};
~mod = { LFNoise1.kr(0.1).exprange(200, 5000)};
~z = { ~y.ar * (SinOsc.ar(~mod.kr) + 1)};

(
~x =Pbind(
	\instrument, \train,
	\xfreq, Pseq([50, ~mod, 5, ~mod, 19], inf),
	\sustain, Pseq([Pwhite(0.01, 0.1, 1), 0.1, 1, 0.5, 0.5], inf),
	\pan, Prand([-1, 1], inf) * 0.4
)
)
