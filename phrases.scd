(
Pdef(\x,
    Pbind(
        \instrument, \wave,
        \mod, Pseq([1,0], inf),
        \dur, Pn(1/4, 8),
        \note, 7
    )
);
)

Pdef(\x).play
(
Pdef(\y,
    Pbindf(
        Pdef(\x),
        \amp, 0.2,
        \note, Pshuf([0,2,3,5], 2) + Prand([0, 5, [0, 4]], inf),
        \dur, Pseq([1,3,2,3]/6, inf)

    )
);
Pdef(\y).play

)
Pn(1/2, 8).asStream.nextN(10).postln;
(
Pdef(\z,
    Pbindf(
        Pdef(\y),
        \dur, 1/4
    )
)
)

(
Pdef(\a,
    Pmul(\dur, Pwhite(-0.02, 0.02)+1,
        Pseq([
            Ppar([Pdef(\x), Pdef(\y)]),
            Pdef(\x),
            Pdef(\y),
            Pdef(\z),
            Ppar([Pdef(\x), Pbindf(Pdef(y), \ctranspose, 12)])
    ], inf)
    )
    )
)

Pdef(\a).play
)


(
Pdef(\x,
    Pbind(
        \instrument, \wave,
        \dur, Pseq([1,3, 2, Prand([3,2])],inf)/6,
        \octave, ([6,4])
    )
);
)

(
Pdef(\x,
    Pbind(
        \instrument, \wave,
        \dur, Pseq([1,3, 2, Prand([3,2])],1)/6,
        \octave, ([6,4])
    )
);
)

Pdef(\a).stop

(
Pdef(\b, Pbindf(Pdef(\y), \ctranspose, 2));
Pdef(\a,
    Pmul(\dur, Pwhite(-0.02, 0.2) + 1,
    Psym(
        Pseq([[\x,\y], \x, \y, \z, [\x, \b]], inf).trace
    )
)
)
)
Pdef(\a).play

(
Pdefn(\sequence, Pseq([[\x,\y], \x, \y, \z, [\x, \b]], inf));
Pdef(\a,
    Pmul(\dur, Pwhite(-0.02, 0.2) + 1,
    Psym(
            Pdefn(\sequence).trace
    )
)
)
)
Pdefn(\sequence, Pseq([\x], inf));





(instrument: \x, type: \phrase).play

(
Pbind(
    \type, \phrase,
    \instrument, \x,
    \legato, 2.5,
    \note, Pseq([0, 5, 20], inf)
).play
)

(
Pdef(\x,
    {
        |note = 0, n = 6, step = 3, modulo = 15, sustain=1|
        Pbind(
            \instrument, \wave,
            \note, note.value + (Pseries(1, step, n) % modulo) + 7,
            \dur, sustain.value / n / 2
        )
    }
);
)
Pdef(\x).play
Pdef(\a).play

(
Pdef(\a,
    Pbind(
        \type, \phrase,
        \instrument, \x,
        \note, Pseq([0,5,4,8,12, 20], inf),
        \n, 5,
        \modulo, Pseq([3, [4,3,5], [13, 15]], inf),
        \dur, Pseq([1,2,0.5,1.5],inf)
    )
);
)

Pdef(\a).play

(
Pdef(\b,
    Pbind(\type, \phrase,
        \instrument, \a,
        \note, Pseq([0, 5,4,8, 0], inf),
        \n, 5,
        \recursionLevel,2,
        \modulo, Prand([3, [4, 3, 5], [13, 15]], inf),
        \dur, Pseq([1, 2, 0.5, 1.5], inf) * 2
    )
)
)
Pdef(\b).stop
