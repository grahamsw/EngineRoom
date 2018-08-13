(
~theRhineMotive_midinotes =
[63, 58, 55, 58, 63, 65] ++
[67, 63, 58, 63, 67, 68] ++
[70, 67, 63, 67, 70, 75] ++
[79, 75, 70, 67, 63, 58];

~theRhineMotive_bass_midnotes =
[[63, 55], [65, 58]] ++
[[67, 63], [68, 65]] ++
[[70, 67], [75, 70]] ++
[[79, 75]];

~triplesAmp = [1, 0.7, 0.7, 0.8, 0.7, 0.7];
~theRhineTimeBasis = 0.15;
~tripleTimes = ~theRhineTimeBasis.dup(6).dup(4).flat;
~tripleBassTimes = ( [5, 1].dup(3).flat ++ 6 ) * ~theRhineTimeBasis;
)

s.prepareForRecord
s.record(path: "~/out.wav".standardizePath);

s.stopRecording


(
var melody = Pbind(\midinote, Pseq(~theRhineMotive_midinotes, inf),
	\dur, 0.15,
\amp, Pseq(~triplesAmp, inf)
);

var bass = Pbind(\midinote, Pseq(~theRhineMotive_bass_midnotes, inf),
	\dur, Pseq(~tripleBassTimes, inf),
	\amp, 0.5);
Ppar([melody, bass]).play
)