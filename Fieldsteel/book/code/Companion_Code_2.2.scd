// Companion Code 2.2
// All About Envelopes

// Envelopes are a centerpiece of synthesis and sampling applications of all kinds. Being familiar with them will help you in the long run. This companion code augments the textbook by examining some additional features related to Env and EnvGen.

/*----------------------------*/
/* Other Env Creation Methods */
/*----------------------------*/

// 'new' is the most general and flexible method for creating an Env, but many others exist as conveniences for common situations. A hand-picked selection of these methods are shown below. A more complete list can be found in the Env help file.

(
// A non-sustaining three-segment envelope whose start and end points are always zero. Useful for simple "trapezoid" shapes.
Env.linen(
	attackTime: 1,
	sustainTime: 1,
	releaseTime: 1,
	level: 1,
	curve: 0
).plot;
)

(
// A non-sustaining two-segment envelope, specified by total duration and peak level. Attack and release segments are always linear, and always of equal duration.
Env.triangle(
	dur: 1,
	level: 1
).plot;
)

(
// Similar to 'triangle' (above), but uses sinusoidal interpolation instead of linear.
Env.sine(
	dur: 1,
	level: 1
).plot;
)

(
// A non-sustaining two-segment envelope. Default values produces a "percussive" shape, with a very short attack and longer exponential release.
Env.perc(
	attackTime: 0.01,
	releaseTime: 1,
	level: 1,
	curve: -4
).plot;
)

(
// Sustaining ADSR envelope. Parameters should be self-explanatory. Looks slightly odd when plotted, because the sustain segment is represented as a single point, rather than a horizontal line. When implemented in a synthesis algorithm, the sustainLevel value will be held as long as the envelope gate remains positive.
Env.adsr(
	attackTime: 0.01,
	decayTime: 0.3,
	sustainLevel: 0.5,
	releaseTime: 1,
	peakLevel: 1,
	curve: -4
).plot;
)

(
// An ADSR envelope without the decay segment. Similar to 'linen', but capable of sustaining at its sustain level.
Env.asr(
	attackTime: 1,
	sustainLevel: 1,
	releaseTime: 1,
	curve: 0
).plot;
)

/*---------------------------------*/
/* More on Specifying Curve Values */
/*---------------------------------*/

// Consider the following example of Env.linen, copied from the previous section:

(
Env.linen(
	attackTime: 1,
	sustainTime: 1,
	releaseTime: 1,
	level: 1,
	curve: 0
).plot;
)

// The curve value is 0, but the envelope has three segments. Which segment does this 0 apply to? For a method like 'linen', when the curve value is an integer or float, it applies to all segments. Change this value to a non-zero number and you'll see it affects all three segments.

// What if we wanted to apply a different curve value for each segment? We can do this by providing an array of values. Each value applies to its corresponding segment.

(
Env.linen(
	attackTime: 1,
	sustainTime: 1,
	releaseTime: 1,
	level: 1,
	curve: [2, 0, -6]
).plot;
)

// This technique applies to other Env creation methods, such as 'perc', 'asr', 'adsr', and others.

/*--------------------------*/
/* A Signal-Controlled Gate */
/*--------------------------*/

// Manually controlling an envelope's gate with set messages is not our only option. We can alternatively control an envelope's gate using another signal. When such a signal transitions from non-positive to positive, the gate opens, and when it transitions back to non-positive, the gate closes. Impulse, which generates short signal pulses at a frequency. is a good candidate for repeatedly triggering a non-sustaining envelope. In this example, we declare an argument that determines the frequency of the pulses:

(
x = { |trigHz = 2|
	var sig, env, gate;
	gate = Impulse.kr(trigHz); // 2 pulses per second
	env = EnvGen.kr(
		Env.new(
			[0, 1, 0],
			[0.02, 0.2],
			[0, -4],
		),
		gate,
	);
	sig = SinOsc.ar(350) * 0.3;
	sig = sig * env;
	sig = sig ! 2;
}.play;
)

x.set(\trigHz, 4); // faster

// If gate transitions occur too rapidly in the signal, the envelope will not have enough time to undergo sufficient decay before the next trigger arrives. In this case, the envelope receives such a high density of triggers that the gate is effectively "stuck" open:

x.set(\trigHz, 16); // fast enough to prevent full decay, but retriggering behavior is still audible

x.set(\trigHz, 50); // too fast for any decay to occur between triggers

x.free; // free when finished

// UGen rates are important when controlling an envelope's gate with another signal. Generally, the envelope signal and the gate signal should be running at the same rate, in other words, both 'kr', or both 'ar'. This ensures that every trigger will be properly detected by the envelope. If the envelope is running at the audio rate, and the gate signal is running at the control rate, this is fine — an audio rate envelope is calculating every sample, so it will never "miss" a control rate value. However, if the envelope is running at the control rate and the gate signal is running at the audio rate, the envelope is only "awake" at the beginning of each control cycle. It's likely that an audio rate trigger will land somewhere in the middle of a control cycle, in which case the envelope won't detect it.

/*--------------------------------------*/
/* A Syntax Shortcut for EnvGen and Env */
/*--------------------------------------*/

// A common envelope syntax involves nesting an Env instance inside of an EnvGen, as we've exclusively been doing so far. However, there is a useful alternative. An instance of Env will respond to the 'kr' or 'ar' method by returning an EnvGen, running at that rate. The Env that receives the method will be used to define the EnvGen's signal. A convenient aspect of this shortcut when 'kr' or 'ar' is applied to an Env is that the order of the arguments is slightly different than when one of these methods is applied to an EnvGen. Specifically, the doneAction (a commonly used parameter) is first, instead of last, allowing us to skip the 'doneAction' keyword. As an example, the following two blocks of code are functionally equivalent:

