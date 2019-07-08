SynthDef(\sonifier, {
		|freq, amp, rate|
		var sound, env;
		sound = SinOsc.ar(freq, mul:amp);
		env = Pulse.ar(freq: rate, width: 0.5);

		Out.ar(0, env * sound);
}).add;

SynthDef(\sonifier2, {
		|freq=500, amp=0.4, bwr=0.5, tremoloFreq=0.1, tremoloDepth=0.95|
		var sound, res, env;
		sound = WhiteNoise.ar();
		res = Resonz.ar(sound, freq, bwr);
		env = SinOsc.kr(freq: tremoloFreq).range(1-tremoloDepth, 1);

		Out.ar(0, env * res * amp);
}).add;