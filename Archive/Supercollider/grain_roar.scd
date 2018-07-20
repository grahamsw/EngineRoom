(

SynthDef(\Ugen_ex3, {
	|gate = 1, amp = 1, rate = 10|
	var trigger, dur, carfreq, modfreq, index, pan, env;
	trigger = Impulse.ar(rate);
	dur = rate.reciprocal;
	carfreq = LFNoise2.kr(0.1).range(100, 110);
	modfreq = LFTri.kr(0.1).exprange(200, 240);
	index = LFCub.kr(0.2).range(4, 10);
	pan = WhiteNoise.ar.range(-0.1, 0.1);
	env = EnvGen.kr(
		Env([0,1,0], [1,1], \sin, 1),
		gate,
		levelScale: amp,
		doneAction: 2);
	Out.ar(0,
		GrainFM.ar(2, trigger,  dur, carfreq, modfreq, index, pan,-1) * env);
}).add;
)
(
#a, b, c = [80, 100, 120].collect({ |freq|
	Synth(\Ugen_ex3, [\rate, freq, \amp, 0.2]);
});
)
(
[c].do({
	|syn|
	syn.set(\gate, 0);
})
)
(
a.set(\rate, 40);
b.set(\rate,60);
c.set(\rate, 40);
)

(
Pbind(
	\instrument, \Ugen_ex3,
	\rate, Pseq([60, 121, 62, 63, 64, 65, 66]),
	\dur, 3
).play
)

{ SinOsc.ar(Latch.kr(SinOsc.kr(0.55).range(320, 460), Impulse.kr(6.7)),0, 0.2) }.play;