(
x = {
	var sig, env;
	env = EnvGen.kr(
		Env.new(
			[0, 1, 0],
			[0.02, 0.3],
			[0, -4],
		),
		doneAction:2
	);
	sig = SinOsc.ar(350) * 0.3;
	sig = sig * env;
	sig = sig ! 2;
}.play;
)

(
x = {
	var sig, env;
	env = Env.new([0, 1, 0], [0.02, 0.3], [0, -4]).kr(2);
	sig = SinOsc.ar(350) * 0.3;
	sig = sig * env;
	sig = sig ! 2;
}.play;
)

/*----------------------------*/
/* Release Node and Loop Node */
/*----------------------------*/

// The book discusses the 'releaseNode' argument of Env.new(), which identifies the level at which the envelope will sustain while its gate is positive. This argument is sometimes paired with an additional argument called 'loopNode', which serves as an index for an earlier value in the envelope's level array. Together, the release node and loop node form two "anchor" points, delineating an internal region of an envelope that repeats indefinitely while the gate is positive.

// Plot the following Env, and you'll see it has two "peak" points in the middle. These two points, which have indices 1 and 3, are specified as the loop node and release node, respectively.

(
e = Env.new(
	levels: [0, 1, 0.2, 1, 0],
	times: [2, 0.1, 0.1, 2],
	curve: [2, \sine, \sine, -2],
	releaseNode: 3,
	loopNode: 1
);
e.plot;
)

// This Env generates an envelope signal in the following code. The gate is initially 1, and the envelope signal starts from the beginning of its shape. When the signal reaches the second peak (the level with index 3), it then begins looping through the middle two segments, for as long as the gate remains open. Technically, when the signal reaches the second peak, it transitions from its current level to the level *immediately after* the loop node, continuing forward to the release node, and repeating this process over and over. It does *not* actually jump back to the first peak — it only seems this way because the release node and loop node have the same value. This behavior of always transitioning to a new value from the current value, rather than suddenly "jumping," is designed to avoid discontinuous behavior, which produces auditory results that are usually undesirable.

(
x = { |gate = 1|
	var sig, env;
	env = EnvGen.kr(
		envelope: Env.new(
			[0, 1, 0.2, 1, 0],
			[1, 0.1, 0.1, 1],
			[2, \sine, \sine, -2],
			3,
			1
		),
		gate: gate,
		doneAction: 2
	);
	sig = SinOsc.ar(350) * 0.3;
	sig = sig * env;
	sig = sig ! 2;
}.play;
)

// When the gate closes, the envelope transitions from its current value — wherever it happens to be in the loop region — to the value immediately after the release node, using the corresponding duration and curve values. Again, to be clear, the signal does not instantaneously "jump" to the release node.

x.set(\gate, 0);

/*----------------------------------*/
/* Two Envelopes, One UGen Function */
/*----------------------------------*/

// To emphasize that envelopes can control nearly any aspect of a sound algorithm, the following code uses one envelope to control amplitude, and another to control frequency. We're also using the 'Env.new().kr' shortcut presented earlier.

(
{
	var sig, freq, env;
	freq = Env.new([3000, 300], [4], [-10]).kr(2);
	env = Env.new([0, 1, 0], [1, 3], [0, 0]).kr(2);
	sig = SinOsc.ar(freq);
	sig = sig * env * 0.3;
	sig = sig ! 2;
}.play;
)

// First, note that the levels for the frequency envelope are much higher than the levels of the amplitude envelope! Because 'freq' controls an oscillator's frequency, the levels represent values measured in Hz, which the oscillator expects. This point is meant to emphasize that an envelope is merely a signal, and it's our responsibility to provide context-appropriate numbers.

// Note also that the doneAction for both envelopes is 2. In this example, the two envelopes have the same total duration (4 seconds), and finish at the same time. Although it's harmless for both to have doneAction: 2, it's only necessary for one envelope to contain a freeing doneAction, and in this particular case, it doesn't really matter which one has it.

// But, in the next example, the frequency envelope is much shorter than the amplitude envelope, lasting only a fifth of a second. The doneAction is still 2 for both, so it's a race! Whichever envelope finishes first will free the sound process. This means the frequency envelope prematurely stops the sound, while the amplitude envelope has barely begun.

(
{
	var sig, freq, env;
	freq = Env.new([3000, 300], [0.2], [-10]).kr(2);
	env = Env.new([0, 1, 0], [1, 3], [0, 0]).kr(2);
	sig = SinOsc.ar(freq);
	sig = sig * env * 0.3;
	sig = sig ! 2;
}.play;
)

// One solution is to remove doneAction: 2 (thus defaulting to doneAction: 0) from the shorter envelope, thus allowing the longer one to finish and determine the true "end" of the sound:

(
{
	var sig, freq, env;
	freq = Env.new([3000, 300], [0.2], [-10]).kr;
	env = Env.new([0, 1, 0], [1, 3], [0, 0]).kr(2);
	sig = SinOsc.ar(freq);
	sig = sig * env * 0.3;
	sig = sig ! 2;
}.play;
)

// The bottom line is that when a UGen function contains multiple UGens with doneActions, it's important to take a holistic view of the algorithm, carefully considering their durations and purposes. The UGen that most directly represents the lifespan of the sound — usually the overall amplitude envelope — is the one that should contain a freeing doneAction.