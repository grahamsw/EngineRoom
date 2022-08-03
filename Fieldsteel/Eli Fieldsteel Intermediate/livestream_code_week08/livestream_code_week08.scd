fft (language-side) vs. FFT (server-side)

fft (language-side):

(
//one cycle of a periodic wave with a simple but custom spectrum
~size = 2048;
~sig = Signal.sineFill(
	~size,
	[1, 0, 0.5, 0, 0.5, 0.25, 0, 0.1],
	[0, 0, pi/2, 0, pi, 0, 0, pi],
);
)

~sig.plot;

(
//apply an FFT to the signal
~imag = Signal.newClear(~size);
~cosTable = Signal.fftCosTable(~size);
~complex = fft(~sig, ~imag, ~cosTable);
)

(
//take a look!
//magnitudes and phases have been adjusted to better reflect the original data
plot(
	[
		~complex.magnitude[1..15].normalize * ~sig.peak, //magnitudes normalized & scaled
		~complex.phase[1..15] + (pi/2) % 2pi //cos -> sin
	],
	bounds:Rect(900,400,800,600)
).plotMode_(\bars);
)

s.boot;

b = Buffer.read(s, PathName(thisProcess.nowExecutingPath).parentPath ++ "delay.aiff");

b.play;
b.free;

//a real time FFT takes little segments of audio one at a time, each a power-of-two sample size, and pretends it is one cycle of a periodic wave
b = Buffer.read(s, PathName(thisProcess.nowExecutingPath).parentPath ++ "delay.aiff", 48000 * 0.32, 2048);

b.play;
b.plot;

(
//fill Signal with Buffer contents using getn & waveFill
~sig = Signal.newClear(~size);
b.getn(0, ~size, {arg frames; ~sig.waveFill({arg val,old,index; frames[index]})});
)

~sig.plot;

(
//calculate the FFT (and also capture magnitude/phase data)
Window.closeAll;
~imag = Signal.newClear(~size);
~cosTable = Signal.fftCosTable(~size);
~complex = fft(~sig, ~imag, ~cosTable);
~mag = ~complex.magnitude.normalize * ~sig.peak;
~phs = ~complex.phase + (pi/2) % (2pi);
)

(
//view magnitude/phase data for n bins
var n=50;
plot(
	[
		~mag[0..n+1],
		~phs[0..n+1],
	],
	bounds:Rect(1100,600,800,400),
	minval:[0,0], maxval:[~sig.peak,2pi]
).plotMode_(\bars);
)

(
//view some number of individual harmonics (equal to size) and their sum. as size increases, watch how the sine sum gradually becomes identical to the original time domain segment
//note that very high values of size (e.g. > 200 or so) will take a significant amount of time to calculate — our approach is very inefficient but allows us to see the FFT in "slow motion"
var size=200, harmonics;
harmonics = Array.fill(size, {
	arg n;
	var amps = [1] ++ (0!(size-1));
	Signal.sineFill(~size, amps.rotate(n), [~phs[n+1]])
	* ~mag[n+1] * -2.dbamp //scaling each signal by some roughly approximate amount
});

harmonics = harmonics.clump(8);

harmonics.do({
	arg setOf8, i;
	setOf8.plot(
		name: (asString((i*8)+1)++"-"++asString((i*8)+8)),
		bounds: Rect(i*200,0,200,Window.screenBounds.height),
		minval:-1,
		maxval:1
	);
});

~sum = harmonics.flatten[0..size].sum;
~sum.plot(minval:-1, maxval:1);
)

//clean up!
Window.closeAll;

//////////////////////////////////////////

FFT (server-side):

Buffer.freeAll;

~buf = Buffer.read(s, PathName(thisProcess.nowExecutingPath).parentPath ++ "delay.aiff");

