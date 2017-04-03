s.quit
s.makeGui

{SinOsc.ar}.play
{|chaos = 1.5| Crackle.ar(chaos)}.play(args:[\chaos, 1.99])

s.freeAll
(
f = {
	|freq1 = 440, freq2 = 440, amp1 = 0.5, amp2 = 0.5|
	var sine1, sine2, output;
	sine1 = SinOsc.ar(freq1, mul:amp1);
	sine2 = SinOsc.ar(freq2, mul:amp2);
	output = sine1 + sine2;
}
)

f.play

f.play(args:[\freq1, 40, \freq2, 40, \amp1, 0.25, \amp2, 0.125])
f.play(args:[\freq1, 440, \freq2, 660, \amp1, 0.125, \amp2, 0.06])

{RHPF.ar(WhiteNoise.ar)}.play
{SinOsc.ar(MouseX.kr(10, 200), mul:MouseY.kr(0, 1))}.play
(
SynthDef(\FPlay,
	{
		var sin, sin2;
		sin = SinOsc.ar(MouseX.kr(10, 200), mul:0.12);
		sin2 = SinOsc.ar(MouseX.kr(12, 202) , mul:MouseY.kr(0, 0.12));
		Out.ar(0, sin + sin2);
}).add;
)

f = Synth.newPaused(\FPlay)
f.run
f.free

s.prepareForRecord;
s.record;
s.stopRecording;

"cunt"!100

(0, 5 .. 100)

-3.dbamp
[-7, -6].dbamp.sum
(-3.dbamp)*(-3.dbamp)

Env.perc.test.plot
Env.triangle.test.plot
Env.linen.test.plot
Env.sine.test.plot
Env.asr.test.plot,
Env.adsr.test.plot

e = Env.adsr.test
e.plot

e = Env(levels:[0.001, 1, 0.01, 2, 1, 3], times:[2,1, 4, 2, 1], curve: \exp).plot
e.plot


(
var envtri, dur = 2;
envtri = Env([0.01, 0.707, 0.01], [dur/2, dur/2], \exp);
envtri.test.plot;

)

(
var envadsr, dur =2;
envadsr = Env([0.001, 0.707, 0.65, 0.4, 0.001], [1/64, 3/32, 14/16, 1/64] * dur, -4);
{EnvGen.ar(envadsr, gate:1, levelScale:1, levelBias:2, timeScale:2, doneAction:0)}.plot(2);
)