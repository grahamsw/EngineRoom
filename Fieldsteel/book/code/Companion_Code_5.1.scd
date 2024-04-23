// Companion Code 5.1
// Routine and TempoClock

// This Companion Code file incorporates SynthDefs and provides additional examples of using Routine and TempoClock in a musical context, aimed at reinforcing a conceptual understanding of basic sequencing. We begin by booting the server and loading two versions of an FM SynthDef featured in Companion Code 3.4, one with a percussive amplitude envelope, and another with a sustaining envelope:

s.boot;

(
SynthDef(\fm, {
	arg freq = 250, ratio = 1, index = 1, atk = 0.001,
	rel = 1, crv = -4, amp = 0.2, out = 0;
	var sig, mod, env;
	env = Env.perc(atk, rel, 1, [1, crv]).ar(2);
	mod = SinOsc.ar(freq * ratio, mul: freq * ratio * index);
	sig = SinOsc.ar(freq + mod);
	sig = sig * env * amp ! 2;
	Out.ar(out, sig);
}).add;

SynthDef(\fmsus, {
	arg freq = 250, ratio = 1, index = 1, gate = 1,
	atk = 0.001, rel = 1, crv = -4, amp = 0.2, out = 0;
	var sig, mod, env;
	env = Env.asr(atk, 1, rel, [1, crv]).ar(2, gate);
	mod = SinOsc.ar(freq * ratio, mul: freq * ratio * index);
	sig = SinOsc.ar(freq + mod);
	sig = sig * env * amp ! 2;
	Out.ar(out, sig);
}).add;
)

Synth(\fm);

x = Synth(\fmsus);
x.set(\gate, 0);

// We'll create a few subroutines, each representing an individual musical layer, and build a composite routine to perform a simple musical example. First, a routine that yields an infinite, repeating sequence of MIDI note numbers to be used for a melodic phrase:

(
~mel_notes_fn = {
	loop({
		[60, 72, 65, 67, 70, 65, 67].do({ |n| n.yield });
	});
};

~mel_notes = Routine(~mel_notes_fn);
)

// Next, a routine that resets the ~mel_notes routine, and then iterates over a sequence of beat durations. In the iteration block, it extracts the next note from the previous routine, feeds it to a new percussive FM Synth, and finally, waits for the specified duration:

(
~mel_fn = {
	~mel_notes.reset;
	[1/2, 1/2, 1/4, 1/2, 1/2, 1/4, 1/2].do({ |d|
		Synth(\fm, [
			\freq, ~mel_notes.next.midicps,
			\rel, 0.5,
			\ratio, 2.015,
		]);
		d.yield;
	});
};

~mel = Routine(~mel_fn);
)

// We'll create a permanent TempoClock operating at 90 beats per minute:

t = TempoClock(90/60).permanent_(true);

// We can perform this sequence using the following code, which schedules '~mel' on TempoClock 't' on the next beat multiple of 3. The 'reset' calls are unnecessary but harmless if the routines have not yet been evaluated, but they facilitate the process of restarting the sequence after the '~mel' sequence has been played:

~mel.reset.play(t, 3);

// Next, a routine that repeatedly produces a pair of sustained drones, and releases their envelopes after a random number of beats. Though the duration of the sustain is random, the yield values are calculated so that one full performance of this routine occupies exactly 12 beats.

// In this case, it's wise to use a local variable for the Synth, so that multiple instances of this routine can run without conflicts. If a global variable were used (e.g. ~drone_synth), then multiple instances of this routine would use the same named container for different Synths, creating stuck notes and envelope release messages that have no valid recipient.

// Note that the drone frequency is selected outside the iteration block, guaranteeing that both Synths have the same random frequency. The FM ratio and index, on the other hand, are selected *inside* the iteration block, inviting the possibility for the pair of drones to have different ratios and indices.

(
~drone_fn = {
	var drone_synth, wait_time, freq;
	freq = [31, 34, 36, 39].choose.midicps;
	wait_time = [3, 6, 9].choose;

	drone_synth = 2.collect({
		Synth(\fmsus, [
			\freq, freq,
			\atk, 3,
			\rel, 3,
			\amp, 0.05,
			\ratio, [2, 3, 4, 5].choose + rrand(0.99, 1.01),
			\index, exprand(3.0, 8.0),
		]);
	});
	wait_time.yield;
	drone_synth.do({ |synth| synth.set(\gate, 0) });
	(12 - wait_time).yield;
};

~drone = Routine(~drone_fn);
)

~drone.reset.play(t, 3);

