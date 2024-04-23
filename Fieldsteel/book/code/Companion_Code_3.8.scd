// Companion Code 3.8
// Wavetable Experiments with Shaper

// This first example applies a gentle clipping effect to a sine wave, producing a harmonically richer spectrum. The 'waveFill' method is discussed in Companion Code 3.6. This wavetable also appears in Figure 3.6 in the book.

s.boot;

(
~wt = Signal.newClear(8193);
~wt.waveFill(
	{
		arg ival, old, index;
		ival.abs.pow(1/2) * ival.sign;
	}, -1, 1
);
b = Buffer.loadCollection(s, ~wt.asWavetableNoWrap);
~wt.plot;
)

(
x = {
	var sig, index;
	index = SinOsc.ar(200);
	sig = Shaper.ar(b, index);
	sig = sig * 0.2 ! 2;
}.play;

s.scope(zoom:0.71);
FreqScope.new;
)

x.release(2);

// Shaper can be configured to behave like Osc by using a periodic linear ramp as the input signal. When doing so, the contents of Shaper's wavetable (in the following example, a pure sine) will be retrieved and reproduced as-is. With this approach, we are treating the buffer not so much as a waveshaping transfer function, but as a conventional wavetable that represents one cyclic shape of an oscillator.

(
~wt = Signal.sineFill(8193, [1], [0]);
b = Buffer.loadCollection(s, ~wt.asWavetableNoWrap);
)

(
x = {
	var sig, index;
	index = LFSaw.ar(200);
	sig = Shaper.ar(b, index);
	sig = sig * 0.2 ! 2;
}.play;
)

x.release(2);

// The advantage of this approach over simply using Osc is that we have direct control over the shape and type of index signal that reads from the wavetable. For example, we can gently bend LFSaw using 'lincurve', plotted here for visualization:

{ LFSaw.ar(200).lincurve(-1, 1, -1, 1, 2) }.plot(1 / 50);

// When deployed as an index signal for Shaper, the rate at which table values are retrieved accelerates over the course of each cycle. This has a "warping" effect on the contents of the wavetable:

(
x = {
	var sig, index;
	index = LFSaw.ar(200);
	index = index.lincurve(-1, 1, -1, 1, 2);
	sig = Shaper.ar(b, index);
	sig = sig * 0.2 ! 2;
}.play;

s.scope(zoom: 0.71);
FreqScope.new;
)

x.release(2);

// The arguments of lincurve are modulatable. In the following example, we sweep the curve parameter up and down, causing the time-warping effect on the wavetable to alternate between gentle and extreme.

// Note: the lincurve operation is unstable for curve values close to zero, because it involves dividing by extremely small values (which produces extremely large values). The UGen implementation antitcipates this, but may not be able to properly do so if the signal being processed and the signal controlling the curve value are not being calculated at the same rate. For this reason, the LFSaw and LFTri in the following code are both running at the audio rate (loud amplitude pops may occur if LFTri runs at the control rate).

(
x = {
	var sig, index, curve;
	index = LFSaw.ar(200);
	curve = LFTri.ar(0.2, 3).exprange(0.5, 30);
	index = index.lincurve(-1, 1, -1, 1, curve);
	sig = Shaper.ar(b, index);
	sig = sig * 0.2 ! 2;
}.play;

s.scope(zoom: 0.71);
FreqScope.new;
)

x.release(2);

// LFSaw is one of many options for an index signal. Just about any audio-rate signal with a range between ±1 will produce some audible result. LFTri, for example, will read the wavetable forwards and backwards on each cycle. Without further changes to the triangle index, the resulting wave will be a sine wave with reversed cycles interleaved between normal cycles:

(
x = {
	var sig, index;
	index = LFTri.ar(200);
	sig = Shaper.ar(b, index);
	sig = sig * 0.2 ! 2;
}.play;

s.scope(zoom: 0.71);
FreqScope.new;
)

x.release(2);

// A similarly creative modification can be made to LFTri, such as taking the square root of the waveform, plotted here for visualization. Note that for audio signals, the square root function has the special definition sqrt(abs(val)) * val.sign, to avoid dealing with complex numbers or undefined values.

