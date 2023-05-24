

// want to make a note happen N times per period of M seconds,
// randomly spaced

(
// this generates n random intervals that add up to total
~make_intervals = {|n, total|
    (n.collect {1.0.rand}).normalizeSum * total
};

// returns a function that when evaluated (in Pfunc, say)
// returns intervals n of which will add up to total.
~durer = {|n, total|
    var ris = nil;
    var next_dur = {
        var ret = ris.next;
        if (ret == nil, {
            ris = Routine {
                ~make_intervals.(n, total).do {|i| i.yield}
            };
            ret = ris.next;
        });
        ret;
    };
    next_dur;
}
)

(
d = ~durer.(1, 15);
e = ~durer.(10, 15);
)

(
Ppar([
Pbind(
        \note, 1,
        \dur, Pfunc({d.().postln}),
        \legato, 0.1,
        \amp, 0.3
    ),
 Pbind(
        \note, 5,
        \dur, Pfunc({e.().postln}),
        \legato, 0.1,
        \amp, 0.3
    ),
]
).play
)


