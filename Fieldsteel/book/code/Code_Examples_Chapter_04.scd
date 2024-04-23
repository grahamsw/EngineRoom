// Code Example 4.1

s.boot;

// replace this string with one that points to an audio file on your computer
b = Buffer.read(s, "/Users/eli/Sounds/scaudio/drumsamples/Claps/clap1.aif");

b.plot;

b.play;

b.free;



// Code Example 4.2

(
b = [
	Buffer.read(s, Platform.resourceDir ++ "/sounds/a11wlk01-44_1.aiff"),
	Buffer.read(s, Platform.resourceDir ++ "/sounds/a11wlk01.wav")
];
)

b[0].play;

b[1].play;



// Code Example 4.3

b = Buffer.read(s, Platform.resourceDir ++ "/sounds/a11wlk01.wav");

b.duration;

b.bufnum;

b.numFrames;

b.numChannels;

b.sampleRate;

b.query; // post several attributes



// Code Example 4.4

(
b = Buffer.readChannel(
	s,
	"path/to/some/stereo/file.aiff", // <- replace with valid path to stereo file
	channels: [0] // only read the left channel
);
)

b.play;



// Code Example 4.5

(
~drone = [
	Buffer.read(s, "/path/to/drone0.wav"),
	Buffer.read(s, "/path/to/drone1.wav"),
	Buffer.read(s, "/path/to/drone2.wav")
];

~creak = [
	Buffer.read(s, "/path/to/creak0.wav"),
	Buffer.read(s, "/path/to/creak1.wav"),
	Buffer.read(s, "/path/to/creak2.wav")
];
)



// Code Example 4.6

(
var folder = PathName.new("/path/to/folder/of/audio/files/");
b = folder.entries.collect({ |file| Buffer.read(s, file.fullPath) });
)

b[0].play;

b[1].play; // etc.



// Code Example 4.7

(
b = (); // create an empty Event
b[\abc] = 17; // store three pieces of data in the Event
b[\jkl] = 30.2;
b[\xyz] = [2, 3, 4];
)

b[\jkl]; // retrieve the data stored at the key 'jkl'



// Code Example 4.8

(
var folder, subfolders;
b = ();
folder = PathName.new("/path/to/main/folder/");
subfolders = folder.entries; // array of PathName subfolders
subfolders.do({ |sub|
	// for each subfolder, iterate over the files
	// and load each one into a buffer
	var bufArray = sub.entries.collect({ |file|
		Buffer.read(s, file.fullPath);
	});
	// then, store the array in the Event, at a key
	// named according to the subfolder name
	b[sub.folderName.asSymbol] = bufArray;
});
)

b[\wood][0].play; // play the 0th file in the wood subfolder

b[\metal][3].play; // play the 3rd file in the metal subfolder, etc.



// Code Example 4.9

b = Buffer.read(s, Platform.resourceDir ++ "/sounds/a11wlk01-44_1.aiff");

{ PlayBuf.ar(b.numChannels, b.bufnum) }.play;



// Code Example 4.10

(
// this fails — an argument cannot be used to define the number of channels
SynthDef(\playbuf, {
	arg nch = 1, buf = 0, out = 0;
	var sig = PlayBuf.ar(nch, buf);
	Out.ar(out, sig ! 2);
}).add;
)



// Code Example 4.11

(
SynthDef(\playbuf, {
	arg buf = 0, out = 0;
	var sig = PlayBuf.ar(1, buf); // fixed channel size
	Out.ar(out, sig ! 2);
}).add;
)

Synth(\playbuf, [buf: b.bufnum]);



// Code Example 4.12

(
SynthDef(\playbuf, {
	arg buf = 0, loop = 1, out = 0;
	var sig = PlayBuf.ar(1, buf, loop: loop, doneAction: 2);
	Out.ar(out, sig ! 2);
}).add;
)

x = Synth(\playbuf, [buf: b.bufnum]); // looping is on by default

x.set(\loop, 0); // turn looping off



// Code Example 4.13

(
SynthDef(\playbuf, {
	arg buf = 0, rate = 1, loop = 1, out = 0;
	var sig = PlayBuf.ar(1, buf, rate, loop: loop, doneAction: 2);
	Out.ar(out, sig ! 2);
}).add;
)

x = Synth(\playbuf, [buf: b.bufnum]);

x.set(\rate, 2); // double speed

x.set(\rate, 0.5); // half speed

x.set(\rate, 0); // freeze frame pointer

x.set(\rate, -0.75); // backwards, three-quarter speed

x.set(\loop, 0); // free Synth when current playback cycle finishes



// Code Example 4.14

