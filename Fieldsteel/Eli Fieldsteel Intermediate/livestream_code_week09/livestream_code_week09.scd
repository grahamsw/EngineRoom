s.boot;

b = Buffer.read(s, PathName(thisProcess.nowExecutingPath).parentPath ++ "delay.aiff");

(
//looping buffer playback with fixed-duration envelope
SynthDef(\play, {
	var sig, env;
	sig = PlayBuf.ar(
		1,
		\buf.kr(0),
		BufRateScale.kr(\buf.kr(0)) * \rate.kr(1),
		\trig.tr(1), \spos.kr(0), \loop.kr(1)
	);
	env = Env(
		[0,1,1,0],
		[\atk.ir(0.001), \sus.ir(0.0), \rel.ir(0.2)],
		[\atkcrv.ir(1), 0, \relcrv.ir(-2)]
	).kr(2);
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(1));
	sig = sig * env;
	Out.ar(\out.kr(0), sig);
}).add;

//looping buffer playback with gated envelope
SynthDef(\playsus, {
	var sig, env;
	sig = PlayBuf.ar(
		1,
		\buf.kr(0),
		BufRateScale.kr(\buf.kr(0)) * \rate.kr(1),
		\trig.tr(1), \spos.kr(0), \loop.kr(1)
	);
	env = Env.asr(
		\atk.kr(0.001),
		\slev.kr(1),
		\rel.kr(0.2),
		[\atkcrv.kr(1), \relcrv.kr(-2)]
	).kr(2, \gate.kr(1));
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(1));
	sig = sig * env;
	Out.ar(\out.kr(0), sig);
}).add;

//basic enveloped sine
SynthDef(\tone, {
	var sig, env;
	sig = SinOsc.ar(\freq.kr(440) * \freqdev.kr(0).midiratio);
	env = Env(
		[0,1,1,0],
		[\atk.ir(0.001), \sus.ir(0.0), \rel.ir(0.2)],
		[\atkcrv.ir(1), 0, \relcrv.ir(-2)]
	).kr(2);
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.1));
	sig = sig * env;
	Out.ar(\out.kr(0), sig);
}).add;
)

Synth(\tone, [\freq, exprand(300,600), \amp, 0.25]);
Synth(\play, [\spos, b.numFrames.rand, \pan, rrand(-0.7,0.7)]);
x = Synth(\playsus, [\spos, b.numFrames.rand]);
x.set(\gate, 0, \rel, 2);

//////////////////////////////
//the basics

t = TempoClock.new(108/60).permanent_(true);

(
~pat = Pbind(
	\instrument, \play,
	\dur, 0.25,
	\rel, 0.08,
	\buf, b.bufnum,
	\spos, Pseries(0, 1000, inf),
	\rate, 1,
	\amp, 0.5,
);
~player = ~pat.play(t, quant:1);
)

~player.stop;

//arrays in value streams
//result in the creation of multiple Synths
(
~pat = Pbind(
	\instrument, \play,
	\dur, 0.25,
	\rel, 0.08,
	\buf, b.bufnum,
	\spos, Pseries(0, 1000, inf) + [2000, 0],
	\rate, [1, 1.2],
	\pan, [-1, 1],
	\amp, 0.5,
);
~player = ~pat.play(t, quant:1);
)

~player.stop;

//locking two value patterns together
//e.g. we want higher harmonics to have a lower amplitude

(
~pat = Pbind(
	\instrument, \tone,
	\dur, Pexprand(0.02,1),
	\atk, Pexprand(0.5,2),
	\sus, 0,
	\rel, 4,
	\relcrv, -2,
	\freqdev, Pwhite(-0.2, 0.2),
	\midinote, 40,
	\harmonic, Pexprand(1, 40).round(1),
	\amp, 0.04,
);
~player = ~pat.play(t, quant:1);
)

~player.stop;

//using Pkey

(
~pat = Pbind(
	\instrument, \tone,
	\dur, Pexprand(0.02,1),
	\atk, Pexprand(0.5,2),
	\sus, 0,
	\rel, 4,
	\relcrv, -2,
	\freqdev, Pwhite(-0.2, 0.2),
	\midinote, 40,
	\harmonic, Pexprand(1, 40).round(1),
	\amp, Pkey(\harmonic).lincurve(1,40,1,0.02,-8) * 0.06,
);
~player = ~pat.play(t, quant:1);
)

~player.stop;

//using Pfunc and passing the event into its function
//order matters! the independent key must come before the dependent key

(
~pat = Pbind(
	\instrument, \tone,
	\dur, Pexprand(0.02,1),
	\atk, Pexprand(0.5,2),
	\sus, 0,
	\rel, 4,
	\relcrv, -2,
	\freqdev, Pwhite(-0.2, 0.2),
	\midinote, 40,
	\harmonic, Pexprand(1, 40).round(1),
	\amp, Pfunc({
		arg ev;
		ev[\harmonic].lincurve(1,40,1,0.02,-8) * 0.06;
	})
);
~player = ~pat.play(t, quant:1);
)

