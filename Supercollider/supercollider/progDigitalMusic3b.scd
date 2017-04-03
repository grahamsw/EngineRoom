
(
SynthDef(\sine, {
	|freq=440, amp=0.707, dur = 1|
	var env, envgen;
	env = Env([0,1,1,0] * amp, [0.01, dur-0.02, 0.01]);
	envgen = EnvGen.ar(env, doneAction:2);
	Out.ar(0, SinOsc.ar(freq, mul:envgen))
}).add;
)

(
var key = 60, score;
j = [0, 4, 7, 12];
k = [0, 3, 7, 12];
score = j++j++(k-3)++(k-3)++(j-7)++(j-7)++[j-7]++[j-7];

score = (key + score).midicps;
), (degree:[0,3,5])]).play
Pbind(\degree, Pseq([0,3,5])).play
Pbind(\degree, Pseq([[0,3,5], [0, 3b, 5], [0, 3, 5s]])
Routine({
	score.do{|i|
		if(i.size > 0, {i.size.do{
			|y|
			Synth(\sine, [\freq, i[y], \amp, 0.707/i.size, \dur, 0.5])}; 1.wait},
			{Synth(\sine, [\freq, i, \dur, 0.25]); 0.25.wait});
	}
}).play;
)

(amp:0.7, freq:880).play

(degree:[0,3,5], timingOffset:[0,1,2]).play

Pseq([(degree:3)]).play
Pseq([(degree:0), (degree:[0,3]), (degree:[0,3,5])]).play
Pbind(\degree, Pseq([0,3,5])).play
Pbind(\degree, Pseq([[0,3,5], [0, 3b, 5], [0, 3, 5s]]), \amp, 0.7).play

Pbind(\note, Pseq((0..12).scramble, 4), \dur, (1/8)).play

(
var score;
j = [0, 4, 7, 12];
k = [0, 3, 7, 12];
score = j++j++(k-3)++(k-3)++(j-7)++(j-7)++[j-7]++[j-7];

Pbind(\note, Pseq(score),
	\dur, Pseq((1/4!24)++(1!12))
).play;
)

(
SynthDef(\inharmony, {
	|freq = 440, amp = 1, dur = 1|
	var env, wave;
	env = EnvGen.ar(Env.triangle(dur), doneAction:2);
	wave = Klang.ar(`[[1, 2.7, 5.4, 8.1], amp/4!4], freq);
	Out.ar(0, wave * env);
	}
).add;
)


(Pbind(
	\instrument, \inharmony,
	\note, Pseq([0, 12, 14, -11, -12]),
	\dur, Pseq(9!5),
	\amp, 0.707,
	\delta, 3
).play;
)
