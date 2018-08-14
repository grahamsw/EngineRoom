(
var durBase = 0.1;
a = [71, 74];
 b = [67, 76];
c = [a,b,a];
d = [b,a,b];
e = [\rest, 74, \rest, 71, 76];
~midi_017_the_gold = c ++ d ++ c ++ d ++ c ++ d ++ c ++ d ++ c ++ e;
~amp_017_the_gold = [1, 0.7, 0.7, 0.8, 0.7, 0.7, 0.8, 0.7, 0.7];

~dur_017_the_gold = (1.dup(27) ++ [ 3,  2, 1, 2, 1]) * durBase ;

)
(
Pdef(\pattern_017_the_gold,
	Pbind(
		\midinote, Pseq(~midi_017_the_gold, inf),
	\amp,Pseq(~amp_017_the_gold, inf),
		\dur, Pseq(~dur_017_the_gold, inf)));
)

Pdef(\pattern_017_the_gold).play

