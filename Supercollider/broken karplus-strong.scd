(

{
	Pluck.ar(
		in:WhiteNoise.ar(0.25),
		trig:Impulse.kr(1),
		delaytime:60.midicps.reciprocal,
		maxdelaytime:60.midicps.reciprocal,
		decaytime:MouseY.kr(1, 20, 1),
		coef:MouseX.kr(-0.75, 0.75))
}.play;
)\


(

SynthDef(\ks,
	{
		|freq = 440, amp  =1, out = 0, thresh = -90, decrease = -0.25|
		var baseFreq = 48.midicps;
		var buf, index, sig, num=2, scale = decrease.dbamp;

		var samples = 44100/baseFreq;
		var actualValue;
		buf = LocalBuf(samples);
		buf.set(Array.fill(buf.numFrames, {2.0.rand - 1}));
		index = Phasor.ar(
			trig:Impulse.ar(buf.numFrames/SampleRate.ir),
			rate:freq/baseFreq,
			start:0,
			end: buf.numFrames,
			resetPos:0
		);

		actualValue = BufRd.ar(1, buf, index);
		Out.ar(out, actualValue*amp);
		DetectSilence.ar(actualValue, thresh.dbamp, 0.01, 2);
		sig = Array.fill(num, {|i| BufRd.ar(1, buf, index-1)}).sum/num*scale;
		BufWr.ar(sig, buf, index);
}).add;
)

k = Synth(\ks, [\freq, 300])