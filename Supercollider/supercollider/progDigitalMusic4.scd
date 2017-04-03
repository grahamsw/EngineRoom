~fname = Platform.resourceDir ++ "/" ++ "sounds/a11wlk01-44_1.aiff";

File.exists(~fname)

SoundFile.use(~fname, {|f| f.inspect})
SoundFile.use(~fname, {|f| f.sampleRate})

(
b = Buffer.cueSoundFile(s, ~fname, 0,1, pow(2, 16));
//p = {DiskIn.ar(1, b, 1)}.play;
)
(
p.release;
b.close;
b.free;
)
b.sampleRate
BufRateScale.ir(b.bufnum)

(
b = Buffer.read(s, ~fname);
x = {PlayBuf.ar(b.numChannels, b.bufnum, BufRateScale.ir(b.bufnum) ,loop:1)}.play;
)

(
SynthDef(\monoSampleTranspose, {|bufnum = 0, tpose = 0|
	var rate, ptr, output;
	rate = BufRateScale.ir(bufnum) * pow(2, tpose/12);
	ptr = Phasor.ar(0, rate, 0, BufFrames.ir(bufnum));
	output = BufRd.ar(1, bufnum, ptr, 1, 4);
	Out.ar(0, output)
}).add;
)

(
y = Synth(\monoSampleTranspose, [\bufnum, b.bufnum]);
t = 2;
y.set(\tpose, t);
)


y.free;b.close;b.free;

{BufRd.ar(1, b.bufnum, Phasor.ar(0, BufRateScale.ir(b.bufnum), b.numFrames/2, b.numFrames), 0)}.play

pow(2,24)/44100/60
~fname
b.bufnum
{Phasor.ar(0, 0.1, 0, 10)}.plot(1000/44100);