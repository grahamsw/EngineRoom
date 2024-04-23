// Code Example 5.1

s.boot;

(
~eventA = {SinOsc.ar(60.midicps ! 2) * Line.kr(0.1, 0, 1, 2)};
~eventB = {SinOsc.ar(70.midicps ! 2) * Line.kr(0.1, 0, 1, 2)};
~eventC = {SinOsc.ar(75.midicps ! 2) * Line.kr(0.1, 0, 1, 2)};

f = {
	~eventA.play;
	~eventB.play;
	~eventC.play;
};
)

f.();



// Code Example 5.2

(
~eventA = {SinOsc.ar(60.midicps ! 2) * Line.kr(0.1, 0, 1, 2)};
~eventB = {SinOsc.ar(70.midicps ! 2) * Line.kr(0.1, 0, 1, 2)};
~eventC = {SinOsc.ar(75.midicps ! 2) * Line.kr(0.1, 0, 1, 2)};

f = {
	~eventA.play;
	1.yield;
	~eventB.play;
	1.yield;
	~eventC.play;
	1.yield;
};

r = Routine(f);
)

r.next; // evaluate repeatedly

r.reset; // return to the beginning at any time



// Code Example 5.3

(
~noteFunc = {
	var num = 48;
	while({ num < 84 }, {
		num.yield;
		num = num + rrand(1, 4);
	});
};

~noteGen = Routine(~noteFunc);
)

~noteGen.next; // evaluate repeatedly



// Code Example 5.4

(
~eventA = {SinOsc.ar(60.midicps ! 2) * Line.kr(0.1, 0, 1, 2)};
~eventB = {SinOsc.ar(70.midicps ! 2) * Line.kr(0.1, 0, 1, 2)};
~eventC = {SinOsc.ar(75.midicps ! 2) * Line.kr(0.1, 0, 1, 2)};

f = {
	~eventA.play;
	1.yield;
	~eventB.play;
	1.yield;
	~eventC.play;
	1.yield;
};

r = Routine(f);
)

r.play;



// Code Example 5.5

(
~playTone = { |freq|
	{ SinOsc.ar(freq ! 2) * Line.kr(0.1, 0, 1, 2) }.play;
};

f = {
	3.do({
		~playTone.(72.midicps);
		0.2.yield;
		~playTone.(62.midicps);
		0.4.yield;
	});
};

r = Routine(f);
)

r.play;



// Code Example 5.6

(
~playTone = { |freq|
	{ SinOsc.ar(freq ! 2) * Line.kr(0.1, 0, 0.2, 2) }.play;
};

r = Routine({
	loop({
		~playTone.(72.midicps);
		0.4.yield;
		[62, 63, 64].do({ |n|
			~playTone.(n.midicps);
			(0.4 / 3).yield;
		});
	});
});
)

r.play;

r.stop;



// Code Example 5.7

(
~playTone = { |freq|
	{ SinOsc.ar(freq ! 2) * Line.kr(0.1, 0, 0.2, 2) }.play;
};

~sub0 = {
	2.do({
		~playTone.(67.midicps);
		0.15.yield;
		~playTone.(69.midicps);
		0.15.yield;
	});
	0.5.yield;
};

~sub1 = {
	3.do({
		~playTone.(75.midicps);
		0.5.yield;
	});
	1.yield;
};

~r_parallel = Routine({
	Routine(~sub0).play;
	Routine(~sub1).play;
});

~r_series = Routine({
	Routine(~sub0).embedInStream;
	Routine(~sub1).embedInStream;
});
)

~r_parallel.play; // subroutines execute simultaneously

~r_series.play; // subroutines play one after the other



// Code Example 5.8

(
t = TempoClock(132/60);

~playTone = { |freq|
	{ SinOsc.ar(freq ! 2) * Line.kr(0.1, 0, 1, 2) }.play;
};

r = Routine({
	[60, 70, 75].do({ |n|
		~playTone.(n.midicps);
		(1/2).yield;
	});
});
)

r.play(t);

t.tempo = 112/60;

r.reset.play(t); // now eighth notes at 112 bpm



// Code Example 5.9

(
t = TempoClock(132/60);

~playTone = { |freq|
	{ SinOsc.ar(freq!2) * Line.kr(0.1, 0, 0.2, 2) }.play;
};

~r0 = Routine({
	loop({
		[60, 63, 65, 67].do({ |n|
			~playTone.(n.midicps);
			(1/2).yield;
		});
	});
});

~r1 = Routine({
	loop({
		[70, 72, 75, 77].do({ |n|
			~playTone.(n.midicps);
			(1/2).yield;
		});
	});
});
)

