// Companion Code 5.3
// Pattern Composition Techniques

// This Companion Code explores pattern composition techniques that focus on sample-based sequencing, in contrast to synthesis-based sequences that have appeared in the book so far. First, we boot the server and read several audio files into arrays of buffers, storing the arrays in an Event contained in the interpreter variable 'b'. These buffer-reading techniques are featured and discussed throughout the Companion Code files associated with Chapter 4.

s.boot;

(
~makeBuffers = { |path, event|
	var dir = PathName(path);
	var contents = dir.entries;

	if (contents.select({ |n| n.isFile }).size > 0)
	{
		var files, bufArray;
		files = contents.select({ |n| n.isFile });
		files = files.select({ |n|
			["aif", "aiff", "wav"].includesEqual(n.extension)
		});

		if (event[dir.folderName.asSymbol] != nil)
		{ "duplicate subfolder name ignored".warn; }
		{
			bufArray = files.collect({ |n| Buffer.read(s, n.fullPath) });
			event[dir.folderName.asSymbol] = bufArray;
		};
	};

	if (contents.select({ |n| n.isFolder }).size > 0)
	{
		var folders = contents.select({ |n| n.isFolder });
		folders.do({ |n| ~makeBuffers.(n.fullPath, event) });
	};

	event;
};

b = ~makeBuffers.("audio/".resolveRelative, ());
)

// The audio files are arranged into three subfolders. One folder contains three flute tongue rams:

b[\flute][0].play;
b[\flute][1].play;
b[\flute][2].play;

// Another folder contains five samples derived from sampling the output of an analog calibration tone generator as it powers off:

b[\glitch][0].play;
b[\glitch][1].play;
b[\glitch][2].play;
b[\glitch][3].play;
b[\glitch][4].play;

// And, a third folder contains a long, processed reverb tail derived from a metallic percussive sound:

b[\drone][0].play;

// To highlight the power and flexibility of patterns, we'll limit ourselves to one SynthDef. The following SynthDef features a two-channel PlayBuf signal, passed through low-pass and high-pass filters. Note that the default cutoff frequencies of these filters are specifically chosen so that the filters are effectively bypassed by default. A three-segment envelope controls the overall amplitude, and we can apply left/right spatialization choices. An ample collection of arguments enables us to take full advantage of creative pattern expression. By default, playback will loop indefinitely, and the PlayBuf UGen does not have a terminating doneAction. Instead, the envelope determines the temporal lifespan of each Synth.

(
SynthDef(\playbuf, {
	arg atk = 0, sus = 0, rel = 1, atkcrv = 0, relcrv = 0,
	buf = 0, rate = 1, spos = 0, loop = 1,
	lpf = 20000, hpf = 20, pan = 0, amp = 0.5, out = 0;
	var sig, env;
	env = Env([0, 1, 1, 0], [atk, sus, rel], [atkcrv, 0, relcrv]).ar(2);
	rate = rate * BufRateScale.kr(buf);
	sig = PlayBuf.ar(2, buf, rate, startPos:spos, loop:loop);
	sig = LPF.ar(sig, lpf);
	sig = HPF.ar(sig, hpf);
	sig = sig * env;
	sig = Balance2.ar(sig[0], sig[1], pan, amp);
	Out.ar(out, sig);
}).add;
)

// With default argument values, each Synth plays the first second of the sample with a linear fade.

Synth(\playbuf, [buf: b[\drone][0]]);

// For the pattern examples that follow, we'll be envisioning most sequences as existing on a metrical grid at 108 beats per minute, so we'll create a permanent TempoClock to provide this grid:

t = TempoClock(108/60).permanent_(true);

// We'll start by creating a few unique Pbinds, and then combine them into a small composition. First, as a starting point, a relatively simple Pbind that represents a rhythmic sequence of glitch samples. Other than amplitude and chosen sample, each Synth is identical.

(
~glitch0pat = Pbind(
	\instrument, \playbuf,
	\buf, Pxrand(b[\glitch], inf),
	\dur, 1/4,
	\rate, 1,
	\spos, 0,
	\atk, 0.001,
	\rel, 0.1,
	\relcrv, -2,
	\pan, 0,
	\amp, Pexprand(0.3, 0.6, inf),
);

x = ~glitch0pat.play(t);
)

