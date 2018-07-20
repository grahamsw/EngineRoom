{LFNoise1.ar(5000)}.plot;
{max(0, LFNoise1.ar(5000))}.plot;
({
	var ampCont;
	ampCont = max(0, LFNoise1.kr(12));
	SinOsc.ar(440, mul: ampCont)}.scope
)

(
{
var fund = 220;
Mix.ar(
		Array.fill(12,
			{arg count;
				var harm = count + 1 * fund;
				SinOsc.ar(harm,
					mul:max([0,0], SinOsc.kr(count+1/4))) / (count + 1)
		})
	) * 0.7
}.scope;
)
Array.fill(3, {Array.fill(2, {rand(10)})})