{ LFTri.ar(200).sqrt }.plot(1/50);

// A similar "warping" effect is produced when used as the index signal for Shaper:

(
x = {
	var sig, index;
	index = LFTri.ar(200).sqrt;
	sig = Shaper.ar(b, index);
	sig = sig * 0.2 ! 2;
}.play;

s.scope(zoom: 0.71);
FreqScope.new;
)

x.release(2);

// For a dynamic effect, we can rewrite the sqrt() function as pow(1/root), and modulate the root value (making sure to keep it greater than zero:

(
x = {
	var sig, index, root;
	root = LFTri.kr(0.3, 3).exprange(0.1, 10);
	index = LFTri.ar(80).pow(1 / root);
	sig = Shaper.ar(b, index);
	sig = sig * 0.2 ! 2;
}.play;

s.scope(zoom: 0.427);
FreqScope.new;
)

x.release(2);

// Even a noise generator can be used as an index signal, which will produce some flavor of noise, depending on the content of the wavetable and type of input noise. Here, the multichannel expansion step has been moved to the noise generator's frequency argument, producing two independent channels of noise. The amplitude has also been adjusted to compensate for a perceived increase in loudness:

(
x = {
	var sig, index;
	index = LFNoise1.ar(3000 ! 2);
	sig = Shaper.ar(b, index);
	sig = sig * 0.05;
}.play;

s.scope(zoom: 0.71);
FreqScope.new;
)

x.release(2);

// One of the more interesting things that can be done with Shaper involves using its own output as an index signal into a second instance of Shaper. For the sake of comparison, we begin with the normal usage of reading a sine table using a periodic linear ramp:

(
x = {
	var sig, index;
	index = LFSaw.ar(200);
	sig = Shaper.ar(b, index);
	sig = sig * 0.2 ! 2;
}.play;

s.scope(zoom: 0.71);
FreqScope.new;
)

x.release(2);

// We can then use the sinusoidal output as the index into a second Shaper, reading from the same wavetable, thus reading a sine table in sinusoidal fashion:

(
x = {
	var sig, index;
	index = LFSaw.ar(200);
	sig = Shaper.ar(b, index);
	sig = Shaper.ar(b, sig);
	sig = sig * 0.2 ! 2;
}.play;

s.scope(zoom: 0.71);
FreqScope.new;
)

x.release(2);

// Iteration allows us to concisely express repeated application of this technique. The results become chaotic fairly quickly, and will vary depending on the type of index signal, and the contents of the transfer function buffer.

(
x = {
	var sig, index;
	index = LFSaw.ar(200);
	sig = Shaper.ar(b, index);
	4.do({ sig = Shaper.ar(b, sig) });
	sig = sig * 0.1!2;
}.play;

s.scope(zoom: 0.71);
FreqScope.new;
)

x.release(2);

// For adventurous coders seeking unbridled chaos, we can use LocalIn and LocalOut to establish a local feedback path, continuously using the waveshaped output as its own index signal (LocalIn/LocalOut also appear near the end of Companion Code 3.5, in the context of feedback FM synthesis). The technique here is similar, but we can supply any transfer function and any index signal. For a bit of extra fun, the horizontal mouse position controls the frequency of the raw index signal.

(
x = {
	var sig, index;
	index = LocalIn.ar(2);
	index = index + LFSaw.ar(MouseX.kr(0.1, 2000, 1));
	sig = Shaper.ar(b, index);
	LocalOut.ar(sig);
	sig * 0.1;
}.play;
)

x.release(2);

// Returning to more conventional uses of Shaper, the following code creates a curvy and complex transfer function using Env. This transfer function loosely resembles the line y = x, but includes random sinusoidal variations along the way.

(
~wt = Env.new(
	levels: [-1] ++ Array.rand(5, -1.0, -0.1) ++ [0] ++ Array.rand(5, 0.1, 1.0) ++ [1],
	times: Array.exprand(12, 0.2, 0.8),
	curve: \sine
).asSignal(8193);
b = Buffer.loadCollection(s, ~wt.asWavetableNoWrap);
~wt.plot;
)

