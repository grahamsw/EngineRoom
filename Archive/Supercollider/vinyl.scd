(
SynthDef(\schedEnv, {
	Out.ar(0,
		Pan2.ar(
			InRange.ar(LFNoise2.ar(10), 0.35, 1).sign
			*
			Formant.ar(LFNoise0.kr(1, mul:60, add:30).midicps, mul:0.15),
			LFNoise1.kr(3, mul:1))
	)
}).add;
)


(
10.do
{
	Synth.new(\schedEnv);
}
)

(
SynthDef(\select, {
	var array;
	array = Array.fill(64, {
		|i|
		(i%4) + (i%7) + (i%11) + 60});
	array = array.add(90).postln.midicps;
	Out.ar(0,
		Saw.ar(
			Select.kr(LFSaw.kr(1/6).linlin(-1.0, 1.0, 0, array.size),
				array),
			0.2))
}).add;
)

Synth(\select)



(
{
	var a, freq, trig;
	a = Drand([1,3,2,7,8]+60, inf);
	trig = Impulse.kr(4);
	freq = Demand.kr(trig, 0, a.
		midicps);
	Mix.fill(10, {Pulse.ar(freq + 5.rand)}) * 0.1;
}.play
)