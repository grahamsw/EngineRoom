s.boot;

3 + [4,5];

(
~fn = {
	arg freq=200, offset=2, lpf=1500, amp=0.2;
	var sig;
	sig = Saw.ar(freq + [0, offset]);
	sig = LPF.ar(sig, lpf);
	sig = sig * amp;
};
)

x = ~fn.play(args: [\freq, 150, \lpf, 3000]);
x.free;


(
SynthDef.new(\saw, {
	arg freq=200, offset=2, lpf=1500, amp=0.2, out=0;
	var sig;
	sig = Saw.ar(freq + [0, offset]);
	sig = LPF.ar(sig, lpf);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth.new(\saw, [\freq, 150, \lpf, 3000]);
x.free;

-----------------------

Env

EnvGen

(
e = Env.new(
	[0, 1, 0.5, 0.5, 0],
	[1, 1, 2, 1],
	[-4, 0, 0, 0]
);

e.plot;
)

Window.closeAll;

(
SynthDef.new(\saw, {
	arg freq=200, offset=2, lpf=1500, amp=0.2, out=0;
	var sig, env;
	env = EnvGen.ar(
		Env.new(
			[0, 1, 0.5, 0.5, 0],
			[1, 1, 2, 1],
			[1, -2, 0, -3]
		),
		doneAction:2
	);
	sig = Saw.ar(freq + [0, offset]);
	sig = LPF.ar(sig, lpf);
	sig = sig * amp;
	sig = sig * env;
	Out.ar(out, sig);
}).add;
)

x = Synth.new(\saw, [\freq, 80, \lpf, 3000]);

rrand(0, 10);
exprand(0, 10);

(
SynthDef.new(\saw, {
	arg freq=200, offset=2, lpf=1500, amp=0.2, out=0;
	var sig, env;
	env = XLine.ar(1, 0.01, 2, doneAction:2) - 0.01;
	sig = Saw.ar(freq + [0, offset]);
	sig = LPF.ar(sig, lpf);
	sig = sig * amp;
	sig = sig * env;
	Out.ar(out, sig);
}).add;
)

x = Synth.new(\saw, [\freq, 80, \lpf, 3000]);

(
SynthDef.new(\saw, {
	arg freq=200, gate=1, offset=2, lpf=1500, amp=0.2, out=0;
	var sig, env;
	env = EnvGen.ar(
		Env.new(
			[0, 1, 0.5, 0],
			[1, 1, 1],
			[1, -2, -3],
			2
		),
		gate,
		doneAction:2
	);
	sig = Saw.ar(freq + [0, offset]);
	sig = LPF.ar(sig, lpf);
	sig = sig * amp;
	sig = sig * env;
	Out.ar(out, sig);
}).add;
)

x = Synth.new(\saw, [\freq, 80, \lpf, 3000]);
x.set(\gate, 0);

---------------------------------

x = [];

//x = x.add(rrand(100,999));

(
x = x.add( Synth.new(\saw, [\freq, 45.midicps, \lpf, 3000, \amp, 0.15]) );
x = x.add( Synth.new(\saw, [\freq, 55.midicps, \lpf, 3000, \amp, 0.15]) );
x = x.add( Synth.new(\saw, [\freq, 59.midicps, \lpf, 3000, \amp, 0.15]) );
x = x.add( Synth.new(\saw, [\freq, 61.midicps, \lpf, 3000, \amp, 0.15]) );
x = x.add( Synth.new(\saw, [\freq, 62.midicps, \lpf, 3000, \amp, 0.15]) );
x = x.add( Synth.new(\saw, [\freq, 64.midicps, \lpf, 3000, \amp, 0.15]) );
)

x[0].set(\gate, 0);
x[1].set(\gate, 0);
x[2].set(\gate, 0);
x[3].set(\gate, 0);
x[4].set(\gate, 0);
x[5].set(\gate, 0);

------------------------------

(
y = [45, 55, 59, 61, 62, 64];
x = y.collect({
	arg n;
	n.cubed;
});
)

(
~notes = [45, 55, 59, 61, 62, 64];
~synths = ~notes.collect({
	arg n;
	Synth.new(\saw, [\freq, n.midicps, \lpf, 3000, \amp, 0.15]);
});
)

(
~synths.do({
	arg n;
	n.set(\gate, 0);
});
)

(
~synths.do({
	arg n;
	n.set(\gate, 0);
});
)

(
y = [45, 55, 59, 61, 62, 64];
x = y.collect({
	arg n;
	n.cubed;
});
)

(
y = [45, 55, 59, 61, 62, 64];
x = y.do({
	arg n;
	n.cubed.postln;
});

)

(1..100).do({
	"hello".postln;
});

(
y = [45, 55, 59, 61, 62, 64];
x = y.collect({
	arg n, i;
	[n.cubed, i];
});
)