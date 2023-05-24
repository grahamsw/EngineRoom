(

SynthDef(\randMelody,
	{
		|base = 40, trigFreq = 10|
		var freq, trig, reset, seq;
		var structure = base + [0,2,3,5,6,8];
		trig = Impulse.kr(trigFreq);
		seq = Dseq(
			structure.add(Dxrand(structure + 12, LFNoise0.kr(6).unipolar * 6)), inf).midicps;
		freq = Demand.kr(trig, 0, seq);
		Out.ar(0,
			Mix.fill(5, {Saw.ar(freq + 0.1.rand + [0, 0.7])*0.1}));
}).add;
)

x = Synth(\randMelody)

(15.do({|i|
	Synth(\randMelody,
		[\base, 20 + (i*[3,5,7].choose), \trigFreq, 7 + (i/10)])
})
)