~r0.play(t, quant: 4); // begin playing on next beat multiple of four

~r1.play(t, quant: 4); // will be beat-aligned with ~r0



// Code Example 5.10

// These two lines rely on the code in Code Example 5.9 and are meant to be substituted for the last two lines in that example.

~r0.reset.play(t, quant: [4, 0]); // plays on the next beat multiple of four

~r1.reset.play(t, quant: [4, 1]); // plays one beat after the next beat multiple of four



// Code Example 5.11

t = TempoClock(132/60).permanent_(true);

// press [cmd]+[period]...

t.beats; // the clock remains

t.permanent = false;

// press [cmd]+[period]...

t.beats; // the clock is destroyed



// Code Example 5.12

(
~pat = Pseries(start: 50, step: 7, length: 6);
~seq = ~pat.asStream;
)

~seq.next; // evaluate repeatedly



// Code Example 5.13

(
~pat = {
	var num = 50, inc = 7, count = 0;
	while({ count < 6 }, {
		num.yield;
		num = num + inc;
		count = count + 1;
	});
};

~seq = Routine(~pat);
)

~seq.next; // evaluate repeatedly



// Code Example 5.14

(
~pat = Pwhite(lo: 48, hi: 72, length: 10);
~seq = ~pat.asStream;
)

~seq.nextN(4); // evaluate repeatedly

~seq.reset;

~seq.all;



// Code Example 5.15

(
~pat = Prand(list: [4, 12, 17], repeats: inf);
~seq = ~pat.asStream;
)

~seq.next; // an inexhaustible supply



// Code Example 5.16

(
~pat = Pwhite(0.0, 1.0, inf) * Pseq([-1, 1], inf);
~seq = ~pat.asStream.nextN(8);
)



// Code Example 5.17

(
~pat = Pseq([
	Pwhite(-1.0, 0.0, 1),
	Pwhite(0.0, 1.0, 1)
], inf);
~seq = ~pat.asStream.nextN(10);
)



// Code Example 5.18

(
SynthDef(\bpf_brown, {
	arg atk = 0.02, rel = 2, freq = 800,
	rq = 0.005, pan = 0, amp = 1, out = 0;
	var sig, env;
	env = Env([0, 1, 0], [atk, rel], [1, -2]).kr(2);
	sig = BrownNoise.ar(0.8);
	sig = BPF.ar(sig, freq, rq, 1 / rq.sqrt);
	sig = Pan2.ar(sig, pan, amp) * env;
	Out.ar(out, sig);
}).add;
)

(instrument: \bpf_brown, freq: 500, atk: 2, rel: 4, amp: 0.6).play;

SynthDescLib.global.browse

// Code Example 5.19

(degree: 0).play;
(degree: 1).play; // modal transposition by scale degree

(note: 0).play;
(note: 2).play; // chromatic transposition by semitones

(midinote: 60).play;
(midinote: 62).play; // MIDI note numbers

(freq: 261.626).play;
(freq: 293.665).play; // Hertz



// Code Example 5.20

(
SynthDef(\bpf_brown, {
	arg atk = 0.02, rel = 2, gate = 1, freq = 800,
	rq = 0.005, pan = 0, amp = 1, out = 0;
	var sig, env;
	env = Env.asr(atk, 1, rel).kr(2, gate);
	sig = BrownNoise.ar(0.8);
	sig = BPF.ar(sig, freq, rq, 1 / rq.sqrt);
	sig = Pan2.ar(sig, pan, amp) * env;
	Out.ar(out, sig);
}).add;
)

x = Synth(\bpf_brown, [freq: 500, amp: 0.2]);

x.set(\gate, 0); // manual gate closure

(instrument: \bpf_brown, freq: 500, amp: 0.2).play; // automatic gate closure



// Code Example 5.21

(
Event.partialEvents.keys.do({ |n|
	n.postln;
	Event.partialEvents[n].keys.postln;
	\.postln;
});\
)



// Code Example 5.22

(
p = Pbind(
	\midinote, Pseq([55, 57, 60], 2),
	\db, Pwhite(-20.0, -10.0, 6),
	\pan, Prand([-0.5, 0, 0.5], 6)
);
)

