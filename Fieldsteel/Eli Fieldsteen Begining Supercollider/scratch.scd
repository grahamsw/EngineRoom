t = TempoClock(60/120).permanent_(true);
(
d = [ \midinote,  70, \dur, 0.25];



p = Pbindef(\test, *d);
//p = Pbindef(\test, \midinote,  70, \dur, 0.25);


Pbindef(\test).play(t, quant:4);

)

Pbindef(\test, \midinote, 80).quant_(4)

Pbind(\midinote, Pseq([64, 59, 67, 66, 67, 64],inf)).play

Pbind(
    \instrument, \basic,
	#[\midinote, \dur], Pseq([[64, 1], [59, 1], [67, 2], [66, 1], [67, 1], [64, 2]], inf)
).play(t, quant:4)

65
62
59

2012-1968

71,71, 71
72, 71, 69,67,69

Pbind(
	#[\midinote, \dur], Pseq([[69, 1/4], [69, 1/4], [69, 1/4],[71, 1/4],
		[69, 1/4], [67, 1/4], [66, 1/4], [64, 1/4]], inf)
).play(quant:4)


(
var notes =	[\midinote,		Pseq([
			[41, 50], [45, 52], [41, 50], [45, 52],
			[41, 50], [45, 52], [41, 50], [45, 52],
			[50, 53], [46, 55], [50, 53], [46, 55],
			[50, 53], [46, 55], [50, 53], [46, 55],
			[53, 57], [50, 58], [53, 57], [50, 58],
			[53, 57], [50, 58], [53, 57], [57, 60],
			[62, 65], [58, 67], [62, 65], [58, 67],
			[62, 65], [58, 67], [62, 65], [57, 64],
			[53, 62], \rest, \rest, \rest,
			\rest, \rest, \rest, \rest
],inf)];

var durs = [\dur, 0.125];



n = notes;
d = durs
)

(

Pbindef(\forest_murmers, *(n++d))

Pbindef(\forest_murmer).play(quant:4)


n[1]

(

Pbind(
	\midinote, 60,
	\dur, Pseq([1], 4),
	\nob, {"poop".postln},
	\callback, {|evt| evt[\amp].postln}

).play

)