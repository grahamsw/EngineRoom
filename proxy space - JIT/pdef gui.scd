(
p = Pbind(
    \degree, Pseq([0, 1,2,3], inf),
    \dur, Pseq([2, 1], inf)
)


)

(
Pdef(\kk,
    Pbind(
    \degree, Pseq([0, 1,2,3], inf),
    \dur, Pseq([2, 1], inf)
    )
)
)
p.play

Pdef(\kk).play

Pdef(\kk, \legato, 5)

PdefAllGui

(
Pdef(\a, { |e| 100.do { |i| i.postln; 0.5.wait } });
Pdef(\b, { |e| 100.do { |i| Pdef(\a).set(\otto, 8.rand); exprand(0.1, 3.0).wait } });
t = PdefAllGui(8);
)
