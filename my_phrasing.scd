
(
Pdef( \base,
    {
        |root=0, dur=1, amp=0.5|
        Pbind(
            \instrument, \default,
            \midinote, Pseq([0,  4, 7, 12] + root, inf),
            \dur, dur,
            \amp, amp
)});
)

Pbind(
().play

(Pdef(\base) <> (root:60, dur:Pseq([0.5, 0.5], 5), amp:0.1, pan: [-1,1])).play

(
Pdef(\playit,
    Pbind(
        \instrument, \base,
        \type, \phrase,
        \root, 60,
        \dur, 1,
        \amp, 0.1,

));
)
Pdef(\playit).play

Pdef (\legato, Pbind( \amp, 0.1));

(Pdef(\legato) <> Pdef(\playit)).play

       