(
SynthDef(\playbuf, {
	arg buf = 0, rate = 1, loop = 1, out = 0;
	var sig;
	rate = rate * BufRateScale.kr(buf);
	sig = PlayBuf.ar(1, buf, rate, loop: loop, doneAction: 2);
	Out.ar(out, sig ! 2);
}).add;
)



// Code Example 4.15

(
SynthDef(\playbuf, {
	arg buf = 0, rate = 1, t_trig = 1, start = 0, loop = 1, out = 0;
	var sig;
	rate = rate * BufRateScale.kr(buf);
	sig = PlayBuf.ar(1, buf, rate, t_trig, start, loop, doneAction: 2);
	Out.ar(out, sig ! 2);
}).add;
)

x = Synth(\playbuf, [buf: b.bufnum]);

// jump to the 0.5 second mark:
x.set(\start, s.sampleRate / 2, \t_trig, 1);

x.free;



// Code Example 4.16

(
SynthDef(\bufrd, {
	arg buf = 0, out = 0;
	var sig, phs;
	phs = Line.ar(0, BufFrames.kr(buf) - 1, BufDur.kr(buf), doneAction: 2);
	sig = BufRd.ar(1, buf, phs);
	Out.ar(out, sig ! 2);
}).add;
)

Synth(\bufrd, [buf: b.bufnum]);



// Code Example 4.17

(
SynthDef(\bufrd, {
	arg buf = 0, rate = 1, out = 0;
	var sig, phs;
	rate = rate * BufRateScale.kr(buf);
	phs = Phasor.ar(rate: rate, start: 0, end: BufFrames.kr(buf));
	sig = BufRd.ar(1, buf, phs);
	Out.ar(out, sig ! 2);
}).add;
)

Synth(\bufrd, [buf: b.bufnum]);



// Code Example 4.18

b = Buffer.alloc(s, s.sampleRate * 0.5, 1); //a half-second mono buffer

(
{
	var sig = SinOsc.ar(ExpRand(200, 1200));
	sig = sig * Env.perc(0.01, 0.49).ar(2);
	RecordBuf.ar(sig, b);
	sig = sig * 0.25 ! 2;
}.play;
)

b.plot;

{ PlayBuf.ar(1, b, BufRateScale.kr(b), doneAction: 2) * 0.25 ! 2 }.play;

b.zero; // clear the buffer

b.plot; // now empty



// Code Example 4.19

(
{
	var sig = SinOsc.ar(ExpRand(200, 1200));
	sig = sig * Env.perc(0.01, 0.49).ar(2);
	RecordBuf.ar(sig, b);
	sig = sig * 0.25 ! 2;
	0; // silent output
}.play;
)

b.play(mul: 0.25);



// Code Example 4.20

b.zero; // clear the buffer first

(
{	// evaluate this function 4-5 times
	var sig = SinOsc.ar(ExpRand(200, 1200));
	sig = sig * Env.perc(0.01, 0.49).ar(2);
	RecordBuf.ar(sig, b, recLevel: 1, preLevel: 0.5);
	sig = sig * 0.25 ! 2;
}.play;
)

{ PlayBuf.ar(1, b, BufRateScale.kr(b), doneAction: 2) * 0.25 ! 2 }.play;



// Code Example 4.21

b.zero; // clear the buffer first

(
x = {
	var sig, freq;
	freq = TExpRand.ar(200, 1200, Dust.ar(12));
	sig = SinOsc.ar(freq.lag(0.02));
	RecordBuf.ar(sig, b, loop: 1);
	sig = sig * 0.25 ! 2;
}.play;
)

x.free;

y = { PlayBuf.ar(1, b, BufRateScale.kr(b), loop: 1) * 0.25 ! 2 }.play;

y.release(2);



// Code Example 4.22

b.zero; // clear the buffer first

(
x = {
	var sig, freq;
	freq = TExpRand.ar(200, 1200, Dust.ar(12));
	sig = SinOsc.ar(freq.lag(0.02));
	RecordBuf.ar(sig, b, recLevel: 1, preLevel: 0.5, loop: 1);
	sig = PlayBuf.ar(1, b, BufRateScale.kr(b), loop: 1) * 0.25 ! 2;
}.play;
)

x.release(2);



// Code Example 4.23

b = Buffer.alloc(s, s.sampleRate, 2); // a one-second stereo buffer

(
{
	var sig, phs;
	sig = SinOsc.ar([250, 252]);
	phs = Line.ar(0, b.numFrames - 1, b.duration, doneAction: 2);
	BufWr.ar(sig, b, phs);
	sig = sig * 0.25;
}.play;
)

b.play(mul: 0.25);

b.plot;



// Code Example 4.24

b.zero; // clear the buffer first

(
{
	var sig, phs;
	sig = SinOsc.ar([250, 252]);
	phs = Line.ar(0, b.numFrames - 1, b.duration * 0.9, doneAction: 2);
	BufWr.ar(sig, b, phs);
	sig = sig * 0.25;
}.play;
)

