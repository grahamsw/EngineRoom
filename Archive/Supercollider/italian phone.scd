(
{
var freq = 422;
var dur = 0.2;

LFPulse.kr(1/(dur * 2)) * SinOsc.ar(freq);

}.play;
)

(
{
var freq = 422, cycleDur = 2;
var env = Env([0,1, 1, 0, 0, 1, 1, 0, 0], [0, 1, 0, 1, 0, 2.5, 0, 1.5]);
EnvGen.kr(env, gate: Impulse.kr(1/cycleDur), timeScale:1/5, doneAction: 0)
*
SinOsc.ar(freq);
}.play;
)

(

{
	var amp = 0.125;
	var firstBit = Array.fill(32, {[0,1].choose});
	var secondBit = Array.fill(16, {[0,1].choose});
	var freq;

	firstBit.do ({|i|
		freq = [2000,2500][i];
		{SinOsc.ar(freq, mul:amp) * Line.kr(1,1,0.3, doneAction:2)}.play;
		0.03.wait;
	});
	0.04.wait;

	secondBit.do ({|i|
		freq = [2000,2500][i];
		{SinOsc.ar(freq, mul:amp) * Line.kr(1,1,0.3, doneAction:2)}.play;
		0.03.wait;
	});
	0.52.wait;
	{SinOsc.ar(1000, mul:amp) * LFPulse.ar(1, width:0.1) * Line.kr(1, 1, 5, doneAction:2)}.play;
	6.wait;
	{SinOsc.ar(1000, mul:amp) * LFPulse.ar(1, width:0.1) * Line.kr(1, 1, 0.1, doneAction:2)}.play;

}.fork;
)


	