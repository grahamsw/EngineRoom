s.boot;

// Code Example 3.1

(
{
	var sig;
	sig = SinOsc.ar(200, mul: 0.2);
	sig = sig + SinOsc.ar(400, mul: 0.1);
	sig = sig + SinOsc.ar(600, mul: 0.05);
	sig = sig + SinOsc.ar(800, mul: 0.025);
	sig = sig ! 2;
}.play;
)



// Code Example 3.2

(
{
	var sig = 0, freqs = [200, 400, 600, 800];
	freqs.do({ |f, i|
		sig = sig + SinOsc.ar(f, mul: 0.2 / 2.pow(i));
	});
	sig = sig ! 2;
}.play;
)



// Code Example 3.3

(
{
	var sig, freqs = [200, 400, 600, 800];
	sig = freqs.collect({ |f, i|
		SinOsc.ar(f, mul: 0.2 / 2.pow(i));
	});
	sig = sig.sum;
	sig = sig ! 2;
}.play;
)



// Code Example 3.4

(
{
	var sig, harm;
	harm = LFTri.kr(0.1, 3).range(1, 50);
	sig = Blip.ar([80, 81], harm);
	sig = sig * 0.1;
}.play;
)



// Code Example 3.5

(
{
	var sig;
	sig = Klang.ar(
		`[	// <- note the backtick character
			Array.exprand(40, 50, 8000).sort,
			Array.exprand(40, 0.001, 0.05).sort.reverse,
			Array.rand(40, 0, 2pi)
		]
	);
	sig = sig ! 2;
}.play;
)



// Code Example 3.6

(
{
	var sig, freqs, amps, phases;
	freqs = Array.exprand(40, 50, 8000).sort;
	amps = Array.exprand(40, 0.005, 0.2).sort.reverse;
	phases = Array.rand(40, 0, 2pi);
	sig = DynKlang.ar(`[ // <- note the backtick character
		freqs * LFNoise1.kr(0.02 ! 40).exprange(0.25, 2),
		amps * LFNoise1.kr(1 ! 40).exprange(0.02, 1),
		phases
	]);
	sig = sig ! 2;
}.play;
)



// Code Example 3.7

(
{
	var sig, mod;
	mod = SinOsc.ar(4, 3pi/2).range(0, 3000);
	sig = Pulse.ar([90, 91]);
	sig = LPF.ar(sig, 200 + mod);
	sig = sig * 0.1;
}.play;
)



// Code Example 3.8

(
{
	var sig, mod, modHz;
	modHz = XLine.kr(1, 150, 10);
	mod = SinOsc.ar(modHz).range(0, 1);
	sig = SinOsc.ar(750, mul: mod);
	sig = sig * 0.2 ! 2;
}.play;
)



// Code Example 3.9

(
{
	var sig, mod, modHz;
	modHz = XLine.kr(1, 150, 10);
	mod = SinOsc.ar(modHz).range(-1, 1);
	sig = SinOsc.ar(750, mul: mod);
	sig = sig * 0.2 ! 2;
}.play;
)



// Code Example 3.10

(
{
	var sig, mod;
	mod = SinOsc.ar(1050).range(0, 1); // audio rate modulator
	sig = SinOsc.ar(750);
	sig = sig * mod * 0.2 ! 2;
}.play;
)

(
{
	var sig, mod;
	mod = SinOsc.kr(1050).range(0, 1); // control rate modulator
	sig = SinOsc.ar(750);
	sig = sig * mod * 0.2 ! 2;
}.play;
)



// Code Example 3.11

(
{
	var sig, mod, modHz;
	modHz = XLine.kr(1, 150, 10);
	mod = SinOsc.ar(modHz, mul: 300);
	sig = SinOsc.ar(750 + mod);
	sig = sig * 0.2 ! 2;
}.play;
)



// Code Example 3.12

(
{
	var sig, mod1, mod2;
	mod2 = SinOsc.ar(0.2, mul: 450);
	mod1 = SinOsc.ar(500 + mod2, mul: 800);
	sig = SinOsc.ar(1000 + mod1);
	sig = sig * 0.2 ! 2;
}.play;
)

