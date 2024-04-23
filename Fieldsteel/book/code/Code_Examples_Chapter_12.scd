s.boot;

// Note: If "*** ERROR: SynthDef system_link_audio_1 not found" appears in the post window when trying to create/play a NodeProxy, recompile the SC class library or quit and restart the SC environment. This error is a consequence of evaluating ServerBoot.removeAll, which appears in a previous chapter. Recompiling/Restarting returns ServerBoot to its default state.

// Code Example 12.1

// play the square wave proxy
Ndef(\sig, { Pulse.ar([100, 100.5], mul: 0.03) }).fadeTime_(3).play;

// play the filter proxy, nesting the oscillator proxy inside
Ndef(\filt, { RLPF.ar(Ndef.ar(\sig, 2), 800, 0.1) }).fadeTime_(3).play;

// stop playing the original proxy
Ndef(\sig).stop(3);

// create the LFO proxy (but don't play it)
Ndef(\lfo, { SinOsc.kr(0.5).range(55, 80).midicps });

// patch the LFO into the filter proxy
Ndef(\filt, { RLPF.ar(Ndef.ar(\sig, 2), Ndef.kr(\lfo, 1), 0.1) });

// fade everything over 5 seconds
Ndef.all.do({ |n| n.clear(5) });



// Code Example 12.2

(
~a = 5; // create two environment variables
~b = 7;
)

currentEnvironment; // ~a and ~b live here, possibly other items too



// Code Example 12.3

e = Environment().push; // create and push to the top of the stack

(
~apple = 17; // store some data
~orange = 19;
)

currentEnvironment; // check the data: only ~apple and ~orange live here

e.pop; // pop it from the stack

currentEnvironment; // we've returned to our previous environment



// Code Example 12.4

p = ProxySpace().fadeTime_(3).push; // (if not already inside a ProxySpace)

~sig.play;

~sig.source = { Pulse.ar([100, 100.5], mul: 0.03) };

~filt.play;

~filt.source = { RLPF.ar(~sig.ar(2), 800, 0.1) };

~sig.stop(3);

~lfo.source = { SinOsc.kr(0.5).range(55, 80).midicps };

~filt.source = { RLPF.ar(~sig.ar(2), ~lfo.kr(1), 0.1) };

p.clear(5);

p.pop;



// Code Example 12.5

b = (); // main structure

b[\buf] = (); // a "subfolder" named 'buf'

// inside this subfolder, a buffer named '0'
b[\buf][\0] = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

b[\buf][\0].play; // it is accessible and playable

b[\chords] = (); // another subfolder named 'chords'

b[\chords][\major] = [0, 4, 7]; // store a chord in this subfolder, etc.



// Code Example 12.6

Ndef(\t).fadeTime_(2).play;

(
Ndef(\t, {
	arg freq = 200, width = 0.5;
	VarSaw.ar(freq + [0, 2], width: width, mul: 0.05);
});
)

Ndef(\t).set(\freq, 300); // immediate change

Ndef(\t).xset(\freq, 400); // crossfaded change

(
// after a source change, freq remains at 400, even though the default is 200
Ndef(\t, {
	arg freq = 200, width = 0.5;
	var sig = SinOsc.ar(freq + [0, 2], mul: 0.1);
	sig = sig * LFPulse.kr(6, 0, 0.3).lag(0.03);
});
)

(
Ndef(\lfo, { LFTri.kr(0.25).exprange(300, 1500) });
Ndef(\t).xset(\freq, Ndef(\lfo));
)

Ndef.all.do({ |n| n.clear(2) });



// Code Example 12.7

(
// first, create a clock at 108 bpm and post beat information
t = TempoClock(108/60);
t.schedAbs(0, { t.beats.postln; 1; });
)

// play a proxy and specify timing information
Ndef(\p).fadeTime_(0).clock_(t).quant_(4).play;