x.stop;

// To add interesting musical features, we'll introduce some structured randomness into several parameters. In the following example, the 'dur' values represent a more complex rhythmic structure, featuring a weighted choice that favors quarter-beats, but occasionally selects a half-beat or a quarter-beat rest. The playback rate can vary by two octaves in either direction. The envelope attack time, release time, and pan position are also randomly chosen from ranges.

// An interesting sonic result occurs with this particular combination of value patterns. As this sequence plays, you may notice an occasional sample that sounds like an echo effect has been applied. Because these samples are short, and looping is enabled, a high playback rate combines with a long release time such that PlayBuf cycles through the sample several times before completely fading out.

(
~glitch0pat = Pbind(
	\instrument, \playbuf,
	\buf, Pxrand(b[\glitch], inf),
	\dur, Pwrand(
		[1/2, 1/4, Rest(1/4)],
		[0.18, 0.8, 0.02],
		inf
	),
	\rate, Pwhite(-24.0, 24.0).midiratio,
	\spos, 0,
	\atk, Pexprand(0.001, 0.02, inf),
	\rel, Pexprand(0.02, 0.9, inf),
	\relcrv, -2,
	\pan, Pwhite(-0.5, 0.5, inf),
	\amp, Pexprand(0.3, 0.6, inf),
);

x = ~glitch0pat.play(t);
)

x.stop;

// A few more changes can add even more subtlety. In this final version, the playback rate is further modified so that playback can run in either direction, and the start position is completely random. The release time and pan position have been further modified to be a bit more complex: the release time is randomly chosen from either a small range or a larger range, but favors the shorter range. The pan position is a random value, often near zero, but occasionally (about once per 50 Events) is heavily shifted toward one side of the stereo image. The sonic nature of these glitch samples is relatively harsh, so we adjust the cutoff frequencies of the low- and high-pass filters in order to temper them.

// Note that these five glitch buffers all have different lengths, so we cannot reasonably use Pwhite to determine the random starting position. This is because Pwhite is an independent value pattern, unable to determine which buffer is selected by the 'buf' pattern, and therefore cannot provide the maximum frame index. Instead, we use Pfunc to access each Event, extract the frame count of the current buffer, and use it as an upper boundary for the start position.

(
~glitch0pat = Pbind(
	\instrument, \playbuf,
	\buf, Pxrand(b[\glitch], inf),
	\dur, Pwrand(
		[1/2, 1/4, Rest(1/4)],
		[0.18, 0.8, 0.02],
		inf
	),
	\rate, Pwhite(-24.0, 24.0).midiratio * Prand([1,-1],inf),
	\spos, Pfunc({ |ev| rrand(0, ev[\buf].numFrames - 1) }),
	\atk, Pexprand(0.001, 0.02, inf),
	\rel, Pwrand([
		Pexprand(0.3, 0.7, 1),
		Pexprand(0.02, 0.09, 1)
	], [0.1, 0.9], inf),
	\relcrv, -2,
	\pan, Pwrand(
		[-0.85, 0.85, Pmeanrand(-0.5, 0.5, 1)],
		[0.01, 0.01, 0.98],
		inf
	),
	\hpf, 100,
	\lpf, 8000,
	\amp, Pexprand(0.3, 0.6, inf),
);

x = ~glitch0pat.play(t);
)

x.stop;

// Our next Pbind will focus on the high-pitched glitch sample, which features a tone with a frequency around 10 kHz:

b[\glitch][0].play;

// One idea is to significantly lower the playback rate to extend the duration and bring the pitch down to a mellower range. Once we've done so, we can experiment with chords and/or tone clusters. In the following Pbind, the playback rate is arbitrarily dropped by 55 semitones, and successive Events occur eight beats apart. The fact that 'dur' is interpreted as beats, but envelope segment durations are interpreted as seconds can create some awkwardness. To avoid this, we can use the 'beatDur' method to convert seconds to beats, so that values specified for 'dur,' 'atk,' and 'rel' are all beat values:

(
~glitch1pat = Pbind(
	\instrument, \playbuf,
	\buf, b[\glitch][0],
	\dur, 8,
	\rate, -55.midiratio,
	\pan, 0,
	\spos, 0,
	\atk, 3 * t.beatDur,
	\rel, 3 * t.beatDur,
	\amp, 0.5,
);

x = ~glitch1pat.play(t);
)

x.stop;

// Pfunc allows us to manipulate the playback rate with creative precision. After the initial downward transposition, we expand this single value into an array, building a 3-voice chord. We then transpose the entire array down by a random number of semitones:

// An interesting side-effect occurs here: when the playback rate is relatively high, the pitch of the sound seems to drift upward toward the end of the sound. This occurs beacuse the pitch of the original sample naturally drifts upward toward the end of the sample. This is simply a consequence of shutting off the power supply to the calibration tone generator, which was captured during the original recording session.

(
~glitch1pat = Pbind(
	\instrument, \playbuf,
	\buf, b[\glitch][0],
	\dur, 8,
	\rate, Pfunc({
		var r = -55;
		r = r + [[0, 2, 5], [0, 3, 5]].choose;
		r = r + [0, -2, -5, -7].choose;
		r = r.midiratio;
	}),
	\pan, 0,
	\spos, 0,
	\atk, 3 * t.beatDur,
	\rel, 3 * t.beatDur,
	\amp, 0.5,
);

x = ~glitch1pat.play(t);
)

x.stop;

// For a shimmering quality, we can double each note, and slightly detune each voice to create subtle beating patterns.

(
~glitch1pat = Pbind(
	\instrument, \playbuf,
	\buf, b[\glitch][0],
	\dur, 8,
	\rate, Pfunc({
		var r = -55;
		r = r + [[0, 2, 5].dupEach, [0, 3, 5].dupEach].choose;
		r = r + [0, -2, -5, -7].choose;
		r = r + Array.rand(6, -0.1, 0.1); // <- slight detuning
		r = r.midiratio;
	}),
	\pan, 0,
	\spos, 0,
	\atk, 3 * t.beatDur,
	\rel, 3 * t.beatDur,
	\amp, 0.5,
);

x = ~glitch1pat.play(t);
)

x.stop;

// This final version of this Pbind adds a few more ideas: The 'dur' values are either two beats or 20 beats, slightly favoring the shorter value. The result is that we tend to hear a clustered sequence of approximately two or three chords, followed by a span of silence. The amplitude, attack time, and release times are randomly selected from a range. The pan position and start position are also random, but use Pfunc to create an array of six values, so that the pan position and start position of each Synth is unique. By contrast, if we were to use Pwhite(-0.5, 0.5) instead of Pfunc for the 'pan' values, then all six voices in each chord would have the exact same spatial position.

(
~glitch1pat = Pbind(
	\instrument, \playbuf,
	\buf, b[\glitch][0],
	\dur, Pwrand([2, 20], [0.65, 0.35], inf),
	\rate, Pfunc({
		var r = -55;
		r = r + [[0, 2, 5].dupEach, [0, 3, 5].dupEach].choose;
		r = r + [0, -2, -5, -7].choose;
		r = r + Array.rand(6, -0.1, 0.1);
		r = r.midiratio;
	}),
	\pan, Pfunc({ Array.rand(6, -0.5, 0.5) }),
	\spos, Pfunc({ Array.rand(6, 0, 5000) }),
	\atk, Pexprand(0.5, 3, inf) * t.beatDur,
	\rel, Pexprand(8, 12, inf) * t.beatDur,
	\amp, Pexprand(0.15, 0.25, inf),
);

x = ~glitch1pat.play(t);
)

x.stop;

// Our third Pbind focuses on the drone sample. The Synths created here are relatively long an relatively sparse, but timing parameters are configured so that a constant stream of sound is produced (the longest possible 'dur' value is shorter than the total envelope duration).

// This Pbind produces a stream that generates two Synths per Event. The playback rate is random within an octave, and the two voices are slightly detuned and start from slightly different positions in the buffer. The two Synths are panned hard-left and hard-right to enhance the spatial characteristics of the detuning effect. The low-pass filter attenuates most of the audible spectrum, producing a dark and subdued timbre.

