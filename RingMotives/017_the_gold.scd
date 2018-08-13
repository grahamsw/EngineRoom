(
a = [71, 74];
 b = [67, 76];
c = [a,b,a];
d = [b,a,b];
~midi_017_the_gold_theme = c ++ d ++ c ++ d ++ c ++ d ;
~amp_017_the_gold_theme = [1, 0.7, 0.7, 0.8, 0.7, 0.7, 0.8, 0.7, 0.7] * 0.3;
)
(
Pdef(\pattern_017_the_gold,
	Pbind(
		\midinote, Pseq(~midi_017_the_gold_theme, inf),
	\amp,Pseq(~amp_017_the_gold_theme, inf),
		\dur, 0.1));
)

Pdef(\pattern_017_the_gold).play

