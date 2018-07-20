(
var pitches, ringspersec, durs, detune;
ringspersec = 1;
detune = 1.03;
pitches = [620, 1030, 1600, 620 * detune, 1030 * detune, 1600 * detune]!(1 * ringspersec) ;

durs = (1/ringspersec)!(1 * ringspersec) ;

p = Pbind(
	\instrument, \bellPartial,
	\freq, Pseq(pitches, inf),
	\dur, Pseq(durs, inf),
	\mul, 0.1
);
q = 5.collect({|i| [i/20, p]}).flat;
r = 5.collect({|i| [i/20 + (7/20), p]}).flat;

Ptpar(q ++ r).play;
)

4.collect{|i| i} ++ 4.collect{|i| i + 6}

