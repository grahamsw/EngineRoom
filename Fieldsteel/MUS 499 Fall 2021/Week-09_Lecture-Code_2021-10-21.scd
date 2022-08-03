s.boot;

(
SynthDef.new(\sine, {
	arg freq=440, amp=0.2, gate=1,
	atk=0.002, rel=1, acrv=1, rcrv=(-4), pan=0, out=0;
	var sig, env;
	env = EnvGen.kr(
		Env.asr(atk, 1, rel, [acrv, rcrv]),
		gate,
		doneAction:2
	);
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp) * env;
	Out.ar(out, sig);
}).add;

SynthDef.new(\reverb, {
	arg in=0, mix=0.08, out=0;
	var sig, wet;
	sig = In.ar(in, 2);
	sig = FreeVerb2.ar(
		sig[0], sig[1],
		mix: mix.varlag(2),
		room: 0.999,
		damp: 0.85
	);
	Out.ar(out, sig);
}).add;

s.newBusAllocators;
~bus = Bus.audio(s, 2);
)

Synth(\reverb, [\in, ~bus, \out, 0]);

(
(
instrument: \sine,
out: ~bus,
sustain: 0.01,
rel: 0.2,
midinote: rrand(40,90)
).play;
)

//Array values in Pbind

(
p = Pbind(
	\type, \note,
	\instrument, \sine,
	\dur, 0.75,
	\strum, 0.05,
	\atk, 0.001,
	\sustain, 0.01,
	\rel, 2,
	\rcrv, -8,
	\amp, 0.02,
	\degree, Pfunc({ Array.rand(4, -7, 14).sort }),
	\out, 0
);
~seq = p.play;
)

~seq.stop;

//Rest events

(
p = Pbind(
	\instrument, \sine,
	\dur, 0.125,
	\atk, 0.001,
	\sustain, 0.01,
	\rel, 3,
	\rcrv, -8,
	\amp, 0.05,
	\degree, Pseq([
		0, \, 1, 3, 4, \, 7, \,
	], inf),
	\out, 0
);
~seq = p.play;
)

~seq.stop;

//Expressing one parameter in terms of another

(
p = Pbind(
	\instrument, \sine,
	\dur, 0.25,
	\atk, 0.001,
	\sustain, 0.01,
	\rel, 1,
	\rcrv, -4,
	\midinote, Plprand(40, 110, inf).trace,
	\db, Pfunc({
		arg ev;
		ev[\midinote].linlin(40, 110, -16, -50);
	}),
	\out, 0
);
~seq = p.play;
)

~seq.stop;

//TempoClock and quantization

t = TempoClock.new(112/60).permanent_(true);

~postinfo = {(t.beats%4).postln;1;}

~postinfo = {};

~postinfo.();

(
~postinfo = {(t.beats%4).postln;1;};
t.schedAbs(t.nextBar, {~postinfo.()});
)


(
p = Pbind(
	\instrument, \sine,
	\dur, 0.5,
	\atk, 0.001,
	\sustain, 0.01,
	\rel, 1,
	\rcrv, -4,
	\degree, Pseq([-2,0,1,3], inf),
	\amp, 0.1,
	\out, 0
);

q = Pbind(
	\instrument, \sine,
	\dur, 0.5,
	\atk, 0.001,
	\sustain, 0.01,
	\rel, 1,
	\rcrv, -4,
	\degree, Pseq([-2,0,1,3], inf) + 4,
	\amp, 0.1,
	\out, 0
);
)

~seq_p = p.play(t, quant:8);
~seq_q = q.play(t, quant:8);

~seq_p.stop;
~seq_q.stop;

//Live manipulation of Patterns
// (& Pseg)

(
p = Pbind(
	\instrument, \sine,
	\dur, 0.5,
	\atk, 0.001,
	\sustain, 0.01,
	\rel, 1,
	\rcrv, -4,
	\degree, Pdefn(\sine_deg, Pseq([-2,0,1,3,4,5,7,8], inf)),
	\amp, 0.1,
	\out, 0
);
)

~seq = p.play(t, quant:4);

Pdefn(\sine_deg).quant = 4;

Pdefn(\sine_deg, Pseq([-2,0,1,3,4,5,7,8], inf) + 3)

~seq.stop;

(
Pdef(\p, Pbind(
	\instrument, \sine,
	\dur, 0.25,
	\atk, 0.001,
	\sustain, 0.01,
	\rel, 1,
	\rcrv, -4,
	\midinote, Pwhite(40, 90, inf),
	\amp, Pkey(\midinote).linexp(40, 90, 0.1, 0.005) *
	Env.new([1,0],[10],[-3]).asPseg,
	\out, 0
));
)

Pdef(\p).quant_(4);

Pdef(\p).play(t);

Pdef(\p).stop;

Pseg(Pseq([1,0],1), Pseq([10],1), Pseq([-3], 1));
