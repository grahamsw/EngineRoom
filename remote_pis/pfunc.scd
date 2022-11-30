// pre-grizzlying it before it goes into the trommel (gold rush)


(
p = Pbind(
    \a, Pseries(1, 1, inf),
    \b, Pif(
        Pkey(\a) <= 2,
        [0, 1],
        [3,4][0]
    )
).asStream;
)


// \b should thus take twice the value of \a in each event:
p = Pbind(\a, Pwhite(1, 10, inf), \b, Pkey(\a) * 2).asStream;


p.next(())    // for Pbind, must pass in a default event even if empty


(
p = Pbind(
    \a, Pseq([[0,1], [2,3], [4,5]], inf),
    \b, Pfunc({|evt| evt[\a][0]})

).asStream;
p.nextN(5, ())
)
(
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
    [Pseq(Scale.at(scale).degrees, 3), Scale.at(scale).degrees.size]
                });
)

(

~scales = [Pseq([0,1,2], 1), Pseq([7,6,5,4,3],1)];
Pbind(
    \type, \rest,
    \aa, Pseq(~scales, inf).trace

).play

)

~ddd = Pseq([[0,1], [2,3], [4,5]], inf)
(
a = Plazy({
    Prand(~scales,inf);
});

Pbind(
    \aa, ,
    \degree, Pfunc{|evt| evt[\aa][0]},
    \cc, Pfunc{|evt| evt[\aa][1]},
    \amp, 0.5
).play
)
(
Pbind(\v, a,
   \ff, Pfunc({})

).asStream.nextN(7, ())
)

().play




(
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
    [Pseq(Scale.at(scale).degrees, 3), Scale.at(scale).degrees.size]
                });
)