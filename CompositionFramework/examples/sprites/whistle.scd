
(
SynthDef(\whistle, {
	|freq = 440, focus = 4, rq = 0.03, pulseFreq = 5, amp = 0.5, out = 0|
	var env = EnvGen.kr(Env.new([0, 1, 0.5, 0], [0.5,1, 3]), doneAction:2);
	var snd = BPF.ar(Pulse.ar(freq, LFTri.kr(pulseFreq).range(0.01, 0.5)), 4  * freq, rq);
	Out.ar(out, snd * env * amp);
}).add;
)
(

~testWhistle = {
(
Pbind(\instrument, \whistle,
	\focus, Pseq([1,3,7,6,3, 8, 3, 10] * 440, inf),
	\dur, 0.1,
	\amp, 0.8
).play
)

};
)

~testWhistle.()
