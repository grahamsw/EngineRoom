// Companion Code 4.4
// RecordBuf and PlayBuf

s.boot;

// This file explores creative sampling techniques involving RecordBuf and PlayBuf. It resides in a folder called "Companion_Code_4.4," accompanied by a stereo audio file named "flute0.aiff." This file serves as the sound source for some of the following examples, so we will begin by reading it into a buffer, and storing that buffer in an event named 'b,' at a key named 'fl':

(
b = ();
b[\fl] = Buffer.read(s, "flute0.aiff".resolveRelative);
)

// It sounds like this:

b[\fl].play;

// In addition, we'll allocate several empty two-channel buffers of various sizes, to be used with RecordBuf.

(
b[\rec60th] = Buffer.alloc(s, s.sampleRate / 60, 2); // 1/60th of a second long
b[\recQtr] = Buffer.alloc(s, s.sampleRate / 4, 2); // one quarter-second long
b[\rec10s] = { Buffer.alloc(s, s.sampleRate * 10, 2) }.dup(4); // four buffers, each 10 sec
b[\recMin] = Buffer.alloc(s, s.sampleRate * 60, 2); // one minute long
)

// The book demonstrated that a RecordBuf/PlayBuf combination can create a simple feedback delay effect, by recording and playing back in looping fashion, while attenuating existing buffer content before new content is recorded:

(
SynthDef(\recplay, {
	arg srcbuf, recbuf, preLevel = 0.9, rate = 1, gate = 1, out = 0;
	var sig = PlayBuf.ar(2, srcbuf, rate * BufRateScale.kr(srcbuf), loop: 1);

	// loop-record into the 1/4-second buffer, slightly
	// attenuating old content before mixing in new content:
	RecordBuf.ar(sig, recbuf, recLevel: 1, preLevel: preLevel);

	// loop-play the contents of the recording buffer,
	// attenuated for monitoring comfort:
	sig = PlayBuf.ar(2, recbuf, loop: 1) * 0.25;

	sig = sig * Env.asr(0, 1, 4).kr(2, gate);
	Out.ar(out, sig);
}).add;
)

(
x = Synth(
	\recplay,
	[
		srcbuf: b[\fl],
		recbuf: b[\recQtr]
	]
);
)

// Rate changes, in combination with the feedback delay effect, can produce eerie results:

x.set(\rate, -4.midiratio);

x.set(\rate, -8.midiratio);

x.set(\rate, -14.midiratio);

x.set(\gate, 0);

// With our current SynthDef, the length of the buffer determines the delay time, and the preLevel serves as a feedback coefficient. When preLevel is close to zero, the sound decays quickly. If preLevel is close to one, the sound decays slowly. If preLevel is zero, there is no delay and the source signal is simply reproduced as it was recorded. If preLevel is one, the source sound is continually added upon itself with no attenuation, creating a dense accumulating texture that is relatively stable, but which may exhibit clipping over a sufficiently long period of time. preLevel values greater than one are unstable and will cause the amplitude to grow exponentially.

// A delay time of 0.25 seconds is long enough for the brain to perceive discrete repetitions. As this value shrinks to about 1/20th of a second, the frequency of repetitions exceeds 20 Hz and enters the audible spectrum. With short enough delay times, the repetitions fuse together and create a sensation of pitch. This effect is called "comb filtering" and produces a distinct buzzy, ringing timbre. If frequency content in the source signal aligns with the fundamental frequency of the delay (or any of its harmonics), then the effect tends to produce a strong sense of resonance at those frequencies, and may drastically increase the amplitude of the signal, especially if preLevel is close to one:

(
x = Synth(
	\recplay,
	[
		srcbuf: b[\fl],
		recbuf: b[\rec60th],
		preLevel: 0.95
	]
);
)

// Even if the pitch of the source signal is altered through rate changes, the resonance at 60 Hz will remain, though its timbre may shift. Playback rate changes alter the spectral content of the buffer, causing the comb filtering effect to highlight different harmonics of 60 Hz:

x.set(\rate, -4.midiratio);

x.set(\rate, -8.midiratio);

x.set(\rate, -14.midiratio);

