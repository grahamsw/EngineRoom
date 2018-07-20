z = s.scope;
(
SynthDef(\UGen_ex2, {arg freq = 440;
	var src, compressor, limiter, out;
	src = SinOsc.ar(
		Array.series(10, freq, freq),
		0,
		Array.fill(10, {Decay2.ar(
			Dust.ar(0.1, 5), 0.01, 5)});).sum;
	compressor  = Compander.ar(src, src, 0.5, 1, 0.1);
	limiter = Limiter.ar(compressor, 0.5);
	out = [DelayN.ar(compressor, 0.02, 0.02), limiter];
	Peak.ar(out ++ src, Impulse.kr(1)).poll(1, ["compressed", "limited", "src"]);
Out.ar(0, out);
}).add;
)

a = Synth(\UGen_ex2, [\freq, 440]);
a.free;

z.window.close;

(
[1,2,3].reciprocal;
)

(
SynthDef(\UGen_ex3,
	{
		arg gate = 1, amp = 1, rate = 10;
		var trigger, dur, carfreq, modfreq, index, pan, env;
		trigger = Impulse.ar(rate);
		dur = rate.reciprocal;
		carfreq = LFNoise2.kr.range(100,110);
		modfreq = LFTri.kr(0.1).exprange(200, 340);
		index = LFCub.kr(0.2).range(4, 10);
		pan = WhiteNoise.ar.range(-0.1, 0.1);
		env = EnvGen.kr(
			Env([0,1,0],[1,1], \sin, 1),
			gate,
			levelScale: amp,
			doneAction: 2);
		Out.ar(0,
			GrainFM.ar(2, trigger, dur, carfreq, modfreq, index, pan, -1) * env);
}).add;
)
(
a = Synth(\UGen_ex3, [\rate, 80, \amp, 0.2]);
b = Synth(\UGen_ex3, [\rate, 42, \amp, 0.2]);
c = Synth(\UGen_ex3, [\rate, 121, \amp, 0.2]);

[a, b, c].do({arg thisSynth;
	thisSynth.set(\gate, 0.50)});
)