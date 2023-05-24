(
~melody1 = Pseq([0,1,2,3,4,5,6,7], inf);
~melody2 = Pseq([0, 2, 4, 7], inf);
~melody3 = Pseq([7, 6, 5, 4], inf);

~durs1 = Pseq([1], inf);
~durs2 = Pseq([3,1]/2, inf);
~durs3 = Pseq([0.25], inf);

~makeDef = {
    | name, degrees, durs |
    Pdef(name, Pbind(\degree, degrees, \dur, durs));
};

[
    [\theme1, ~melody1, ~durs1],
    [\theme2, ~melody2, ~durs2],
    [\theme3, ~melody3, ~durs3]
].do {|items|
    ~makeDef.(items[0], items[1], items[2]);
}
)

(
t = TempoClock(120);
Pdef(\theme1).play(t, quant: 4);

().play

Pdef(\theme1).source