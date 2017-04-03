(
{
	var mod, car;
	mod = SinOsc.ar(200, mul:EnvGen.ar(Env.linen(level:300, curve:\sin)));
	car = SinOsc.ar(500 + mod, mul:0.7);
}.play;
)

(
SynthDef(\fmratio,
	{
		|modFreq=440, cmratio = 1, index =1, dur =1|
	    var env, mod, car;
		env = EnvGen.kr(Env.linen(dur/10, 0, dur*9/10), doneAction:2);
		mod = SinOsc.ar(modFreq, mul:modFreq*index);
		car = SinOsc.ar((modFreq*cmratio)+mod);
		Out.ar(0,car*env);
	}
).add;
)

(
var cmratios;
cmratios = Pseq([1, 2.25, 3.60, 4.91]);

Pbind(
	\instrument, \fmratio,
	\cmratio, cmratios,
	\index, 5,
	\dur, 2,
).play;
)

(
SynthDef(\fmindex,
	{
		|carfreq=500, mcratio=0.4, fmindex=1, dur=1|
		var env, mod, car;
		env = EnvGen.kr(Env.linen(dur/100, dur*98/100, dur/100), doneAction:2);
		mod = SinOsc.ar(carfreq*mcratio, mul:carfreq*mcratio * fmindex);
		car = SinOsc.ar(carfreq+mod);
		Out.ar(0,car*env);
}).add;
)
(0, 0.1..10)
(
var index;
index = Pseq((0, 1..10));
Pbind(
	\instrument, \fmindex,
	\fmindex, index,
	\dur, 1
).play;
)

// vibrato
(
{

	var env, mod, car, modfreq=6, index=4, carfreq=440;
	env = EnvGen.kr(Env.linen(0.2, 0, 1.8), doneAction:2);
	mod = SinOsc.ar(modfreq, mul:modfreq*index);
	car = SinOsc.ar(carfreq + mod, mul:env);
}.play;
)

(
SynthDef(\fmsynth, {
	|carfreq=440, ratio=1, index=1, dur=1|
	var levels, times, env, mod, car;
	levels = \levels.ar([0,0,0,0,0]);
	times = \times.ar([0,0,0,0]);
	env = EnvGen.kr(Env(levels, dur * times), doneAction:2);
	mod = SinOsc.ar(carfreq*ratio, mul:carfreq*ratio*index*env);
	car = SinOsc.ar(carfreq + mod, mul:env);
	Out.ar(0, car*env);
	}
).add;
)

(var
notes = 4,
carfreq = [440, 880, 400, 440],
ratio = [1, 1/3, 7/5, 11/3],
index = [5,2,10, 4],
dur = 4,
levels = [[0, 1, 2/3, 1/2, 0],
	[0, 1, 1, 0],
	[0, 1, 0],
	[0, 1, 0]],
times = [[1/12, 1/4, 1/2, 1/6],
	[1/5, 3/5, 1/5],
	[1/600, 599/600],
	[599/600, 1/600]];

Routine{
	notes.do{|i|
		Synth(\fmsynth, [
			\carfreq, carfreq[i],
			\ratio, ratio[i],
			\index, index[i],
			\dur, dur,
			\levels, levels[i],
			\times, times[i],
		]);
		dur.wait;
	}
}.play;
)

(
Synth(\fmsynth, [
			\carfreq, 440,
			\ratio, 0.5,
			\index, 5,
			\dur, 4,
			\levels, [0, 1, 1, 0],
			\times, [1/5, 1/5, 3/5],
		]);
)

().play