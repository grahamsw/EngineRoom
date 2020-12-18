(
SynthDef(\harms,
	{
		|freq = 400, amp = 0.2, tf = 0.3, atk = 0.01, decay = 3|
		var sig = Mix.fill(8, {
			|n|
			SinOsc.ar(freq * (1+n)) * Decay2.ar(Dust.ar(tf), atk, decay, 1/(1+n))
		});
		Out.ar(0, sig/20 * amp);
}).add;
)

a = Synth(\harms, [\freq, 100])

a.set(\amp,0.1)
a.set(\decay, 2)
a.set(\freq, 100)
a.set(\atk, 0.1)
a.set(\tf, 15)
a.stop

Synth(\harms, [\freq, 150, \amp, 0.5])
Synth(\harms, [\freq, 300])



Ndef(\a).play; // play to hardware output.
Ndef(\a).fadeTime = 2; // fadeTime specifies crossfade
// set the source
Ndef(\a, { SinOsc.ar([350, 351.3], 0, 0.2) });

(
Ndef(\a,

	{Blip.ar([350, 351.3],4, [Pulse.kr(0.1), Pulse.kr(0.3)]
	)}
)
)

(
Ndef(\a,
	{}
)
)