(
// now, any source change to the proxy will be quantized:
Ndef(\p, { |freq = 1000|
	var trig, sig;
	trig = Impulse.kr(t.tempo);
	sig = SinOsc.ar(freq) * 0.1 ! 2;
	sig = sig * Env.perc(0, 0.1).kr(0, trig);
});
)

(
Ndef(\p).clear; // clean up
t.stop;
)



// Code Example 12.8

(
// create a clock, post beats, and push a new ProxySpace
t = TempoClock(108/60);
t.schedAbs(0, { t.beats.postln; 1; });
p = ProxySpace(clock: t).quant_(8).push; // all proxies inherit clock/quant
)

~sig.play;

(
// source changes are quantized to the nearest beat multiple of 8
~sig = {
	var freq, sig;
	freq = ([57, 60, 62, 64, 67, 69, 71]).scramble
	.collect({ |n| n + [0, 0.1] }).flat.midicps;
	sig = Splay.ar(SinOsc.ar(freq)) * 0.05;
};
)

~sig.quant_(0); // override quant for this proxy

(
// change now occurs immediately
~sig = {
	var freq, sig;
	freq = ([57, 60, 62, 64, 67, 69, 71] - 2).scramble
	.collect({ |n| n + [0, 0.1] }).flat.midicps;
	sig = Splay.ar(SinOsc.ar(freq)) * 0.05;
};
)

(
p.clear;
t.stop;
)

p.pop;



// Code Example 12.9

Ndef(\sines).play;

Ndef(\sines).numChannels; // -> 2

Ndef(\sines).reshaping; // -> nil (no reshaping)

(
// Define a 2-channel source
Ndef(\sines, {
	var sig = SinOsc.ar([425, 500]);
	sig = sig * Decay2.ar(Impulse.ar([2, 3]), 0.005, 0.3, 0.1);
});
)

(
// Define a 4-channel source. No reshaping is done, and excess channels are mixed with the lowest two. A notification appears in the post window.
Ndef(\sines, {
	var sig = SinOsc.ar([425, 500, 750, 850]);
	sig = sig * Decay2.ar(Impulse.ar([2, 3, 4, 5]), 0.005, 0.3, 0.1);
});
)

Ndef(\sines).numChannels; // -> 2

Ndef(\sines).reshaping_(\elastic); // change reshaping behavior

(
// Defining a 4-channel source now reshapes the proxy. All four signals are on separate channels. If working with only two speakers, we'll only hear the first two channels.
Ndef(\sines, {
	var sig = SinOsc.ar([425, 500, 750, 850]);
	sig = sig * Decay2.ar(Impulse.ar([2, 3, 4, 5]), 0.005, 0.3, 0.1);
});
)

Ndef(\sines).numChannels; // -> 4

(
// An elastic proxy will shrink to accommodate a smaller source
Ndef(\sines, {
	var sig = SinOsc.ar([925, 1100]);
	sig = sig * Decay2.ar(Impulse.ar([6, 7]), 0.005, 0.3, 0.1);
});
)

Ndef(\sines).numChannels; // -> 2

Ndef(\sines).clear;



// Code Example 12.10

(
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

SynthDef(\play, {
	arg atk = 0.002, rel = 0.08, buf = 0,
	rate = 1, start = 0, amp = 0.5, out = 0;
	var sig, env;
	env = Env.perc(atk, rel).ar(2);
	sig = PlayBuf.ar(
		1, buf, rate * BufRateScale.kr(buf), startPos: start
	);
	sig = sig * env * amp ! 2;
	Out.ar(out, sig);
}).add;

t = TempoClock(108/60);
t.schedAbs(0, { t.beats.postln; 1; });
)

// create a proxy and provide an initial source
Ndef(\a).fadeTime_(0).clock_(t).quant_(4).play;

(
// source change occurs on a quantized beat
Ndef(\a, Pbind(
	\instrument, \play,
	\dur, 1/2,
	\buf, b,
	\amp, 0.2,
	\start, 36000,
));
)

// set a crossfade time of four beats
Ndef(\a).fadeTime_(t.beatDur * 4);

