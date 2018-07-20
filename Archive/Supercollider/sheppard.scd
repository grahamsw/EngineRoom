

(
{
	var noise = LFNoise1.ar(10);
	SinOsc.ar(400, mul:noise);

}.play
)


(


{
	LFNoise2.ar(MouseX.kr(0, 10000), mul:MouseY.kr(0,1))
}.play


)


(
{
	LFNoise1.ar(SinOsc.kr(1/4).range(100, 1000))
}.play
)
(

{

	var env = EnvGen.kr(Env.perc,doneAction:2);
	var samplesHeld = 50;
	var freq = 500;
	var bwfract = 0.15;
	var noise = LFNoise1.ar(freq * bwfract );
	SinOsc.ar(1000, mul:noise) * env
}.play;



)


// shepard tones
// alberto de campo
(
var ampTable, freqTable, b1, b2;

ampTable = Signal.hanningWindow(1024).squared;
freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);

b1 = Buffer.loadCollection(s, freqTable);
b2 = Buffer.loadCollection(s, ampTable);

{
	var freqs, amps, phasor, ratescale, rate, phases;
	ratescale = 1024 / 44100 / 10;
	rate = 0.1;	// once per 10 sec
	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);
	phases = (0..9) * 0.1 * 1024 + phasor;

	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);

	Mix.new(SinOsc.ar(freqs) * amps) * 0.1;
}.play;

)
(2**3)
(

SynthDef(\sheppard, { |amp = 0.1|
	var pitch = XLine.kr(2**6, 2**14, 10);
	var env = EnvGen.kr(Env.new([0.01, 1, 0.01], [5,5], \exp), doneAction:2);
	Out.ar(0, SinOsc.ar(pitch, 0, env * amp))}).add;

)

Synth(\sheppard)

(
Pdef(\shep, Pbind(
	\instrument, \sheppard,
	\dur, 1/4,
	\sustain, 10
)).play

)

[7,8,9,10,11,12,13,14].do({|i| (2**i).postln})



(
SynthDef(\bissetGong, {|ring=135, freq = 400, amp = 0.5, dur = 0.2|
	var pulse = Pulse.ar(ring).range(0,1);
	var sin = SinOsc.ar(freq);
	Out.ar(0,sin * pulse * EnvGen.kr(Env.new([0,1,1,0]* amp, [0.1, 0.4, 0.1].normalizeSum * dur), doneAction:2));
}).add;
)

Synth(\bissetGong, [\dur, 10])

(
Pbind(
	\instrument, \bissetGong,
	\freq, [60, 64, 67].midicps,
	\ring, [135, 150, 180],
	\dur,* 10,
	\amp, 0.2
).play

)


(
Pbind(
	\instrument, \bissetGong,
	\freq, Pseq([60, 64, 67].midicps),
	\ring, Pseq([135, 150, 180])
).play

)

(
{
	Mix.new(7.collect({|i| SinOsc.ar(109.91 + (i * 0.09), mul:0.1)}));
}.play
)

7.collect({|i| 109.91 + (i * 0.03)})


(

{

	var modFreq = MouseX.kr(100, 200).poll(1, "X");

	var mod = SinOsc.ar(modFreq/3.6).range(0, MouseY.kr(0, 200).poll(1,"Y"));
	SinOsc.ar(modFreq + mod, mul:0.5);
}.play
)