(
~drone0pat = Pbind(
	\instrument, \playbuf,
	\dur, Phprand(5, 15,inf),
	\atk, 10 * t.beatDur,
	\rel, 10 * t.beatDur,
	\buf, b[\drone][0],
	\rate, Pfunc({
		var r = rrand(-12.0, 0);
		r = r + Array.rand(2, -0.2, 0.2);
		r = r.midiratio;
	}),
	\spos, Pfunc({
		var sp = rrand(0, 100000);
		sp = sp + Array.rand(2, 0, 5000);
	}),
	\pan, [1, -1],
	\lpf, 500,
	\amp, Pexprand(0.1, 0.15, inf),
);

x = ~drone0pat.play(t);
)

x.stop;

// Our final Pbind focuses on the flute samples. Unlike the other three Pbinds, this example specifies a finite sequence of 40 Events, limited by the length of the 'amp' stream, which is reduced by two decibels per Event. The 'pan' position alternates back and forth, simulating a ping-pong delay. We randomly select from the three samples and slightly vary the buffer start position and playback rate of each one, which avoids repeatedly producing the exact same sample, creating a more organic sound.

(
~flute0pat = Pbind(
	\instrument, \playbuf,
	\buf, Pxrand(b[\flute], inf),
	\dur, 1/4,
	\rate, Pwhite(-12.0, -11.7, inf).midiratio,
	\pan, Pseq([0.7, -0.7], inf),
	\spos, Pwhite(0, 2000, inf),
	\atk, 0.005,
	\sus, 0,
	\rel, 0.5,
	\relcrv, -10,
	\amp, Pgeom(0.5, -2.dbamp, 40)
);

x = ~flute0pat.play(t);
)

// The following modified version features a few improvements. The 'dur' pattern occasionally selects a half-beat instead of a quarter-beat, creating a slightly unpredictable rhythm. A finite 'rate' pattern selects a random playback rate and duplicates it 40 times. This ensures that within a stream of 40 Events, each Synth will have the same playback rate, but successive performances of this stream will select a new random rate. The pan position is modified so that the ping-pong effect may start on either the left or right side.

(
~flute0pat = Pbind(
	\instrument, \playbuf,
	\buf, Pxrand(b[\flute], inf),
	\dur, Pwrand([1/4, 1/2], [0.9, 0.1], inf),
	\rate, Pdup(40, Pwhite(-18.0, -9.0, 1).midiratio),
	\pan, Prand([
		Pseq([0.7, -0.7], inf),
		Pseq([-0.7, 0.7], inf)
	], 1),
	\spos, Pwhite(0, 1000, inf),
	\atk, 0.005,
	\sus, 0,
	\rel, 0.5,
	\relcrv, -10,
	\amp, Pgeom(0.5, -2.dbamp, 40)
);

x = ~flute0pat.play(t);
)

// As we combine these Pbinds into larger composite structures, we may find the need to insert rests of varying lengths. Instead of repeatedly typing out a one-rest Pbind, like this,

(
Pbind(
	\dur, Pseq([ Rest(4) ], 1)
);
)

// We can write a function that performs this task for us. The following ~rest function returns a Pbind with a rest duration specified as an input argument:

(
~rest = { |n|
	Pbind(
		\dur, Pseq([ Rest(n) ], 1)
	);
};
)

// Thus, we can easily express a arbitrarily long rest pattern like this:

~rest.(8); // a Pbind that represents eight beats of rest

// From here, we're ready to begin assembling our patterns into compositional sections. For convenience, all four Pbinds and the ~rest function are included here.

