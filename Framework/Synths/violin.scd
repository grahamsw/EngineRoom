// from http://sccode.org/1-5as
// by nicolaariutti

// define the violin-like sound synth
(
SynthDef(\violin, {
	| midinote=60, gate=1, amp=0.25 |
	var env = EnvGen.kr(Env.asr(0.1, 1, 0.1), gate, doneAction:2);
	var sig = VarSaw.ar(
		midinote.midicps,
		width:LFNoise2.kr(1).range(0.2, 0.8)*SinOsc.kr(5, Rand(0.0, 1.0)).range(0.7,0.8))*0.25;
	sig = sig * env * amp;
	Out.ar(0, sig!2);
}).add;
)



// play a chord (farfisa-like sound)
(
[60, 64, 67].do ({
	| note |
	Synth(\violin, [\midinote, note]);
})
)

// play some random notes
(
p = Pbind(
	\instrument, \violin,
	\midinote, Prand( Scale.majorPentatonic.degrees, inf) + 60,
	\dur, 3,
	\legato, 1
).play;
)