//"brickwall filter"
(
SynthDef(\brickwall, {
	var sig, chain, size=2048;
	sig = PlayBuf.ar(1, \buf.kr(0), BufRateScale.ir(\buf.kr(0)), loop:1);
	chain = FFT(LocalBuf(size), sig);
	chain = PV_BrickWall(chain, \wipe.kr(0));
	sig = IFFT(chain) * \amp.kr(0.5)!2;
	Out.ar(\out.kr(0), sig);
}).add;
)

x = Synth(\brickwall, [\buf, ~buf, \wipe, 0]);
x.set(\wipe, -0.92); //low pass
x.set(\wipe, 0.04); //high pass

//"brickwall filter" with more intuitive arguments
(
SynthDef(\brickwall, {
	var sig, chain, size=2048;
	sig = PlayBuf.ar(1, \buf.kr(0), BufRateScale.ir(\buf.kr(0)), loop:1);
	chain = FFT(LocalBuf(size), sig);

	chain = PV_BrickWall(chain, \lpf.kr(20000).linlin(20,20000,-1,0));
	chain = PV_BrickWall(chain, \hpf.kr(20).linlin(20,20000,0,1));

	sig = IFFT(chain) * \amp.kr(0.5)!2;
	Out.ar(\out.kr(0), sig);
}).add;
)

x = Synth(\brickwall, [\buf, ~buf]);
x.set(\hpf, 600, \lpf, 3000);
x.free;

x = 4.collect({ Synth(\brickwall, [\buf, ~buf, \amp, -18.dbamp]) });

(
//four different brickwall bandpass filters
x[0].set(\hpf, 100, \lpf, 150);
x[1].set(\hpf, 400, \lpf, 750);
x[2].set(\hpf, 1600, \lpf, 3000);
x[3].set(\hpf, 7000, \lpf, 15000);
)

FreqScope.new; //^^ to see four bands more clearly

(
SynthDef(\scramble, {
	var sig, chain, size=2048;
	sig = PlayBuf.ar(1, \buf.kr(0), BufRateScale.ir(\buf.kr(0)), loop:1);
	chain = FFT(LocalBuf(size), sig);
	chain = PV_BinScramble(chain, \wipe.kr(0), \width.kr(0), \trig.tr(0));
	sig = IFFT(chain) * \amp.kr(0.5)!2;
	Out.ar(\out.kr(0), sig);
}).add;
)

x = Synth(\scramble, [\buf, ~buf]);
x.set(\wipe, 1, \width, 0.01, \trig, 1);
x.free;

//see PV_ChainUGen for descriptions of pvcalc, pvcalc2, and pvcollect
//these are "choose your own adventure" server-side FFT methods which allow custom procesing of magnitudes and phases, and even individual processing on each bin!

//these three methods tend to create very big SynthDefs that require a lot of processing power! the PV_ChainUGen help file includes tips for optimizing the processing requirements.

(
SynthDef(\pvcalc, {
	var sig, chain, size=2048;
	sig = PlayBuf.ar(1, \buf.kr(0), BufRateScale.ir(\buf.kr(0)), loop:1);
	chain = FFT(LocalBuf(size), sig);
	chain = chain.pvcalc(size, {
		arg mag, phs;
		mag = mag.rotate(-9); //rotate magnitudes
		[mag, phs];
	});
	sig = IFFT(chain) * \amp.kr(0.5)!2;
	Out.ar(\out.kr(0), sig);
}).add;
)

//open FreqScope.new; to more easily "see" the bin rotation
//with a negative rotation, energy at each bin shifts a bit lower on the spectrum, and the very lowest bins appear at the very top
x = Synth(\pvcalc, [\buf, ~buf]);

(
SynthDef(\pvcalc, {
	var sig, chain, size=2048;
	sig = PlayBuf.ar(1, \buf.kr(0), BufRateScale.ir(\buf.kr(0)), loop:1);
	chain = FFT(LocalBuf(size), sig);
	chain = chain.pvcalc(size, {
		arg mag, phs;
		//apply some randomness to magnitudes and phases
		mag = mag * ({Rand(-20.dbamp, 3.dbamp)}!(mag.size));
		phs = phs + ({rrand(0,2pi)}!(phs.size));
		[mag, phs];
	});
	sig = IFFT(chain) * \amp.kr(0.5)!2;
	Out.ar(\out.kr(0), sig);
}).add;
)

