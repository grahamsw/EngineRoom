// Code Example 10.1

// Numerous code examples throughout this chapter rely on the two SynthDefs that appear here.

s.boot;

(
SynthDef(\sine, {
	arg atk = 1, rel = 4, gate = 1,
	freq = 300, freqLag = 1, amp = 0.1, out = 0;
	var sig, env;
	env = Env.asr(atk, 1, rel).kr(2, gate);
	sig = SinOsc.ar(freq.lag(freqLag) + [0, 2]);
	sig = sig * amp * env;
	Out.ar(out, sig);
}).add;

SynthDef(\noise, {
	arg atk = 1, rel = 4, gate = 1,
	freq = 300, amp = 0.2, out = 0;
	var sig, env;
	env = Env.asr(atk, 1, rel).kr(2, gate);
	sig = BPF.ar(PinkNoise.ar(1 ! 2), freq, 0.02, 7);
	sig = sig * amp * env;
	Out.ar(out, sig);
}).add;
)

(
// event 0: create sine synth
~sine0 = Synth(\sine, [freq: 60.midicps, amp: 0.05]);
)

(
// event 1: create two noise synths
~noise0 = Synth(\noise, [freq: 75.midicps, amp: 0.15]);
~noise1 = Synth(\noise, [freq: 53.midicps, amp: 0.3]);
)

(
// event 2: modify frequencies of noise synths
~noise0.set(\freq, 77.midicps);
~noise1.set(\freq, 56.midicps);
)

(
// event 3: modify frequency of sine synth
~sine0.set(\freq, 59.midicps);
)

(
// event 4: fade all synths
[~sine0, ~noise0, ~noise1].do({ |n| n.set(\gate, 0) });
)



// Code Example 10.2

(
SynthDef(\simple, {
	arg atk = 0.2, rel = 1, gate = 1,
	freq = 300, freqLag = 1, amp = 0.1, out = 0;
	var sig, env;
	env = Env.linen(atk, 1, rel).kr(2);
	sig = SinOsc.ar(freq.lag(freqLag) + [0, 2]) * amp * env;
	Out.ar(out, sig);
}).add;
)

Synth(\simple, [freq: 330, amp: 0.05]); // event 0

Synth(\simple, [freq: 290, amp: 0.05]); // event 1



// Code Example 10.3

(
~events = [
	Synth(\simple, [freq: 330, amp: 0.05]),
	Synth(\simple, [freq: 290, amp: 0.05])
];
)

~events[0]; // returns the Synth, but no sound is produced



// Code Example 10.4

(
~events = [
	{ Synth(\simple, [freq: 330, amp: 0.05]) },
	{ Synth(\simple, [freq: 290, amp: 0.05]) }
];
)

~events[0].(); // play 0th event

~events[1].(); // play 1st event



// Code Example 10.5

(
~index = 0;
~events = [
	{ Synth(\simple, [freq: 330, amp: 0.05]) },
	{ Synth(\simple, [freq: 290, amp: 0.05]) },
	{ Synth(\simple, [freq: 420, amp: 0.05]) },
	{ Synth(\simple, [freq: 400, amp: 0.05]) }
];

~nextEvent = {
	~events[~index].();
	~index = ~index + 1;
};
)

~nextEvent.(); // evaluate repeatedly

~index = 0; // reset to beginning



// Code Example 10.6

(
~index = 0;
~events = [
	[ { Synth(\simple, [freq: 330, amp: 0.05]) }, 2 ],
	[ { Synth(\simple, [freq: 290, amp: 0.05]) }, 0.5 ],
	[ { Synth(\simple, [freq: 420, amp: 0.05]) }, 0.25 ],
	[ { Synth(\simple, [freq: 400, amp: 0.05]) }, 0 ],
];

~seq = Routine({
	~events.do({
		~events[~index][0].();
		~events[~index][1].wait;
		~index = ~index + 1;
	});
});
)

~seq.play;



// Code Example 10.7

(
~events = Dictionary()
.add(\play330sine -> { Synth(\simple, [freq: 330, amp: 0.05]) })
.add(\play290sine -> { Synth(\simple, [freq: 290, amp: 0.05]) });
)

~events[\play330sine].();

~events[\play290sine].();



// Code Example 10.8

(
~events = Pseq([
	{
		~sine0 = Synth(\sine, [freq: 60.midicps, amp: 0.05])
	},
	{
		~noise0 = Synth(\noise, [freq: 75.midicps, amp: 0.15]);
		~noise1 = Synth(\noise, [freq: 53.midicps, amp: 0.3]);
	},
	{
		~noise0.set(\freq, 77.midicps);
		~noise1.set(\freq, 56.midicps);
	},
	{
		~sine0.set(\freq, 59.midicps);
	},
	{
		[~sine0, ~noise0, ~noise1].do({ |n| n.set(\gate, 0) });
	}
], 1).asStream;
)