(
// pattern-based proxies are crossfaded as expected
Ndef(\a, Pbind(
	\instrument, \play,
	\dur, 1/4,
	\buf, b,
	\amp, 0.3,
	\start, Pwhite(50000, 70000),
	\rate, -4.midiratio,
));
)

// create an effect and route the first proxy through it
Ndef(\reverb).fadeTime_(5).play;

(
Ndef(\reverb, {
	var sig;
	sig = Ndef.ar(\a, 2);
	sig = LPF.ar(GVerb.ar(sig.sum, 300, 5), 1500) * 0.2;
});
)

(
// clean up:
Ndef.all.do({ |n| n.clear });
t.stop;
)



// Code Example 12.11

Tdef(\t).play;

(
// a finite-length source — execution begins immediately
Tdef(\t, {
	3.do{
		[ 6, 7, 8, 9 ].scramble.postln;
		0.5.wait;
	};
	"done.".postln
});
)

Tdef(\t).play; // do it again

(
// a new, infinite-length source
Tdef(\t, {
	~count = Pseq((0..9), inf).asStream;
	loop{
		~count.next.postln;
		0.25.wait;
	};
});
)

Tdef(\t).pause;

Tdef(\t).resume; // continues from pause location

Tdef(\t).stop;

Tdef(\t).play; // restarts from beginning

Tdef(\t).clear;



// Code Example 12.12

(
// create a verbose clock at 108 bpm
t = TempoClock(108/60);
t.schedAbs(0, { t.beats.postln; 1; });
)

// create a task proxy and set clock/quant values
Tdef(\ticks).clock_(t).quant_(4).play;

(
// post a visual effect, execution begins on next quantized beat
Tdef(\ticks, {
	loop{
		4.do{ |n|
			"*---".rotate(n).postln;
			0.25.wait;
		}
	}
});
)

(
// clean up
Tdef(\ticks).clear;
t.stop;
)



// Code Example 12.13

Ndef(\pad).fadeTime_(3).play;

(
Ndef(\pad, { |notes = #[43, 50, 59, 66]|
	var sig;
	sig = notes.collect({ |n|
		4.collect({
			LFTri.ar(
				freq: (n + LFNoise2.kr(0.2).bipolar(0.25)).midicps,
				mul: 0.1
			);
		}).sum
	});
	sig = Splay.ar(sig.scramble, 0.5);
	sig = LPF.ar(sig, notes[3].midicps * 2);
});
)

(
Tdef(\seq, {
	var chords = Pseq([
		[48, 55, 62, 64],
		[41, 48, 57, 64],
		[55, 59, 64, 69],
		[43, 50, 59, 66],
	], inf).asStream;
	loop{
		Ndef(\pad).xset(\notes, chords.next);
		8.wait;
	}
}).play
)

(
// clean up
Tdef(\seq).stop;
Ndef(\pad).clear(8);
)



// Code Example 12.14

History.start; // start a history session

// now, run a sequence of code statements:

s.boot;

Ndef(\k).fadeTime_(1).play;

Ndef(\k, { SinOsc.ar([200, 201], mul: 0.1) });

Ndef(\k, { SinOsc.ar([250, 253], mul: 0.1) });

(
Ndef(\k, {
	var sig, mod;
	mod = LFSaw.kr(0.3, 1).range(2, 40);
	sig = LFTri.ar([250, 253], mul: 0.1);
	sig = sig * LFTri.kr(mod).unipolar(1);
});
)

Ndef(\k).clear(3);

s.quit;

History.end; // stop the session

// save to your home directory
History.saveCS("~/myHistoryCS.scd".standardizePath);

History.clear; // clear the history, to demonstrate properly

History.play; // confirm history is currently empty

History.loadCS("~/myHistoryCS.scd".standardizePath); // load recorded history

History.play; // replay

// save to your home directory in "story" format
History.saveStory("~/myHistoryStory.scd".standardizePath);