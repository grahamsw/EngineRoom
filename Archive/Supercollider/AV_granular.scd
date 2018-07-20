(

{
var baseFreq = MouseX.kr(50, 120, 1).midicps;

var disp = MouseY.kr;
var strata = 30;
var minDur = 0.05, maxDur = 1;

Mix.fill(strata,
	{
		SinOsc.ar(
			freq: baseFreq *
			LFNoise0.kr(20).linlin(-1.0, 1.0, baseFreq * disp * 1.neg, baseFreq * disp), mul: 1/strata)*
		LFPulse.kr(
			freq: LFNoise0.kr(20).linlin(-1.0, 1.0,minDur.reciprocal, maxDur.reciprocal))
	})

}.freqscope;
)


(

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

SynthDef(\grainBuf,
	{
		|sndBuf|
		Out.ar(0,
			GrainBuf.ar(2,
				trigger: Impulse.kr(MouseX.kr(10, 20)),
				dur: MouseY.kr(0.01, 0.1),
				sndbuf: sndBuf,
				rate: LFNoise0.kr.range(0.5, 2),
				pos:LFNoise2.kr(0.1).range(0.0, 1.0),
				interp:1,
				pan:LFNoise1.kr(3)
))
}).add;
)

x = Synth(\grainBuf, [\sndbuf, b])

