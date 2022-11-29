(


fork {

SynthDef(\pluck, {arg freq=440, amp=1, trig=1, time=2, coef=0.1, cutoff=2, pan=0;
    var pluck, burst;
    burst = LPF.ar(WhiteNoise.ar(1), freq*cutoff);
    pluck = Pluck.ar(burst, trig, freq.reciprocal, freq.reciprocal, time, coef:coef);
    DetectSilence.ar(pluck, 0.001, doneAction:2);
    Out.ar(0, Pan2.ar(pluck * amp, pan));
}).add;

SynthDef(\reverb, {
    | out = 0, mix = 0.1|
    var dry = In.ar(out);

    var wet =FreeVerb.ar(dry,0.45,2.0,0.5);

    wet = DelayN.ar(wet, 0.03, 0.03);
    wet = CombN.ar(wet, 0.1, {Rand(0.01,0.099)}!32, 4);
    wet = SplayAz.ar(2, wet);
    wet = LPF.ar(wet, 1500);
    5.do{wet = AllpassN.ar(wet, 0.1, {Rand(0.01,0.099)}!2, 3)};
    XOut.ar(out, mix, wet);
}).add;


/*
Synth(\pluck);
Synth(\pluck, [\coef, 0.01]);
Synth(\pluck, [\coef, 0.3]);
Synth(\pluck, [\coef, 0.9, \time, 0.1]);
Synth(\pluck, [\coef, 0.3, \time, 0.1]);
Synth(\pluck, [\coef, 0.3, \time, 5]);
Synth(\pluck, [\coef, 0.2, \time, 5, \cutoff, 1]);
Synth(\pluck, [\freq, 150, \coef, 0.2, \time, 5, \cutoff, 2]);
Synth(\pluck, [\coef, 0.2, \time, 5, \cutoff, 5]);
Synth(\pluck, [\coef, 0.2, \time, 5, \cutoff, 15]);
*/


//Scale.directory;

      s.sync;

      ~scales = [
            \major,
            \minor,
            \augmented,
            \augmented2,
            \diminished,
            \romanianMinor,
            \rast,
            \phrygian,
            \sikah,
            \scriabin,
            \hindu,
            \indian,
            \bastanikar,
            \locrian,
            \lydian,
            \diminished2,
            \zhi
        ].collect({
                    |scale|
                    Pseq(Scale.at(scale).degrees, 3)
                });

        Pdef(\rainstick,
            Pfx(
                Pbind(
                    \instrument, \pluck,
                    \degree, Pseq(~scales, inf),
                    \coef, 0.05,
                    \time, Pwhite(2, 3, inf),
                    \dur, 0.125,
                    \amp, Pseq([0.5, 0.1, 0.1, 0.1, 0.1, 0.1], inf),
                    \pan, Pwhite(-1.0, 1.0, inf)
                ),
                \reverb,\mix, 0.5)).play(quant:4)

      }
)







                