// \help_SPE3 AllPass
(
SynthDef( \AllPassN, { arg freq, reps;
    var out, env;
    out = RLPF.ar(
        LFSaw.ar( freq, mul: EnvGen.kr( Env.perc, levelScale: 0.3, doneAction: Done.freeSelf ) ),
        LFNoise1.kr(1, 36, 110).midicps,
        0.1
    );
    reps.do({ out = AllpassN.ar(out, 0.05, [0.05.rand, 0.05.rand], 4) });
    Out.ar( 0, out );
}).add
)
Synth( \AllPassN, [\freq, 620, \reps, 0])
(
var freqStream;

freqStream = Pseq([
    Prand([
        nil,    // a nil item reached in a pattern causes it to end
        Pseq(#[24, 31, 36, 43, 48, 55]);
    ]),
    Pseq([ 60, Prand(#[63, 65]), 67, Prand(#[70, 72, 74]) ], { rrand(2, 5) }),
    Prand(#[74, 75, 77, 79, 81], { rrand(3, 9) })
], inf).asStream.midicps;

Task({
    loop({
        Synth( \AllPassN, [\freq, freqStream.next , \reps, 6]);
        0.13.wait;
    })
}).play;
)
s.defaultGroup.free






