(
t = [0,2,4,6,7,\rest];
d = [1];

Ptpar([
        0, Pbind(
                \degree, Pseq(t,inf),
                \dur,Pseq(d,inf)),
        2, Pbind(
                \degree, Pseq(t,inf),
                \dur,Pseq(d,inf)),

        5, Pbind(
                \degree, Pseq(t,inf),
                \dur,Pseq(d,inf)),

]).play;
)



