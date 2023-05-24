(
SynthDef(\sin,
	{
		|gate=1, out = 0, freq = 400, amp = 0.4, pan = 0, ar = 1, dr = 1|
		var audio;
		audio = SinOsc.ar(freq, 0, amp);
		audio = audio * Linen.kr(gate, ar, 1, dr, 2);
		audio = Pan2.ar(audio, pan);
		OffsetOut.ar(out, audio);
}).add;
)

Synth(\sin)
().play