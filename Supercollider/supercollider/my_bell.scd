
f = {
| freq = 600, dur = 0.05, mul = 0.3, curve = -8|
	var env;
	env = Env.perc(attackTime: 0.001,releaseTime: dur, curve:curve);
	Klang.ar(`[[1, 2.5, 3.5], [0.7, 0.45, 0.25].normalize], freqscale:freq) * EnvGen.kr(env, doneAction:2) * mul;
}

(

SynthDef.new(\bellPartial, {
| freq = 600, dur = 0.05, mul = 0.3, curve = -8, trig= 10|
	var env, out, gate;
	gate = Impulse.kr(trig );
	env = Env.perc(attackTime: 0.001,releaseTime: dur, curve:curve);

	out = Klang.ar(`[[1, 2.5, 3.5], [0.7, 0.45, 0.25].normalize], freqscale:freq) * EnvGen.kr(env, gate:gate, doneAction:0) * mul;

Out.ar(0, out);
	}
).add;
)
(
Synth(\bellPartial, [\freq, 720, \dur, 0.5, \trig, 15]);
Synth(\bellPartial, [\freq, 1230, \dur, 0.5, \trig, 15]);
Synth(\bellPartial, [\freq, 1800, \dur, 0.5, \trig, 15]);
)


(

f.play(args: [\freq, 720, \dur, 1]);
f.play(args: [\freq, 1230, \dur, 0.8, \mul, 0.2]);
f.play(args: [\freq, 1800, \dur,0.5, \mul, 0.15]);

)


(

f.play(args: [\freq, 50, \dur, 10, \mul, 0.4, \curve:-2]);
f.play(args: [\freq, 120, \dur, 10, \mul, 0.1]);
f.play(args: [\freq, 630, \dur, 8, \mul, 0.2]);
f.play(args: [\freq, 800, \dur, 6, \mul, 0.15, \curve:1]);

)

)

{ |i| i.postln }.dup(10);
{{|i| 0.1*SinOsc.ar(100*(i+1))}.dup(10).sum.tanh!2}.play



