



(
SynthDef(\flux8, {
        |freq=60, amp=0.1, detune=1.05, gate=1, low=0.5, high=2, varlag=0.1,
         spectra=#[10, 6, 7, 10, 0.01, 6, 0.01, 14], out=0|
        var env, sig;
        spectra = spectra.normalizeSum;
        sig = Splay.ar(Array.fill(spectra.size,{
            |n|
            SinOsc.ar(
                freq.varlag(varlag) * (n+detune),
                n.linlin(0.0, spectra.size, 0, 2pi),
                SinOsc.kr(1/(n+1)).range(spectra[n]* low,spectra[n]*high));
    }))
        * amp;

        env = EnvGen.kr(Env.adsr,gate, doneAction:2);
        Out.ar(out, sig * env);
        }).add;

)
(
a = Synth(\flux8);

a.set(\amp, 0.6);
a.set(\freq, 60);
a.set(\low, 0.4, \high, 1.4);
a.set(\varlag, 0.1);
)

a.set(\detune, 1.0)
a.set(\spectra, [10,12,24,4,5,28,0,18])

(
SynthDef(\sin, {|freq = 400, variationFreq = 1, from = 0.5, to=1, out=0|
    Out.ar(out, SinOsc.ar(freq, 0, SinOsc.kr(variationFreq).range(from, to)));
}).add
)

b =  Synth(\sin)

    b.set(\from, 0.1)
    b.set(\to, 0.2)
)

