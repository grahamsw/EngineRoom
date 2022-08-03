
Pdef(\chords).source.postcs
(

    ~chords=[
        [0,4,7,12],
        [4,7,11,16],
        [-3,0,4,7],
        [-3,0,5,9],
    ].collect({|c|
        [(c+60).midicps]

    });

    Pdef(\chords,
        Pbind(
            \instrument, \chord,
            \chord, Pxrand(~chords, inf).trace,
            \filterhz, 440,
            \klangamp, 0.05,
            \amp, 0.3,
            \dur, Pwhite(5, 30, inf).trace,
            \out, ~fxBus
        );
    );
)
[1,2,3].choose
Pdef(\cs).play
3.rand
().play
(
var chord = [1,2,3,4];
var chrd = chord + ([24.neg] ++ (36.neg!3));
chrd.postln;

(chord + 60).midicps.postln;

)
~chord = ([-3,0,5,9] + 60).midicps
x = Synth(\chord, [\chord, ~chord, \filterhz, 10])

x.set(\chord, ~chord)
x.set(\klangamp, 0.001)
x.set(\amp, 0.14)
x.set(\gate, 0)
x.set(\filterhz, 10)