// Before we create a composite routine that sequences these subroutines, an important point of clarification: the beginning of Chapter 5 emphasized the importance of making a distinction between processes that define sequences, and processes that perform sequences. In the code above, the functions (~drone_fn, ~mel_fn) are the processes that define sequences, and the routines (~drone, ~mel) are the processes that perform the sequences.

// With this in mind, we can observe that it's clumsy to repeatedly 'reset' a singular routine over and over again, if we wish to perform it multiple times in a row. For example, notice how the following block of code works fine:

(
~player = Routine({
	~drone.reset.play(t, 3);
});

~player.play(t, 3);
)

// But an attempt to create two drone routines in parallel fails silently:

(
~player = Routine({
	2.do({ ~drone.reset.play(t, 3) });
});

~player.play(t, 3);
)

// The essential problem is that we are telling one routine to "reset and play" itself twice in rapid succession, resulting in some internal messaging confusion. What we actually want is to create two separate, independent routines which perform the ~drone_fn sequence. Thus, a better approach is to create these routines on-the-fly within the outer routine:

(
~player = Routine({
	2.do({ Routine(~drone_fn).play(t, 3) })
});

~player.play(t, 3);
)

// An infinite number of routines can be spawned from one function, just as an infinite number of performances can be spawned from one musical score. Instead of creating one routine and awkwardly attempting to rewind it over and over again, a superior approach is to dynamically create and play new routines as needed.

// On a similar note, we should also modify the ~mel_fn function so that it does not reset one specific instance of the ~mel_notes routine, but instead, dynamically creates a new routine from ~mel_notes_fn each time it is called. This avoids the problem of having to 'reset' ~mel_notes whenever ~mel is played.

(
~mel_fn = {
	var mel_notes;
	mel_notes = Routine(~mel_notes_fn);
	[1/2, 1/2, 1/4, 1/2, 1/2, 1/4, 1/2].do({ |d|
		Synth(\fm, [
			\freq, mel_notes.next.midicps,
			\rel, 0.5,
			\ratio, 2.015,
		]);
		d.yield;
	});
};

Routine(~mel_fn).play(t, 3);
)

// The following code concisely encompasses all previous functions and routines, and sequences them together into a short demonstration. Several 'postln' calls are included to help visualize the progression through the parent routine:

(
~mel_notes_fn = {
	loop({
		[60, 72, 65, 67, 70, 65, 67].do({ |n| n.yield; });
	});
};

~mel_fn = {
	var mel_notes;
	mel_notes = Routine(~mel_notes_fn);
	[1/2, 1/2, 1/4, 1/2, 1/2, 1/4, 1/2].do({ |d|
		Synth(\fm, [
			\freq, mel_notes.next.midicps,
			\rel, 0.5,
			\ratio, 2.015,
		]);
		d.yield;
	});
};

~drone_fn = {
	var drone_synth, wait_time, freq;
	freq = [31, 34, 36, 39].choose.midicps;
	wait_time = [3, 6, 9].choose;

	drone_synth = 2.collect({
		Synth(\fmsus, [
			\freq, freq,
			\atk, 3,
			\rel, 3,
			\amp, 0.05,
			\ratio, [2, 3, 4, 5].choose + rrand(0.99, 1.01),
			\index, exprand(3.0, 8.0),
		]);
	});
	wait_time.yield;
	drone_synth.do({ |synth| synth.set(\gate, 0); });
	(12 - wait_time).yield;
};

~player_fn = {

	"section 0".postln;	// two melody iterations

	2.do({ Routine(~mel_fn).embedInStream });

	"section 1".postln;	// two iterations of one drone played
						// in parallel with four melody iterations
	2.do({
		Routine({
			Routine(~drone_fn).play(t);
			4.do({ Routine(~mel_fn).embedInStream });
		}).embedInStream;
	});

	"section 2".postln;	// twelve drones play in overlapping fashion
						// (staggered by two beats each) while four
						// melody iterations play in parallel, each
						// separated by 3 beats of rest
	Routine({
		12.do({
			Routine(~drone_fn).play(t);
			2.yield;
		})
	}).play(t);

	Routine({
		4.do({
			Routine(~mel_fn).embedInStream;
			3.yield;
		});
	}).embedInStream;

	9.yield;			// a nine-beat rest precedes the final section

	"section 3".postln;	// one final drone

	Routine(~drone_fn).embedInStream;

};

Routine(~player_fn).play(t, 3);
)

// Note that although it's necessary to play internal subroutines on the appropriate clock to ensure correct beat durations, it's not necessary to specify quantization values for internal subroutines, because the relative timing is already handled through 'yield' and 'embedInStream'.

// We'll now take a step back from this large example, and focus on a few useful aspects of TempoClock. We already know we can change the tempo of a TempoClock using the 'tempo' method:

(
t.tempo = 130/60;
Routine(~mel_fn).play(t);
)

(
t.tempo = 70/60;
Routine(~mel_fn).play(t);
)

// But is it possible to create a "smooth" tempo change from one tempo to another? The answer is yes, and it involves...creating and playing a routine!

// In the code below, we define a function that iterates over a collection of tempo values, and uses each one to set a new tempo. We wait for a quarter of a beat at each new tempo. The array represents a transition from 60 to 120 bpm, divided into 48 values spanning this distance in equal amounts. Thus, the tempo transition occupies four bars (if we're thinking of our music in a 3/4 time signature, each bar contains 12 sixteenth notes):

(
t.tempo = 60/60;

~change_tempo_fn = {
	Array.interpolation(48, 60, 120).do({ |bpm|
		t.tempo = (bpm/60);
		(1/4).wait;
	});
};
)

// A simple demonstration follows, relying on functions created earlier in this file. We play a routine that generates four sequential iterations of the melody. At the same time, we also create and play our tempo-changing routine.

(
~player = Routine({
	4.do({ Routine(~mel_fn).embedInStream });
});

~player.play(t, 3);

Routine(~change_tempo_fn).play(t, 3);
)

// Technically, this is not a truly "smooth" tempo change; it is a sequence of discrete changes that occur on sixteenth beats. However, the perceptual difference between this and a continuous tempo change is too small for the ear to notice.

// To conclude, we'll use TempoClock to create a simple visual metronome that posts beat information in the post window. Although we've already experienced the usefulness of TempoClock, the fact that TempoClock operates invisibly can be frustrating, and a visual component can help us understand some of its features, such as quantization.

// Functions can be directly scheduled on TempoClock without the use of routines, using TempoClock's scheduling methods, 'sched' or 'schedAbs'. 'sched' schedules a function to be evaluated some number of beats in the future, relative to when the scheduling code is executed, and 'schedAbs' schedules a function to be evaluated at a specific beat in the future, regardless of when the scheduling code is evaluated.

t.sched(4, { "hello!".postln }); // "hello!" appears four beats later

// When using 'schedAbs', it can be useful to know the current beat, to avoid scheduling on a beat that has already occured. As we've already seen, the current beat can be obtained with the 'beats' method:

t.beats; // evaluate repeatedly

// It's also possible to obtain the current bar, a value corresponding to the number of "downbeats" that have occurred:

t.bar; // evaluate repeatedly

// By default, a new TempoClock has four beats per bar:

t.beatsPerBar;

// The 'nextBar' method gives the beat value of the next downbeat:

t.nextBar; // evaluate repeatedly

// Our musical example from earlier was composed in a 3/4 time signature, which means there are three beats per bar. We cannot change the TempoClock's number of beats per bar like this:

t.beatsPerBar = 3;

// This change can only be made within the scheduling thread established by the TempoClock. The correct approach is to use 'schedAbs' to schedule a time signature change on the next downbeat (much in the same way that it generally does not make sense to alter the time signature of notated music in the middle of a measure):

t.schedAbs(t.nextBar, { t.beatsPerBar = 3 });

// Now, 'nextBar' returns the beat number of the next bar, using the implied musical grid of a 3/4 time signature. These downbeats may or may not be multiples of three; if the time signature change occurred on a multiple of 12 (the least common multiple of 3 and 4), then the new downbeat values will coincide with multiples of three. If the time signature change happened to occur on a multiple of 4 that is not a multiple of 3, the new downbeat values will not be multiples of three. However, whether the downbeats are multiple of the number of beats per bar is not significant; a TempoClock is perfectly capable of keeping track of beats and bars in either case.

t.nextBar;

// If a function scheduled on TempoClock returns a number, that function is automatically rescheduled that many beats in the future, resulting in an infinite chain of reschedulings. In this case, it's appropriate to give the function a global variable name, so that it can be redefined in real-time, for example, to return a non-number, thus canceling the rescheduling process:

(
~sayhello = {
	"hello!".postln;
	1;
};

t.schedAbs(t.nextBar, { ~sayhello.() });
)

// Redefining the function as an empty function, or one that returns nil, has the effect of unscheduling this repeated task from the clock, because the function no longer returns a number.

~sayhello = { };

// With these features in mind, we can now create a simple visual metronome tool:

(
~postInfo = {
	("current beat: " ++ t.beats).postln;
	("current bar: " ++ t.bar).postln;
	"".postln; // empty line for readability
	1; // rescheduled on every beat
};

t.schedAbs(t.nextBar, { ~postInfo.() });
)

~postInfo = { }; // <- "turn off" the metronome
	