b.play(mul: 0.25); // glitchy harmonic distortion



// Code Example 4.25

b.zero; // clear the buffer first

(
{
	var sig, phs;
	sig = SinOsc.ar([2000, 2010]);
	phs = Line.ar(0, b.numFrames - 1, b.duration * 3.7, doneAction: 2);
	BufWr.ar(sig, b, phs);
	sig = sig * 0.25;
}.play;
)

b.play(mul: 0.25); // glitchy harmonic distortion



// Code Example 4.26

b.zero; // clear the buffer first

(
x = {
	var sig, freq, phs;
	freq = TExpRand.ar(200, 1200, Dust.ar(12) ! 2);
	sig = SinOsc.ar(freq.lag(0.02));
	phs = Phasor.ar(0, BufRateScale.kr(b), 0, BufFrames.kr(b));
	BufWr.ar(sig, b, phs);
	sig = sig * 0.25;
}.play;
)

x.free;

y = { PlayBuf.ar(2, b, BufRateScale.kr(b), loop: 1) * 0.25 }.play;

y.release(2);



// Code Example 4.27

b.zero; // clear the buffer first

(
x = {
	var sig, freq, phs, delay;
	freq = TExpRand.ar(200, 1200, Dust.ar(12) ! 2);
	sig = SinOsc.ar(freq.lag(0.02));
	phs = Phasor.ar(0, BufRateScale.kr(b), 0, BufFrames.kr(b));
	BufWr.ar(sig, b, phs);
	delay = BufRd.ar(2, b, phs - (SampleRate.ir / 3));
	sig = sig + (delay * 0.5);
	sig = sig * 0.25;
}.play;
)

x.release(2);



// Code Example 4.28

b.zero; // clear the buffer first

(
x = {
	var sig, freq, phs, delay;
	freq = TExpRand.ar(200, 1200, Dust.ar(12) ! 2);
	sig = SinOsc.ar(freq.lag(0.02), mul: 0.25);
	sig = sig * Line.kr(0, 1, 0.02);
	phs = Phasor.ar(0, BufRateScale.kr(b), 0, BufFrames.kr(b));
	sig = sig + (BufRd.ar(2, b, phs) * 0.75);
	BufWr.ar(sig, b, phs);
	sig = sig * 0.25;
}.play;
)

x.release(2);



// Code Example 4.29

b = Buffer.read(s, Platform.resourceDir ++ "/sounds/a11wlk01.wav");

(
{
	GrainBuf.ar(
		numChannels: 2,
		trigger: Impulse.kr(8),
		dur: 0.05,
		sndbuf: b
	);
}.play;
)



// Code Example 4.30

(
{
	GrainBuf.ar(
		numChannels: 2,
		trigger: Impulse.kr(8),
		dur: 0.05,
		sndbuf: b,
		rate: 7.midiratio,
		pos: 0.5
	);
}.play;
)



// Code Example 4.31

(
{
	GrainBuf.ar(
		numChannels: 2,
		trigger: Impulse.kr(8),
		dur: 0.05,
		sndbuf: b,
		rate: 7.midiratio,
		pos: Line.kr(0, 1, BufDur.ir(b))
	);
}.play;
)



// Code Example 4.32

(
var env = Env.new([0, 1, 0], [0.01, 1], [0, -4]);
~grainenv = Buffer.loadCollection(s, env.discretize(8192));
)

(
{
	GrainBuf.ar(
		numChannels: 2,
		trigger: Impulse.kr(8),
		dur: 0.05,
		sndbuf: b,
		rate: 7.midiratio,
		pos: Line.kr(0, 1, BufDur.ir(b)),
		interp: 2,
		pan: LFNoise1.kr(10),
		envbufnum: ~grainenv
	);
}.play;
)



// Code Example 4.33

(
{
	TGrains.ar(
		numChannels: 2,
		trigger: Impulse.kr(8),
		bufnum: b,
		rate: 7.midiratio,
		centerPos: Line.kr(0, BufDur.ir(b), BufDur.ir(b)),
		dur: 0.05,
		pan: LFNoise1.kr(10),
		amp: 1,
		interp: 2
	);
}.play;
)



// Code Example 4.34

(
{
	var sig;
	sig = Warp1.ar(
		numChannels: 1,
		bufnum: b,
		pointer: Line.kr(0, 1, BufDur.ir(b)),
		freqScale: 7.midiratio,
		windowSize: 0.05,
		envbufnum: -1,
		overlaps: 0.4,
		windowRandRatio: 0,
		interp: 2,
		mul: 0.5,
	);
	sig = Pan2.ar(sig, LFNoise1.kr(10));
}.play;
)