x = Synth(\pvcalc, [\buf, ~buf]);

//pvcalc2 allows processing on the magnitudes and phases of two different FFT chains

(
//basic vocoder effect, i.e. daft punk, imogen heap, etc
SynthDef(\pvcalc2, {
	var sig, sig2, chain, chain2, size=1024;
	sig = PlayBuf.ar(1, \buf.kr(0), BufRateScale.ir(\buf.kr(0)), loop:1);
	sig2 = Saw.ar([40,47,52,56,58,61,63].midicps * \trnsp.kr(0).midiratio, 0.05).sum;
	chain = FFT(LocalBuf(size), sig);
	chain2 = FFT(LocalBuf(size), sig2);
	chain = chain.pvcalc2(chain2, size, {
		arg mag, phs, mag2, phs2;
		mag = (mag * \blend.kr(1)) + (mag2 * (1-\blend.kr(1)));
		[mag, phs2];
	});
	sig = IFFT(chain) * \amp.kr(0.2)!2;
	Out.ar(\out.kr(0), sig);
}).add;
)

//phase vocoder effect (combining magnitudes of modulator signal with phases of carrier signal)
x = Synth(\pvcalc2, [\buf, ~buf]);
x.set(\trnsp, rrand(-2,14)); //transposition
x.set(\blend, 0.8); //magnitude crossfade
x.set(\blend, 0.5);


(
//one kind of spectral morph (suggested by Demetris)
//use low bins from one FFT, and high bins from another FFT
//using two BrickWall filters
SynthDef(\morph, {
	var sig, sig2, chain, chain2, size=2048;
	var cf = \cf.kr(20);
	sig = PlayBuf.ar(1, \buf.kr(0), BufRateScale.ir(\buf.kr(0)), loop:1);
	chain = FFT(LocalBuf(size), sig);
	//HPF
	chain = PV_BrickWall(chain, cf.linlin(20,20000,-1,0));
	sig = IFFT(chain);

	sig2 = Saw.ar([40,47,52,56,58,61,63].midicps * \trnsp.kr(0).midiratio, 0.05).sum;
	chain2 = FFT(LocalBuf(size), sig2);
	//HPF
	chain2 = PV_BrickWall(chain2, cf.linlin(20,20000,0,1));
	sig2 = IFFT(chain2);

	sig = sig + sig2;
	sig = sig * \amp.kr(0.2)!2;
	Out.ar(\out.kr(0), sig);
}).add;
)

x = Synth(\morph, [\cf, 20000]);
x.set(\cf, 5000); //sawtooth above 5k, talking below 5k
x.set(\cf, 2000);
x.set(\cf, 500);
x.set(\cf, 100);
x.set(\cf, 20);
//try replacing \cf.kr(20) with MouseX.kr(20,20000,1) for one type of manual modulation!
x.free;

//this is not a particularly intersting use of pvcollect because it doesn't incorporate the bin number...see the helpfile for other ideas
(
SynthDef(\pvcollect, {
	var sig, sig2, chain, chain2, size=1024;
	sig = PlayBuf.ar(1, \buf.kr(0), BufRateScale.ir(\buf.kr(0)), loop:1);
	chain = FFT(LocalBuf(size), sig);
	chain = chain.pvcollect(size, {
		arg mag, phs, bin;
		//each magnitude is modulated by a random sine wave LFO
		mag = mag * SinOsc.kr(Rand(0.3,0.8), Rand(0,2pi)).exprange(0.01,1);
		[mag, phs];
	});
	sig = IFFT(chain) * \amp.kr(1)!2;
	Out.ar(\out.kr(0), sig);
}).add;
)

x = Synth(\pvcollect, [\buf, ~buf]);
x.free;

