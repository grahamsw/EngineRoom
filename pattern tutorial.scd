
(
~p0 = Pbind(\note, 8, \amp, 0.05, \dur, 0.5, \tempo, 0.25);
~p1 = Pbind(\note, 0, \amp, 0.1, \dur, 1, \delta, 4);
~p2 = Pbind(\note, 3, \amp, 0.1, \dur, 1, \delta, 4);
~p3 = Pbind(\note, 5, \amp, 0.1, \dur, 1, \delta, 4);
)

~p1.play(quant:0)
~p2.play(quant:1)
~p3.play(quant:3)
~p0.play(quant:0)


(
Pbind(

	\degree, Pslide((-6,-4 .. 12), 8, 3, 1, 0),
	\dur, Pseq([0.1, 0.1, 0.2], inf),
	\sustain, 0.15
).play(TempoClock.new(2))
)

(
Pbind(

	\degree, Ppatlace([
		Pseries(0, 1, 8),
		Pseries(2,1,7)],inf).trace,
	\dur, 0.25
).play
)

(
Pbind(
	\degree, Ptuple(
		[
			Pseries(7,-1,8),
			Pseq([9,7,7,7,4,4,2,2],1),
			Pseq([4,4,4,2,2,0,0,-3], 1)
		],inf
	),
	\dur, 1
).play
)


(
Pbind(
		\degree, Pseries(-7,1,15),
		\dur, Pgeom(0.5, 0.89140193218427,15)
).play
)


Ppoisson(1, inf).asStream.nextN(10000).histo(100, 0, 2).plot

Pmeanrand(0.0, 1.0, inf).asStream.nextN(10000).histo(100, 0, 2).plot






(
SynthDef(\trig_demo, {
	|freq, gate=1, t_trig=1|
	var env = Decay2.kr(t_trig, 0.01, 0.1),
	sig = SinOsc.ar(freq, 0,env) * Linen.kr(gate, 0.01, 0.1, doneAction:2);
	Out.ar(0, sig!2);
}).store;
)


(

p =
Pmono(\trig_demo,
	\freq, Pexprand(200, 800, inf),
	\trig, 1,
	\delta, 0.125).play
)
p.stop

Synth(\trig_demo, [\freq, 1000])




(
SynthDef(\bass, {
	| freq = 440, gate = 1, amp= 0.5, slideTime = 0.17, ffreq = 1100, width=0.15, detune = 1.005, preamp = 4|
	var sig, env = Env.adsr(0.01, 0.3, 0.4, 0.1);
	freq = Lag.kr(freq, slideTime);
	sig = Mix(VarSaw.ar([freq, freq * detune], 0,width, preamp)).distort * amp * EnvGen.kr(env, gate, doneAction:2);


	sig = LPF.ar(sig, ffreq);
	Out.ar(0, sig!2);
}).add;
)

Synth(\bass)


(
~patterns = (

	repeated:Pbind(
		\instrument, \bass,
		\midinote, 36,
		\dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.5], 1),
		\legato, Pseq([0.9, 0.3,0.3,0.3,0.3], 1),
		\amp, 0.5,
		\detune, 1.005
	),
	octave: Pbind(
		\instrument, \bass,
		\midinote, Pseq([36, 48, 36], 1),
		\dur, Pseq([0.25, 0.25, 0.5], 1),
		\amp, 0.5,
		\detune, 1.005
	),
	tritone: Pmono(
		\bass,
		\midinote, Pseq([36, 42, 41, 33], 1),
		\dur, Pseq([0.25, 0.25, 0.25, 0.75], 1),
		\amp, 0.5,
		\detune, 1.005
	)

)
)

(

TempoClock.default.tempo = 128/60;

p = Psym(Pxrand([\repeated, \octave, \tritone], inf), ~patterns).play
)























