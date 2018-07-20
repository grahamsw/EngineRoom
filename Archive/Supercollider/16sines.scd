(
SynthDef(\sum, {|out = 2|
	Out.ar(out, Array.fill(16, {
		SinOsc.ar(freq: Rand(48, 84).midicps,
			mul: LFNoise1.kr(Rand(2, 0.1))
		)
}))}).add;
)

(
SynthDef(\mix, {|in|
	Out.ar(0, Mix.ar(In.ar(in, 16)/10))}).add;
)



b = Bus.audio(s, 16);
b.scope;

x = Synth(\sum, [\out, b]);

Synth.after(x, \mix, [\in, b]);
