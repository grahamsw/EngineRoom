(

SynthDef(\sum, {
|out = 2|
	Out.ar(out, Array.fill(16, {
		SinOsc.ar(freq:Rand(48, 84).midicps,
			mul: LFNoise1.kr(Rand(2, 0.1))
		)
	}))
}).add;



SynthDef(\mix, {|in|
	Out.ar(0, Mix(In.ar(in, 16)/16));
}).add;
)

b = Bus.audio(s, 16).scope;
x = Synth(\sum, [\out, b])

Synth.after(x, \mix, [\in, b])

