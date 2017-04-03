(
var file, soundPath;
~buffers = List[];
Dialog.getPaths({
	|paths|
	paths.do ({
		|soundPath|
		soundPath.postln;
		~buffers.add(Buffer.read(s, soundPath););})
});
)

~buffers[0].play;

(
SynthDef(\samplePlayer, {
	| out = 0, buf = 0, rate = 1, at= 0.01, rel = 0.1, pos = 0, pSpeed = 0, lev = 0.5|
	var sample, panT, amp, aux;
	sample = PlayBuf.ar(1, buf, rate * BufRateScale.kr(buf), 1, 0, 0);
	panT = FSinOsc.kr(pSpeed);
	amp = EnvGen.ar(Env.perc(at, rel, lev), doneAction:2);
	Out.ar(out, Pan2.ar(sample, panT, amp));
}).add;
)

// Synth(\samplePlayer, [\out, 0, \buf, ~buffers[0], \rel, 0.25]);

// Pxrand([0, 1, 2, 3, 4, 5, 6, 7], inf)


(
~stut = Routine( {
	var dur, pos;
	~stuttPatt = Pseq([Pgeom(0.01, 1.1707, 18), Pn(0.1, 1), Pgeom(0.1, 0.94, 200)]);
	~str = ~stutPatt.asStream;
	100.do{
		dur = ~str.next;
		dur.postln;
		~sample = Synth(\samplePlayer, [\out, 0, \buf, ~buffers[0], \at, 0.1, \rel, 0.05, \Speed, 0.5]);
		dur.wait;
	}
});
)


~stut.play;
~stut.reset;
January 28 at 9:04pm · New York ·
And another big " FUCK YOU, TRUMP" from this greencard holding, tax paying immigrant woman...fuuuuuuck you and all your people. Nope.


