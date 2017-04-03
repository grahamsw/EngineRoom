(
{
	var trig, dur, freq;
	dur = 1/40;
	trig = Impulse.ar(1/dur);
	freq = TRand.ar(440, 880, trig);
	GrainSin.ar(1, trig, dur, freq)}.play
)

(SynthDef(\grainsine, {|freq = 440, amp = 1, dur = 0.05|
	var env, output;
	env = EnvGen.ar(Env.triangle(dur, amp), doneAction:2);
	output = SinOsc.ar(freq, mul:amp);
	OffsetOut.ar(0, output)
}).add)

(
Pbind(
\instrument, \grainsine,
	\freq, Pseq(Array.fill(10000, {rrand(100, 10000)})),
	\amp, Pseq(Array.fill(10000, {exprand(0.05, 0.02)})),
	\dur, 0.002).play
)

d = SoundFile.use(~fname, {|f| f.duration});
b = Buffer.read(s, ~fname);

(SynthDef(\grainfile, {|buffer = 0, pos = 0, dur = 1, amp =1|
	var rate, output, env;
	rate = BufRateScale.ir(buffer);
	output = PlayBuf.ar(1, buffer, rate, 1, pos, 1);
	env = EnvGen.ar(Env.linen(dur/100, dur * 0.98, dur/100, amp), doneAction: 2);
	OffsetOut.ar(0, output * env)}).add
)

(
var clouds = 0!4;
clouds[0] = Pbind(
	\instrument, \grainfile,
	\buffer, b,
	\pos, 0,
	\dur, Pseries(0.1, 0.1, 8)++Pseq([d]),
	\amp, 1);
clouds[1] = Pbind(
	\instrument, \grainfile,
	\buffer, b,
	\pos, 70000,
	\dur, Pgeom(1, 0.9, 20),
	\amp, 1);
clouds[2] = Pbind(
	\instrument, \grainfile,
	\buffer, b,
	\pos, 70000,
	\dur, Pwhite(0.15, 0.25, 100),
	\amp, Pseq((0.99, 0.98..0)/100, 100));
clouds[3] = Pbind(
	\instrument, \grainfile,
	\buffer, b,
	\pos, Pwhite(0, 100000, 100),
	\dur, Pwhite(0.15, 0.25, 100),
	\amp, Pseq((0.01, 0.02..1)/10, 100));

Routine{
	Pseq([clouds[0], clouds[1]]).play;
	(14.8223).wait;
	100.do{Ppar([clouds[2], clouds[3]]).play}}.play
)

(
var a;
a = Pwhite(0.0, 1.0, inf);
c = a.asStream.nextN(500);
w = Window.new("Pwhite", Rect(10, 10, 540, 800));
// plot the values
c.plot(bounds: Rect(10, 10, 520, 380), discrete: true, parent: w);
// a histogram of the values
c.histo(500).plot(bounds: Rect(10, 410, 520, 380), parent: w);
)

(
var a;
a = Pwhite(0, 1000, 10000);
a.asStream.nextN(10000).plot;
)