x.release(3);

// The preLevel feedback coefficient can be expressed as a decay time in seconds by raising 0.001 to an exponent equal to the ratio of delay time (i.e. buffer duration) to desired decay time:

0.001.pow(b[\rec60th].duration / 5); // preLevel for 5 second decay

// 0.001 is used because is is equivalent to a reduction of -60 decibels:

0.001.ampdb; // -> -60.0

// Thus, the previous expression represents the feedback coefficient that causes the sound to decay by 60 dB over the specified number of seconds. We can therefore change our SynthDef in order to express this parameter differently:

(
SynthDef(\recplay, {
	arg srcbuf, recbuf, decaytime = 5, rate = 1, gate = 1, out = 0;
	var sig = PlayBuf.ar(2, srcbuf, rate * BufRateScale.kr(srcbuf), loop: 1);
	RecordBuf.ar(
		sig,
		recbuf,
		recLevel: 1,
		preLevel: 0.001.pow(BufDur.kr(recbuf) / decaytime)
	);
	sig = PlayBuf.ar(2, recbuf, loop: 1) * 0.25;
	sig = sig * Env.asr(0, 1, 4).kr(2, gate);
	Out.ar(out, sig);
}).add;
)

(
x = Synth(
	\recplay,
	[
		srcbuf: b[\fl],
		recbuf: b[\rec60th],
		decaytime: 5 // five-second decay
	]
);
)

x.set(\decaytime, 0.5); // half-second decay

x.set(\decaytime, 2); // two-second decay

x.set(\gate, 0);

// This approach is not the only option for creating delay effects using real-time buffer recording and playback. RecordBuf's 'offset' argument can be used to specify a start position other than the 0th frame. If PlayBuf begins playing at frame 0, but RecordBuf begins recording somewhere in the middle of the buffer, then the recorded signal will not be reproduced until some amount of time has passed. This technique allows the creation of a non-feedback delay effect (a singular echo) whose delay time can be any value between zero and the duration of the recording buffer.

// To create this effect, we need to create a modified SynthDef, removing the decaytime argument and setting the preLevel to zero, since we no longer want a feedback delay effect. We add arguments for delay time and the amplitude of the delayed signal, so the echo can be made quieter than the source signal. It's preferable to be able to specify the delay time in seconds, but RecordBuf's offset argument expects a value in frames, so we must multiply the delay time by the sample rate. Toward the end of the SynthDef, we sum the source signal with the delayed copy, so that the original sound and its echo are both part of the output signal. This was not previously necessary, due to the mixing that automatically occurs with a non-zero preLevel.

(
SynthDef(\recplay, {
	arg srcbuf, recbuf, delaytime = 0, delayamp = 0.4, rate = 1, gate = 1, out = 0;
	var sig, delay;
	sig = PlayBuf.ar(2, srcbuf, rate * BufRateScale.kr(srcbuf), loop: 1);
	RecordBuf.ar(sig, recbuf, offset: delaytime * SampleRate.ir, recLevel: 1, preLevel: 0);
	delay = PlayBuf.ar(2, recbuf, loop: 1);
	sig = sig + (delay * delayamp);
	sig = sig * Env.asr(0, 1, 4).kr(2, gate);
	Out.ar(out, sig);
}).add;
)

// For this effect, we'll use the first of our four 10-second buffers, which means we can specifiy a delay time anywhere from zero to ten seconds when the Synth is created.

(
x = Synth(
	\recplay,
	[
		srcbuf: b[\fl],
		recbuf: b[\rec10s][0],
		delaytime: 1/3, // a 1/3rd-second echo
		delayamp: 0.4,
	],
);
)

x.set(\gate, 0);

// This approach can be used to create a multi-tap delay. Though the following example is not as convenient as using the MultiTap UGen, it's a valuable exercise to build one ourselves. In our current SynthDef, the source signal is always present in the output signal, at full amplitude. Thus, if we created four Synths (to produce a four-tap delay), the amplitude of the source signal would quadruple. So, we should create an amplitude argument for the source signal (srcamp), so that one of the four Synths could provide a blend of source and delay, while the other three will only output the delayed signal.

