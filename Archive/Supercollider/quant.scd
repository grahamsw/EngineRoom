t = TempoClock.tempo = 80/60;
(
Pdef(\click, Pbind(
    \degree, Pseq([0,1,2,3],inf),
    \dur, 1,
    \legato, 0.125,
    \amp, 1,
)).play(t, quant:#[-1], doReset:true)
)

(
Pdef(\click, Pbind(
	// \latency, 0.05,
	\do, Pfunc { t.beatInBar.postln },
    \degree, Pseq([0,1,2,3],inf),
    \dur, 1,
    \legato, 0.125,
    \amp, 1,
)).play(t, quant: 2, doReset:true);
)
t.beatInBar;
t.bar;
Pdef(\click).stop;


t = TempoClock.tempo = 160/60;
(
Pdef(\click, Pbind(

    \degree, Pseq([0,1,2,3],inf),
    \dur, 1,
    \legato, 0.125,
    \amp, 1,
    \do, Pfunc {
        arg env;
        (
            "___\n"++
            "Bar    : " ++ t.bar
            ++"\n"++
            "Beat   : " ++ t.beatInBar
            ++"\n"++
            "Degree : " ++ env[\degree]
    ).postln },

)).play(t, quant: -1, doReset:true);
)