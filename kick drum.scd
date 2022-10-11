(
SynthDef(\kick,
{
        | freqA = 1000, freqB = 50, freqC=1, freqDur1=0.01, freqDur2=0.2, freqC1=1, freqC2=(-1), atk=0.01, rel=1, c1=1,c2=(-12),amp=0.8,pan=0,out=0|
        var sig, env, freqSweep;
        freqSweep=Env([freqA, freqB, freqC],[freqDur1, freqDur2], [freqC1, freqC2]).ar;
        env = Env([0,1,0], [atk, rel], [c1,c2]).kr(2);
        sig=SinOsc.ar(freqSweep, pi/2);
        Out.ar(out, Pan2.ar(sig * env,pan,amp));
    }
).add;
)

(
~setPdefBeat = {
    | name, beat |
    Pdef(
    name,
    Pbind(
        \instrument,   \kick,
            \freqA,    beat[\freqA],
            \freqB,    beat[\freqB],
            \freqC,    beat[\freqC],
            \freqDur1, beat[\freqDur1],
            \freqDur2, beat[\freqDur2],
            \freqC1,   beat[\freqC1],
            \freqC2,   beat[\freqC2],
            \atk,      beat[\atk],
            \rel,      beat[\rel],
            \c1,       beat[\c1],
            \c2,       beat[\c2],
            \amp,      beat[\amp],
            \pan,      beat[\pan],
            \dur,      beat[\dur],
            \timingOffset, beat[\timingOffset]
    )
).quant(4)
}
)
(
~beat2 = (
    \freqA: [650, 600],
    \freqB: [80,70],
    \freqC: [100, 70],
    \freqDur1: 0.07,
    \freqDur2: 1,
    \freqC1: -1,
    \freqC2: -4,
    \atk: [0.01, 0.01],
    \rel: [1, 1],
    \c1: 1,
    \c2: (-12),
    \amp: Pseq([Pwhite(0.13, 0.15, 1),
    //    Pwhite(0.05, 0.1, 1),
        Pwhite(0.05, 0.1, 1),
        Pwhite(0.05, 0.1, 1),
        Pwhite(0.1, 0.13, 1),
     //   Pwhite(0.05, 0.1, 1),
        Pwhite(0.05, 0.1, 1),
        Pwhite(0.05, 0.1, 1)
    ] * 0.3, inf),
    \pan: 0.5,
    \dur: (1/3),
    \timingOffset: Pseq([0,
        Pwhite(0, 0.0015, 1),
        Pwhite(0, 0.0015, 1),
        Pwhite(0, 0.0015, 1), ], inf)
);

~setPdefBeat.(\pat1, ~beat2)
)
(
~beat1 = (
    \freqA: [350, 400],
    \freqB: [100,100],
    \freqC: 50,
    \freqDur1: 0.1,
    \freqDur2: 1,
    \freqC1: 1,
    \freqC2: -4,
    \atk: [0.01, 0.01],
    \rel: [1, 0.5],
    \c1: 1,
    \c2: (-12),
    \amp: Pseq([Pwhite(0.13, 0.15, 1),
        Pwhite(0.05, 0.1, 1),
        Pwhite(0.05, 0.1, 1),
        Pwhite(0.05, 0.1, 1),
        Pwhite(0.1, 0.13, 1),
        Pwhite(0.05, 0.1, 1),
        Pwhite(0.05, 0.1, 1),
        Pwhite(0.05, 0.1, 1)
    ] , inf),
    \pan: [-0.5, -0.5],
    \dur: (1/8),
    \timingOffset: Pseq([0,
        Pwhite(0, 0.0015, 1),
        Pwhite(0, 0.0015, 1),
        Pwhite(0, 0.0015, 1), ], inf)
);

~setPdefBeat.(\pat0, ~beat1)
)


(
t = TempoClock(1).permanent_(true);

Pdef(\pat0).play(t, quant:4)
Pdef(\pat1).play(t, quant:4)

)

t.tempo = 1

Pdef(\pat0).stop

(
Tdef(\tempo,
{
    var tempo = 1;
    var inc = 0.005;
    loop {
        t.tempo = tempo;
        tempo = tempo - inc;
        if ((tempo < 0.5).or(tempo > 1.1), {inc = (-1) * inc});

        0.01.wait;
    }
}
)
)

Tdef(\tempo).stop


t.tempo

Pdef(\pat3).stop