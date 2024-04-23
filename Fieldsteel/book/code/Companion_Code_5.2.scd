// Companion Code 5.2
// Pbind

// To demonstrate Pbind's features in more detail, we'll begin by building a SynthDef of our own, which generates a two-channel sawtooth wave with a frequency offset applied to the second channel. The sawtooth is passed through a resonant low-pass filter, and an ADSR envelope controls the overall amplitude. To establish consistency with the design of the Event paradigm, the arguments 'amp', 'freq', and 'gate' have been specifically declared and implemented to perform their typical tasks.

s.boot;

(
SynthDef(\filtsaw, {
	arg amp = 0.2, freq = 300, offset = 2,
	gate = 1, atk = 0.01, dec = 0.1, slev = 0.3, rel = 1,
	lpf = 20000, rq = 1, out = 0;
	var sig, env;
	env = Env.adsr(atk, dec, slev, rel).kr(2, gate);
	sig = Saw.ar(freq + [0, offset]);
	sig = RLPF.ar(sig, lpf, rq);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

// The default Synth sounds like this:

x = Synth(\filtsaw);

x.set(\gate, 0);

// As we've seen, using Events to create Synths is perhaps a bit more sophisticated than explicitly creating Synths. In particular, the default note Event contains a 'sustain' key, whose value determines the number of beats to wait before automatically sending a set(\gate, 0) message, which relieves us of the burden of sending this message ourselves:

(instrument: \filtsaw).play; // default sustain = 0.8 beats

(instrument: \filtsaw, sustain: 2).play; // custom sustain value

// Before diving into creative examples, it will be helpful to have a more substantive discussion about the structure of the Event paradigm and some of the consequences of its design.

// The pre-defined keys that exist within the default Event framework ('sustain', 'amp', 'freq', 'gate', etc.), their purposes, how they interact with SynthDef arguments, and the unexpected results they sometimes create, can be a common source of confusion. Indeed, the "soft" requirement of declaring specifically-named arguments to take advantage of Event features suggests the possibility of other hidden "rules."

// In almost all cases, the user can name SynthDef arguments as they please, and will not encounter any surprises when playing Pbinds, but conflicts occasionally arise. The following examples and guidelines aim to provide clarity on how and why these conflicts arise, and suggestions on how to avoid them:

// First, as mentioned in the book (Code Examples 5.21), a list of named keys that exist in the default Event mechanisms can be neatly printed in the post window using the following code:

(
Event.partialEvents.keys.do({ |n|
	n.postln;
	Event.partialEvents[n].keys.postln;
	\.postln;
});\
)

// Note that this list includes some keys we have already discussed, including 'amp,' 'freq,' 'gate,' and 'sustain,' along with numerous others. One of these additional keys is 'detune', which has a default value of 0.0:

Event.partialEvents.pitchEvent[\detune];

// 'detune' is internally added to the value of the 'freq' key in the context of a note Event:

Event.partialEvents.pitchEvent[\detunedFreq].postcs;\

// This being the case, it would be inadvisable to name our frequency-shifting argument 'detune', if we intend to use Events. To explain why, we temporarily rename 'offset' as 'detune', and also poll the frequency values using a trigger value of zero, so that the values appear exactly once in the post window:

(
SynthDef(\filtsaw, {
	arg amp = 0.2, freq = 300, detune = 2, // 'offset' changed to 'detune'
	gate = 1, atk = 0.01, dec = 0.1, slev = 0.3, rel = 1,
	lpf = 20000, rq = 1, out = 0;
	var sig, env;
	env = Env.adsr(atk, dec, slev, rel).kr(2, gate);
	sig = Saw.ar((freq + [0, detune]).poll(0)); // poll frequency values
	sig = RLPF.ar(sig, lpf, rq);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

// When explicitly creating a Synth, this name change doesn't pose a problem, and our detune parameter works as exected:

// left -> 400 Hz, right -> 500 Hz
x = Synth(\filtsaw, [freq: 400, detune: 100]);
x.set(\gate, 0);

// left -> 400 Hz, right -> 300 Hz
x = Synth(\filtsaw, [freq: 400, detune: -100]);
x.set(\gate, 0);

// However, when creating an Event, we inadvertently deliver a "double dose" of detuning, because a detune operation is programmed into the SynthDef, and also programmed into the Event infrastructure. Thus, the detuning occurs twice, and the resulting frequency values are not what we intend, despite providing the exact same parameters:

// left -> 500 Hz, right -> 600 Hz
(instrument: \filtsaw, freq: 400, detune: 100).play;

// left -> 300 Hz, right -> 200 Hz
(instrument: \filtsaw, freq: 400, detune: -100).play;

// By giving 'detune' a different name (e.g. 'offset'), we keep these two detuning operations separate from one another: Our 'offset' parameter only detunes one channel of the two-channel oscillator, while 'detune' is still available as a built-in Event parameter that shifts the overall frequency.

// We'll now return to the original version of this SynthDef:

(
SynthDef(\filtsaw, {
	arg amp = 0.2, freq = 300, offset = 2, // reverted to original name
	gate = 1, atk = 0.01, dec = 0.1, slev = 0.3, rel = 1,
	lpf = 20000, rq = 1, out = 0;
	var sig, env;
	env = Env.adsr(atk, dec, slev, rel).kr(2, gate);
	sig = Saw.ar((freq + [0, offset]).poll(0)); // also reverted here
	sig = RLPF.ar(sig, lpf, rq);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

// Now, the pitch information is the same, regardless of whether we create a Synth or play an Event:

// left -> 400 Hz, right -> 500 Hz
x = Synth(\filtsaw, [freq: 400, offset: 100]);
x.set(\gate, 0);

// left -> 400 Hz, right -> 500 Hz
(instrument: \filtsaw, freq: 400, offset: 100).play;

// Note that 'detune' now has no meaning in the context of creating a Synth, and thus has no effect:

// left -> 400 Hz, right -> 500 Hz
x = Synth(\filtsaw, [freq: 400, offset: 100, detune: 300]);
x.set(\gate, 0);

// But detune is built-into the Event infrastructure, and is therefore still a valid parameter in the context of playing an Event. Here, the right channel is offset by 100 Hz, and the overall frequency is offset by 300 Hz:

// left -> 700 Hz, right -> 800 Hz
(instrument: \filtsaw, freq: 400, offset: 100, detune: 300).play;

// Other problematic situations, similar to this 'detune' demonstration, may be encountered by naming a SynthDef argument identically to another built-in Event key, and may produce similarly redundant and/or conflicting behavior. To avoid stumbling into these pitfalls, the following guidelines serve to provide practical, useful tips when designing SynthDefs to be used with Pbind:

/*
(1) If a SynthDef outputs a pitched sound, 'freq' should be declared as the argument that determines the base frequency of the relevant UGen(s). Usually, this is the frequency of an oscillator, but might be the center frequency of a band-pass filter, or a parameter factored into the playback rate of PlayBuf, etc.

(2) If a SynthDef has an overall level control for its output signal, 'amp' should be declared as the argument which determines that level, with a value of one representing "full" amplitude and zero representing silence.

(3) If a SynthDef has a gated amplitude envelope with a terminating doneAction, 'gate' should be declared as the argument that controls that envelope's gate.

(4) If a SynthDef writes a signal to a bus (or writes a multichannel signal to a group of busses), 'out' should be declared as the argument for the lowest-numbered bus index.

(5) When in doubt, and with the exception of the guidelines listed above — unless you're certain you know what you're doing — it's sensible to avoid declaring SynthDef arguments that share a name with other built-into Event keys (e.g. 'detune', 'dur', 'sustain', 'note', 'midinote', etc.).
*/

// Let's now turn our attention to creative applications involving Pbind.

(
SynthDef(\filtsaw, {
	arg amp = 0.2, freq = 300, offset = 2, gate = 1, atk = 0.01,
	dec = 0.1, slev = 0.3, rel = 1, lpf = 20000, rq = 1, out = 0;
	var sig, env;
	env = Env.adsr(atk, dec, slev, rel).kr(2, gate);
	sig = Saw.ar(freq + [0, offset]);
	sig = RLPF.ar(sig, lpf, rq);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

// Like routines, EventStreamPlayers rely on a clock for scheduling and timing information. So, we'll also create a new, permament TempoClock running at a tempo of 150 bpm:

t = TempoClock(150/60).permanent_(true);

// As a simple introductory example, each key in the following Pbind is paired with a static value, and thus the Pbind represents an infinite sequence of identical note Events. We'll play this Pbind on our custom TempoClock, in which case our 'dur' value of 1 represents the duration of one beat at 150 bpm.

(
p = Pbind(
	\instrument, \filtsaw,
	\dur, 1,		// events each separated by one beat
	\sustain, 0.2,	// each note released after 0.2 beats
	\amp, 0.1,		// amplitude = 0.1
	\freq, 80,		// frequency of each note = [80, 82] Hz
	\offset, 2,
	\atk, 0.01,		// ADSR envelope parameters
	\dec, 0.1,
	\slev, 0.3,
	\rel, 0.1,
	\lpf, 1000,		// low-pass cutoff frequency = 1 kHz
	\rq, 0.2,		// filter quality = 5 (rq = 1/5)
	\out, 0,
);

~seq = p.play(t);
)

~seq.stop;

// This Pbind takes up a considerable amount of space in the text editor. Some note Event keys have been included ('instrument', 'dur', 'sustain'), as well as all of the SynthDef's arguments. However, it's not necessary to explicitly provide values for all parameters; if we omit a key that exists in the Event framework (e.g. 'dur' or 'freq'), the default value in the default note Event will be used. If we omit a key that exists as a SynthDef argument (but not as a default Event key), the default SynthDef argument value will be used. Thus, the previous Pbind can be simplified as follows, taking advantage of several default values:

(
p = Pbind(
	\instrument, \filtsaw,
	\sustain, 0.2,
	\freq, 80,
	\rel, 0.1,
	\lpf, 1000,
	\rq, 0.2,
);

~seq = p.play(t);
)

~seq.stop;

// Creating interesting musical sequences regularly boils down to envisioning a particular type of sound sequence, and translating it into pattern language. Here is an example in which numerous musical parameters have been thoroughly randomized:

(
p = Pbind(
	\instrument, \filtsaw,
	\dur, Pexprand(0.05, 1.2, inf),
	\sustain, Pexprand(0.02, 1, inf),
	\amp, Pexprand(0.02, 0.1, inf),
	\freq, Pexprand(30, 1000, inf),
	\rel, Pexprand(0.1, 3, inf),
	\lpf, Pexprand(60, 20000, inf),
	\rq, Pexprand(0.02, 0.8, inf),
);

~seq = p.play(t);
)

~seq.stop;

// Randomness excels at generating irregularity and chaos, but these are not always desired flavors. Deterministic patterns, on the other hand, allow for precise specification. Here, Pseq is the predominant value pattern, which creates predictable sequences of values, each specified as a cycle of 8 values. 'freq' has been replaced with 'midinote' to facilitate musical pitch expression. Some keys ('sustain', 'amp', and 'midinote') feature a more complex value sequence involving nested patterns. The final note in the 8-note 'midinote' pattern is randomly selected from three choices for a small bit of unpredictability.

(
p = Pbind(
	\instrument, \filtsaw,
	\dur, Pseq(1/[ 2, 1, 4, 8, 8, 2, 2, 1 ], inf),
	\sustain, Pseq([ Pseq([0.15], 7), 0.5 ], inf),
	\amp, Pseq([ Pgeom(0.25, 0.72, 7), 0.2 ], inf),
	\midinote, Pseq([ 52, 67, 52, 42, 47, 40, 63, Prand([66, 70, 78],1) ], inf),
	\rel, Pseq([ 0.2, 0.5, 0.1, 0.1, 0.1, 0.1, 0.2, 0.9 ], inf),
	\lpf, Pseq(1000 * [ 1.5, 6, 3, 0.5, 0.7, 0.6, 5, 2.5 ], inf),
	\rq, Pseq([ 0.5, 0.3, 0.5, 0.02, 0.02, 0.02, 0.6, 0.2 ], inf),
);

~seq = p.play(t);
)

~seq.stop;

// We can create a drone/pad texture by lengthening the 'sustain' key and/or envelope parameters, while keeping the 'dur' values relatively short, ensuring that adjacent Synths will overlap and blend. Because many Synths will be sounding simultaneously, it's usually wise to keep the 'amp' values somewhat low to avoid distortion. 'midinote' has been replaced by a combination of 'degree' and 'scale' to facilitate specification of pitch as scale degrees. In this case, the scale is constructed from the 1st, 2nd, 4th, and 5th degrees of the diatonic major scale). Phprand, introduced here, is a pattern which randomly picks two values within a range, and selects the higher of the two, thus tending toward its upper boundary (Plprand is a similar pattern which favors low values).

(
p = Pbind(
	\instrument, \filtsaw,
	\dur, Prand([0.5, 1], inf),
	\sustain, 6,
	\amp, Pexprand(0.01, 0.05, inf),
	\degree, Phprand(-10, 14, inf),
	\scale, [0, 2, 5, 7],
	\offset, Pwhite(-1.0, 1.0, inf),
	\atk, Pexprand(5.0, 6.0, inf),
	\dec, 0,
	\slev, 1,
	\rel, Pwhite(8.0, 12.0, inf),
	\lpf, Pexprand(800, 10000, inf),
	\rq, Pexprand(0.25, 1, inf),
);

~seq = p.play(t);
)

~seq.stop;

// In this drone example, it becomes clear that stopping the EventStreamPlayer does not also immediately free the Synths which happen to exist at that point in time. Instead, the process that creates new Synths is stopped, but any existing Synths are allowed to live out the rest of their lifespans in a satisfying fade-out.

// Next, an arpeggiator example, in which the 'degree' and 'scale' patterns have been altered. A nested pattern structure for 'degree' establishes a finite arithmetic series, which is repeated indefinitely. Here, we also implement a common ADSR envelope technique in which the sustain level of the envelope is zeroed, thus bypassing the sustain and release phases. Instead, only the attack and decay portions are heard, producing a simpler, two-segment envelope:

(
p = Pbind(
	\instrument, \filtsaw,
	\dur, 1/6,
	\sustain, 0.32,
	\amp, 0.05,
	\degree, Pseq([ Pseries(-5, 1, 24) ], inf),
	\scale, [0, 3, 5, 7, 10],
	\atk, 0.001,
	\dec, 0.3,
	\slev, 0,
	\rel, 0,
	\lpf, 1000,
	\rq, 0.25,
);

~seq = p.play(t);
)

~seq.stop;

// In these previous examples, each value pattern is unique and independent. However, situations arise in which we want the value of one parameter to depend on the value of another parameter. In the arpeggiator, as the pitch of the oscillator ascends, the cutoff frequency of the low-pass filter remains fixed at 1000 Hz. As a result, higher pitches are affected more strongly and are noticeably quieter. To counteract this, we can have the cutoff frequency "follow" the oscillator frequency, so that the ratio of the cutoff frequency and the oscillator frequency remains constant.

// There are multiple ways to do this. One option involves Pkey, a pattern that retrieves the value at some Event key, and allows us to apply it to another Event key. Even though the 'freq' key is not explicitly provided in the Pbind, we know it is internally calculated from 'degree' and therefore still available. The simplest usage involves using the 'freq' value as is. In this case, the oscillator frequency and filter frequency are equal, and most of the higher harmonics are filtered out for each Synth, leaving mostly the fundamental frequency and producing a more "sinusoidal" timbre:

(
p = Pbind(
	\instrument, \filtsaw,
	\dur, 1/6,
	\sustain, 0.31,
	\amp, 0.05,
	\degree, Pseq([ Pseries(-5, 1, 24) ], inf),
	\scale, [0, 3, 5, 7, 10],
	\atk, 0.001,
	\dec, 0.3,
	\slev, 0,
	\rel, 0,
	\lpf, Pkey(\freq),
	\rq, 0.25,
);

~seq = p.play(t);
)

~seq.stop;

// Recall that mathematical operations and methods can be applied to value patterns. For instance, we can set the cutoff frequency of each Synth to be equal to the 6th harmonic of the fundamental, simply by multiplying Pkey by 6. When working with filters, we should always ensure that the cutoff frequency remains within sensible boundaries, e.g. between 20 and 20,000 Hz (or else we risk blowing up the filter), so it's smart to 'clip' these values.

(
p = Pbind(
	\instrument, \filtsaw,
	\dur, 1/6,
	\sustain, 0.31,
	\amp, 0.05,
	\degree, Pseq([ Pseries(-5, 1, 24) ], inf),
	\scale, [0, 3, 5, 7, 10],
	\atk, 0.001,
	\dec, 0.3,
	\slev, 0,
	\rel, 0,
	\lpf, (Pkey(\freq) * 6).clip(20, 20000),
	\rq, 0.25,
);

~seq = p.play(t);
)

~seq.stop;

// Pfunc is another option for having one value pattern depend on the output of another. When Pbind generates an Event, Pfunc evaluates its function, and pairs the returned value with its key. One of the main benefits of Pfunc, particularly in this context, is that we can declare an argument inside the function, which is interpreted as the current Event. Thus, we have the ability to access any other key in the Event:

(
p = Pbind(
	\instrument, \filtsaw,
	\dur, 1/6,
	\sustain, 0.31,
	\amp, 0.05,
	\degree, Pseq([ Pseries(-5, 1, 24) ], inf),
	\scale, [0, 3, 5, 7, 10],
	\atk, 0.001,
	\dec, 0.3,
	\slev, 0,
	\rel, 0,
	\lpf, Pfunc({ |ev| (ev[\freq] * 6).clip(20, 20000) }),
	\rq, 0.25,
);

~seq = p.play(t);
)

~seq.stop;

// Likewise, in the previous drone example, we may wish to have the amplitude follow the scale degree so that higher pitches are quieter, to produce a timbre that sounds more psychoacoustically balanced. In the following example, degree values are mapped to amplitude values using 'lincurve'. Note that in this somewhat rare case, the order of the key-value pairs is consequential: the dependent pattern ('amp') must appear after the independent pattern ('degree'), or else the lincurve calculation will be applied to the default degree value, rather than the user-specified degree.

(
p = Pbind(
	\instrument, \filtsaw,
	\dur, Prand([0.5, 1], inf),
	\sustain, 6,
	\degree, Phprand(-10, 14, inf),
	\amp, Pfunc({ |ev| ev[\degree].lincurve(-10, 14, 0.05, 0.005, -2) }),
	\scale, [0, 2, 5, 7],
	\offset, Pwhite(-1.0, 1.0, inf),
	\atk, Pexprand(5.0, 6.0, inf),
	\dec, 0,
	\slev, 1,
	\rel, Pexprand(8.0, 12.0, inf),
	\lpf, Pexprand(800, 10000, inf),
	\rq, Pexprand(0.25, 1, inf),
);

~seq = p.play(t);
)

~seq.stop;

// It's possible to configure a Pbind such that one Event produces multiple Synths. This is an excellent way to generate chords or pitch clusters. If a value pattern corresponding to a SynthDef argument generates an array of n values, then n Synths will be created, and the values from the array will be individually assigned to these Synths (note, however, that this technique cannot be applied to values for the 'dur' key). In the following example, the array [0, 2, 4] is bound to the 'degree' key, producing an infinite sequence of major triads (note that the default 'scale' value is a diatonic major scale in twelve-tone equal temperament):

(
p = Pbind(
	\instrument, \filtsaw,
	\dur, 1,
	\amp, 0.05,
	\sustain, 0.02,
	\degree, [0, 2, 4],
	\slev, 1,
	\rel, 0.5,
	\lpf, 5000,
	\rq, 0.9,
);

~seq = p.play(t);
)

~seq.stop;

// This feature opens up additional creative possibilities. For instance, we can use Prand to randomly select one of several chords, perhaps varying a few other key values along the way:

(
p = Pbind(
	\instrument, \filtsaw,
	\dur, Pseq([1, 1/2, 1, 1, 1/2], inf),
	\amp, 0.05,
	\sustain, 0.02,
	\degree, Prand([
		[-3, -1, 1], [-2, 0, 2], [0, 2, 4], [1, 3, 5]
	], inf),
	\slev, 1,
	\rel, Pexprand(0.5, 1, inf),
	\lpf, 5000,
	\rq, 0.9,
);

~seq = p.play(t);
)

~seq.stop;

// The value pattern provided for 'degree' can be written more succinctly using pattern math:

(
p = Pbind(
	\instrument, \filtsaw,
	\dur, Pseq([1, 1/2, 1, 1, 1/2], inf),
	\amp, 0.05,
	\sustain, 0.02,
	\degree, [0, 2, 4] + Prand([-3, -2, 0, 1], inf),
	\slev, 1,
	\rel, Pexprand(0.5, 1, inf),
	\lpf, 5000,
	\rq, 0.9,
);

~seq = p.play(t);
)

~seq.stop;

// 'strum' is a built-in Event key that inserts a beat duration between successive voices in a chord, producing an effect reminiscent of strumming guitar strings:

(
p = Pbind(
	\instrument, \filtsaw,
	\dur, Pseq([1, 1/2, 1, 1, 1/2], inf),
	\amp, 0.05,
	\sustain, 0.02,
	\degree, [0, 2, 4] + Prand([-3, -2, 0, 1], inf),
	\strum, 1/16,
	\slev, 1,
	\rel, Pexprand(0.5, 1, inf),
	\lpf, 5000,
	\rq, 0.9,
);

~seq = p.play(t);
)

~seq.stop;

// Events that produce multiple Synths need not be conceived as musical chords. This technique works equally well for creating detuned pitch clusters. In the following code, each Event corresponds to 12 Synths whose frequencies are clustered around a random even-numbered scale degree:

(
p = Pbind(
	\instrument, \filtsaw,
	\dur, 1,
	\amp, 0.03,
	\sustain, 1,
	\degree, Pxrand([-4, -2, 0, 2, 4, 6, 8], inf) +
	Pfunc({ Array.rand(12, -0.04, 0.04) }),
	\atk, Pexprand(0.05, 0.2, inf),
	\dec, 0.1,
	\slev, 0.8,
	\rel, 3,
	\lpf, 5000,
	\rq, 0.9,
);

~seq = p.play(t);
)

~seq.stop;

// Keep in mind that creating multiple Synths proportionally increases the server's processing load. Depending on the number of Synths and the complexity of the SynthDef, it's possible to overexert your CPU, creating audio glitches and dropped samples.

// It's not always desirable to specify a trajectory for some parameter in terms of discrete values assigned on an Event-by-Event basis. In some cases, it makes more sense to specify a parameter trajectory that occurs over a certain duration in beats, regardless of the number of Events that occur within that timespan. For example, consider the following, which generates 100 note Events with an exponentially increasing 'dur' value, producing a "slow-down" effect:

(
p = Pbind(
	\instrument, \filtsaw,
	\dur, Pgeom(0.02, 1.04, 100),
	\sustain, Pkey(\dur),
	\freq, 50,
	\offset, 100,
	\atk, 0.001,
	\dec, Pkey(\dur) / 2,
	\slev, 0,
	\rel, 0,
	\db, Pseries(-6, -0.3, 100),
	\lpf, 1000,
	\rq, 0.1,
);

~seq = p.play(t);
)

// And, suppose we want to specify a trajectory of the low-pass filter's cutoff frequency that sweeps up for 2 beats and down for 4 beats. It would be mathematically complicated to specify this trajectory using Pseq and some sort of manually created array of 100 values, particularly because the Events in this pattern are not evenly spaced in time — they occur quickly at first, and then more slowly as time progresses.

// Pseg is a useful option in cases like this. Pseg is essentially the pattern analogue of EnvGen/Env, allowing us to specify a breakpoint envelope consisting of some number of envelope segments (hence the name "Pseg"). We provide Pseg with three internal value patterns, which represent envelope levels, durations (in beats) and segment curves, which is more or less the same configuration we encounter with Env.new(). The first value of the levels pattern is used for the starting position, and subsequent value trios from these three patterns are used to generate each envelope segment. For example, the following Pseg represents a linear trajectory from 0 to 1 over 2 beats, followed by a curved trajectory from 1 to 0 over 3 beats.

(
Pseg(
	Pseq([0, 1, 0], 1),
	Pseq([2, 3], 1),
	Pseq([0, -2], 1)
);
)

// The following Pbind uses Pseg to determine filter cutoff frequencies. Note that an additional "dummy" segment that sustains at 400 for an arbitrary duration of 60 beats is included to ensure that all 100 note Events are heard. Otherwise, if the duration of this Pseg is shorter that the time it takes to generate these 100 note Events, the Pseg will be considered the shortest value pattern and prematurely end the EventStreamPlayer.

(
p = Pbind(
	\instrument, \filtsaw,
	\dur, Pgeom(0.02, 1.04, 100),
	\sustain, Pkey(\dur),
	\freq, 50,
	\offset, 100,
	\atk, 0.001,
	\dec, Pkey(\dur) / 2,
	\slev, 0,
	\rel, 0,
	\db, Pseq( Array.interpolation(100, -6, -40), 1),
	\lpf, Pseg(
		Pseq([400, 20000, 400, 400], 1),
		Pseq([3, 5, 60], 1),
		Pseq([3, -3, 0], 1),
	),
	\rq, 0.1,
);

~seq = p.play(t);
)

// Finally, in addition to being able to schedule an EventStreamPlayer on a specific TempoClock, we can also quantize the start of an EventStreamPlayer to begin on a specific beat multiple. To demonstrate, we first create three similar Pbinds, meant to be played together. These Pbinds are similar in some respects: they all fixate on a eighth note/sixteenth note grid and draw pitches from an E-minor pentatonic scale, but have subtle differences in how they select pitches, filter parameters, and 'dur' values:

(
~p0 = Pbind(
	\instrument, \filtsaw,
	\dur, Pseq([ Pseq([0.5, 0.25], 4), Pseq([0.5], 2) ], inf),
	\sustain, 0.01,
	\atk, 0.001,
	\dec, 0,
	\slev, 1,
	\rel, 0.35,
	\midinote, Pseq([28, 40], inf),
	\lpf, (Pkey(\freq) * Pexprand(2.0, 3.0, inf)).clip(20, 20000),
	\rq, 0.5,
	\amp, 0.5
);

~p1 = Pbind(
	\instrument, \filtsaw,
	\dur, 0.25,
	\sustain, 0.01,
	\atk, 0.001,
	\dec, 0,
	\slev, 1,
	\rel, 0.2,
	\midinote, Pseq([40, 52, 40, 43, 50, 40, 43, 45, 40, 43, 50], inf),
	\lpf, (Pkey(\freq) * Pexprand(3.0, 16.0, inf)).clip(20, 20000),
	\rq, 0.1,
	\amp, 0.1,
);

~p2 = Pbind(
	\instrument, \filtsaw,
	\dur, Pwrand([0.25, 0.5], [0.9, 0.1], inf),
	\sustain, 0.01,
	\atk, 0.001,
	\dec, 0,
	\slev, 1,
	\rel, 0.4,
	\midinote, Pseq([40, 50, 40, 43, 52, 40, 45, 47, 43, 40, 45, 47], inf),
	\ctranspose, 36,
	\lpf, (Pkey(\freq) * Pexprand(2.0, 4.0, inf)).clip(20, 20000),
	\rq, 0.2,
	\amp, 0.02,
);
)

// A performance of these three patterns may involve starting one, and having the other patterns join the sequence at a later point in time. To time these changes precisely and reliably, we specify 'quant' information with the play message. For instance, we can quantize the first pattern to the nearest beat multiple of 4:

~seq0 = ~p0.play(t, quant:4);

// When we are ready to add the next pattern, we can quantize it in the same way to guarantee that it joins on an appropriate beat:

~seq1 = ~p1.play(t, quant:4);

// After a few cycles have passed, we can add the third pattern:

~seq2 = ~p2.play(t, quant:4);

// We can remove any of these EventStreamPlayers using stop:

~seq1.stop;

// Like 'play,' the 'resume' method also accepts a clock and quant value (these parameters are not "remembered" when an EventStreamPlayer is stopped, and must be provided again):

~seq1.resume(t, quant:4);

(
~seq0.stop;
~seq1.stop;
~seq2.stop;
)

// Hopefully, these examples begin to reveal the depth of possibilities that Pbind offers. Keep in mind that in this Companion Code, we've limited ourselves to only one SynthDef! Even more creative avenues become available when we increase the size of our code "orchestra," e.g., by adding other types of SynthDefs. It's impossible to cover the full range of creative possibilities here, and many interesting sequencing ideas are yet to be discovered. Take some time to compose and explore a few Pbinds of your own!