(
{
	var sig, mod1, mod2;
	mod2 = SinOsc.ar(0.2, mul: 450);
	mod1 = SinOsc.ar(500, mul: 800);
	sig = SinOsc.ar(1000 + mod1 + mod2);
	sig = sig * 0.2 ! 2;
}.play;
)



// Code Example 3.13

(
{
	var sig, mod;
	mod = LFTri.ar(0.3).range(0, 1);
	sig = Pulse.ar(100, width: mod);
	sig = sig * 0.2 ! 2;
}.play;
)

(
{
	var sig, mod;
	mod = LFTri.ar(0.3).range(0, 1);
	sig = VarSaw.ar(200, width: mod);
	sig = sig * 0.2 ! 2;
}.play;
)



// Code Example 3.14

(
{
	var sig, freq;
	freq = XLine.kr(20, 8000, 10, doneAction: 2);
	sig = Pulse.ar(freq); // replace with LFPulse and notice the difference
	sig = sig * 0.2 ! 2;
}.play;
)



// Code Example 3.15

(
~wt = Signal.sineFill(8192, [1], [0]).asWavetable;
b = Buffer.loadCollection(s, ~wt);
)

{ Osc.ar(b, 200) * 0.2 ! 2 }.play;



// Code Example 3.16

(
b = Buffer.allocConsecutive(4, s, 16384);

~wt = [
	Signal.sineFill(8192, 1 ! 4, 0 ! 4),
	Signal.sineFill(8192, 1 / (1..50), 0 ! 50),
	Signal.sineFill(
		8192,
		[ 1 / (1, 3..50), 0 ! 25].lace(50),
		0 ! 50
	),
	Signal.sineFill(
		8192,
		Array.exprand(50, 0.001, 1).sort.reverse,
		{ rrand(0, 2pi) } ! 50
	),
];

b.do({ |buf, i| buf.loadCollection(~wt[i].asWavetable) });
)

~wt.plot; // optional visualization



// Code Example 3.17

(
{
	var sig, bufmod;
	bufmod = SinOsc.kr(0.05, 3pi/2).unipolar(2.999);
	sig = VOsc.ar(b[0].bufnum + bufmod, 200);
	sig = sig * 0.1 ! 2;
}.play;
)



// Code Example 3.18

(
~wt = Env.new([-1, 0, 1], [1, 1], [4, -4]).asSignal(8193);
b = Buffer.loadCollection(s, ~wt.asWavetableNoWrap);
)

~wt.plot; // optional visualization

(
{
	var sig, index;
	index = SinOsc.ar(200);
	sig = Shaper.ar(b, index);
	sig = sig * 0.2 ! 2;
}.play;
)



// Code Example 3.19

{ WhiteNoise.ar(0.1 ! 2) }.play;
{ PinkNoise.ar(0.1 ! 2) }.play;
{ BrownNoise.ar(0.1 ! 2) }.play;



// Code Example 3.20

(
{
	var sig, freq;
	freq = LFNoise0.kr(8).exprange(150, 2000);
	sig = SinOsc.ar(freq) * 0.2 ! 2;
}.play;
)



// Code Example 3.21

{ LFNoise0.ar(XLine.kr(100, s.sampleRate, 8)) * 0.1 ! 2 }.play;
{ LFNoise1.ar(XLine.kr(100, s.sampleRate, 8)) * 0.1 ! 2 }.play;
{ LFNoise2.ar(XLine.kr(100, s.sampleRate, 8)) * 0.1 ! 2 }.play;

{ LFDNoise0.ar(XLine.kr(100, s.sampleRate, 8)) * 0.1 ! 2 }.play;
{ LFDNoise1.ar(XLine.kr(100, s.sampleRate, 8)) * 0.1 ! 2 }.play;
{ LFDNoise3.ar(XLine.kr(100, s.sampleRate, 8)) * 0.1 ! 2 }.play;



// Code Example 3.22

(
{
	var sig, cutoff;
	cutoff = LFTri.kr(0.1, 3).exprange(100, 10000);
	sig = PinkNoise.ar(1);
	sig = LPF.ar(sig, cutoff) * 0.25 ! 2; // replace with HPF
}.play;
)

