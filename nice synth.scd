PdefAllGui()

(

SynthDef(\param, { arg freq = 100, sustain, amp;
	var sig;
    sig = LFPar.ar(freq: freq,
        mul: EnvGen.kr(Env.perc(0.01, sustain, 0.5), doneAction:2) * amp);
	sig = Splay.ar(sig);
	Out.ar(0, sig);
}).add;
)

t = TempoClock.default.tempo = 120/60;


(
Pdef(\x,
Pbind(
        \midinote, Pseq([[60-12+4, 60-12, 60], 64, 69, [72, 76, 79]], inf),
    \dur, Pseq([1.5, 0.5, 1, 1], inf),
    \instrument, \param,
        \amp, Pseq([0.3,0.3, 0.3, 0.1], inf),
        \sustain, Pseq([8, 2,2,2], inf),
) // returns an EventStream

).quant_(4);
)

Pdef(\x).play(t)

)
Pbindef(\x, \dur, Pseq([0.5], inf));
Pdef(\x, nil)
g = Pdef(\y,
Pbind(
        \midinote, Pseq([60, 64, 67, [72, 76, 79, 84]].reverse, inf),
    \dur, Pseq([1.5, 0.5, 1, 1], inf),
    \instrument, \param,
        \amp, Pseq([0.5,0.3, 0.3, 0.1], inf),
	\sustain, 1,
) // returns an EventStream

).quant_(4);

().play
f.play(t)