// 16: The Rhine
(
~the_rhine_016 = {

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


var tripleTimes = Pbind(\dur, Pseq(1.dup(6).dup(4).flat, inf));

var tripleBassTimes = Pbind(\dur, Pseq(( [5, 1].dup(3).flat ++ 6 ), inf));

var melody = Pchain(theRhineMotive_midinotes, tripleTimes);
//var bass = Pchain(theRhineMotive_bass_midnotes, tripleBassTimes);
	melody;

Ppar([melody, bass]);
}.();
)