~events.next.(); // evaluate repeatedly;

~events.reset; // reset to beginning



// Code Example 10.9

(
~events.reset;
1.do({ ~events.next }); // retrieve the first event but do not evaluate
)

~events.next.(); // retrieve and evaluate the next event



// Code Example 10.10

(
~startAt = Dictionary()
.add(\event1 -> {
	~events.reset;
	1.do({ ~events.next });
	~sine0 = Synth(\sine, [freq: 60.midicps, amp: 0.05]);
})
.add(\event2 -> {
	~events.reset;
	2.do({ ~events.next });
	~sine0 = Synth(\sine, [freq: 60.midicps, amp: 0.05]);
	~noise0 = Synth(\noise, [freq: 75.midicps, amp: 0.15]);
	~noise1 = Synth(\noise, [freq: 53.midicps, amp: 0.3]);
})
.add(\event3 -> {
	~events.reset;
	3.do({ ~events.next });
	~sine0 = Synth(\sine, [freq: 60.midicps, amp: 0.05]);
	~noise0 = Synth(\noise, [freq: 77.midicps, amp: 0.15]);
	~noise1 = Synth(\noise, [freq: 56.midicps, amp: 0.3]);
})
.add(\event4 -> {
	~events.reset;
	4.do({ ~events.next });
	~sine0 = Synth(\sine, [freq: 59.midicps, amp: 0.05]);
	~noise0 = Synth(\noise, [freq: 77.midicps, amp: 0.15]);
	~noise1 = Synth(\noise, [freq: 56.midicps, amp: 0.3]);
});
)

~events.reset;

~events.next.(); // evaluate repeatedly

// press [cmd]+[period], then cue an event
~startAt[\event3].value;

~events.next.(); // play the new "next" event



// Code Example 10.11

(
var scl = [0, 3, 5, 7, 9, 10];
var oct = [72, 72, 84, 84, 84, 96];
var notes = oct.collect({ |n|  n + scl.choose });
~synths = ([60] ++ notes).collect({ |n|
	// MIDI note 60 is prepended to avoid randomizing the bass note
	Synth(\noise, [freq: n.midicps, amp: 0.15]);
});
)

~synths.do({ |n| n.set(\gate, 0) });



// Code Example 10.12

(
Pfin(
	exprand(3, 15).round, // creates between 3–15 synths
	Pbind(
		\instrument, \sine,
		\dur, 0.07,
		\scale, [0, 3, 5, 7, 9, 10],
		\degree, Pbrown(10, 20, 3),
		\sustain, 0.01,
		\atk, 0.002,
		\rel, 0.8,
		\amp, 0.03
	)
).play;
)



// Code Example 10.13

(
~events = Pseq([
	{
		// create cluster chord
		var scl = [0, 3, 5, 7, 9, 10];
		var oct = [72, 72, 84, 84, 84, 96];
		var notes = oct.collect({ |n|  n + scl.choose });
		~synths = ([60] ++ notes).collect({ |n|
			Synth(\noise, [freq: n.midicps, amp: 0.15]);
		});
	},

	// repeat a pattern a random number of times
	Pseq([
		{
			Pfin(
				exprand(3, 15).round,
				Pbind(
					\instrument, \sine,
					\dur, 0.07,
					\degree, Pbrown(10, 20, 3),
					\scale, [0, 3, 5, 7, 9, 10],
					\sustain, 0.01,
					\atk, 0.002,
					\rel, 0.8,
					\amp, 0.03
				)
			).play;
		}
	], { rrand(3, 5) }), // <- produces 3, 4, or 5 tone burst events

	// fade cluster chord
	{ ~synths.do({ |n| n.set(\gate, 0) }) }
], 1).asStream;
)

~events.next.();

~events.reset;



// Code Example 10.14

(
~events = Pseq([
	Pshuf([
		{
			var scl = [0, 3, 5, 7, 9, 10];
			var oct = [72, 72, 84, 84, 84, 96];
			var notes = oct.collect({ |n|  n + scl.choose });
			~synths = ([60] ++ notes).collect({ |n|
				Synth(\noise, [freq: n.midicps, amp: 0.15]);
			});
		},

		Pseq([
			{
				Pfin(
					exprand(3, 15).round,
					Pbind(
						\instrument, \sine,
						\dur, 0.07,
						\degree, Pbrown(10, 20, 3),
						\scale, [0, 3, 5, 7, 9, 10],
						\sustain, 0.01,
						\atk, 0.002,
						\rel, 0.8,
						\amp, 0.03
					)
				).play;
			}
		], { rrand(3, 5) })
	], 1),

	{ ~synths.do({ |n| n.set(\gate, 0) }) }
], 1).asStream;
)

~events.next.();

~events.reset;