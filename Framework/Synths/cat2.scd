(
SynthDef(\cat2,
	{
		|purr_rate=10, pass_freq = 80, rq = 0.5, amp_freq = 0.2, amp_min = 0.1, amp_max = 0.3, mix = 0.33,
		room = 0.5, damp = 0.5,out = 0|
		var sound, pink, lowpass, triangle, amp;
		pink = PinkNoise.ar;
		triangle = LFTri.ar(purr_rate).range(0, 1);
		amp = SinOsc.ar(amp_freq).range(amp_min,amp_max);
		sound = RLPF.ar(pink, freq: pass_freq, rq: rq);
		sound = sound * triangle * amp;
		sound = FreeVerb.ar(sound, mix: mix, room: room, damp: damp);
		Out.ar(out, Pan2.ar(sound));
}).add;

"loaded \\cat2 now".postln;
)



/*
x = Synth(\cat2)

x.set(\room, 0.2)

x.set(\damp, 0.5)

x.set(\mix, 0.5)


x.set(\amp_min, 0.1)

x.set(\amp_max, 0.3)

x.set(\rq, 0.5)

x.set(\purr_rate, 40)

*/