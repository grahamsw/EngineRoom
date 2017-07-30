(
var sig, exp;
var soundFile;

exp = 16;
sig = Signal.fill(2.pow(exp), {2.0.rand - 1});
sig = sig.asWavetable;

soundFile = SoundFile.new;
soundFile.headerFormat_("AIFF").sampleFormat_("int16").numChannels_(1);
soundFile.openWrite("/home/grahamsw/rand.aiff");
soundFile.writeData(sig);
soundFile.close;
)

(
SynthDef(\tableOsc, {
	|buf, freq = 440, amp=0.4|
	Out.ar(0, Osc.ar(buf, freq, mul:amp));
}).add;
)
(

var freq = 440;
var buf, synth;
var exp = 3;

buf = Buffer.read(s, "/home/grahamsw/rand.aiff");

x = Synth.new(\tableOsc, [\buf, buf]);
)

x.set(\freq, 13300);

s.scope


(
SynthDef(\playBuf, {
	| buf, loop = 1, rate = 1|
	Out.ar(0, PlayBuf.ar(1, buf, rate:rate, loop:loop));
}).add;

)



~xbus = Bus.control(s)
{Out.kr(~xbus, MouseX.kr(0.2, 2, 0).poll(2))}.play
s.scope
(

var freq = 440;
var buf, synth;
var exp = 3;

b = Buffer.read(s, "/home/grahamsw/f_7.aiff");
b.plot;

x = Synth.new(\playBuf, [\buf, b]);
)


~kontrol = Bus.control(s);
{Out.kr(~kontrol, MouseX.kr(0.5, 2.0).poll(1))}.play


x.map(\rate, ~kontrol)