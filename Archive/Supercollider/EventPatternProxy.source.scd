(
f = {|x| x + 1};
g = {|x| x * 2};

)

g

f.(3)
g.(3)

h = g<>f;
i = f<>g;
h.(1)
i.(1)

(
~rhythm = EventPatternProxy(Pbind(
    \dur, Pseq([1,1,1,1],  inf)
));
~melody = EventPatternProxy(Pbind(
    \degree, Pseq((0..7), inf)
));

)
t = TempoClock(1)
p = Pchain(~melody, ~rhythm).play(t, quant:4);

~melody.source = PmonoArtic(\default, \degree, Pseries(4, Prand(#[-1, 1], inf), inf).fold(-4, 11));

~melody.source = Pbind(\degree, Pseries(4, Pwrand(#[-2, -1, 1, 2], #[0.3, 0.2, 0.2, 0.3], inf), inf).fold(-4, 11));

~rhythm.source_(Pbind(\dur, Pseq([2, 0.5, 1, 0.5], inf))).quant_(4)
~rhythm.source_(Pbind(\dur, Pseq([1.5, 0.5, 1.5, 0.5], inf))).quant_(4)
~rhythm.source_(Pbind(\dur, Pseq([1, 1, 1, 1], inf))).quant_(4)


p.stop;