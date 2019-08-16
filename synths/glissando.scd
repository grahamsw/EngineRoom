
SynthDef (\glissando, {
	| from = 200, to = 2000, len = 10, amp = 0.6, out = 0|
	var pitchenv = Env([from, to], [len], 'exp');
	var ramp = 0.01;
	var sound = SinOsc.ar(EnvGen.kr(pitchenv));
	var ampenv = Env.linen(ramp, len-(2 * ramp), ramp, amp);
	sound = EnvGen.kr(ampenv, doneAction: 2) * sound;
	Out.ar([0,1], sound);
}).add;
