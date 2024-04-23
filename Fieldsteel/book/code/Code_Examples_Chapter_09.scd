// Code Example 9.1

s.quit; // quit first to properly demonstrate

(
s.boot;
{ PinkNoise.ar(0.2 ! 2) * XLine.kr(1, 0.001, 2, doneAction: 2) }.play;
)



// Code Example 9.2

s.quit; // quit first to properly demonstrate

(
s.waitForBoot({
	{ PinkNoise.ar(0.2 ! 2) * XLine.kr(1, 0.001, 2, doneAction: 2) }.play;
});
)



// Code Example 9.3

s.quit; // quit first to properly demonstrate

(
s.waitForBoot({
	SynthDef(\tone_000, {
		var sig = SinOsc.ar([350, 353], mul: 0.2);
		sig = sig * XLine.kr(1, 0.0001, 2, doneAction: 2);
		Out.ar(0, sig);
	}).add;

	Synth(\tone_000);
});
)



// Code Example 9.4

s.quit; // quit first to properly demonstrate

(
s.waitForBoot({
	SynthDef(\tone_001, {
		var sig = SinOsc.ar([350, 353], mul: 0.2);
		sig = sig * XLine.kr(1, 0.0001, 2, doneAction: 2);
		Out.ar(0, sig);
	}).add;

	s.sync;

	Synth(\tone_001);
});
)



// Code Example 9.5

(
// audio server assumed to be already booted
SynthDef(\tone_002, {
	var sig = SinOsc.ar([350, 353], mul: 0.2);
	sig = sig * XLine.kr(1, 0.0001, 2, doneAction: 2);
	Out.ar(0, sig);
}).add;

s.sync; // -> ERROR: yield was called outside of a Routine.

Synth(\tone_002);
)



// Code Example 9.6

s.quit; // quit first to properly demonstrate

(
s.newBusAllocators;
~bus = Bus.audio(s, 2);

s.waitForBoot({
	SynthDef(\source, { |out = 0|
		var sig, env, freq, trig;
		trig = Trig.kr(Dust.kr(4), 0.1);
		env = EnvGen.kr(Env.perc(0.001, 0.08), trig);
		freq = TExpRand.kr(200, 1500, trig);
		sig = SinOsc.ar(freq ! 2, mul: 0.2);
		sig = sig * env;
		Out.ar(out, sig);
	}).add;

	SynthDef(\reverb, { |in = 0, mix = 0.2, out = 0|
		var sig, fx;
		sig = In.ar(in, 2);
		fx = FreeVerb2.ar(sig[0], sig[1], 1, 0.85);
		sig = sig.blend(fx, mix);
		Out.ar(out, sig);
	}).add;

	s.sync;

	~reverb = Synth(\reverb, [in: ~bus]);
});
)

Synth(\source, [out: ~bus, freq: exprand(200, 1500)]);



// Code Example 9.7

(
~quitMessage = {
	" ***************** ".postln;
	" *** good-bye! *** ".postln;
	" ***************** ".postln;
};
ServerQuit.add(~quitMessage);
)

s.boot;

s.quit; // message appears in post window



// Code Example 9.8

(
s.waitForBoot({
	~treeMessage = { "Server tree cleared".postln };
	ServerTree.add(~treeMessage);
});
)

// press [cmd]+[period] to see the message



// Code Example 9.9

(
s.waitForBoot({
	ServerTree.removeAll;
	~treeMessage = { "Server tree cleared".postln };
	ServerTree.add(~treeMessage);
});
)

// press [cmd]+[period] to see the message



// Code Example 9.10

(
s.newBusAllocators;
~bus = Bus.audio(s, 2);

~cleanup = {
	s.freeAll;
	ServerBoot.removeAll;
	ServerTree.removeAll;
	ServerQuit.removeAll;
};
~cleanup.();
ServerQuit.add(~cleanup);

s.waitForBoot({
	SynthDef(\source, { |out = 0|
		var sig, env, freq, trig;
		trig = Trig.kr(Dust.kr(4), 0.1);
		env = EnvGen.kr(Env.perc(0.001, 0.08), trig);
		freq = TExpRand.kr(200, 1500, trig);
		sig = SinOsc.ar(freq ! 2, mul: 0.2);
		sig = sig * env;
		Out.ar(out, sig);
	}).add;

	SynthDef(\reverb, { |in = 0, mix = 0.2, out = 0|
		var sig, fx;
		sig = In.ar(in, 2);
		fx = FreeVerb2.ar(sig[0], sig[1], 1, 0.85);
		sig = sig.blend(fx, mix);
		Out.ar(out, sig);
	}).add;

	s.sync;

	~makeReverb = { ~reverb = Synth(\reverb, [in: ~bus]) };
	ServerTree.add(~makeReverb);
	ServerTree.run;
});
)

Synth(\source, [out: ~bus, freq: exprand(200, 1500)]);