(
SynthDef(\recplay, {
	arg srcbuf, recbuf, delaytime = 0, srcamp = 1, delayamp = 0.4, rate = 1, gate = 1, out = 0;
	var sig, delay;
	sig = PlayBuf.ar(2, srcbuf, rate * BufRateScale.kr(srcbuf), loop: 1);
	RecordBuf.ar(sig, recbuf, offset: delaytime * SampleRate.ir, recLevel: 1, preLevel: 0);
	delay = PlayBuf.ar(2, recbuf, loop: 1);
	sig = (sig * srcamp) + (delay * delayamp);
	sig = sig * Env.asr(0, 1, 4).kr(2, gate);
	Out.ar(out, sig);
}).add;
)

// Additionally, if multiple instances of RecordBuf write to the same buffer, they may interfere with each other, possibly overwriting each others' content before PlayBuf is able to reproduce it. A clean solution is to use a different buffer for each Synth (which is why we created four 10-second buffers at the start of this code).

// Bear in mind that content recorded into a Buffer will remain there unless the buffer is explicitly zeroed or deallocated — pressing [command]+[period] or freeing Synths will have no effect. Therefore, it's often appropriate to clear buffers before they are recycled.

b[\rec10s][0].zero;

(
x = 4.collect({ |i|
	Synth(
		\recplay,
		[
			srcbuf: b[\fl],

			// each Synth uses a different 10-second recording buffer
			recbuf: b[\rec10s][i],

			// four exponentially increasing delay times
			delaytime: Array.geom(4, 0.15, 1.8).at(i),

			// the 0th Synth plays the source signal at full amplitude,
			// while the other three Synths silence it completely
			srcamp: (i == 0).asInteger,

			// delayed signals with longer delays are quieter
			delayamp: i.linlin(0, 3, -6, -24).dbamp,
		],
	);
});
)

x.do({ |synth| synth.set(\gate, 0) });

// It may be tempting to loop-record a signal to a buffer and simultaneously loop-play it back at a different rate, to create a harmonizing effect. However, this desynchronization of frame pointer speeds presents a technical problem. At any point in time, there is a discontinuity at the location of the recording pointer, between the newest and oldest recorded sample. These values are likely to be different, and will produce a click if reproduced.

// To provide a simple demonstration, the following UGen function records 1/3rd of a second of a stereo sine tone into a 1/4-second buffer, in looping fashion. Because of these durations, RecordBuf wraps back to the beginning and overwrites some data before the Synth is freed.

(
x = {
	var sig;
	sig = SinOsc.ar(250!2) * 0.4;
	RecordBuf.ar(sig, b[\recQtr]);
	Line.kr(0, 0, 1/3, doneAction: 2);
	sig;
}.play;
)

// The discontinuity is visible one-third of the way through the buffer:

b[\recQtr].plot;

// And the discontinuity can be clearly heard:

b[\recQtr].play;

// In the following code, we add a 'delrate' argument to the SynthDef, which allows the rate of the delayed PlayBuf to be changed. The source signal is replaced with a sine tone to make the resulting problem more clearly audible.

(
SynthDef(\recplay, {
	arg recbuf, delaytime = 0, srcamp = 1, delayamp = 0.4, delrate = 1, gate = 1, out = 0;
	var sig, delay;
	sig = SinOsc.ar(250 ! 2, mul: 0.5);
	RecordBuf.ar(sig, recbuf, offset: delaytime * SampleRate.ir, recLevel: 1, preLevel: 0);
	delay = PlayBuf.ar(2, recbuf, delrate, loop: 1);
	sig = (sig * srcamp) + (delay * delayamp);
	sig = sig * Env.asr(0, 1, 4).kr(2, gate);
	Out.ar(out, sig);
}).add;
)

b[\recQtr].zero; // zero the buffer first

// If the rate of the delayed PlayBuf is one, then its frame pointer moves at the same speed as RecordBuf's frame pointer. They remain perfectly in phase, and the record pointer discontinuity is never encountered:

(
x = Synth(
	\recplay,
	[
		recbuf: b[\recQtr],
		delaytime: 0.01,
		delrate: 1,
	],
);
)

