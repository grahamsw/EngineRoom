(
SynthDef(\cat2,
	{
		|purr_rate=10, pass_freq = 80, rq = 0.5, amp_freq = 0.2, amp_min = 0.8, amp_max = 1, out = 0|
		var sound, pink, lowpass, triangle, amp;
		pink = PinkNoise.ar;
		triangle = LFTri.ar(purr_rate).range(0, 1);
		amp = SinOsc.ar(amp_freq).range(amp_min,amp_max);
		sound = RLPF.ar(pink, freq: pass_freq, rq: rq);
		sound = sound * triangle * amp;
		Out.ar(out, sound);
}).add;

"loaded \\cat2 now".postln;


)

