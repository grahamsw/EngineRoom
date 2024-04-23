s.boot;

// Code Example 2.1

{ SinOsc.ar(300, 0, 0.1, 0) }.play;



// Code Example 2.2

{ SinOsc.ar(300, 0, 0.1, 0) ! 2 }.play;



// Code Example 2.3

{ SinOsc.ar(freq: 300, phase: 0, mul: 0.1, add: 0) ! 2 }.play;



// Code Example 2.4

(
x = { |freq = 300|
	SinOsc.ar(freq, mul: 0.1) ! 2;
}.play;
)

x.set(\freq, 400); // change the frequency



// Code Example 2.5

(
x = { |freq = 300, amp = 0.1|
	SinOsc.ar(freq, mul: amp) ! 2;
}.play;
)

x.set(\freq, 400, \amp, 0.4); // modify both arguments

x.set(\amp, 0.05, \freq, 500); // order of name/value pairs doesn't matter

x.set(\freq, 600); // modify only one argument



// Code Example 2.6

(
// define the sound
f = { |freq = 300, amp = 0.1|
	SinOsc.ar(freq, mul: amp) ! 2;
};
)

x = f.play; // play the sound

x.set(\freq, 400, \amp, 0.3); // change the sound

f.set(\freq, 500, \amp, 0.05); // no effect if applied to the function



// Code Example 2.7

(
f = { |freq = 300, amp = 0.1|
	SinOsc.ar(freq, mul: amp) ! 2;
};
)

x = f.play(args: [freq: 800, amp: 0.2]); // override default arguments

x.set(\freq, 600, \amp, 0.05); // set messages work normally



// Code Example 2.8

(
f = { |freq = 300, amp = 0.1|
	SinOsc.ar(freq, mul: amp) ! 2;
};
)

x = f.play(args: [freq: 350]);

y = f.play(args: [freq: 450]);

y.free;

x.free;



// Code Example 2.9

(
f = { |freq = 300, amp = 0.1|
	SinOsc.ar(freq, mul: amp) ! 2;
};
)

x = f.play;

x.release(2);



// Code Example 2.10

(
x = {
	var sig;
	sig = SinOsc.ar(300, mul: 0.15);
	sig = sig + PinkNoise.ar(mul: 0.1);
	sig = sig ! 2;
}.play;
)

x.release(2);



// Code Example 2.11

(
x = {
	var sig;
	sig = SinOsc.ar(300) * 0.15;
	sig = sig + (PinkNoise.ar * 0.1);
	sig = sig ! 2;
}.play;
)

x.release(2);



// Code Example 2.12

(
x = {
	var sig, lfo;
	lfo = SinOsc.kr(freq: 1/5, phase: 3pi/2, mul: 0.1, add: 0.1);
	sig = PinkNoise.ar * lfo;
	sig = sig ! 2;
}.play;
)

x.release(2);



// Code Example 2.13

(
x = {
	var sig, lfo;
	lfo = SinOsc.kr(freq: 0.2, phase: 3pi/2).range(0, 0.2);
	sig = PinkNoise.ar * lfo;
	sig = sig ! 2;
}.play;
)

x.release(2);



// Code Example 2.14

(
{
	var sig, env;
	env = Line.kr(start: 0.3, end: 0, dur: 0.5);
	sig = SinOsc.ar(350) * env;
	sig = sig ! 2;
}.play;
)

(
{
	var sig, env;
	env = XLine.kr(start: 0.3, end: 0.0001, dur: 0.5);
	sig = SinOsc.ar(350) * env;
	sig = sig ! 2;
}.play;
)



// Code Example 2.15

(
{
	var sig, env;
	env = XLine.kr(start: 0.3, end: 0.0001, dur: 0.5, doneAction: 2);
	sig = SinOsc.ar(350) * env;
	sig = sig ! 2;
}.play;
)



// Code Example 2.16

(
e = Env.new(
	levels: [0, 1, 0],
	times: [1, 3],
	curve: [0, 0]
);

e.plot;
)



// Code Example 2.17

(
{
	var sig, env;
	env = EnvGen.kr(
		envelope: Env.new(
			levels: [0, 1, 0],
			times: [1, 3],
			curve: [0, 0]
		),
		doneAction: 2
	);
	sig = SinOsc.ar(350) * 0.3;
	sig = sig * env;
	sig = sig ! 2;
}.play;
)



// Code Example 2.18

(
f = { |gate = 1|
	var sig, env;
	env = EnvGen.kr(
		envelope: Env.new(
			[0, 1, 0.2, 0],
			[0.02, 0.3, 1],
			[0, -1, -4],
			2
		),
		gate: gate,
		doneAction: 2
	);
	sig = SinOsc.ar(350) * 0.3;
	sig = sig * env;
	sig = sig ! 2;
};
)

x = f.play;

x.set(\gate, 0);



// Code Example 2.19

(
f = { |gate = 1|
	var sig, env;
	env = EnvGen.kr(
		Env.new(
			[0, 1, 0.2, 0],
			[0.02, 0.3, 1],
			[0, -1, -4],
			2
		),
		gate
	);
	sig = SinOsc.ar(350) * 0.3;
	sig = sig * env;
	sig = sig ! 2;
};
)

