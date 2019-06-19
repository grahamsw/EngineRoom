//Chaos engine hum
(
{
	SinOsc.ar(10 + (50 * SinOsc.kr([50, 51], 0, SinOsc.kr(101, Saw.kr(0.12345, 678, 9), 0.2, 0.8), Pulse.kr([25, 25.5], 0.25, 0.125, -0.25))), 0, 0.5, 0);
}.play();

)