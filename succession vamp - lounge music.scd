


~ex = Panola.new("<c4 e> <e g> <c4 e g c5>");
~ex.asPbind.play

t = TempoClock(1).permanent_(true)
//t.tempo = 0.465

(
~acc = Panola.new("<c4 e c5>");
~acc_notes = ~acc.midinotePattern.list;

Pdef(\accompaniment,
    Pbind(
        \instrument, \default,
        \midinote, Pseq(~acc_notes, inf),
        \amp, Pseq([0.15, 0.1, 0.12, 0.1]*0.5, inf),
    \dur, Pseq([0.25], inf)
    )
)

)


(
~melody = Panola.new("c5_1 g4 a e_1");
~melody_notes = ~melody.midinotePattern.list;
~melody_durs = ~melody.durationPattern.list;
Pdef(\melody,
    Pbind(
        \instrument, \default,
        \midinote, Pseq(~melody_notes, inf),
        \amp, Pseq([0.3], inf),
    \dur, Pseq(~melody_durs, inf)
    )

).quant_(4)
)

(

Pdef(\melody2,
    Pbind(
        \instrument, \default,
        \note, Pseq([[5,17]], 1),
        \amp, Pseq([0.3], inf),
    \dur, Pseq([1], inf)
    )

).quant_(4)
)

)
Pdef(\melody2).play(t, quant:4)
Pdef(\melody2).stop

Pdef(\accompaniment).play(t, quant: 4)

Pdef(\melody).play(t, quant: 4)

s.defaultGroup.fade(5)