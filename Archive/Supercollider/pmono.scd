(
SynthDef(\sawpulse, {
	|out, freq = 440, gate = 0.5, plfofreq = 6, mw = 0, ffreq = 2000, rq = 0.3, freqlag = 0.05, amp = 1|
	var sig, plfo, fcurve;
	plfo = SinOsc.kr(plfofreq, mul:mw, add:1);
	freq = Lag.kr(freq, freqlag) * plfo;
	fcurve = EnvGen.kr(Env.adsr(0, 0.3, 0.1, 20), gate);
	fcurve = (fcurve - 1).madd(0.7, 1) * ffreq;
	sig = Mix.ar([Pulse.ar(freq, 0.9), Saw.ar(freq*1.007)]);
	sig = RLPF.ar(sig, fcurve, rq)   * EnvGen.kr(Env.adsr(0.04, 0.2, 0.6, 0.1), gate, doneAction:2)   * amp;
	Out.ar(out, sig ! 2) }).add;

)

(
p = PmonoArtic(\sawpulse,
	\midinote, Pseq([84, 85, 84, 84, 88, 84, 83, 81, 83, 81, 78, 76, 81, 83], 1),
	\dur, Pseq(#[0.125, 0.535, 0.67, 1.92, 0.25, 0.166, 0.167, 0.167, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25], 1),
	\sustain, Pseq(#[0.2, 3.12, 0.2, 0.2, 0.2, 0.2, 0.2, 0.15, 0.3, 0.2, 0.2, 0.2,     0.3, 0.2], 1),
	\amp, Pseq(#[1, 0.8, 0.8, 0.8, 1, 1, 0.8, 0.8, 1, 0.8, 0.8, 0.8,     1, 0.8], 1),
	\mw, Pseq([0, 0.005, 0.005, 0.06, Pseq(#[0], 10)], 1)  )
)

Synth(\sawpulse)

().play