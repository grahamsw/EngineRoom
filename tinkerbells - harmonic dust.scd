(
SynthDef(\harms,
	{
		|freq = 400, amp = 0.2, tf = 0.3, atk = 0.01, decay = 3|
		var sig = Mix.fill(8, {
			|n|
			SinOsc.ar(freq * (1+n)) * Decay2.ar(Dust.ar(Rand(0.1, 1)), atk, decay, 1/(1+n))
		});
		Out.ar(0, sig/20 * amp);
}).add;
)

a = Synth(\harms, [\freq, 100])

a.set(\amp,0.5)
a.set(\decay, 8)
a.set(\freq, 70)
a.set(\atk, 1)
a.set(\tf, 15)
a.stop

Synth(\harms, [\freq, 150, \amp, 0.5])
Synth(\harms, [\freq, 300])

Ndef(\trigs).play
Ndef(\trigs).fadeTime = 2;

Ndef(\trigs, {


Ndef(\hooah).play; // play to hardware output.
Ndef(\hooah).fadeTime = 2; // fadeTime specifies crossfade

Ndef(\hooah, {SinOsc.ar})

Ndef(\hooah, {
		var freq = 75, amp = 0.15, tf = 0.1, atk = 0.01, decay = 7;
		var sig = Splay.arFill(12, {
			|n|
			SinOsc.ar(freq * [(1.05 + n), (1+n)]) * Decay2.ar(Impulse.ar(1/(1+n)), Rand(atk, 10* atk), Rand(decay, 5 * decay), 1/(1+n))
		});
		Splay.ar((FreeVerb.ar(sig * amp, 0.633, 0.5)).flatten);
}
)

Ndef(\hooah).end
// set the source
Ndef(\a, { SinOsc.ar([350, 351.3], 0, 0.2) });

(
Ndef(\a,

	{Blip.ar([350, 351.3],4, [Pulse.kr(0.1), Pulse.kr(0.3)]
	)}
)
)
	Ndef(\a).end

(
Ndef(\a,
	{}
)
)