~seq = p.asStream;

~seq.next(()).play; // evaluate repeatedly, returns nil when finished

~seq.reset; // can be reset at any time



// Code Example 5.23

(
p = Pbind(
	\midinote, Pseq([55, 57, 60], 2),
	\db, Pwhite(-20.0, -10.0, 6),
	\pan, Prand([-0.5, 0, 0.5], 6)
);

~seq = p.play;
)



// Code Example 5.24

(
p = Pbind(
	\dur, Pseq([0.75, 0.25, 0.75, 0.25, 0.5, 0.5], 1),
	\midinote, Pseq([55, 57, 60], 2),
	\db, Pwhite(-20.0, -10.0, 6),
	\pan, Prand([-0.5, 0, 0.5], 6)
);

~seq = p.play;
)



// Code Example 5.25

(
p = Pbind(
	\dur, Pseq([0.75, 0.25, 0.75, 0.25, 0.5, 0.5], inf),
	\midinote, Pseq([55, 57, 60], 8),
	\db, -15
);

~seq = p.play;
)

~seq.stop;

~seq.resume;



// Code Example 5.26

(
p = Pbind(
	\dur, 0.2,
	\midinote, rrand(50, 90), // <- should use Pwhite(50, 90) instead
);

~seq = p.play;
)



// Code Example 5.27

(
t = TempoClock(90/60);

p = Pbind(
	\dur, 0.25,
	\midinote, Pwhite(48, 60, inf),
);

q = Pbind(
	\dur, 0.25,
	\midinote, Pwhite(72, 84, inf),
);
)

~seq_p = p.play(t, quant:4); // scheduled on next beat multiple of 4

~seq_q = q.play(t, quant:4); // synchronizes with ~seq_p



// Code Example 5.28

t = TempoClock.new(112/60);

(
Pbind(
	\dur, Pseq([1/2, 1/2, 1/2, 1/4, 1/2, 1/2, 1/2], 1),
	\sustain, 0.1,
	\degree, Pseq([4, 5, 7, 4, 5, 7, 8], 1),
).play(t);
)



// Code Example 5.29

t = TempoClock.new(112/60);

(
Pbind(
	\dur, Pseq([
		Pseq([ Rest(1/4), 1/4 ], 4), // bar 1
		Pseq([ 1/4, Rest(1/4), 1/4, Rest(1/4), 1/4, Rest(3/4) ]) // bar 2
	], 1),
	\sustain, 0.1,
	\degree, Pseq([
		0, 4, 0, 5, 0, 7, 0, 4, // bar 1
		5, 0, 7, 0, 8, 0, 0, 0  // bar 2
	], 1),
).play(t);
)



// Code Example 5.30

t = TempoClock.new(112/60);

(
Pbind(
	\type, Pseq([
		Pseq([\rest, \note], 4), // bar 1
		Pseq([\note, \rest], 2), \note, Pseq([\rest], 3) // bar 2
	], 1),
	\dur, 1/4,
	\sustain, 0.1,
	\degree, Pseq([
		0, 4, 0, 5, 0, 7, 0, 4, // bar 1
		5, 0, 7, 0, 8, 0, 0, 0  // bar 2
	], 1),
).play(t);
)



// Code Example 5.31

t = TempoClock.new(112/60);

(
Pbind(
	\dur, 1/4,
	\sustain, 0.1,
	\degree, Pseq([
		\, 4, \, 5, \, 7, \, 4, // bar 1
		5, \, 7, \, 8, \, \, \  // bar 2
	], 1),
).play(t);
)



// Code Example 5.32

(
p = Pbind(
	\dur, 1/8,
	\sustain, 0.02,
	\freq, Pexprand(200, 4000, inf),
);

q = Pfin(16, p);

~seq = q.play; // stops after 16 events
)



// Code Example 5.33

(
p = Pbind(
	\dur, 1/8,
	\sustain, 0.02,
	\freq, Pexprand(200, 4000, inf),
);

q = Pfindur(3, p);

~seq = q.play; // stops after 3 beats
)



// Code Example 5.34

(
~p0 = Pbind(
	\dur, 1/6,
	\degree, Pseq([0, 2, 3, 5], 1),
	\sustain, 0.02,
);

~p1 = Pbind(
	\dur, 1/6,
	\degree, Pseq([2, 4, 5, 7], 1),
	\sustain, 0.02,
);
)



