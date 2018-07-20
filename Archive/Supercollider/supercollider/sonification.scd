Environment.make{~a = 10; ~b = 1 + pi * 7.rand;}

Environment.make{~a = pi + 10.rand; ~b = ~a.pow(5)}

(
~a = pi + 10.rand;
~b = ~a.pow(5);
)

Environment.make {~c = 3}.use{~a = 2.pow(10); ~c + ~a}


~c = 2;
~a = 2.pow(10);
~c + ~a;


(a:5, b:2).use({{|a, b| a + b}.valueEnvir(3,4)});
a
b

{|a,b| a + b}.(7,9)

().play.parent

Server.default.boot

(degree:5).parent
(degree:5).play.parent.asCompileString
(degree:5).play

(

SynthDef("ping", {
	|freq = 440|
	Out.ar(0, SinOsc.ar(freq, 0, EnvGen.kr(Env.perc(level:0.1), doneAction:2)))
}).add;
SynthDef("wham", {
		Out.ar(0, BrownNoise.ar(EnvGen.kr(Env.perc(level:0.1), doneAction:2)))
	}).add;


Pbind(\instrument, \ping, \freq, Pseq((440, 500..1000).pyramid(5)), \dur, 0.1).play
)
(
Task {
	x = 4; y = 13; m = 5;
	loop {
		x = (x * y) % m;
		( note: x.postln, dur: 0.125).play;
		0.125.wait;
	}
}.play
)

x = 7;
y = 3;
m = 50



({
	x = SinOsc.kr(4);
	y = SinOsc.kr(13);
	SinOsc.ar(x * y % 0.4*500 + 600) * 0.2


}.play
)


(
p = ProxySpace.push;
~x = {SinOsc.kr(4)};
~y = {SinOsc.kr(13)};
~z = {SinOsc.ar(~x * ~y % 0.4 * 500 + 600) * 0.2};
~z.play;

~x = {SinOsc.kr(0.4)};
~y = {SinOsc.kr(1.3)};
)
p.clear(2).pop;

{var num = 5; var x = 1.0; num.do {x = x * SinOsc.ar(1911.0.rand, mul:0.9)}; x}.play