~player.stop;

//lock two keys together using #[key1, key2]
//and a pattern that returns an array of values
//see also Ptuple

(
~pat = Pbind(
	\instrument, \tone,
	\dur, Pexprand(0.02,1),
	\atk, Pexprand(0.5,2),
	\sus, 0,
	\rel, 4,
	\relcrv, -2,
	\freqdev, Pwhite(-0.2, 0.2),
	\midinote, 40,
	#[harmonic,amp], Pfunc({
		var h, a;
		h = exprand(1,40).round(1);
		a = h.lincurve(1,40,1,0.02,-8) * 0.06;
		[h,a];
	}),
);
~player = ~pat.play(t, quant:1);
)

~player.stop;

//real-time control of event streams
//Pdef, Pbindef, Pdefn,

(
~note = 40;
~pat = Pbind(
	\instrument, \tone,
	\dur, Pexprand(0.02,1),
	\atk, Pexprand(0.5,2),
	\sus, 0,
	\rel, 4,
	\relcrv, -2,
	\freqdev, Pwhite(-0.2, 0.2),
	\midinote, Pfunc({~note}), //Pfunc to the rescue
	#[harmonic,amp], Pfunc({
		var h, a;
		h = exprand(1,40).round(1);
		a = h.lincurve(1,40,1,0.02,-8) * 0.03;
		[h,a];
	}),
);
~player = ~pat.play(t, quant:1);
)

~note = 42; //change me while playing

~player.stop;

//swapping out a pattern instead of a number in real-time
//starting pattern:

(
~pat = Pbind(
	\instrument, \tone,
	\dur, 0.3,
	\atk, 0,
	\sus, 0,
	\rel, 0.3,
	\relcrv, -8,
	\midinote, Pseq([57,60,69,57,60,62], inf),
	\amp, Pseq([-10, Pseries(-24,-2,5)].dbamp, inf),
);
~player = ~pat.play(t, quant:1);
)

~player.stop;

//using the Pn(Plazy({ }), inf) construction
//useful for repeatedly embedding a pattern that can be changed on-the-fly

(
~note = Pseq([57,60,69,57,60,62], 1);
~pat = Pbind(
	\instrument, \tone,
	\dur, 0.3,
	\atk, 0,
	\sus, 0,
	\rel, 0.3,
	\relcrv, -8,
	\midinote, Pn(Plazy({~note}),inf),
	\amp, Pseq([-10, Pseries(-24,-2,5)].dbamp, inf),
);
~player = ~pat.play(t, quant:1);
)

//change will occur whenever the previous patterns reaches its end
~note = Pseq([57,60,69,57,60,62]+2, 1); //change me (can be any pattern, not just Pseq)

~player.stop;

////////////////////////////////////

x = Synth(\playsus, [\buf, b.bufnum, \spos, b.numFrames.rand]);
x.set(\gate, 0);

//the 'sustain' key automatically sends .set(\gate, 0) messages
//but it assumes you've named your argument 'gate' and are
//using it to release a doneAction:2 envelope!

(
~pat = Pbind(
	\instrument, \playsus,
	\dur, 2,
	\sustain, 0.3,
	\rel, 0.08,
	\buf, b.bufnum,
	\spos, Pseries(0, 20000, inf),
	\rate, 1,
	\amp, 0.5,
	//\sendGate, false, //uncomment to break stuff
);
~player = ~pat.play(t, quant:1);
)

~player.stop;

s.defaultGroup.set(\gate, 0);

////////////////
//how to use patterns to update/manipulate a single Synth, rather than creating a stream of multiple Synths

//manually:

x = Synth(\playsus, [\buf, b.bufnum, \spos, 180000]);

(
x.set(
	\spos, rrand(0, b.numFrames-1),
	\trig, 1,
	\rate, rrand(-8.0,3.0).midiratio * [1,-1].choose
);
)

x.set(\gate, 0, \rel, 1);

//using Pmono

(
~pat = Pmono(
	\playsus,
	\dur, Pexprand(0.01,1),
	\buf, b.bufnum,
	\spos, Pwhite(0, b.numFrames-1, inf),
	\trig, 1, //try changing to zero to avoid jumping around
	\rate, Pwhite(-8.0,3.0).midiratio * Prand([-1,1],inf),
	\amp, 0.5,
);
~player = ~pat.play;
)

~player.stop;

// using "set" type events with Pbind

~synth = Synth(\playsus, [\buf, b.bufnum, \amp, 0.5]);

