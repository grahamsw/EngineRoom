s.plotTree
(
SynthDef(\blip,
	{
		| out= 0 |
		var freq, trig, sig;
		freq = LFNoise0.kr(3). exprange(300, 1200).round(300);
		sig = SinOsc.ar(freq) * 0.25;
		trig = Dust.kr(2);
		sig = sig * EnvGen.kr(Env.perc(0.01,0.2), trig);
		sig = Pan2.ar(sig, LFNoise0.kr(10));
		Out.ar(out, sig);
}).add;


SynthDef(\reverb,
	{
		| in, out = 0 |
		var sig;
		sig = In.ar(in, 2);
		sig = FreeVerb.ar(sig, 0.5, 0.8, 0.2);
		Out.ar(out, sig);
}).add;
)


y = Synth(\reverb, [\in, 6])
x =	Synth(\blip, [\out, 6])

x.set(\out, 25)
y.set(\in, 25)


{LFNoise2.ar(10)}.plot(1)