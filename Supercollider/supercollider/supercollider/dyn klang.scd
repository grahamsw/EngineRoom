(
{
loop({
    play({
        var mod = SinOsc.kr(Rand(0.1, 0.9), 0, Rand(5, 20));
        Pan2.ar(DynKlang.ar(`[ Array.rand(12, 200.0, 2000.0), 1, mod ]), 1.0.rand)
            * EnvGen.kr(Env.sine(4), 1, 0.02, doneAction: 2);
    });
    2.wait;
})
}.fork;
)


// resetting the frequencies and amplitudes after the synth has been created
(
SynthDef('help-dynKlang', {| freqs=#[220, 440, 880, 1760],
    amps=#[0.35, 0.23, 0.12, 0.05],
    phases=#[1, 1.5, 2, 2.5]|

    Out.ar(0, DynKlang.ar(`[freqs, amps, phases]))
}).add
)

a = Synth('help-dynKlang');

a.setn(\freqs, Array.rand(4, 500, 2000));
a.setn(\amps, Array.rand(4, 0.01, 0.25));