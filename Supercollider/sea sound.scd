(
{
	Resonz.ar(PinkNoise.ar,
		SinOsc.kr(0.3).exprange(100,150),
		SinOsc.kr(0.2).exprange(0.3, 0.7)
	)
}.play;

)

(
SynthDef(\ocean, {
	| freqFrom = 100, freqTo = 150, freqFreq = 0.3,
	  bwrFrom = 0.3, bwrTo = 0.7, bwrFreq = 0.2, outBus = 0 |
	var out = Resonz.ar(PinkNoise.ar,
		SinOsc.kr(freqFreq).exprange(freqFrom, freqTo),
		SinOsc.kr(bwrFreq).exprange(bwrFrom, bwrTo)
	);
	Out.ar(outBus, out);
	}
).add;
)

(
a = Synth(\ocean, [\freqFrom, 200, \freqTo, 250, \freqFreq, 0.1]);
b = Synth(\ocean, [\freqFrom, 100, \freqTo, 200, \freqFreq, 0.3]);
c = Synth(\ocean, [\bwrFrom, 0.1, \bwrTo, 0.90, \bwrFreq, 0.3]);
)

c.set(\freqTo, 2000, \freqFrom, 2000, \freqFreq, 0.01, \bwrFreq, 0.5, \bwrFrom, 0.1, \bwrTo, 1)
a.free
b.free

