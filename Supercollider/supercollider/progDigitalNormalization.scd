b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

(
r = Routine {|buff=0|
	var dur, thresh, ratio, in, compress, expand;
	dur = buff.duration;
	thresh = (-40).dbamp;
	ratio = 4;
	in = {PlayBuf.ar(1, buff, BufRateScale.ir(buff), doneAction:2)};
	in.play; dur.wait;
	compress = {Compander.ar(in, in, thresh, 1, 1/ratio, 0.01, 0.01)};
	compress.play; dur.wait;
	expand = {Compander.ar(compress, compress, thresh, 1, ratio/1, 0.01, 0.01)};
	expand.play;
})
Routine{r.reset; 3.do{r.(b);b.duration.wait}}.play;

(
r = Routine{|buff = 0|
	var dur, thresh, ratio, headroom, in, compress, normal;
	dur = buff.duration;
	thresh = (-40).dbamp;
	ratio = r;
	headroom = (-3).dbamp;
	in = {LeakDC.ar(PlayBuf.ar(1, buff, BufRateScale.ir(buff), doneAction:2))};
	in.play; dur.wait;
	compress = {Compander.ar(in, in, thresh, 1, 1/ratio, 0.01, 0.01)};
	complress.play; dur.wait;
	normal = {Normalizer.ar(compress, headroon)};
	normal.play;
}
)

Routine{r.reset; 3.do{r.(b); b.duration.wait}}.play;

{SinOsc.ar.cubed}.scope

//distortion
b = Buffer.alloc(s, 1024, 1);
b.cheby([1, 1/2, 1, 1/8]);
(
SynthDef(\distortion, {|buffer = 0, freq = 440, amp = 0.707, dur = 1|
	var input, index, bufout, output, env;
	input = SinOsc.ar(freq);
	index = LinLin.ar(input, -1.0, 1.0, 0, BufFrames.ir(buffer));
	bufout = BufRd.ar(1, buffer, index, 0,4);
	output = LeakDC.ar(bufout);
	env = EnvGen.ar(Env.perc(0.01, dur-0.01, amp), doneAction:2);
	OffsetOut.ar(0, (output*env)!2);
}).add;
)
(
var notes;
c = [64, 67, 64, 57];
d = [62, 66,62, 57];
e = [61, 64, 61, 57];
f = [60, 62, 60, 57];
g = [57, 64];

x = (c++d++e++f);

notes = ((x!3).flatten++[g]).midicps;
Pbind(
	\instrument, \distortion,
	\buffer, b,
	\freq, Pseq(notes),
	\dur, Pseq((1/12)!48++4),
	\amp, Pseq((0.707)!48++(1/2)),
).play;
)
{LeakDC.ar(Shaper.ar(b.bufnum, SinOsc.ar(MouseX.kr(110,440,\exponential), 0, 0.707)))}.play;

s.makeGui.window.alwaysOnTop= false 