// But, if the rate of the delay PlayBuf is changed, the recording/playback speeds will be different, and they will drift out of phase. Periodically, the PlayBuf pointer will encounter the recording discontinuity, and a click will be produced:

x.set(\delrate, -4.midiratio);

x.set(\gate, 0);

// A typical solution involves two complementary playback processes that begin at different frames but move at the same speed. The amplitudes of these two playback processes are modulated by a pair of unipolar sine waves with a 180-degree phase difference. As a result, one playback process fades out just as the other fades in to take its place. The mathematics of this solution are unusually complex with RecordBuf and PlayBuf, because we cannot directly control the positions of the frame pointers — only their speeds. This task is easier with BufWr/BufRd, and these ideas are explored in the next Companion Code.

// As a brief but significant side note, glitches or unexpected behavior may occur when the delay between recording and playback is smaller than one control block. The delay value in the previous Synth (0.01) is chosen somewhat arbitrarily, but is intentionally greater than the duration of one control block. If the delay time is less than the duration of one control block, the signal may be noticeably distorted (demonstrated here):

b[\recQtr].zero; // zero the buffer first

(
x = Synth(
	\recplay,
	[
		recbuf: b[\recQtr],
		delaytime: (s.options.blockSize - 1) / s.sampleRate,
		delrate: 1,
	],
);
)

x.free;

// Finally, we might want to record (and subsequently loop or process) the entirety of some finite-length sound whose exact duration is not known in advance. In this case, we can't allocate a buffer with the ideal size, so the most practical solution is to allocate a buffer that is larger than needed, but large enough to capture the complete sound. With some clever UGen tricks, we can implicitly "mark" the point in the buffer where live sound ends, allowing us to easily avoid whatever silence remains beyond that point, and loop through the buffer as if it were the ideal size all along.

// The following SynthDef uses the Timer UGen to track the number of seconds between the creation of the Synth and a trigger, manually generated by the user to mark the end of the recording process. The output value of Timer is zero until it receives a trigger, at which point its value is the number of seconds that have elapsed. The Timer value (esp. whether it is zero or not) is used to control the movement of certain frame pointers, and to initiate a looping envelope.

(
SynthDef(\recplay, {
	arg srcbuf, recbuf, t_trig = 0, gate = 1, out = 0;
	var sig, timer, trigEnv;

	// Timer begins with an output value of zero. When it receives a trigger,
	// it outputs the number of seconds that elapsed since it was created, or
	// the number of seconds since the most recent trigger. In this case, we
	// will only need to trigger Timer once, when the source sound ends.
	timer = Timer.kr(t_trig);

	// The source signal. Here, the sound is created by playing a file stored
	// in a buffer, but this can be any signal (a synthesized signal, a live
	// microphone, etc).
	sig = PlayBuf.ar(2, srcbuf, BufRateScale.kr(srcbuf));

	// When the user generates a trigger, the sound is declared to be "done."
	// The trigger starts this envelope, which fades out the source sound.
	sig = sig * Env([1, 0], [0.02], [0]).kr(gate: t_trig);

	// Record the source signal to a buffer. If the timer value is less than
	// or equal to zero, recording proceeds. When a trigger is received at
	// 't_trig', the timer's value will be positive, causing the comparative
	// expression "timer <= 0" to be false, thus setting the 'run' value to
	// zero, stopping the recording pointer.
	RecordBuf.ar(sig, recbuf, run: timer <= 0, loop: 0);

	// Env.circle specifies a repeating envelope shape. In this case, it's
	// used to create an envelope signal that moves from 0 to 1, at a period
	// determined by the timer value. Initially, this envelope's gate is zero
	// (because timer > 0 initially returns false), so it does not begin
	// looping until a trigger is received and Timer outputs a positive value.
	trigEnv = Env.circle([0, 1], [timer, 0], 'lin').kr(gate: timer > 0);

	// The 'trigEnv' envelope is used as a trigger, to periodically jump the
	// frame pointer of this PlayBuf to the 0th frame (each time trigEnv
	// resets, it briefly outputs zero, followed by positive values, and thus
	// functions as a recurring trigger signal). This PlayBuf's rate is 0
	// (timer > 0 returns false) until a trigger is received and Timer ouputs
	// a positive value. Thus, it doesn't begin playing until recording is
	// complete.
	sig = sig + PlayBuf.ar(2, recbuf, timer > 0, trigger: trigEnv);

	// A normal envelope used for fading the sound and freeing the Synth.
	sig = sig * Env.asr(0, 1, 4).kr(2, gate);
	Out.ar(out, sig);
}).add;
)