x = f.play;

x.set(\gate, 0); // fade to silence but do not free

x.set(\gate, 1); // reopen the gate to restart the envelope

x.set(\gate, 0); // fade to silence again

x.free; // free when finished



// Code Example 2.20

(
x = { |t_gate = 0|
	var sig, env;
	env = EnvGen.kr(
		Env.new(
			[0, 1, 0],
			[0.02, 0.3],
			[0, -4],
		),
		t_gate,
	);
	sig = SinOsc.ar(350) * 0.3;
	sig = sig * env;
	sig = sig ! 2;
}.play;
)

x.set(\t_gate, 1); // evaluate repeatedly

x.free; // free when finished



// Code Example 2.21

{ SinOsc.ar([350, 353]) * 0.2 }.play;

{ [ SinOsc.ar(350), SinOsc.ar(353) ] * 0.2 }.play;

{ [ SinOsc.ar(350) * 0.2, SinOsc.ar(353)  * 0.2 ] }.play;



// Code Example 2.22

(
{
	var sig, mod;
	sig = SinOsc.ar([450, 800]);
	mod = SinOsc.kr([1, 9]).range(0, 1);
	sig = sig * mod;
	sig = sig * 0.2;
}.play;
)



// Code Example 2.23

// these two expressions produce the same signal:
{ SinOsc.ar(300 ! 2, mul: 0.1) }.play;
{ SinOsc.ar(300, mul: 0.1) ! 2 }.play;

// these two expressions produce different signals:
{ PinkNoise.ar(mul: 0.2) ! 2 }.play; // "point" source between the speakers
{ PinkNoise.ar(mul: 0.2 ! 2) }.play; // "wide" source between the speakers



// Code Example 2.24

(
{
	var sig;
	sig = [ SinOsc.ar(300), PinkNoise.ar ];
	sig = sig * 0.1;
	sig = sig ! 2;
}.play;
)



// Code Example 2.25

(
{
	var sig, pan;
	pan = SinOsc.kr(0.5) * 0.8;
	sig = PinkNoise.ar * 0.2;
	sig = Pan2.ar(sig, pan);
}.play;
)



// Code Example 2.26

(
{
	var sig, freq;
	freq = { exprand(200, 2000) } ! 50;
	sig = SinOsc.ar(freq) * 0.1;
}.play;
)



// Code Example 2.27

(
{
	var sig, freq;
	freq = { exprand(200, 2000) } ! 50;
	sig = SinOsc.ar(freq) * 0.1;
	sig = Splay.ar(sig);
}.play;
)



// Code Example 2.28

(
x = {
	var sig;
	sig = SinOsc.ar([350, 353]);
	sig = sig * 0.2;
}.play;
)

x.free;



// Code Example 2.29

(
SynthDef(\test, {
	var sig;
	sig = SinOsc.ar([350, 353]);
	sig = sig * 0.2;
	Out.ar(0, sig);
}).add;
)



// Code Example 2.30

x = Synth(\test);

x.free;



// Code Example 2.31

(
SynthDef.new(\test, {
	arg freq = 350, amp = 0.2, atk = 0.01, dec = 0.3,
	slev = 0.4, rel = 1, gate = 1, out = 0;
	var sig, env;
	env = EnvGen.kr(
		Env.adsr(atk, dec, slev, rel),
		gate,
		doneAction: 2
	);
	sig = SinOsc.ar(freq + [0, 1]);
	sig = sig * env;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth(\test);

x.set(\freq, 450);

x.set(\amp, 0.5);

x.set(\gate, 0, \rel, 3);



// Code Example 2.32

x = Synth(\test, [freq: 800, amp: 0.1, atk: 4, slev: 1]);

x.set(\gate, 0);



// Code Example 2.33

(
// return an array of four Synths, assigned to x
x = [205, 310, 525, 700].collect({ |f|
	Synth.new(\test, [\freq, f, \amp, 0.1]);
});
)

// fade out each Synth
x.do({ |n| n.set(\gate, 0, \rel, 5) });



// Code Example 2.34

(
SynthDef.new(\test, {
	arg freq = 350, amp = 0.2, atk = 0.01, dec = 0.3,
	slev = 0.4, rel = 1, gate = 1, out = 0;
	var sig, env;
	env = EnvGen.kr(
		Env.adsr(atk, dec, slev, rel),
		gate,
		doneAction: 2
	);
	sig = SinOsc.ar(freq + [0, 1]);
	sig = sig * env;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth(\test, [freq: 60.midicps, amp: -20.dbamp]);

x.set(\freq, 62.midicps); // increase pitch by 2 semitones

x.set(\amp, -12.dbamp); // increase level by 8 dB

x.set(\gate, 0);



// Code Example 2.35

(
x = {
	var sig, freq;
	freq = SinOsc.kr(0.2).exprange(200,800).poll(20);
	sig = SinOsc.ar(freq);
	sig = sig * 0.2;
	sig = sig ! 2;
}.play;
)



// Code Example 2.36

{ SinOsc.ar(110) }.plot(0.05); // 0.05 seconds of a 110 Hz sine wave

{ SinOsc.ar([110, 220, 330, 440]) }.plot(0.05); // multichannel plot