(
{
	var sig, cutoff, rq;
	cutoff = LFTri.kr(0.1, 3).exprange(100, 10000);
	rq = MouseY.kr(0.01, 1, 1).clip(0.01, 1);
	sig = PinkNoise.ar(1);
	sig = BPF.ar(sig, cutoff, rq) * 0.25 ! 2; // replace with BRF
}.play;
)



// Code Example 3.23

(
{
	var sig, cutoff, rq;
	cutoff = LFTri.kr(0.1, 3).exprange(100, 10000);
	rq = MouseY.kr(0.01, 1, 1).clip(0.01, 1);
	sig = PinkNoise.ar(1);
	sig = BPF.ar(sig, cutoff, rq, mul: 1 / rq.sqrt) * 0.5 ! 2;
}.play;
)



// Code Example 3.24

(
{
	var sig;
	sig = WhiteNoise.ar(1 ! 2);
	2.do({ sig = LPF.ar(sig, 1000) }); // change to 3.do, 4.do, etc.
	sig = sig * 0.25;
}.play;
)



// Code Example 3.25

(
{
	var sig, cutoff, freq, randseq;
	freq = LFNoise0.kr(1).range(25, 49).round(1).midicps;
	cutoff = VarSaw.kr(6, width: 0.1).exprange(50, 10000);
	sig = Pulse.ar(freq * [0.99, 1.01]);
	sig = RLPF.ar(sig, cutoff, 0.1);
	sig = sig * 0.1;
}.play;
)



// Code Example 3.26

(
{
	var sig, exc;
	exc = Impulse.ar(1);
	sig = Ringz.ar(
		in: exc,
		freq: 800,
		decaytime: 1/3
	);
	sig = sig * 0.2 ! 2;
}.play;
)

(
{
	var sig, exc;
	exc = PinkNoise.ar(1);
	sig = Resonz.ar(
		in: exc,
		freq: 800,
		bwr: 0.001,
		mul: 1 / 0.001.sqrt
	);
	sig = sig * 0.5 ! 2;
}.play;
)



// Code Example 3.27

(
{
	var sig, exc, freqs, amps, decays;
	freqs = [ 211, 489, 849, 857, 3139, 4189, 10604, 15767 ];
	amps = [ 0.75, 0.46, 0.24, 0.17, 0.03, 0.019, 0.002, 0.001 ];
	decays = [ 3.9, 3.4, 3.3, 2.5, 2.2, 1.5, 1.3, 1.0 ];
	exc = Impulse.ar(0.5);
	sig = Klank.ar(
		`[freqs, amps, decays], // <- note the backtick character
		exc,
	);
	sig = sig * 0.25 ! 2;
}.play;
)



// Code Example 3.28

(
{
	var sig, mod;
	mod = SinOsc.kr(0.1, 3pi/2).exprange(0.2, 4);
	sig = SinOsc.ar(300, mul: mod);
	sig = Clip.ar(sig, -1, 1); // replace with Fold.ar or Wrap.ar
	sig = sig * 0.2 ! 2;
}.play;
)



// Code Example 3.29

(
{
	var sig, mod;
	mod = SinOsc.kr(0.1, 3pi/2).exprange(0.2, 4);
	sig = SinOsc.ar(300, mul: mod);
	sig = sig.softclip; // replace with 'distort' or 'tanh'
	sig = sig * 0.2 ! 2;
}.play;
)



// Code Example 3.30

(
{
	var sig, mod;
	mod = SinOsc.kr(0.2, 3pi/2).exprange(1, 15);
	sig = SinOsc.ar(300);
	sig = sig.lincurve(-1, 1, -1, 1, mod);
	sig = LeakDC.ar(sig) * 0.2 ! 2;
}.play;
)



// Code Example 3.31

(
{
	var sig, mod;
	mod = SinOsc.kr(0.2, 3pi/2).exprange(0.02, 1);
	sig = SinOsc.ar(300);
	sig = sig.round(mod) * 0.2 ! 2;
}.play;
)

(
{
	var sig, mod;
	mod = SinOsc.kr(0.2, 3pi/2).exprange(SampleRate.ir/2, SampleRate.ir/100);
	sig = SinOsc.ar(300);
	sig = Latch.ar(sig, Impulse.ar(mod));
	sig = sig * 0.2 ! 2;
}.play;
)