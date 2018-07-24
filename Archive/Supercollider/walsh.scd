(
SynthDef(\walsh, {
	|freq = 440, osc1Type = \saw, osc2FreqMult = 16, osc2Type = \saw,
	 lfoRoute = \pitch, lfoFreq = 1, lfoDepth = 0.15, out = 0|
	var sig1, sig2, lfo, fq, sig;
	lfo = SinOsc.ar(lfoFreq);
	fq =  freq * lfo.range(1-lfoDepth, 1);
	sig1 = Saw.ar(fq);
	sig2 = Saw.ar(fq * osc2FreqMult.midiratio);
	sig = (sig1 + sig2) * 0.2;
	sig = LPF.ar(sig, 1800);
	sig = EnvGen.kr(Env.perc, doneAction:2) * sig;
	Out.ar(out, sig);
}).add;
)

Synth



(
Pdef(\w,
Pbind(
	\instrument, \walsh,
	\midinote, Pseq([60, 64, 67], inf),
	\dur, 0.2
)).play;
)


		 