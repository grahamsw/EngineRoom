
(
SynthDef( \help_SPE3_Allpass6, { arg freq;
    var out, env;
    out = RLPF.ar(
        LFSaw.ar( freq, mul: EnvGen.kr( Env.perc, levelScale: 0.3, doneAction: Done.freeSelf ) ),
        LFNoise1.kr(1, 36, 110).midicps,
        0.1
    );
    6.do({ out = AllpassN.ar(out, 0.05, [0.05.rand, 0.05.rand], 4) });
    Out.ar( 0, out );
}).add
)


(
SynthDef( \help_SPE3, { arg freq, reps;
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
Synth( \help_SPE3, [\freq, 620, \reps, 0])
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
        Synth( \help_SPE3, [\freq, freqStream.next , \reps, 6]);
        0.13.wait;
    })
}).play;
)
s.defaultGroup.free
nil.do{|n| n.postln}




(
SynthDef( \help_SPE3_Mridangam, { |out, t_amp|
    var sound;
​
    sound = Resonz.ar(
        WhiteNoise.ar(70) * Decay2.kr( t_amp, 0.002, 0.1 ),
        60.midicps,
        0.02,
        4
    ).distort * 0.4;
​
    Out.ar(out, sound);
    DetectSilence.ar(sound, doneAction: Done.freeSelf);
}).add;
​
SynthDef( \help_SPE3_Drone, { |out|
    var sound;
    sound = LPF.ar(
        Saw.ar([60, 60.04].midicps)
        +
        Saw.ar([67, 67.04].midicps),
        108.midicps,
        0.007
    );
    Out.ar(out, sound);
}).add;
)
​
(
// percussion solo in 10/8
​
var stream, pat, amp;
​
pat = Pseq([
    Pseq(#[0.0], 10),
​
    // intro
    Pseq(#[0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 2),
    Pseq(#[0.9, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0, 0.2, 0.0, 0.0], 2),
    Pseq(#[0.9, 0.0, 0.0, 0.2, 0.0, 0.2, 0.0, 0.2, 0.0, 0.0], 2),
    Pseq(#[0.9, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0, 0.2, 0.0, 0.2], 2),
​
    // solo
    Prand([
        Pseq(#[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0]),
        Pseq(#[0.9, 0.2, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0]),
        Pseq(#[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.2]),
        Pseq(#[0.9, 0.0, 0.0, 0.7, 0.2, 0.2, 0.0, 0.7, 0.0, 0.0]),
        Pseq(#[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.2, 0.7, 0.2, 0.0]),
        Pseq(#[0.9, 0.2, 0.2, 0.7, 0.2, 0.2, 0.2, 0.7, 0.2, 0.2]),
        Pseq(#[0.9, 0.2, 0.2, 0.7, 0.2, 0.2, 0.2, 0.7, 0.0, 0.0]),
        Pseq(#[0.9, 0.0, 0.0, 0.7, 0.2, 0.2, 0.2, 0.7, 0.0, 0.0]),
        Pseq(#[0.9, 0.0, 0.4, 0.0, 0.4, 0.0, 0.4, 0.0, 0.4, 0.0]),
        Pseq(#[0.9, 0.0, 0.0, 0.4, 0.0, 0.0, 0.4, 0.2, 0.4, 0.2]),
        Pseq(#[0.9, 0.0, 0.2, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0]),
        Pseq(#[0.9, 0.0, 0.0, 0.7, 0.0, 0.0, 0.0, 0.7, 0.0, 0.0]),
        Pseq(#[0.9, 0.7, 0.7, 0.0, 0.0, 0.2, 0.2, 0.2, 0.0, 0.0]),
        Pseq(#[0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])
    ], 30),
​
    // tehai : 7 beat motif 3 times sharing 1st beat with next 7x3
    // and again the third time:
    //   123456712345671234567                   123456712345671234567
    //                       123456712345671234567
    //   !                   !                   !                   !
    //   1234567890123456789012345678901234567890123456789012345678901
    Pseq(#[2.0, 0.0, 0.2, 0.5, 0.0, 0.2, 0.9,
        1.5, 0.0, 0.2, 0.5, 0.0, 0.2, 0.9,
        1.5, 0.0, 0.2, 0.5, 0.0, 0.2], 3),
    Pseq(#[5], 1),    // sam
​
    Pseq(#[0.0], inf)
]);
​
stream = pat.asStream;
​
Task({
    Synth(\help_SPE3_Drone);
    loop({
        if( ( amp = stream.next ) > 0,
            { Synth(\help_SPE3_Mridangam, [ \t_amp, amp ]) }
        );
        (1/8).wait;
    })
}).play
)