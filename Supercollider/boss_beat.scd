
(
SynthDef(\iter2, {
	| freq = 200, dev = 1.02|
	var temp, sum;
	sum = 0;
	10.do {
		|count|
		temp = SinOsc.ar(freq * (count + 1) * LFNoise1.kr({Rand(0.05, 0.2)}!2).range(dev.reciprocal, dev));
		temp = temp * LFNoise1.kr({Rand(0.5, 8)}!2).exprange(0.01, 1);
		sum = sum + temp;
	};
	sum = sum * 0.1;
	Out.ar(0, sum);
}).add;
)

x = Synth(\iter2)
x.set(\freq, 40)
x.set(\dev, 1.02)
x.free