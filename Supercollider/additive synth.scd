(
{
	[Mix.fill(20, {|i|
		SinOsc.ar(200*(i+1), mul:1/40);
	}),
	Mix.fill(20, {|i|
		SinOsc.ar(200*(i+1), phase:2pi.rand, mul:1/40);
	})];
}.play;
)

(
{
	Mix.fill(40, {|i|
		var right = LFNoise1.kr(1, 1/20);
		var left = SinOsc.kr(rrand(0.3, 0.5), 2pi.rand, mul:0.5, add:0.5);
		SinOsc.ar(50 *(i + 1), [2pi.rand, 2pi.rand], mul:[left/20, right])
	});
}.play;

)


(
{
var arr = Array.series(20, 1).postln.reverse.normalizeSum.postln;
Mix.fill(20, {|i|
		SinOsc.ar(60.midicps* (i + 1), 2pi.rand, mul:arr[i])});
}.play;
)



// Promising
(
{
Mix.fill(50,
	{
		|k|
		var incr = 1;
		var env;
		i = k + 1;
		env = LFNoise1.ar(LFNoise0.ar(10, add:1.75, mul:0.75), add:0.5, mul:0.5);
		SinOsc.ar(50 * i + (i * incr).rand,
			mul: 0.05/i.asFloat.rand)*env});
}.play
)

(
var num = 80;
{Mix.fill(num, {SinOsc.ar(20 + 10000.0.rand, 2pi.rand, 1/num)})}.play;
)

// excellent
(
{
	Mix.fill(20,
		{
			SinOsc.ar(500 +
				LFNoise1.ar(LFNoise1.ar(1, add:1.5, mul:1.5),
					add:500, mul:500.0.rand), 0, 0.05)})
}.play
)
// a melody, of sorts
(
{
	var arr = Array.fill(4, {LFNoise1.ar(1, add: 0.15, mul:0.15)});
	f = LFNoise0.ar(LFNoise0.ar(
		SinOsc.kr(0.25, 0, 0.75, 1).unipolar.round(0.0625),
		add:0.95, mul:0.95),
	add:48, mul:12).round.midicps;
	Pan2.ar(Mix.new([
		SinOsc.ar(f, mul:arr[0]),
		Blip.ar(f, mul:arr[1]),
		RLPF.ar(Dust.ar(f * 0.2), f, mul:arr[2]),
		Formant.ar(f, mul:arr[3])
	]), LFNoise1.ar(0.2, mul:1)
	)
}.play
)


(

	SynthDef(\multi, { |base = 30|
	var comp = 100;
	var res = 0.1;
	var music = Mix.fill(comp, {|i|
		SinOsc.ar(freq:(base + (i * res)).midicps,
			phase: 2pi.rand, mul: 4.0/comp)});
	Out.ar(0, music);
}).add;
)