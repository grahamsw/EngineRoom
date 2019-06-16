
(

SynthDef (\glissando, {
	| from = 200, to = 2000, len = 10, amp = 0.6, out = 0|
	var pitchenv = Env([from, to], [len], 'exp');
	var ramp = 0.01;
	var sound = SinOsc.ar(EnvGen.kr(pitchenv));
	var ampenv = Env.linen(ramp, len-(2 * ramp), ramp, amp);
	sound = EnvGen.kr(ampenv, doneAction: 2) * sound;
	Out.ar([0,1], sound);
}).add;

)
(
~play = {|from, to, len, amp|
	Synth(\glissando, [\from, from, \to, to, \len, len, \amp, amp]);
};
)


(

~playPattern = {
	|freqFrom, freqTo, durFrom, durTo, ampFrom, ampTo, lenFrom, lenTo |
	var pitchRange = Pwhite(freqFrom, freqTo, inf);
	var ret = Pbind(
	\instrument, \glissando,
	\from, pitchRange,
	\to, pitchRange,
		\dur, Pwhite(durFrom, durTo, inf),
	\amp, Pwhite(ampFrom, ampTo, inf),
	\len, Pwhite(lenFrom, lenTo, inf)
	);
	ret.play;
}

)
(
y = ~playPattern.(
	freqFrom:80,
	freqTo:120,
	durFrom:0.16,
	durTo:0.46,
	ampFrom:0.01,
	ampTo:0.03,
	lenFrom:0.1,
	lenTo:20)
)
y.play
y.stop

(
z = ~playPattern.(
	freqFrom:5180,
	freqTo:1020,
	durFrom:0.06,
	durTo:0.16,
	ampFrom:0.01,
	ampTo:0.04,
	lenFrom:0.07,
	lenTo:0.1)
)


z.stop

(
t = ~playPattern.(
	freqFrom:80,
	freqTo:5000,
	durFrom:1,
	durTo:7,
	ampFrom:0.01,
	ampTo:0.03,
	lenFrom:3,
	lenTo:7)
)


t.stop


t.play

(
~pitchRange = Pwhite(120, 180, inf);
Pdef(\gliss, Pbind(
	\instrument, \glissando,
	\from, ~pitchRange,
	\to, ~pitchRange,
	\dur, 0.16,
	\amp, Pwhite(0.05, 0.07, inf),
	\len, Pwhite(0.1, 1, inf),

)).play;

)

().play
