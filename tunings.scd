
Array.rand(8, 50, 90).nearestInScale(a.degrees).sort

a = Scale.major

a.tuning_(\just)

a.tuning

Scale.directory

Tuning.directory
a.cents

(
s.waitForBoot({
  //  a = Scale.ionian;

    p = Pbind(
        \degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2, 1, 0, \rest], inf),
        \scale, Pfunc({a}, inf),
        \dur, 0.25
    );

    q = p.play;
})
)

// change scale
a = Scale.phrygian;

// change tuning
a.tuning_(\pythagorean);

// can also set tuning at creation time
a = Scale.ionian(\pythagorean);