(
~rest = { |n|
	Pbind(
		\dur, Pseq([ Rest(n) ], 1)
	);
};

~glitch0pat = Pbind(
	\instrument, \playbuf,
	\buf, Pxrand(b[\glitch], inf),
	\dur, Pwrand(
		[1/2, 1/4, Rest(1/4)],
		[0.18, 0.8, 0.02],
		inf
	),
	\rate, Pwhite(-24.0, 24.0).midiratio * Prand([1,-1],inf),
	\spos, Pfunc({ |ev| rrand(0, ev[\buf].numFrames - 1) }),
	\atk, Pexprand(0.001, 0.02, inf),
	\rel, Pwrand([
		Pexprand(0.3, 0.7, 1),
		Pexprand(0.02, 0.09, 1)
	], [0.1, 0.9], inf),
	\relcrv, -2,
	\pan, Pwrand(
		[-0.85, 0.85, Pmeanrand(-0.5, 0.5, 1)],
		[0.01, 0.01, 0.98],
		inf
	),
	\hpf, 100,
	\lpf, 8000,
	\amp, Pexprand(0.3, 0.6, inf),
);

~glitch1pat = Pbind(
	\instrument, \playbuf,
	\buf, b[\glitch][0],
	\dur, Pwrand([2, 20], [0.65, 0.35], inf),
	\rate, Pfunc({
		var r = -55;
		r = r + [[0, 2, 5].dupEach, [0, 3, 5].dupEach].choose;
		r = r + [0, -2, -5, -7].choose;
		r = r + Array.rand(6, -0.1, 0.1);
		r = r.midiratio;
	}),
	\pan, Pfunc({ Array.rand(6, -0.5, 0.5) }),
	\spos, Pfunc({ Array.rand(6, 0, 5000) }),
	\atk, Pexprand(0.5, 3, inf) * t.beatDur,
	\rel, Pexprand(8, 12, inf) * t.beatDur,
	\amp, Pexprand(0.15, 0.25, inf),
);

~drone0pat = Pbind(
	\instrument, \playbuf,
	\dur, Phprand(5, 15,inf),
	\atk, 10 * t.beatDur,
	\rel, 10 * t.beatDur,
	\buf, b[\drone][0],
	\rate, Pfunc({
		var r = rrand(-12.0, 0);
		r = r + Array.rand(2, -0.2, 0.2);
		r = r.midiratio;
	}),
	\spos, Pfunc({
		var sp = rrand(0, 100000);
		sp = sp + Array.rand(2, 0, 5000);
	}),
	\pan, [1, -1],
	\lpf, 500,
	\amp, Pexprand(0.1, 0.15, inf),
);

~flute0pat = Pbind(
	\instrument, \playbuf,
	\buf, Pxrand(b[\flute], inf),
	\dur, Pwrand([1/4, 1/2], [0.9, 0.1], inf),
	\rate, Pdup(40, Pwhite(-18.0, -9.0, 1).midiratio),
	\pan, Prand([
		Pseq([0.7, -0.7], inf),
		Pseq([-0.7, 0.7], inf)
	], 1),
	\spos, Pwhite(0, 1000, inf),
	\atk, 0.005,
	\sus, 0,
	\rel, 0.5,
	\relcrv, -10,
	\amp, Pgeom(0.5, -2.dbamp, 40)
);

// The beginning section plays the drone pattern for 32 beats.
~sec0 = Pfindur(32, ~drone0pat);

// The next section plays another 24 beats of the drone pattern, but this time it plays together with a sequence that alternates between the flute pattern and 4 beats of rest. The internal flute pattern is longer than the 24 beats of drone pattern, so there should be a brief period of time at the end of the first section where we hear a brief flute pattern solo.
~sec1 = Ppar([
	Pfindur(24, ~drone0pat),
	Pseq([~flute0pat, ~rest.(4)], 4)
], 1);

// Section 2 specifies 64 beats of all four patterns playing in parallel.
~sec2 = Pfindur(
	64,
	Ppar([
		~drone0pat,
		Pseq([~flute0pat], inf),
		~glitch0pat,
		~glitch1pat
	], 1)
);

// In Section 3, we hear 32 beats of only the two glitch patterns:
~sec3 = Pfindur(
	32,
	Ppar([
		~glitch0pat,
		~glitch1pat
	], 1)
);

// In this brief final section, we get 16 beats of the drone pattern (enough for only 1 or 2 drone Synths), which plays together with the glitch chord pattern.
~sec4 = Pfindur(
	16,
	Ppar([
		~drone0pat,
		~glitch1pat
	], 1)
);

// Pseq is used to perform these sections in order.
~player = Pseq([
	~sec0,
	~sec1,
	~sec2,
	~sec3,
	~sec4
], 1).play(t, quant:4);
)