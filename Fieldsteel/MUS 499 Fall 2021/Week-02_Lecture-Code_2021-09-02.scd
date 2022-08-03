//conditional logic

2 == 2
2 != 3

2 > 3
2 < 3

2 <= 3
2 >= 3

2 >= 2
2 > 2

(
if(
	[0,1].choose == 0,
	{ "0 was chosen".postln },
	{ "1 was chosen".postln }
);
)

(
~func = {
	arg input;
	if(
		input > 5,
		{ "sine".postln; },
		{ "noise".postln; }
	);
};
)

~func.value(5);

(
~func = {
	arg input;
	case
	{ input < 0}	{ "sine".postln; }
	{ input > 10 }	{ "noise".postln; }
	{ true }		{ "sawtooth".postln; };
};
)

~func.value(10);

//randomness

rrand(-10, 20);
-10.rrand(20);

rrand(-10, 20.0);

3.squared;
squared(3);

exprand(1, 100);
exprand(1, 100).round;
exprand(1, 100).asInteger;

exprand(-1, 100);
exprand(-1, -100);

//useful audio server utilities

s.boot;

(
~mysound = {
	arg freq=400;
	SinOsc.ar(freq, 0, 0.2, 0);
};
)

~mysound.plot(0.01);

s.meter;
s.scope;
FreqScope.new;
s.plotTree;
s.volume.gui;


//making sound: UGens & function-dot-play

(
~mysound = {
	|freq=400|
	SinOsc.ar(freq, 0, 0.2, 0);
};
)

x = ~mysound.play(args: [\freq, 400]);

x.set(\freq, 300);

x.free;

[1,2,3,4,5]

(
~mysound = {
	arg freq;
	var sig;
	sig = SinOsc.ar(freq, 0, 0.2, 0);
	[sig, sig];
};
)

x = ~mysound.play(args: [\freq, 400]);

(
{
	var sig;
	sig = PinkNoise.ar(0.2);
	[sig, 0].reverse;
}.play;
)

(
{
	var sig;
	sig = PinkNoise.ar(0.2);
	sig = sig!2;
}.play;
)

7.dup(5);

7!5;

(
{
	var sig;
	sig = PinkNoise.ar(0.2!2);
}.play;
)

(
{
	var sig;
	sig = PinkNoise.ar(0.2)!2;
}.play;
)

///////////////

(
{
	arg freq=400;
	var sig;
	sig = SinOsc.ar(freq, 0, 0.2, 0);
	sig = sig + SinOsc.ar(freq * 1.03, 0, 0.2, 0);
	sig!2;
}.play;
)

(
{
	arg freq=400;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig + SinOsc.ar(freq * 1.03);
	sig = sig * 0.1;
	sig!2;
}.play;
)

(
{
	var sig, mod;
	sig = WhiteNoise.ar(0.1);
	mod = LFPulse.ar(8).range(0.1, 0.6);
	sig = sig * mod;
	sig!2;
}.play;
)