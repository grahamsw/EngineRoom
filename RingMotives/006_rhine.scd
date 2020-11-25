// 16: The Rhine
(
~the_rhine_016 = {
	| timeBasis = 0.15, ampBasis = 0.1, transpose = 0, instrument=\default|


	var inst = Pbind(\instrument, instrument);
	var theRhineMotive_midinotes = Pbind(\midinote, Pseq(
		[63, 58, 55, 58, 63, 65] ++
		[67, 63, 58, 63, 67, 68] ++
		[70, 67, 63, 67, 70, 75] ++
		[79, 75, 70, 67, 63, 58], inf));

	var theRhineMotive_bass_midnotes = Pbind( \midinote,
		Pseq(
			[[63, 55], [65, 58]] ++
			[[67, 63], [68, 65]] ++
			[[70, 67], [75, 70]] ++
			[[79, 75]], inf));
	var trans = Pbind(\ctranspose, transpose);

	var triplesAmp = Pbind(\amp,Pseq([1, 0.7, 0.7, 0.8, 0.7, 0.7] * ampBasis, inf));
	var tripleTimes = Pbind(\dur, Pseq(timeBasis.dup(6).dup(4).flat, inf));
	var tripleBassTimes = Pbind(\dur, Pseq(( [5, 1].dup(3).flat ++ 6 ) * timeBasis, inf));
	var melody = Pchain(trans, inst, theRhineMotive_midinotes,	triplesAmp, tripleTimes);
	var bass = Pchain(trans, inst, theRhineMotive_bass_midnotes, tripleBassTimes);
	Ppar([melody, bass]);
}
)

~the_rhine_016.(transpose:5, timeBasis:0.1).play;

t = Bus.control(s)
t.set(5)

(
~melody_notes = Pseq(
		[63, 58, 55, 58, 63, 65] ++
		[67, 63, 58, 63, 67, 68] ++
		[70, 67, 63, 67, 70, 75] ++
		[79, 75, 70, 67, 63, 58], inf);
~melody_amps = Pseq([1, 0.7, 0.7, 0.8, 0.7, 0.7], inf);
~melody_durs =  Pseq(1.dup(6).dup(4).flat, inf);
~bass_notes = Pseq(
			[[63, 55], [65, 58]] ++
			[[67, 63], [68, 65]] ++
			[[70, 67], [75, 70]] ++
			[[79, 75]], inf);
~bass_durs = Pseq([5,1].dup(3).flat ++ 6, inf);


~bass = Pbind(\dur, ~bass_durs,
	\midinote, ~bass_notes,
	\stretch, 0.1
);

~bass.play

~melody = Pbind(\dur, ~melody_durs,
	\midinote, ~melody_notes,
	\amp, ~melody_amps,
	\stretch, 0.2
);

~dumpN = {|pat, n=10|
	pat.asStream.nextN(n).postln;
}


{SinOsc.ar}.play

~dumpN.(~melody_durs)

~melody.play