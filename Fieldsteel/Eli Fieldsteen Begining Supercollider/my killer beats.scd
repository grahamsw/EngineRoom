// just assumes we want to load every file in foldername
~loadBuffs = {
	|foldername, isAbsolute = false|
	var fn = if (isAbsolute, {foldername}, {PathName(thisProcess.nowExecutingPath).parentPath + foldername});
	PathName(fn).files.collect({
		|f|
		Buffer.read(s, f.fullPath);
	})
}

(
SynthDef.new(\basic, {

	arg freq=500, atk=0.002, sus=0, rel=1,
	pan=0, amp=0.1, out=0;

	var sig, env;

	env = EnvGen.ar(
		Env.new([0,1,1,0],[atk,sus,rel],[2,0,-2]),
		doneAction:2
	);

	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp) * env;
	Out.ar(out, sig);
}).add;

SynthDef.new(\reverb, {
	arg in=0, drylevel=0.7, wetlevel=0.3, out=0;
	var sig, reverb;
	sig = In.ar(in, 2);
	reverb = In.ar(in, 2);
	reverb = LPF.ar(GVerb.ar(sig, 250, 4), 900);
	sig = (sig * drylevel) + (reverb * wetlevel);
	Out.ar(out, sig);
}).add;

)

(

t = TempoClock.new(30/60).permanent_(true);

Pbindef(\p1,
	\instrument, \basic,
	\dur, Pn(Pseq([0.5, 0.25, 0.25, 1], 2), inf),
    \degree, 2,
	\rel, 0.2,
	\atk, 0.1,
	\amp, 0.3
);


Pbindef(\p2,
	\instrument, \basic,
	\dur, Pn(Pseq([0.25, 0.25,0.25, 0.25, 0.5, 0.5], 2), inf),
	\degree, 2,
	\amp, 0.01
);

Pbindef(\p3,
	\instrument, \basic,
	\dur, Pseq([0.25, 0.25,0.25, 0.25], inf),
	\degree, Pseq([7,6,5,4], inf),
	\amp, 0.01
);

Pbindef(\p4,
	\instrument, \basic,
	\dur, Pseq([1], inf),
	\degree, Pseq([-2], inf),
	\amp, 0.01
);
)

t.tempo_(0.5);


Pbindef(\p1).play(t, quant:2);
Pbindef(\p1, \degree, Pseq([7,5,2,4],inf), \amp, 0.04, \atk, 0.01, \sus, 0.2).quant_(2);
Pbindef(\p1).stop;

Pbindef(\p2).play(t, quant:2)

Pbindef(\p2, \degree, \amp, 0.03, Pseq([2, 4, 2, 2, 4, 4], inf)).quant_(2);
Pbindef(\p2).stop


Pbindef(\p3).play(t, quant:2)
Pbindef(\p3, \dur, 0.125, \amp, 0.0045, \rel, 1, \pos, Pwhite(-1.0, 1.0, inf)).quant_(2);


Pbindef(\p4).stop


Pbindef(\p4).play(t, quant:2)
Pbindef(\p4, \degree, Pseq([[-2, -5]], inf), \amp, Pseq([[0.05, 0.1]], inf), \rel, [4,6], \atk, [0.01, 0.3]).quant_(2);
Pbindef(\p4).stop

(

t = TempoClock.new(60/60).permanent_(true);

Pbindef(\q1,
	\instrument, \basic,
	\dur, Pn(Pseq([0.25, 0.5, 0.25, 1], 2), inf),
    \degree, 0,
	\rel, 0.2,
	\atk, 0.1,
	\amp, 0.3
);
)

Pbindef(\q1).play(t, quant:2)
Pbindef(\q1, \degree, Pseq([0], inf)).quant_(2);
Pbindef(\q1, \degree, Pseq([[7,2],[2,0]], inf)).quant_(2);
(
r = Routine({
	(0..7).do{
		|d|
		Pbindef(\q1, \degree, d).quant_(2);
		3.wait;
	}
});

)

r.play


(
Pbindef(
	\r1,
	\instrument, \basic,
	\midinote, Pseq([\rest,55, 59, 53, 55], inf),
	\ctranspose, 12,
	\dur, Pseq([0.5, 0.5, 1, 1, 1], inf)
);
)
(
Pbindef(
	\r2,
	\instrument, \basic,
	\midinote, Pseq([55, 57,56], inf),
	\dur, Pseq([1,1,2], inf)
);
)
t.tempo_(120/60)
Pbindef(\r1).play(t, quant: 4)
Pbindef(\r1, \midinote, Pseq([ 55, 59, 53, 55], inf), \dur, Pseq([0.5], inf)).quant_(4)
Pbindef(\r1, \midinote, Pseq([ 55, 59, 62, 55, 59, [59,62], [41, 53], 55], inf)).quant_(4)

Pbindef(\r2).play(t, quant:4)
Pbindef(\r2, \dur, Pseq([1,1,2], inf), \rel, 2).quant_(4)
Pbindef(\r2).stop