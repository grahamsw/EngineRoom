
s.makeGui
s.plotTree

(
SynthDef(\multi, {
	var sig, amp, env;
	env= EnvGen.kr(Env([0,1,0], [10, 10], [1, -1]), doneAction: 2);
	amp = SinOsc.kr({ExpRand(0.2, 12)}!8).range(0,1);
	sig = SinOsc.ar({ExpRand(50,1200)}!8);
	sig = sig * amp * env;
	Out.ar(0, Splay.ar(sig) * 0.5);

}).add;
)

Synth(\multi);