// We are already familiar with the general effect of applying a waveshaping transfer function: the input wave is translated into a new shape, using the transfer function as an input/output map. In this case, a sine wave input emerges with a sort of "imprint" of the transfer function:

(
x = {
	var sig, index;
	index = SinOsc.ar(200);
	sig = Shaper.ar(b, index);
	sig = sig * 0.15!2;
}.play;

s.scope(zoom: 1.422);
FreqScope.new;
)

x.release(2);

// An interesting and easily overlooked side-effect of complex transfer functions is that the spectrum of the waveshaped output signal does not uniformly scale with the amplitude of the input signal. In other words, if we vary the amplitude of the input signal, we are likely to see a sort of morphing effect as the amplitude of the index signal fluctuates. Here, the amplitude of the sinusoidal index grows from 0.1 to 1 over five seconds. The output signal may include DC bias at lower amplitudes, due to the random nature of the transfer function, so LeakDC is included.

(
x = {
	var sig, index;
	index = SinOsc.ar(200) * XLine.kr(0.1, 1, 5);
	sig = Shaper.ar(b, index);
	sig = LeakDC.ar(sig);
	sig = sig * 0.2 ! 2;
}.play;

s.scope(zoom: 1.422);
FreqScope.new;
)

x.release(2);

// For comparison, if we apply the amplitude modulation after waveshaping has occurred, then the spectrum scales in a more predictably uniform (and boring) manner:

(
x = {
	var sig, index;
	index = SinOsc.ar(200);
	sig = Shaper.ar(b, index);
	sig = sig * XLine.kr(0.1, 1, 5);
	sig = sig * 0.2 ! 2;
}.play;

s.scope(zoom: 1.422);
FreqScope.new;
)

x.release(2);

// Modulating the amplitude of the index signal presents a unique dimension for creative exploration. To conclude, we create a set of four unique but similar wavetables:

(
~wt = 4.collect({
	var table;
	table = Env.new(
		levels: [-1] ++ Array.rand(5, -1.0, -0.1) ++ [0] ++ Array.rand(5, 0.1, 1.0) ++ [1],
		times: Array.exprand(12, 0.2, 0.8),
		curve: \sine
	);
	table = table.asSignal(8193);
});
~buf = ~wt.collect({
	arg table;
	Buffer.loadCollection(s, table.asWavetableNoWrap);
});
)

// (optional) plot these wavetables:
~wt.do({ |table| table.plot });

// Next, we create a SynthDef based on Shaper, featuring multichannel expansion, a frequency detuning effect, a random amplitude modulation applied to the waveshaping input, and an overall amplitude envelope. LeakDC is included again to compensate for DC offset.

(
SynthDef(\shaper, {
	arg buf, freq = 200, atk = 2, rel = 5, amp = 0.2, out = 0;
	var sig, index, env, freqs, amps;
	env = EnvGen.kr(
		Env.new([0, 1, 0], [atk, rel], [1, -3]),
		doneAction:2
	);
	freqs = freq * { ExpRand(0.99, 1.01) }.dup(8);
	amps = LFNoise1.kr({ Rand(0.1, 0.2) }.dup(8)).exprange(0.1, 1);
	index = SinOsc.ar(freqs, mul: amps);
	sig = Shaper.ar(buf, index);
	sig = Splay.ar(sig) * env * amp;
	sig = LeakDC.ar(sig);
	Out.ar(out, sig);
}).add;
)

// The essential sound of this SynthDef is a tone with a lively spectrum:
Synth(\shaper, [buf: ~buf.choose]);

// Using iteration and specific pitch choices, we can create a lush harmonic texture. Each evaluation produces a unique cluster chord, each containing 4 to 8 notes, spaced by 5 or 7 semitones.

(
Array.series(rrand(4, 8), rrand(45, 65), [5, 7].choose).do({ |n, i|
	Synth(
		\shaper,
		[
			buf: ~buf.choose,
			freq: n.midicps,
			amp: 0.4 / ((i + 1) * 2),
			atk: exprand(2, 3),
			rel: exprand(5, 8),
		]
	);
});
)