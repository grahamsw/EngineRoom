(

SynthDef(\param, { arg freq = 100, sustain = 1, amp=0.1, out=0
	var sig;
    sig = LFPar.ar(freq: freq) *
    EnvGen.kr(Env.perc(0.01, sustain, amp), doneAction:2);
	Out.ar(out, sig);
}).add;
)
