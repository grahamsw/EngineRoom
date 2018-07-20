// Noise modulated AM

(

{
	var f = MouseX.kr(1,80);

	Mix.arFill(5, { | n |

		SinOsc.ar(200 * (n + 1), mul:0.7/(n + 1)) * LPF.ar( BrownNoise.ar, f)
	})

}.play
)
(

{
	SinOsc.ar(400 * LPF.ar( WhiteNoise.ar, 5), mul:0.8)
}.play

)


