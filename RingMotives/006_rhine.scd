
(
~theRhineMotive_midinotes = Pbind(\midinote, Pseq(
[63, 58, 55, 58, 63, 65] ++
[67, 63, 58, 63, 67, 68] ++
[70, 67, 63, 67, 70, 75] ++
	[79, 75, 70, 67, 63, 58], inf));

~theRhineMotive_bass_midnotes = Pbind( \midinote,
	Pseq(
[[63, 55], [65, 58]] ++
[[67, 63], [68, 65]] ++
[[70, 67], [75, 70]] ++
		[[79, 75]], inf));

~triplesAmp = Pbind(\amp,Pseq([1, 0.7, 0.7, 0.8, 0.7, 0.7], inf));

~theRhineTimeBasis = 0.15;

~tripleTimes = Pbind(\dur, Pseq(~theRhineTimeBasis.dup(6).dup(4).flat, inf));

~tripleBassTimes = Pbind(\dur, Pseq(( [5, 1].dup(3).flat ++ 6 ) * ~theRhineTimeBasis, inf));
)


(
var melody = Pchain(~theRhineMotive_midinotes,	~triplesAmp, ~tripleTimes);

var bass = Pchain(~theRhineMotive_bass_midnotes, ~tripleBassTimes, Pbind(\amp, 0.5));

Ppar([melody, bass]).play

)