

SynthDef(\default, {
		|freq = 440, amp = 0.3|
	    e = Env([0, 1, 0] * amp, [0.1, 1]);
	    f = EnvGen.ar(e, doneAction: 2);
	Out.ar(0, {SinOsc.ar(freq, mul: f )})
	}).add;

(

r = Routine({
	c = TempoClock.new;
	t = Task({
		loop({
			x.release(0.1);
			x = Synth(\default, [freq: 61.midicps, amp:0.2]);
			0.2.wait;
			x.release(0.1);
			x = Synth(\default, [freq:67.midicps, amp:0.2]);
			rrand(0.075, 0.25).wait;
		});
	}, c;
	t.start;
	nil.yield;
	y = Synth(\default, [freq: 73.midicps, amp:0.3]);
	nil.yield;

	y.release(0.1);
	y = Synth(\default, [freq: 79.midicps, amp: 0.3]);

	c.tempo = 2;
	nil.yield;
	t.stop;
	y.release(1);
	x.release(0.1);
});

)

r.next

(
p = Pxrand([64, 66, 68, 70, 71, 73, 74, 76], inf).asStream;
q = Pseq([1,2, 0.5], inf).asStream;
t = Task({
	loop({
		x.release(2);
		x = Synth(\default, [freq: p.value.midicps]);
		q.value.wait;
	});
});
t.start;
)
t.stop;
x.release(2);


(
p = 64;
q = Pseq([1,2, 0.5], inf).asStream;
t = Task({
	loop({
		x.release(2);
		x = Synth(\default, [freq: p.value.midicps]);
		q.value.wait;
	});
});
t.start;
)

p = Pseq([64, 66, 68], inf).asStream;
p = { rrand(64, 76) };
p = 99;
t.stop;
x.release;

(
SynthDef(\ScoreSine, {
	| freq = 440|
	Out.ar(0, SinOsc.ar(freq, 0, 0.2) * Line.kr(1, 0, 0.5, doneAction: 2));
}).add;



x = [
	[0.0, [\s_new, \ScoreSine, 1000, 0, 0, \freq, 1413]],
	[0.5, [\s_new, \ScoreSine, 1001, 0, 0, \freq, 712]],
	[1.0, [\s_new, \ScoreSine, 1002, 0, 0, \freq, 417]],
	[2.0, [\c_set, 0, 0]]
];
z = Score(x);
)

z.play

(

SynthDef(\playbuf, {
	| out = 0, buf, gate = 1 |
	Out.ar(out,
		PlayBuf.ar(1, buf, BufRateScale.kr(buf), loop:1.0) *
		Linen.kr(gate, doneAction:2);
	)
}).add;

~someSounds = "/usr/share/SuperCollider/sounds/*".pathMatch.collect{ |path| Buffer.read(s, path)};
)

~nowPlaying = Synth(\playbuf, [buf: ~someSounds[0]]);
~nowPlaying.release;
~nowPlaying = Synth(\playbuf, [buf: ~someSounds[2]]);

~someSounds.do(_.free)