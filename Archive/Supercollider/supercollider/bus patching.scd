
// whole thing
{SinOsc.ar(LFNoise0.kr([10, 15]) * 400 + 800, 0, 0.3)}.scope



// control

{Out.kr(9, LFNoise0.kr([1, 0.5], 1, 0))}.scope(16, zoom: 10)

//patching control to sound

{SinOsc.ar(In.kr(9) * 400 + 800, 0, 0.3)}.scope

(
SynthDef(\switchable,
	{
		|busNum = 9|
		Out.ar(0, SinOsc.ar(In.kr(busNum) * 400 + 800, 0, 0.3))
	}).add;

{Out.kr(9, LFNoise0.kr([1, 0.5], 1, 0))}.scope(16, zoom: 10)
{Out.kr(11, MouseX.kr(1,2))}.scope(16, zoom: 10)

a = Synth(\switchable)
a.set(\busNum,9)