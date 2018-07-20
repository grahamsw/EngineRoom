"definining \sprite".postln;

SynthDef(\sprite, {
	|freq = 440, amp = 0.2, rate = 4, attack = 0.01, pos = 0, out = 0|

	var env, trig, signal;
	trig = LFPulse.kr(rate);
	signal = Mix.fill(4, { Saw.ar(freq * (1 + 0.01.rand))}) * amp / 4;
	env = EnvGen.kr(Env.perc(attack), trig);
	signal = env * signal;
	signal = Pan2.ar(signal, pos);
	Out.ar(out, signal);
}).add;