(
~pat = Pbind(
	\type, \set,
	\dur, Pexprand(0.02,1),
	\id, ~synth,
	\args, #[\spos, \trig, \rate],
	\spos, Pwhite(0, b.numFrames-1, inf),
	\trig, 1, //again try changing to 0 for a different result
	\rate, Pwhite(-8.0,3.0).midiratio * Prand([-1,1],inf),
);
)

~player = ~pat.play(t, quant:1); //play it

~player.stop;

~synth.set(\gate, 0);

//composition with patterns (akin to function composition, not musical composition)
//a.k.a. various ways of blending two patterns, or filtering one pattern through another
(
x = Pbind(
	\abc, Pseq([2,3],inf),
	\jkl, Prand([5,6,7],inf)
);
z = x.asStream;
)

z.next(( )); //run me repeatedly

(
//Pbindf allows us to add and/or replace keys in an existing Pbind
y = Pbindf(x, \pqr, Prand([100,200,300],inf));
z = y.asStream;
)

z.next(()); //run me repeatedly

//Pbindf with sound

(
~basepat = Pbind(
	\instrument, \tone,
	\dur, 0.25,
	\freq, 440,
	\freqdev, 0,
	\atk, 0.001,
	\sus, 0,
	\rel, 0.2,
	\atkcrv, 1,
	\relcrv, -2,
	\pan, 0,
	\amp, 0.1,
	\out, 0,
);
)

~player = ~basepat.play(t, quant:1);
~player.stop;

(
//replacing \freq with a different pattern, overwriting freq in the base pattern
~pat = Pbindf(~basepat, \freq, Pseq([60,65,70,74,63],inf).midicps);
~player = ~pat.play(t, quant:1)
)

~player.stop;

(
//replacing multiple keys, line-by-line
~pat = Pbindf(~basepat, \freq, Pseq([60,65,70,74,63],inf).midicps * [-12.2,12.2].midiratio);
~pat = Pbindf(~pat, \amp, Pwhite(-30,-10,inf).dbamp);
~pat = Pbindf(~pat, \pan, Pseq([[-0.5,0.5],[0.5,-0.5]],inf));
~player = ~pat.play(t, quant:1)
)
~player.stop;

(
//replacing multiple keys with one Pbindf
~pat = Pbindf(
	~basepat,
	\freq, Pseq([60,65,70,74,63],inf).midicps * [-12.2,12.2].midiratio,
	\amp, Pwhite(-30,-10,inf).dbamp,
	\pan, Pseq([[-0.5,0.5],[0.5,-0.5]],inf),
);
~player = ~pat.play(t, quant:1);
)

~player.stop;

//Pchain and <>
//a way of using key-value pairs from one Pbind in another Pbind

//non-sound example
//first pattern has priority (e.g. the \a key will not be overwritten by the 2nd Pbind)
~pat = Pchain(Pbind(\a, 4, \z, 12), Pbind(\a, 2, \b, 3));
~player = ~pat.asStream;
~player.next(());

//alternative syntax using the <> composition operator
~pat = Pbind(\a, 4, \z, 12) <> Pbind(\a, 2, \b, 3);
~player = ~pat.asStream;
~player.next(());

////////////////////
//Pchain sound example:
(
~basepat = Pbind(
	\instrument, \tone,
	\dur, Prand([0.25,0.5,0.75],inf),
	\midinote, Pwhite(50,90).round(5),
	\freqdev, Ptuple({Pwhite(-0.15,0.15)}!2),
	\atk, 0.01,
	\sus, 0,
	\rel, Pexprand(2, 5),
	\atkcrv, 1,
	\relcrv, -4,
	\pan, Pwhite(-0.5,0.5),
	\amp, Pexprand(0.02,0.07),
	\out, 0,
);
~player = ~basepat.play(t, quant:1);
)

~player.stop;

(
//overwriting \midinote values:
~pat1 = Pchain(Pbind(\midinote, Pwhite(60,70).round(2)), ~basepat);
~player1 = ~pat1.play(t, quant:1);
)

~player1.stop;

(
//overwriting multiple key-value pairs
~pat2 = Pchain(
	Pbind(
		\midinote, Pwhite(72,96),
		\rel, Pexprand(0.1,0.2),
		\dur, Pkey(\dur) * 2,
		\amp, Pexprand(0.08,0.25),
	),
	~basepat
);
~player2 = ~pat2.play(t, quant:1);
)

~player2.stop;

(
~player = ~basepat.play(t, quant:1);

//using <> operator

~pat1 = Pbind(\midinote, Pwhite(60,70).round(2)) <> ~basepat;
~player1 = ~pat1.play(t, quant:1);

~pat2 = Pbind(
	\midinote, Pwhite(72,96),
	\rel, Pexprand(0.1,0.2),
	\dur, Pkey(\dur) * 2,
	\amp, Pexprand(0.08,0.25),
) <> ~basepat;
~player2 = ~pat2.play(t, quant:1);
)

(
~player.stop;
~player1.stop;
~player2.stop;
)