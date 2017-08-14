
(

b = Buffer.alloc(s, s.sampleRate * 1.0, 1);

SynthDef(\sin, {|freq = 100, buf|
	RecordBuf.ar(SinOsc.ar(freq), buf, loop:1)
}).add;

SynthDef(\perm, {
	|buf, permFreq = 10|
	var trig = Impulse.ar(permFreq);
	var startPos = LFSaw.ar(permFreq, iphase:1, mul:0.5, add:0.5);
	var periodInSamples = permFreq.reciprocal * SampleRate.ir;
	var sig = BufRd.ar(1, buf, Phasor.ar(trig, 1, startPos * periodInSamples, startPos *periodInSamples * 2, startPos * periodInSamples));
	Out.ar(0, sig);
}).add;
)


x = Synth(\sin, [\buf, b]);
y = Synth.after(x, \perm, [\buf, b]);


~k = Bus.control
~k = {MouseX.kr(10, 2000)}.play
y.map(\permFreq, ~k )
x.set(\freq, 500);
y.set(\permFreq, 20000/64)
s.scope