

(
~minor_eleven = [ 0, 3, 7, 10, 14, 17 ];
~major_thirteen = [ 0, 4, 7, 14, 18, 21 ];
~chord_shapes = [ ~minor_eleven, ~major_thirteen ];
~chords = Array.fill (4) {|i| 60 - i + ~chord_shapes[i % 2] };

SynthDef (\simple_sine) {
	var env = EnvGen.kr (Env.perc, doneAction:2);
	var sig = SinOsc.ar (\freq.ir (440)) * env;
	sig = Pan2.ar (sig, \pan.ir (0), \amp.ir (0.2));
	Out.ar (0, sig);
}.add;

~roll_chord = {
	arg chord, roll_amount = 0.1;
	Task {
		chord.do {
			arg note;
			Synth (\simple_sine, [
				\freq, note.midicps,
			]);
			roll_amount.rand.wait;
		};
	}.play;
};
)

~roll_chord.(~chords[0])

Task { 64.do {|i| ~roll_chord.(~chords[i % 4]); 1.wait } }.play


(
Pbind(
	\instrument, \simple_sine,
	\root, Pseq([0, 1, 2, 3], inf),
	\scale, Scale.chromatic,
	\degree, Pxrand([
		Pn(~minor_eleven, 1),
		Pn(~major_thirteen, 1),
	], inf),
	\sustain, 0.1,
	\strum, Pfuncn({0.1.rand}, inf),
	\dur, 1
).play
)

(
~minor_eleven = [ 0, 3, 7, 10, 14, 17 ];
~major_thirteen = [ 0, 4, 7, 14, 18, 21 ];
~chord_shapes = [ ~minor_eleven, ~major_thirteen ];
~chords = Array.fill (4) {|i| 60 - i + ~chord_shapes[i % 2] };

Pdef(\rollChord, {
	|dur=0.1, count=5|

	Pbind(
		\instrument,	\simple_sine,
		\amp,			0.1,
        \midinote, 		Pser([60, 64, 67, 72], count),
		\dur, 			dur,
	)
});
(Pdef(\rollChord)<>(dur: 0.25, count:10)).play

Pdef(\rollBase, Pbind(
	\instrument, 	\rollChord,
	\type, 			\phrase,
	\legato, 		15,
	\count, 		15,
	\dur, 			0.25,
));
Pdef(\rollBase).play

Pdef(\fast, Pbind(
	\rollDelta, 0.02,
	\dur, Pkey(\rollDelta, inf) * Pkey(\count) / 2,
));

Pdef(\slow, Pbind(
	\rollDelta, 0.5,
	\dur, Pkey(\rollDelta, inf) * Pkey(\count) / 2,
));

Pdef(\fastSlow, Pbind(
	\rollDelta, Pn(Penv([0.15, 0.25, 0.15], [30, 30]), inf),
	\dur, Pkey(\rollDelta, inf) * Pkey(\count) / 2,
));

Pdef(\clipped, Pbind(
	\count, Pfunc({ rrand(4, 8) })
));

Pdef(\long, Pbind(
	\dur, 8,
	\count, inf,
));

Pdef(\strum, Pbind(
	\dur, 4,
	\count, 8,
	\release, 10,
	\rollDelta, 0.05
));

Pdef(\chordSequence, Pbind(
	\chordIndex, Pstutter(2, Pseq([
		0, 1, 2, 3, 2, 3, 2, 2, 1
	], inf))
));
//
Pdef(\rollA, Pdef(\slow) <> Pdef(\clipped) <> Pdef(\chordSequence) <> Pdef(\rollBase));
Pdef(\rollB, Pdef(\long) <> Pdef(\fast) <> Pdef(\chordSequence) <> Pdef(\rollBase));
Pdef(\rollC, Pdef(\strum) <> Pdef(\chordSequence) <> Pdef(\rollBase));

Pdef(\roll).source = Pdef(\rollA);
Pdef(\roll).play;
)