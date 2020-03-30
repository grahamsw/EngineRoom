(
Ndef(\transmed, {
	var sig = Ndef(\phonesource).ar.clip2(0.9);
	sig = BPF.ar(sig, 2000, 1/12);
	sig =
		BPF.ar(sig * 0.5, 400, 1/3)
		+
		(sig.clip2(0.4) * 0.15);
	HPF.ar(HPF.ar(sig, 90), 90) * 100;
}).play
)

(
Ndef(\phonesource, {
	var onoff;
	onoff = if(MouseX.kr > 0.2, 1, 0);
	SinOsc.ar([350, 440], 0, onoff).sum * 0.2
})
)

(
Ndef(\phonesource, {
	var onoff;
	onoff = LFPulse.ar(1/6, width: 1/3);
	SinOsc.ar([480, 440], 0, onoff).sum * 0.2
})
)

(
Ndef(\phonesource, { |t_trig=0, number=0|
	var onoff, trigs, son;
	number = if(number < 0.5, 10, number); // zero is represented by 10 clicks!
	onoff = Trig1.ar(t_trig, number * 0.1);
	trigs = Impulse.ar(10) * onoff;
	son = Trig1.ar(trigs, 0.04);
	son;
});
)
// ...then dial some numbers by repeatedly running this line:
Ndef(\phonesource).set(\t_trig, 1, \number, 10.rand.postln);

(
// This data structure (like a "hashtable" or "associative array" in other languages)
// maps from a phone key to a pair of frequencies in Hz.
// We can push these frequencies to a synth.
~tbl = IdentityDictionary[
	$1 -> [[697, 1209]],
	$2 -> [[770, 1209]],
	$3 -> [[852, 1209]],
	$4 -> [[697, 1336]],
	$5 -> [[770, 1336]],
	$6 -> [[852, 1336]],
	$7 -> [[697, 1477]],
	$8 -> [[770, 1477]],
	$9 -> [[852, 1477]],
	$* -> [[697, 1633]],
	$0 -> [[770, 1633]],
	$# -> [[852, 1633]],
	$A -> [[941, 1209]],
	$B -> [[941, 1336]],
	$C -> [[941, 1477]],
	$D -> [[941, 1633]]
];

// Here we define a SynthDef which plays a single "number" at a time.
// Note that our strategy here is a bit different from the PD code in the book:
//   there, a single pair of sine-wave oscillators was re-used for each number,
//   whereas here, we create (and later free) an individual synth for each number.
SynthDef(\dtmf, {|freq=#[770, 1633], out=0, amp=0.2, gate=1|
	var son, env;
	son = SinOsc.ar(freq, 0, amp).sum;
	env = EnvGen.ar(Env.asr(0.001, 1, 0.001), gate, doneAction: 2);
	Out.ar(out, Pan2.ar(son * env * amp));
}).add;
)


// Check that it works:
x = Synth(\dtmf) // create


x.set(\gate, 0)  // free



(
// You could even dial a specific number:
Pbind(
	\instrument, \dtmf,
	\dur,  Pwhite(0.2, 0.3, inf),
	\sustain, 0.15,
	\amp, 0.3,
	\freq, Pseq("6466237918".collectAs({|digit| ~tbl[digit] }, Array))
).play;
)




(
Ndef(\alarm, {
	var tone1 = SinOsc.ar(600);
	var tone2 = SinOsc.ar(800);
	// We switch between the tones using LFPulse, but soften the crossfade with the low-pass:
	var control = LPF.kr(LFPulse.kr(2), 70);
	var out = SelectX.ar(control, [tone1, tone2]);
	Pan2.ar(out * 0.1)
}).play
)




(
Ndef(\alarm, {
	var tone1 = SinOsc.ar(723);
	var tone2 = SinOsc.ar(932);
	var tone3 = SinOsc.ar(1012);
	// Stepper is perfect for stepping through the options:
	var control = LPF.kr(Stepper.kr(Impulse.kr(2), 0, 0, 2), 70);
	var out = SelectX.ar(control, [tone1, tone2, tone3]);
	Pan2.ar(out * 0.1)
}).play
)


(
Ndef(\alarm, {
	var freq, out, operations;
	freq = Duty.kr(0.05, 0, Dseq([723, 932, 1012], inf));
	freq = LPF.kr(freq, 70);
	out = SinOsc.ar(freq);
	operations = [out, (out * pi).sin, (out * pi).cos, ((out+0.25) * pi).cos];
	out = Select.ar(MouseX.kr(0,4).poll, operations);
	Pan2.ar(out * 0.1)
}).play
)


(
SynthDef(\dsaf_multialarm, {
	|length=0.05, freqs=#[600,800,600,800], timbre=1, repeats=inf|
	var freq, out, operations;
	freq = Duty.ar(length, 0, Dseq(freqs, repeats), doneAction: 2);
	freq = LPF.ar(freq, 70);
	out = LeakDC.ar(SinOsc.ar(freq));
	out = Select.ar(timbre, [out, (out * pi).sin, (out * pi).cos, ((out+0.25) * pi).cos]);
	// NOTE: when writing a synthdef always remember the Out ugen!
	// (Handy shortcuts like Ndef and {}.play often add Out on your behalf)
	Out.ar(0, Pan2.ar(out * 0.1))
}).add;
)

// happy blips
Synth(\dsaf_multialarm, [\length, 0.1, \freqs, [349, 0, 349, 0], \timbre, 1, \repeats, 1]);
// affirmative
Synth(\dsaf_multialarm, [\length, 0.1, \freqs, [238, 0, 317, 0], \timbre, 2, \repeats, 1]);
// activate
Synth(\dsaf_multialarm, [\length, 0.02, \freqs, [300, 125, 0, 0], \timbre, 2, \repeats, 10]);
// invaders?
Synth(\dsaf_multialarm, [\length, 0.03, \freqs, [360, 238, 174, 158], \timbre, 1]);
// information
Synth(\dsaf_multialarm, [\length, 0.05, \freqs, [2000, 2010, 2000, 2010], \timbre, 1, \repeats, 6]);
// message alert
Synth(\dsaf_multialarm, [\length, 0.15, \freqs, [619, 571, 365, 206], \timbre, 1, \repeats, 2]);
// finished
Synth(\dsaf_multialarm, [\length, 0.15, \freqs, [365, 571, 619, 206], \timbre, 3, \repeats, 1]);
// error code
Synth(\dsaf_multialarm, [\length, 0.01, \freqs, [1000, 0, 1000, 0], \timbre, 3, \repeats, 30]);
// wronnnnnnnnnng
(
Pbind(
	\instrument, \dsaf_multialarm,
	\freqs, [[1000, 476, 159, 0]],
	\timbre, 2,
	\repeats, 25,
	\length, Pseq([0.003, 0.005]),
	\dur, 0.5
).play
)




