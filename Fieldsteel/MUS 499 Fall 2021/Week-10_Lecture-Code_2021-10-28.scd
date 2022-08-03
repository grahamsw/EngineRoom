s.boot;

//MIDIClient.init;
MIDIIn.connectAll;

MIDIFunc.trace(true);
MIDIFunc.trace(false);

(
SynthDef(\tri, {
	arg freq=200, harm=8, rel=0.6, amp=0.1, out=0;
	var sig, env;
	sig = {Saw.ar(freq * Rand(-0.2, 0.2).midiratio)}!8;
	sig = Splay.ar(sig);
	sig = RLPF.ar(sig, (freq * harm).clip(20,20000), 0.5);
	env = EnvGen.ar(Env.perc(0.001, rel), doneAction:2);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

(
r = Routine({
	loop{
		Synth(\tri, [
			\freq, rrand(40,90).nearestInScale([0,3,5,7,9,10]).midicps,
			\harm, exprand(4,20),
			\amp, exprand(0.02, 0.1),
		]);
		0.16.wait;
	}
}).play;
)

r.stop;

(
MIDIdef.noteOn(\on, {
	arg val, num, chan, src;
	Synth(\tri, [
		\freq, num.midicps,
		\harm, val.lincurve(0,127,1,40,9),
		\amp, val.linlin(0,127,-40, -12).dbamp,
	]);
});
)

(
SynthDef(\tri, {
	arg freq=200, harm=8, rel=0.6, amp=0.1, gate=1, out=0;
	var sig, env;
	sig = {Saw.ar(freq * Rand(-0.2, 0.2).midiratio)}!8;
	sig = Splay.ar(sig);
	sig = RLPF.ar(sig, (freq * harm).clip(20,20000), 0.5);
	env = EnvGen.ar(Env.adsr(0.001, 0.2, 0.4, 1), gate, doneAction:2);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth(\tri);
x.set(\gate, 0);

/////////////////////
//128-voice polyphony

(
~notes = Array.fill(128, nil);

MIDIdef.noteOn(\on, {
	arg val, num;
	~notes.put(
		num,
		Synth(\tri, [
			\freq, num.midicps,
			\harm, 20,
			\amp, val.linlin(0,127,-30, -6).dbamp,
			\gate, 1
		]);
	);
});

MIDIdef.noteOff(\off, {
	arg val, num;
	~notes[num].set(\gate, 0);
	~notes[num] = nil;
});
)

///////////////////////
//adding filter control

(
s.newBusAllocators;
~harmbus = Bus.control(s, 1);

SynthDef(\harm, {
	arg harm=8, out=0;
	Out.kr(out, harm.lag(0.1));
}).add;

SynthDef(\tri, {
	arg inharm=0, freq=200, rel=0.6, amp=0.1, gate=1, out=0;
	var sig, env, harm;
	harm = In.kr(inharm, 1);
	sig = {Saw.ar(freq * Rand(-0.2, 0.2).midiratio)}!8;
	sig = Splay.ar(sig);
	sig = RLPF.ar(sig, ((freq * harm).clip(20,20000)), 0.33);
	env = EnvGen.ar(Env.adsr(0.001, 0.2, 0.4, 1), gate, doneAction:2);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

~harmSynth = Synth(\harm, [\out, ~harmbus], s.defaultGroup, \addBefore);

~harmSynth.set(\harm, 8);

~harmbus.getSynchronous;

x = Synth(\tri, [\in, ~harmbus, \amp, 0.3]);
x.set(\gate, 0);

~harmSynth.free;

(
~harmSynth = Synth(\harm, [\out, ~harmbus], s.defaultGroup, \addBefore);

~notes = Array.fill(128, nil);
~harm = 8;

MIDIdef.noteOn(\on, {
	arg val, num;
	~notes.put(
		num,
		Synth(\tri, [
			\inharm, ~harmbus,
			\freq, num.midicps,
			\amp, val.linlin(0,127,-30, -6).dbamp,
			\gate, 1
		]);
	);
});

MIDIdef.noteOff(\off, {
	arg val, num;
	~notes[num].set(\gate, 0);
	~notes[num] = nil;
});

MIDIdef.cc(\harm, {
	arg val, num;
	[val,num];
	~harm = val.linlin(0,127,2,40);
	~harmSynth.set(\harm, ~harm);
});
)

s.freeAll;

////////////////
//adding vibrato

(
s.newBusAllocators;
~harmbus = Bus.control(s, 1);
~vibbus = Bus.control(s, 1);

SynthDef(\harm, {
	arg harm=8, out=0;
	Out.kr(out, harm.lag(0.1));
}).add;

SynthDef(\vib, {
	arg vib=1, out=0;
	var sig;
	sig = SinOsc.kr(6.5).bipolar(vib.lag(0.05)).midiratio;
	Out.kr(out, sig);
}).add;

SynthDef(\tri, {
	arg invib=0, inharm=0, freq=200,
	rel=0.6, amp=0.1, gate=1, out=0;
	var sig, env, harm, vib;
	harm = In.kr(inharm, 1);
	vib = In.kr(invib, 1);
	freq = freq * vib;
	sig = {Saw.ar(freq * Rand(-0.2, 0.2).midiratio)}!8;
	sig = Splay.ar(sig);
	sig = RLPF.ar(sig, ((freq * harm).clip(20,20000)), 0.33);
	env = EnvGen.ar(Env.adsr(0.001, 0.2, 0.4, 1), gate, doneAction:2);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

(
~harmSynth = Synth(\harm, [\out, ~harmbus], s.defaultGroup, \addBefore);
~vibSynth = Synth(\vib, [\out, ~vibbus], s.defaultGroup, \addBefore);

~notes = Array.fill(128, nil);
~harm = 8;
~vib = 0;

//right way!
MIDIdef.noteOn(\on, {
	arg val, num;
	~notes.put(
		num,
		Synth(\tri, [
			\inharm, ~harmbus,
			\invib, ~vibbus,
			\freq, num.midicps,
			\amp, val.linlin(0,127,-30, -6).dbamp,
			\gate, 1
		]);
	);
});

MIDIdef.noteOff(\off, {
	arg val, num;
	~notes[num].set(\gate, 0);
	~notes[num] = nil;
});

MIDIdef.cc(\harm, {
	arg val, num;
	~harm = val.linlin(0,127,2,40);
	~harmSynth.set(\harm, ~harm);
}, 22);

MIDIdef.cc(\vib, {
	arg val, num;
	~vib = val.lincurve(0, 127, 0, 0.8, 3);
	~vibSynth.set(\vib, ~vib);
}, 1);
)

s.freeAll;
MIDIdef.freeAll;