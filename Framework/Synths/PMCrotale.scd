(
SynthDef("PMCrotale", {
	arg midi = 60, tone = 3, art = 1, amp = 0.8, pan = 0;
	var env, out, mod, freq;

	[midi.value, tone, art, amp, pan].postln;
	freq = midi.midicps;
	env = Env.perc(0, art);
	mod = 5 + (1/IRand(2, 6));

	out = PMOsc.ar(freq, mod * freq,
		pmindex: EnvGen.kr(env, timeScale: art, levelScale: tone),
		mul: EnvGen.kr(env, timeScale:art, levelScale: 0.3));
	out = Pan2.ar(out, pan);
	out = out * EnvGen.kr(env, timeScale: 1.3 * art,
		levelScale: Rand(0.1, 0.5), doneAction:2);
	Out.ar(0, out);
}).add;
)
/*
Synth("PMCrotale", ["midi", rrand(48, 72).round(1), "tone", rrand(1,6), \art, rrand(1,10), \pan, rrand(0.0, 10.0)/10.0])


[1,2,3].postln

*/