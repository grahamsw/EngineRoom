(
~the_gold_017 = {
	var a = [71, 74];
	var b = [67, 76];
	var c = [a,b,a];
	var d = [b,a,b];
	var e = [\rest, 74, \rest, 71, 76];

	var midi = c ++ d ++ c ++ d ++ c ++ d ++ c ++ d ++ c ++ e;
    var dur = (1.dup(27) ++ [ 3,  2, 1, 2, 1]) ;
	Pbind(
		\midinote, Pseq(midi, inf),
		\dur, Pseq(dur, inf));
}.();
)

~the_gold_017.play






