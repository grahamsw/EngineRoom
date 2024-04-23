// Code Example 6.1

(
s.options.numOutputBusChannels_(8);
s.options.numInputBusChannels_(4);
s.reboot;
)



// Code Example 6.2

(
s.options.numOutputBusChannels_(2);
s.options.numInputBusChannels_(2);
s.reboot;
)



// Code Example 6.3

(
~mixerBus = Bus.audio(s, 8);
~delayBus = Bus.audio(s, 2);
~reverbBus = Bus.audio(s, 2);
)

~delayBus.index; // -> 12



// Code Example 6.4

(
~quadCtlBus = Bus.control(s, 4);
~stereoCtlBus = Bus.control(s, 2);
~monoCtlBus = Bus.control(s, 1);
)

~monoCtlBus.index; // -> 6



// Code Example 6.5

(
s.newBusAllocators; // reset bus counters
~mixerBus = Bus.audio(s, 8); // -> busses 4-11
~delayBus = Bus.audio(s, 2); // -> busses 12-13
~reverbBus = Bus.audio(s, 2); // -> busses 14-15
)



// Code Example 6.6

(
x = { Out.kr(33, PinkNoise.kr(1 ! 4)) }.play;
s.scope(rate: \control, numChannels: 4, index: 33);
)

x.free;



// Code Example 6.7

(
x = { Out.ar(14, SinOsc.ar([150, 151], mul: 0.2)) }.play;
s.scope(rate: \audio, numChannels: 2, index: 14);
)

x.free;



// Code Example 6.8

(
s.newBusAllocators;
~bus = Bus.audio(s, 2);

SynthDef(\fader, { |in = 0, out = 0|
	var sig = In.ar(in, 2);
	sig = sig * 0.2;
	Out.ar(out, sig);
}).add;

SynthDef(\src, { |out = 0, freq = 150|
	var sig = SinOsc.ar(freq + [0, 1]);
	Out.ar(out, sig);
}).add;
)

(
~fader = Synth(\fader, [in: ~bus, out: 0]);
~src = Synth(\src, [out: ~bus]);
s.scope(rate: \audio, numChannels: 16, index: 0); // visualize bus activity
)

(
~src.free; // cleanup
~fader.free;
)



// Code Example 6.9

(
{	// FEEDBACK WARNING — use headphones
	var sig = In.ar(bus: 2, numChannels: 1) ! 2;
	Out.ar(0, sig);
}.play;
)



// Code Example 6.10

(
{	// FEEDBACK WARNING — use headphones
	var sig, freq;
	sig = In.ar(2, 1) ! 2;
	freq = LFNoise0.kr([8, 7]).exprange(50, 2000);
	sig = sig * SinOsc.ar(freq);
	Out.ar(0, sig);
}.play;
)



// Code Example 6.11

(
{	// FEEDBACK WARNING — use headphones
	var sig = SoundIn.ar(bus: 0) ! 2;
	Out.ar(0, sig);
}.play;
)



// Code Example 6.12

(
SynthDef(\sine, { |gate = 1, out = 0|
	var sig = SinOsc.ar(250, mul: 0.1 ! 2);
	sig = sig * Env.asr.kr(2, gate);
	Out.ar(out, sig);
}).add;

SynthDef(\pink, { |gate = 1, out = 0|
	var sig = PinkNoise.ar(0.1 ! 2);
	sig = sig * Env.asr.kr(2, gate);
	Out.ar(out, sig);
}).add;
)

(
~a = Synth(\sine);
~b = Synth(\pink);
)



// Code Example 6.13

(
s.newBusAllocators;
~bus = Bus.audio(s, 2);

SynthDef(\pulses, { |out = 0, freq = 800, pulsefreq = 0.3|
	var sig = SinOsc.ar(freq + [0, 2], mul: 0.2);
	sig = sig * LFPulse.kr(pulsefreq, 0, 0.01);
	Out.ar(out, sig);
}).add;

SynthDef(\reverb, { |in = 0, out = 0, size = 0.97|
	var sig = In.ar(in, 2);
	sig = FreeVerb2.ar(sig[0], sig[1], mix: 0.2, room: size);
	Out.ar(out, sig);
}).add;
)

(
~b = Synth(\reverb, [in: ~bus, out: 0]);
~a = Synth(\pulses, [out: ~bus]);
)



// Code Example 6.14

// This example relies on the bus and SynthDefs created in the previous example.

(
~genGrp = Group();
~fxGrp = Group(~genGrp, \addAfter);
~a = Synth(\pulses, [out: ~bus], ~genGrp);
~b = Synth(\reverb, [in: ~bus, out: 0], ~fxGrp);
)



// Code Example 6.15

// This example relies on the bus and SynthDefs created in Code Example 6.13 and assumes Code Example 6.14 has been evaluated.

(
Routine({
	4.do({
		Synth(\pulses, [freq: exprand(300, 3000), out: ~bus], ~genGrp);
		exprand(0.05, 1).wait;
	});
}).play;
)

~genGrp.set(\pulsefreq, 1); // set all Synths in ~genGrp

~genGrp.freeAll; // free all Synths in ~genGrp



// Code Example 6.16

(
{
	var sig, delay;
	Line.kr(0, 0, 1, doneAction: 2);
	sig = PinkNoise.ar(0.5!2) * XLine.kr(1, 0.001, 0.3);
	delay = DelayN.ar(sig, 0.5, 0.5) * -6.dbamp;
	sig = sig + delay;
}.play(fadeTime: 0);
)



// Code Example 6.17