// To run this example, create the following Synth. When you hear the flue sound stop, evaluate the second line to generate a "done" trigger, which tells the Synth that the source sound is finished. On receiving this trigger, the Synth begins looping through the buffer, from the beginning to the "marked" spot. It's not necessary to wait until the source signal goes silent — if the Synth is triggered prematurely, then it will loop through a smaller section of the buffer.

x = Synth(\recplay, [srcbuf: b[\fl], recbuf: b[\recMin]]);

x.set(\t_trig, 1);

x.set(\gate, 0);

// The above version should work well for live looping purposes, and the timing of the manual trigger is even easier if you're the performer making the live sound. For the adventurous reader, there is one last finesse we might consider. The DetectSilence UGen can be used to automate the triggering process, by monitoring the amplitude of the source signal, and generating a trigger when the amplitude is below a threshold for a sufficient amount of time.

// DetectSilence outputs a value of zero until silence is detected, at which point it ouputs a value of one. DetectSilence can be tricky with stereo and multichannel signals, because multichannel expansion results in the creation of multiple DetectSilence UGens — one for each channel of audio. Depending on the source sound, the DetectSilence UGens may output triggers at different times, e.g., the left channel may go silent slighly before the right channel. To ensure that all DetectSilence UGens have detected silence before generating a trigger, we can multiply all of their outputs together. Thus, the resulting value will be one only if all of the individual DetectSilence UGens are outputting a value of one.

// One additional required change is that Timer must run at the audio rate, since it is listening for a trigger from an audio-rate instance of DetectSilence. DetectSilence must also run at the audio rate, since it is monitoring an audio-rate signal.

(
SynthDef(\recplay, {
	arg srcbuf, recbuf, gate = 1, out = 0;
	var sig, timer, trig, trigEnv;

	// The source signal
	sig = PlayBuf.ar(2, srcbuf, BufRateScale.kr(srcbuf));

	// Generates a trigger when both channels are below -60 dBFS
	// for at least 0.2 seconds
	trig = DetectSilence.ar(sig, -60.dbamp, 0.2).product;

	// Fades out the source signal when silence is detected
	sig = sig * Env([1, 0], [0.02], [0]).kr(gate: trig);

	// Marks the time (sec) when silence is detected
	timer = Timer.ar(trig);

	// Writes the source signal to the buffer until silence is detected
	RecordBuf.ar(sig, recbuf, run: timer <= 0, loop: 0);

	// After silence is detected, repeatedly retriggers PlayBuf to loop
	// through the recording buffer, at a period and duration determined
	// by the initial trigger
	trigEnv = Env.circle([0, 1], [timer, 0], 'lin').ar(gate: trig);

	// Plays back the recorded buffer once silence is detected
	sig = sig + PlayBuf.ar(2, recbuf, timer > 0, trigger: trigEnv);

	// A normal envelope used for fading the sound and freeing the Synth
	sig = sig * Env.asr(0, 1, 4).kr(2, gate);
	Out.ar(out, sig);
}).add;
)

// After running this Synth, the flute sample will be recorded to the 60-second buffer. After the sound fades to silence, the looping playback process will begin automatically.

x = Synth(\recplay, [srcbuf: b[\fl], recbuf: b[\recMin]]);

x.set(\gate, 0);

// To help clarify what's going on here, we can plot the buffer. Although it's a minute long, it contains only about seven seconds of sound (note that plotting a buffer this large takes a few seconds):

b[\recMin].plot;

// This live looping technique will work with any sufficiently large buffer and any source signal. Either this SynthDef or the previous version can be used, depending on whether manual or automatic triggering is desired.
