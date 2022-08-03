~events
~clock2 = TempoClock.new(2)
(
~events[\set_clock].(40,\default);
~events[\start].(\first, "<c4_4@vol[0.2] e- g> <c4_4@vol[0.1] e- g> <c4_4@vol[0.1] e- g> <c4_4@vol[0.1] e- g> ", instrument:\default);
~events[\start].(\second, " c4_2. g3_4", instrument:\default);
)
~events[\set_clock].(10,\default);
a = ["c4 e g b","a3 d4 f a",];
a.add("c4 g")
a.add("g5 d6")
().play

~events[\set_clock].(20);
~events[\start].(\first, "c4 g");
~events[\change].(\first, "g4 d5");
~events[\change].(\first, "d5 a")
~events[\change].(\first, "d4 a");
~events[\change].(\first, "a4 e5");
~events[\change].(\first, "a3 e4");
~events[\change].(\first, "e4 b");
~events[\change].(\first, "b4 f#5");
~events[\change].(\first, "b3 f#4");
~events[\change].(\first, "f#4 c#5");


~events[\start].(\first, "c3 g g d4 d3 a a e4 e3 b b f#4 f#3 c#4 c#  g# g#3 d#4 d# a# a#3 e#4 e# c5", instrument:\default);


~events[\start].(\first, "c4 a3 a f# f# d# d#4 c", instrument:\default);

~events[\change].(\first, "c4 a3 a f# f# d# d#4 c")

);

(
a.add("d4 a");
a

~events[\change].(\first, a.last(), instrument:\default);
)
~events[\stop].(\first)

(
~events[\change].(\first, "<b3_4@vol[0.2] f4 g> <b3_4@vol[0.1] f4 g> <b3_4@vol[0.1] f4 g> <f3_4@vol[0.1] f4 g> ");
~events[\change].(\second, "e-3_2 g b_1 ", repeats:inf);
)

(
~events[\change].(\first, "<c4_4@vol[0.2] e- g> <c4_4@vol[0.1] e- g> <c4_4@vol[0.1] e- g> <c4_4@vol[0.1] e- g>");
~events[\change].(\second, " c4_2. g3_4", repeats:inf)
)

~events[\start].(\second, "e-4_4[0.2] e-[0.1] e- f e- d c3 b c3_1[0.2] c_1", repeats:inf)
(
~events[\stop].(\first);
~events[\stop].(\second);
)
(
x = 120;
{
    ({x >= 20}).while ({
    x = x * 0.95;
    x.postln;
    ~events[\set_clock].(x,\default);
    0.5.wait;
});
}.fork;
)
