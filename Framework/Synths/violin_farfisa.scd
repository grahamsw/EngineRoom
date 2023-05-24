// from http://sccode.org/1-5as
// by nicolaariutti

// define the violin-like sound synth


/*
// play a chord (farfisa-like sound)
(
[60, 64, 67].do ({
	| note |
	Synth(\violin, [\midinote, note]);
})(
SynthDef(\violin_farfisa, {
	| midinote=60, amp=0.25 |
	var env = EnvGen.kr(Env.perc, doneAction:2);
	var sig = VarSaw.ar(
		midinote.midicps,
		width:LFNoise2.kr(1).range(0.2, 0.8)*SinOsc.kr(5, Rand(0.0, 1.0)).range(0.7,0.8))*0.25;
	sig = sig * env * amp;
	Out.ar(0, sig!2);
}).add;
)
)

// play a single note (it seems also a flute!)
x = Synth(\violin, [\midinote, 84, \dur, 0.3]);



// play some random notes
(
p = Pbind(
	\instrument, \violin,
	\midinote, Prand( Scale.majorPentatonic.degrees, inf) + 60,
	\dur, 3,
	\legato, 1
).play;
)
*/