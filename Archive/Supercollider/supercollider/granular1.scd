Pbindef(\grain,
	\instrument, \gabor1, \freq, 1000, \dur, 1,
	\sustain, Pseq([0.001, 0.1], inf),
	\amp, Pseq([0.1, 0.1], inf)
).play;

Pbindef(\grain, \sustain, Pseq([0.01, 0.1], inf), \amp, Pseq([0.2, 0.1],inf)).play;


(

{
SynthDef(\grain, {
         |bufNum = 0, pos, dur, env = 0.05, pitch = 1, pan = 0, amp =
0.5, size=1|
         var envl, sig;
         envl = EnvGen.kr(Env.linen(env, dur, env, amp, -3), doneAction: 2);

         sig = PlayBuf.ar(1, bufNum, pitch, 0, pos*BufFrames.kr(b),1) *
envl;
         Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

(
SynthDef(\gabor,
	{
		|out, freq = 440, sustain = 1, pan, amp = 0.1, width = 0.25|
		var env = LFGauss.ar(sustain, width, loop: 0, doneAction: 2);
		var son = FSinOsc.ar(freq, 0.5pi, env);
		OffsetOut.ar(out, Pan2.ar(son, pan, amp));
}, \ir  ! 6).add;
)

(
Pbindf(\gabor, \instrument, \gabor, \freq, 1000, \dur, 0.5, \sustain, 20/1000, \amp, 0.2).play;
)