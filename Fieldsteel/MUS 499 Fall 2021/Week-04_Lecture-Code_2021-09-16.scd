(
f = {
	var sig;
	sig = [
		SinOsc.ar(257),
		SinOsc.kr(257)
	];
	sig = sig * 0.15;
}.plot(0.03);
)

s.sampleRate;

s.options.blockSize / s.sampleRate;

(
f = {
	var sig, mod, modhz;
	modhz = MouseX.kr(1, 4000, 1).poll;
	mod = SinOsc.kr(modhz).bipolar(400);
	sig = SinOsc.ar(500 + mod);
	sig = sig * 0.2;
}.play;
)

///////////////////

(
f = {
	var sig;
	sig = Saw.ar([40,40.5]);
	sig = sig * 0.2;
}.play;
)

FreqScope.new;

(
f = {
	var sig, filt;
	filt = MouseX.kr(20, 20000, 1).poll;
	filt = filt.clip(20, 20000);
	sig = Saw.ar([40, 40.5]);
	sig = RHPF.ar(sig, filt, 0.04, 0.4);
	sig = sig * 0.3;
}.play;
)

FreqScope.new;

(
SynthDef.new(\pansynth, {
	arg out=0;
	var sig, pan;
	pan = SinOsc.ar(0.2).bipolar(1);
	sig = PinkNoise.ar(1);
	sig = BPF.ar(sig, 1000, 0.1, 4);
	sig = sig * LFPulse.kr(8);
	sig = Pan2.ar(sig, pan, 0.8);
	Out.ar(out, sig);
}).add;
)

Synth.new(\pansynth);

(
SynthDef.new(\pansynth, {
	arg out=0;
	var sig, pan;
	pan = SinOsc.ar(0.2).bipolar(1);
	sig = [Saw.ar(40, mul:0.1), PinkNoise.ar(0.3)];
	sig = Balance2.ar(sig[0], sig[1], pan);
	Out.ar(out, sig);
}).add;
)

Synth.new(\pansynth);

(
SynthDef.new(\pansynth, {
	arg out=0;
	var sig, pan;
	pan = SinOsc.ar(0.2).bipolar(0.5);
	sig = Saw.ar(
		Array.exprand(50, 40, 3000)
	);
	sig = LPF.ar(sig, 4000);
	sig = Splay.ar(sig) * 0.2;
	sig = Balance2.ar(sig[0], sig[1], pan);
	Out.ar(out, sig);
}).add;
)

Synth.new(\pansynth);