(
g = {|root, harms|
	harms.collect{|h| root * h};
};
f = {|root, harms, amps|
	var hs,
	phs;
	hs = {g.(root, harms)};
	phs = harms.size.collect { 2pi.rand};
	Ref([hs, amps, phs]).postln
}
)

f.(100, [3, 4, 5], [2, 1, 1].normalizeSum)


~p = Ndef(\x, {

	DynKlang.ar(f.(90, [2, 3.2, 4.9, 7.1,6,8,10.3, 20, 21], 7.collect{LFNoise1.kr({60.0.rand}.()).range(0, 0.1)} ++ 0.01 ++ 0.01) )}).play;



~p.fadeTime_(2)
(
SynthDef(\klng, {
	|freq = 90, amp = 1, gate = 1, out = 0|
	var harms = [2, 3.2, 4.9, 7.1,6,8,10.3, 20, 21];
	var freqs = harms * freq;
	var phs = harms.size.collect{2pi.rand};
	var amps = (harms.size - 2).collect{LFNoise1.kr({60.0.rand}.()).range(0, 0.1)} ++ 0.01 ++ 0.01;
	var rs = Ref([freqs, amps * amp, phs]);

	var sound = DynKlang.ar(rs);

	Out.ar(out, sound * EnvGen.kr(Env.adsr(releaseTime:0.3), gate: gate, doneAction:2));
}).add;
)

a = Synth(\klng, [\freq, 200])
a.set(\gate, 0)

