Tdef(\x, { loop { 0.5.wait; "aaaaaaaaaaaaaazz".scramble.postln } }).play;
Tdef(\x, { loop { 0.125.wait; "aazz".scramble.postln } });
Tdef(\x, { loop { 0.5.wait; (note: 14.rand).play } });
Tdef(\x, { loop { 0.5.wait; (note: 14.rand + [0, 3, 6, 7].keep(4.rand)).play } });
Tdef(\x).stop;
Tdef(\x).play;
Tdef(\x).clear;


t = TempoClock(12);

t.tempo = 1
(
Tdef(\beat, {
    inf.do {
        |i|
        if (i.mod(4) == 0,
            {(note: 0).play},
            {(note:12, amp:0.05).play});
        1.wait;
    }
}
)
)

g = TdefGui()
g.object = Tdef(\beat)
().play
Tdef(\beat).quant(16)
Tdef(\beat).play(t, quant:4)
Tdef(\beat).stop

Tdef(\beat, { loop { 0.5.wait; (note: 14.rand).play } });

Tdef(\z).stop
Tdef(\z, { loop { 5.wait; (note: 14.rand).play } });
