
(
SynthDef(\sinegrainpulse, { |freq = 1000, pulse = 10, cycle = 500, amp = 0.3, bus = 0|
	var dur = cycle * freq.reciprocal;
	Out.ar(bus,
		GrainSin.ar(1, Impulse.kr(pulse), dur, freq, envbufnum:-1) * amp);
}).add;
)

(
a = Synth(\sinegrainpulse, [\freq, 50, \cycle, 400, \pulse, 24]);

b = Synth(\sinegrainpulse, [\freq, 300, \pulse, 31, \cycle, 300, \amp, 0.2]);

c = Synth(\sinegrainpulse, [\freq, 150, \pulse, 11, \cycle, 300]);
d = Synth(\sinegrainpulse, [\freq, 500, \pulse, 21, \cycle, 300, \amp, 0.1]);
)


b.set(\freq, 50)
b.set(\cycle,400)
b.set(\pulse, 24)
a.set(\freq, 50)
a.set(\pulse, 31)
d.set(\amp, 0.025)
d.set(\freq, 300)
d.set(\cycle, 200)


a.set(\amp, 0.2)