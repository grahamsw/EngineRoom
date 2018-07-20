
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
(
SynthDef(\noOp, {
	|soundBuf, out= 0|
	var in, chain;
	var fftBuf = LocalBuf(2048, 1);
	in = PlayBuf.ar(1, soundBuf, loop:1);
	chain = FFT(fftBuf, in);
	Out.ar(out, IFFT(chain));
}).add;
)
Synth(\noOp, [\soundBuf, b])

)



b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

s.freqscope;
s.scope;

(SynthDef(\fftShift, {
	|soundbuf|
	var in, chain;
	var fftBuf = LocalBuf(2048, 1);
	in = PlayBuf.ar(1, soundbuf, loop:1);
	chain = FFT(fftBuf, in);

	chain = PV_BinShift(chain, 1, MouseX.kr(-128, 128));
	Out.ar(0, 0.5 * IFFT(chain).dup);
}).play(s, [\soundbuf, b]);
)