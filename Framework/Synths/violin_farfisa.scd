(
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
x = Synth(\violin_farfisa, [\midinote, 74, \dur, 2]);