(
s.newBusAllocators;
~bus = Bus.audio(s, 2);

SynthDef(\del, {
	arg in = 0, out = 0, del = 0.5, amp = 0.5;
	var sig, delay;
	sig = In.ar(in, 2);
	delay = DelayN.ar(sig, 1, del) * amp;
	sig = sig + delay;
	Out.ar(out, sig);
}).add;

SynthDef(\src, {
	arg out = 0;
	var sig = PinkNoise.ar(0.5 ! 2);
	sig = sig * XLine.kr(1, 0.001, 0.3, doneAction: 2);
	Out.ar(out, sig);
}).add;
)

~del = Synth(\del, [in: ~bus, out: 0]); // create the echo effect

~src = Synth(\src, [out: ~bus]); // can be run repeatedly

~del.free;



// Code Example 6.18

(
s.options.memSize_(2.pow(20));
s.reboot;
)



// Code Example 6.19

~buf = {Buffer.alloc(s, (s.sampleRate / 2).nextPowerOfTwo)} ! 2;

(
{
	var sig, delay;
	Line.kr(0, 0, 1, doneAction: 2);
	sig = PinkNoise.ar(0.5!2) * XLine.kr(1, 0.001, 0.3);
	delay = BufDelayN.ar(~buf, sig, 0.5) * -6.dbamp;
	sig = sig + delay;
}.play(fadeTime: 0);
)



// Code Example 6.20

(
{
	var sig, delay, lfo;
	lfo = SinOsc.kr(0.1, 3pi/2).range(0.001, 0.01);
	sig = LPF.ar(Saw.ar(100 ! 2, mul: 0.2), 2000);
	delay = DelayL.ar(sig, 0.01, lfo);
	sig = sig + delay;
}.play;
)



// Code Example 6.21

(
{
	var sig, delay;
	Line.kr(0, 0, 10, doneAction: 2);
	sig = PinkNoise.ar(0.5 ! 2) * XLine.kr(1, 0.001, 0.3);
	delay = CombN.ar(sig, 0.1, 0.1, 9) * -6.dbamp;
	sig = sig + delay;
}.play(fadeTime: 0);
)



// Code Example 6.22

(
SynthDef(\comb, { |freq = 4|
	var sig, delay;
	Line.kr(0, 0, 10, doneAction: 2);
	sig = PinkNoise.ar(0.5 ! 2) * XLine.kr(1, 0.001, 0.3);
	delay = CombN.ar(sig, 1, 1/freq, 9) * -6.dbamp;
	delay = LeakDC.ar(delay);
	sig = sig + delay;
	Out.ar(0, sig);
}).add;
)

Synth(\comb, [freq: 4]); // slower echo

Synth(\comb, [freq: 14]); // faster echo

Synth(\comb, [freq: 40]); // 40 Hz tone sensation

Synth(\comb, [freq: 120]); // 120 Hz tone sensation



// Code Example 6.23

(
{	// FEEDBACK WARNING — use headphones
	var sig = SoundIn.ar(0);
	sig = GrainIn.ar(
		numChannels: 1,
		trigger: Dust.kr(16),
		dur: 0.04,
		in: sig
	) ! 2;
}.play;
)



// Code Example 6.24

(
{	// FEEDBACK WARNING — use headphones
	var sig = SoundIn.ar(0);
	sig = sig * Env.sine(0.04).ar(gate: Dust.ar(16)) ! 2;
}.play;
)



// Code Example 6.25

(
{	// FEEDBACK WARNING — use headphones
	var sig = SoundIn.ar(0);
	sig = DelayN.ar(sig, 0.2, 0.2) * 0.7;
	sig = GrainIn.ar(1, Dust.kr(16), 0.04, sig) ! 2;
}.play;
)



// Code Example 6.26

b = Buffer.alloc(s, s.sampleRate * 3); // three-second buffer

(
SynthDef(\livegran, {
	arg buf = 0, rate = 1, ptrdelay = 0.2;
	var sig, ptr, gran;
	sig = SoundIn.ar(0);
	ptr = Phasor.ar(0, BufRateScale.ir(buf), 0, BufFrames.ir(buf));
	BufWr.ar(sig, buf, ptr);
	sig = GrainBuf.ar(
		numChannels: 2,
		trigger: Dust.kr(16),
		dur: 0.04,
		sndbuf: buf,
		rate: rate,
		pos: (ptr - (ptrdelay * SampleRate.ir)) / BufFrames.ir(buf)
	);
	Out.ar(0, sig);
}).add;
)

// FEEDBACK WARNING — use headphones
Synth(\livegran, [buf: b]);



// Code Example 6.27

(
// FEEDBACK WARNING — use headphones
b.zero;
Synth(\livegran, [buf: b, ptrdelay: 0.005, rate: 4.midiratio]);
)



// Code Example 6.28

b = Buffer.alloc(s, s.sampleRate * 3);

(
SynthDef(\livegran, {
	arg buf = 0, rate = 1, ptrdelay = 0.2;
	var sig, ptr, gran, maxgraindur;
	sig = SoundIn.ar(0);
	ptr = Phasor.ar(0, BufRateScale.ir(buf), 0, BufFrames.ir(buf));
	BufWr.ar(sig, buf, ptr);
	maxgraindur = ptrdelay / rate;
	sig = GrainBuf.ar(
		numChannels: 2,
		trigger: Dust.kr(16),
		dur: min(0.04, maxgraindur),
		sndbuf: buf,
		rate: rate,
		pos: (ptr - (ptrdelay * SampleRate.ir)) / BufFrames.ir(buf)
	);
	Out.ar(0, sig);
}).add;
)

(
// FEEDBACK WARNING — use headphones
b.zero;
Synth(\livegran, [buf: b, ptrdelay: 0.05, rate: 7.midiratio]);
)