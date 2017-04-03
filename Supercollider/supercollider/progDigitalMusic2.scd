(
{
	var dur = 2, envtri, trig, envgen, output;
	envtri = Env([0.01, 0.707, 0.01], [dur/2, dur/2], \exp);
	trig = Impulse.kr(1/dur);
	envgen = EnvGen.ar(envtri, trig);
	output = SinOsc.ar(mul:envgen);
}.play
)

(
{
	var dur = 2, envadsr, gate, envgen, output;
	envadsr = Env([0, 0, 0.8, 0.6, 0.7, 0.6, 0], [0.001, 0.1, 0.2, 0.2, 1, 0.5], \lin, 5, 3);
	gate = SinOsc.ar(1/(3 * dur), mul:1/2);
	envgen = EnvGen.ar(envadsr, gate);
	output = SinOsc.ar * envgen;
}.plot(8)
)


(
{
	var dur = 1, env16seg, trig, envgen, output;
	env16seg = Env([0.01, 1, 0.01, 7/8, 0.01, 6/8, 0.01, 5/8, 0.01, 4/8, 0.01, 3/8, 0.01, 2/8, 0.01, 1/8, 0.01] * 0.707, dur/16!16, \exp);
	trig = SinOsc.ar(1/dur, mul:1/2);
	envgen = EnvGen.ar(env16seg, trig);
	output = SinOsc.ar(mul:envgen);
}.play;
)

(SynthDef(\sinenv,
	{
		|freq=440, amp=1, dur=1|
		var env, trig, envgen, output;
		env = Env([0, 0.707, 0.65, 0.4, 0] * amp, [1/64, 3/32, 14/16, 1/64] * dur, -4);
		trig = SinOsc.ar(1/dur, mul:1/2);
		envgen = EnvGen.ar(env, trig);
		Out.ar(0, SinOsc.ar(freq, mul:envgen))
}).add;
)

a = Synth(\sinenv, [\amp, 1/5]);
b = Synth(\sinenv, [\freq, 550, \amp, 1/5, \dur, 2]);
c = Synth(\sinenv, [\freq, 660, \amp, 1/5, \dur, 3]);
a.free; b.free; c.free;

p = [1,2,4];
p.size
(

	var amaj, amp;
	amaj = [60, 63, 68, 70].midicps;
	amp = 0.5/amaj.size;
	amaj.size.do { arg count;
		{
		SinOsc.ar(amaj[count], mul:amp)
	}.play;
	}

)

(
	var freq = {XLine.kr(400, 444, 10)};
	{SinOsc.ar([440, freq], mul:-6.dbamp)}.play;

)

{Blip.ar(mul:-6.dbamp)}.play


~buffer = Buffer.alloc(s, 2 ** 16);
~fund = 440;
~harmN = ((s.sampleRate/2)/~fund).floor;
~norm = -6.dbamp;

(
var sine;
sine = ~buffer.sine1([1, 0.5, 0, 0.5]);
{Osc.ar(sine, ~fund, mul: ~norm)}.play;
)
(
var harm, saw;
harm = Harmonics(~harmN);
saw = ~buffer.sine1(harm.decay);
saw.plot;
{Osc.ar(saw,~fund)}.play;
)

(
var freqs, amps, square;
freqs = (1, 3..~harmN);
amps = 1/freqs;
square= ~buffer.sine2(freqs, amps);
{Osc.ar(square, ~fund, mul:~norm)}.play;
)


(
var freqs, amps, triangle;
freqs = (1, 3..~harmN);
amps = 1/freqs.pow(2);
triangle= ~buffer.sine2(freqs, amps);
{Osc.ar(triangle, ~fund, mul:~norm)}.play;
)



(
var freqs, amps, square;
freqs = (1, 3..~harmN);
amps = 1/freqs;
square= ~buffer.sine2(freqs, amps);
{Osc.ar(square, ~fund, mul:~norm)}.play;
)

(
var freqs, amps, pulse;
amps = 1/(1!~harmN);
pulse= ~buffer.sine1(amps, asWavetable:false);
{Osc.ar(pulse, ~fund, mul:~norm)}.play;
)

