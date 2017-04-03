~nob = 0;
TempoClock.sched(0, {
	~nob = ~nob + 1;
	postln(~nob);
	0.1;
})


Server.local.makeGui

b = Buffer.alloc(s, 2 **16);
b.sine2((1,3..23), 1/(1, 3..23).pow(2));
(
SynthDef(\tri, {
	|buff = 0, freq=440, amp=0.707, dur=1, t_trig=0|
	var env, envgen, output;
	env = Env([0,1,9/10, 1/2, 0] * amp, [1/50, 1/25, 23/25, 1/50] * dur);
	envgen = EnvGen.ar(env, t_trig);
	output = Osc.ar(buff, freq, mul:envgen);
	Out.ar(0, output);
}).add;
)

(
var clock, synth, freq, dur;
clock = [TempoClock, TempoClock(2)];
synth = [Synth(\tri, [\buff, b, \amp, 0.707/2]),
	     Synth(\tri, [\buff, b, \amp, 0.707/2])];
freq = [[60, 64, 67, 72], Array.fill(7,
	{60 + 12.rand})].midicps;
dur = [2!4, 1!6++2];
freq.do{
	|i,j|
	i.size.do{|x|
		clock[j].sched(x, {synth[j].set(\freq, i[x], \dur, dur[j][x], \t_trig, 1)});
	};
	clock[j].sched(dur[j].sum+2, {synth[j].set(\amp, 0); synth[j].free});
};
)
b.free;
