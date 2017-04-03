(
Ndef(\pedestrian,  {
	SinOsc.ar(2500, 0, 0.2) * LFPulse.ar(5);
}).play
)

(
{
	var son;
	son = Klank.ar(`[
		[521, 732, 934],  // freqs
		[0.7, 0.45, 0.25],// amps
		[0.8, 0.8, 0.8]   // ring times
		]
	, Impulse.ar(1));
	Out.ar(0, Pan2.ar(son * 0.2));
}.play
)
(
x = {
	var son = WhiteNoise.ar(XLine.ar(1, 0.000001, 0.01, doneAction: 2)) * 0.1;
	Out.ar(0, Pan2.ar(son));
}.play
)

(
SynthDef(\dsaf_phonebell1, { |freq=465, strength=1, decay=3|
	var son;
	son = Klank.ar(`[
		// frequency ratios
		[0.501, 1, 0.7,   2.002, 3, 9.6,   2.49, 11, 2.571,  3.05, 6.242, 12.49, 13, 16, 24],
		// amps
		[0.002,0.02,0.001, 0.008,0.02,0.004, 0.02,0.04,0.02, 0.005,0.05,0.05, 0.02, 0.03, 0.04],
		// ring times - "stutter" duplicates each entry threefold
		[1.2, 0.9, 0.25, 0.14, 0.07].stutter(3)
		]
	, Impulse.ar(1), freq, 0, decay);
	Out.ar(0, Pan2.ar(son));
}).store
)
x = Synth(\dsaf_phonebell1, [\freq, 500]);

(
SynthDef(\dsaf_phonecase1, { |in=0, out=0, mix=0|
	var casein = In.ar(in, 2);

	var delayA = CombC.ar(casein, 0.00077, 0.00077, 0.1);
	var delayB = CombC.ar(delayA, 0.00088, 0.00088, 0.1);
	var bands = BPF.ar(delayB, [1243, 287, 431], 1/12).sum;
	var son = bands.clip2(0.3);

	ReplaceOut.ar(out, XFade2.ar(casein, son, mix))

}).add
)
y = Synth(\dsaf_phonecase1, target: x, addAction: \addAfter);