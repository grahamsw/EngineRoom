(
SynthDef(\wow, {
	|freq = 60, amp = 0.1, gate = 1, wowrelease = 3|
	var chorus, source, filtermod, env, snd;
	chorus = Lag.kr(freq,2) *  LFNoise2.kr([0.4, 0.5, 0.7, 1, 2, 5, 10]).range(1, 1.02);
	source = LFSaw.ar(chorus) * 0.5;
	filtermod = SinOsc.ar(1/16).range(1, 10);
	env = Env.asr(1, amp, wowrelease).kr(2, gate);
	snd = LPF.ar(in:source, freq: freq * filtermod, mul: env);
	Out.ar(0, Splay.ar(snd));
}).add;
)

s.plotTree


a = Array.fill(6, {Synth(\wow, [\freq, rrand(40, 70).midicps, \amp, rrand(0.1, 0.5)])})

6.do({|i| a[i].set(\gate, 0)})




SystemClock.sched(0, {a[5.rand].set(\freq, rrand(40,70),\\.midicps); rrand(3, 10)})


(
Pbind(
	\instrument, \wow,
	\degree, Pwhite(-7,7),
	\dur, Prand([0.125, 0.25], inf),
	\amp, Pwhite(0.5, 1),
	\wowrelease, 1
).play
)


(

Pbind(
	\instrument, \wow,
	\scale, Pstutter(8, Pseq([
		Scale.lydian,
		Scale.major,
		Scale.mixolydian,
		Scale.minor,
		Scale.phrygian], inf)),
	\degree, Pseq([0, 1,2,3,4,5,6,7], inf),
	\dur, 0.2,
	\amp, Pwhite(0.5, 1),
	\wowrelease, 4,
	\legato, 0.1
).play
)



(
SynthDef(\pluck, {
	|amp = 0.1, freq = 440, decay = 5, mutedString = 0.1|
	var env, snd;
	env = Env.linen(0, decay, 0).kr(doneAction:2);
	snd = Pluck.ar(
		in: WhiteNoise.ar(amp),
		trig: Impulse.kr(0),
		maxdelaytime: 0.1,
		delaytime: freq.reciprocal,
		decaytime: decay,
		coef: mutedString);
	Out.ar(0, [snd, snd] * env);
}).add;
)


Synth(\pluck)


(

~myControl = Bus.control(s, 1);

c = {Out.kr(~myControl, Pulse.kr(freq: MouseX.kr(1, 10), mul:MouseY.kr(0, 1)))}.play;

)


(

{
	Blip.ar(
		freq: LFNoise0.kr([1/2, 1/3]).range(50, 60),
		numharm: In.kr(~myControl).range(1,10),
		mul: LFTri.kr([1/4, 1/6]).range(0, 0.1))
}.play;
)


(

{
	Splay.ar(
		Pulse.ar(
			freq: LFNoise0.kr([1.4, 1, 1/2, 1/3]).range(100, 1000)

			* In.kr(~myControl).range(0.9, 1.1),
			mul: SinOsc.ar([1/3, 1/2, 1/4, 1/8]).range(0, 0.03))
	)
}.play
)










