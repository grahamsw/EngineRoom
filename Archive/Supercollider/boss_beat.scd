(


SynthDef(\iter2, {
	| freq = 200, dev = 1.02, amp = 0.1, out = 0|
	var temp, sum;
	sum = 0;
	10.do {
		|count|
		temp = SinOsc.ar(freq * (count + 1) * LFNoise1.kr({Rand(0.05, 0.2)}!2).range(dev.reciprocal, dev));
		temp = temp * LFNoise1.kr({Rand(0.5, 8)}!2).exprange(0.01, 1);
		sum = sum + temp;
	};
	sum = sum * amp;
	Out.ar(out, sum);
}).add;

)

x = Synth(\iter2, [\freq, 40, \dev, 1.02]);
b = Bus.control(s);
{Out.kr(b, MouseX.kr(0, 2))}.play;
c = Bus.control;
{Out.kr(c, MouseY.kr(100, 1000, 1))}.play(s);
x.map(\freq, c);
x.map(\dev, b);


x.free

{SinOsc.ar(300 * LFNoise1.kr(rrand(0.05, 0.2)}!2).range(dev.reciprocal, dev), mul:0.5)}.play


p = Pbind(
    \instrument, \iter2,
    \dur, Pwhite(0.5, 5, inf),
	\freq, Pexprand(50, 800, inf).round(50).trace,
    \atk, Pwhite(2.0, 3.0, inf),
    \rel, Pwhite(5.0, 10.0, inf),
    \amp, Pexprand(0.01, 0.2, inf),
 //   \pan, Pwhite(-0.8, 0.8, inf),
    ).play;

//p.stop

//{SinOsc.ar(3000 *LFNoise1.ar(0.1).exprange(0.01, 1), mul:0.3) * LFNoise1.kr(3).exprange(0.01,1)}.scope
}

)