// Code Example 5.35

(
~p_seq = Pseq([~p0, ~p1], 2);
~player = ~p_seq.play;
)



// Code Example 5.36

(
~p_par = Ppar([ ~p0, ~p1 ], 3);
~seq = ~p_par.play;
)



// Code Example 5.37

(
p = Ptpar([
	0, Pseq([~p1], 3),
	1/12, Pseq([~p0], 3)
], 1);

~seq = p.play;
)



// Code Example 5.38

// Note – this is a non-functional pseudo-code example.

ThingDef(\name, data); // create proxy and provide initial data
ThingDef(\name, newData); // overwrite proxy with new data
ThingDef(\name); // reference current proxy data



// Code Example 5.39

(
p = Pbind(
	\dur, 0.2,
	\sustain, 0.02,
	\degree, Pdefn(\deg0, Pwhite(-4, 8, inf)),
);

~seq = p.play;
)

Pdefn(\deg0, Pseq([0, 2, 3], inf));



// Code Example 5.40

(
p = Pbind(
	\dur, 0.2,
	\sustain, 0.02,
	\degree, Pwhite(-4, 8, inf),
	\db, Pdefn(\db0, -20),
);

~seq = p.play;
)

Pdefn(\db0, Pseries(-20, -1, 40));



// Code Example 5.41

(
Pdefn(\deg0, Pseq([0, 4, 1, 5], inf));

p = Pbind(
	\dur, 0.2,
	\sustain, 0.02,
	\degree, Pdefn(\deg0),
);

q = Pbind(
	\dur, 0.2,
	\sustain, 0.02,
	\degree, Pdefn(\deg0) + 2,
);

~seq = Ppar([p, q]).play;
)

Pdefn(\deg0, Pseq([-3, -2, 0],inf));



// Code Example 5.42

(
t = TempoClock(128/60);

p = Pbind(
	\dur, 1/4,
	\sustain, 0.02,
	\note, Pdefn(\note0, Pseq([0, \, \, \, 1, 2, 3, 4], inf)),
);

~seq = p.play(t, quant: 4);
)

(
Pdefn(\note0,
	Pseq([7, \, 4, \, 1, \,  \, \], inf)
).quant_(4);
)



// Code Example 5.43

Pdefn(\note0).source; // -> a Pseq
Pdefn(\note0).source.postcs; // -> full Pseq code
Pdefn(\note0).clear; // erase Pdefn data
Pdefn(\note0).source; // -> nil
Pdefn.all.do({ |n| n.clear });



// Code Example 5.44

(
t = TempoClock(128/60);

Pdef(\seq,
	Pbind(
		\dur, 0.25,
		\sustain, 0.02,
		\degree, Pseq([0, 2, 4, 5], inf),
	)
).clock_(t).quant_(4);

Pdef(\seq).play;
)

(
Pdef(\seq, // swap the old Pbind for a new one
	Pbind(
		\dur, Pseq([0.5, 0.25, 0.25, 0.5, 0.5], inf),
		\sustain, 0.5,
		\degree, Pxrand([-4, -2, 0, 2, 3], inf),
	)
);
)



// Code Example 5.45

(
Pbindef(\seqA,
	\dur, Pexprand(0.05, 2, inf),
	\degree, Prand([0, 1, 2, 4, 5], inf),
	\mtranspose, Prand([-7, 0, 7], inf),
	\sustain, 4,
	\amp, Pexprand(0.02, 0.1, inf),
).play;
)

// change degree pattern:
Pbindef(\seqA, \degree, Prand([0, 1, 3.1, 4.1, 5], inf));

// change dur and sustain pattern in one expression:
Pbindef(\seqA, \dur, 0.3, \sustain, Pseq([2, 0.02], inf));

// add a new value pattern:
Pbindef(\seqA, \pan, Pwhite(-0.8, 0.8, inf));

// fade out with finite amp pattern:
Pbindef(\seqA, \amp, Pgeom(0.05, 0.85, 30));



// Code Example 5.46

(
Pbindef(\seqB,
	\dur, 0.2,
	\sustain, 0.02,
	\freq, Pexprand(500, 1200, inf)
).play;
)

// degree values are ignored:
Pbindef(\seqB, \degree, Pwhite(0, 7, inf));

// degree values take effect:
Pbindef(\seqB, \freq, nil, \degree, Pwhite(0, 7, inf));