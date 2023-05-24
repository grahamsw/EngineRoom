s.boot;

s.plotTree;

(
SynthDef.new(\sin, {
	arg out=0, gate=1;
	var freq, sig, tenv, env;
	freq = LFDNoise0.kr(16!2).exprange(150, 4000);
	sig = SinOsc.ar(freq);
	tenv = EnvGen.ar(Env.perc(0.001, 0.06), Dust.kr(6!2));
	env = EnvGen.kr(Env.asr(5, 1, 5), gate, doneAction:2);
	sig = sig * tenv * env * 0.1;
	Out.ar(out, sig);
}).add;

SynthDef.new(\pn, {
	arg out=0, gate=1;
	var sig, env, mod;
	sig = PinkNoise.ar(1!2);
	mod = LFPulse.kr(0.6, 0, 0.02);
	sig = sig * mod;
	env = EnvGen.kr(Env.asr(0, 1, 5), gate, doneAction:2);
	sig = sig * env * 0.4;
	Out.ar(out, sig);
}).add;
)

~sin = Synth(\sin);
~sin.set(\gate, 0);

~pn = Synth(\pn);
~pn.set(\gate, 0);

(
SynthDef.new(\rev, {
	arg in=0, wetamp=0.3, out=0;
	var sig, wet;
	sig = In.ar(in, 2);
	wet = FreeVerb2.ar(
		sig[0], sig[1],
		mix: 1.0,
		room: 1.0,
		damp: 0.85,
		mul: wetamp
	);
	sig = sig + wet;
	Out.ar(out, sig);
}).add;
)

s.options.numAudioBusChannels;

s.options.blockSize;

~rev = Synth(\rev, [\in, 6, \out, 0]);

~sin = Synth(\sin, [\out, 6]);

~sin.set(\gate, 0);

~rev.free;




(
~rev = Synth(
	\rev,
	[\in, 6, \out, 0],
	s.defaultGroup,
	\addToHead
);
)

(
~sin = Synth(
	\sin,
	[\out, 6],
	s.defaultGroup,
	\addToHead
);
)

~sin.set(\gate, 0);


~sin = Synth(\sin, [\out, 6]);
~rev = Synth(\rev, [\in, 6, \out, 0], ~sin, \addAfter);

s.freeAll;

~sin = Synth(\sin, [\out, 6]);
~rev = Synth(\rev, [\in, 6, \out, 0], s.defaultGroup, \addAfter);

s.freeAll;

~sourceGroup = Group.new;
~fxGroup = Group.new(~sourceGroup, \addAfter);


(
~sin = Synth(\sin, [\out, 6], ~sourceGroup);
~rev = Synth(\rev, [\in, 6, \out, 0], ~fxGroup);
)

~sin.set(\gate, 0);

~rev.free;

~sourceGroup.free;
~fxGroup.free;

//////////

~fxGroup = Group.new;
~rev = Synth(\rev, [\in, 6, \out, 0], ~fxGroup);

Synth(\sin, [\out, 6], ~fxGroup, \addBefore);

s.defaultGroup.set(\gate, 0);

(
~sourceGroup = Group.new;
~fxGroup = Group.new(~sourceGroup, \addAfter);
)

~rev = Synth(\rev, [\in, 6, \out, 0], ~fxGroup);

Synth(\sin, [\out, 6], ~sourceGroup);

~sourceGroup.set(\gate, 0);

~fxBus = Bus.audio(s, 2);


(
~sourceGroup = Group.new;
~fxGroup = Group.new(~sourceGroup, \addAfter);
~rev = Synth(\rev, [\in, ~fxBus, \out, 0], ~fxGroup);
~sin = Synth(\sin, [\out, ~fxBus], ~sourceGroup);
)

~sourceGroup.set(\gate, 0);

s.freeAll;

~extraBus = Bus.audio(s, 2);

1000.do({ Bus.audio(s, 2); })


(
s.newBusAllocators;
~fxBus = Bus.audio(s, 2);
)

(
s.bind({
	~sourceGroup = Group.new;
	~fxGroup = Group.new(~sourceGroup, \addAfter);
	~rev = Synth(\rev, [\in, ~fxBus, \out, 0], ~fxGroup);
	~sin = Synth(\sin, [\out, 9], ~sourceGroup);
});
)

s.freeAll;

s.options.numOutputBusChannels = 8;
s.options.numInputBusChannels = 1;

s.reboot;







