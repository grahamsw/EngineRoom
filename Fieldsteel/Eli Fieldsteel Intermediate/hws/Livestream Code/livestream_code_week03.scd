s.boot;

//basic steps:
//1. create some cyclic shape (Env, Signal, Buffer)
//2. convert to Wavetable format
//3. load into Buffer
//4. use wt oscillator UGen to read that Buffer @ some Hz

(
~sig = Signal.sineFill(4096, [1,0.5,0.2,0.2,0.15,0.1], [0,pi,0,pi,0,0]);
~wt = ~sig.asWavetable;
r{
	~buf = Buffer.alloc(s, 8192);
	s.sync;
	~buf.sendCollection(~wt);
	s.sync;
	~buf.plot;
}.play(AppClock);
)

(
{
	var sig;
	sig = Osc.ar(~buf, MouseX.kr(100,800,1).poll) * 0.06!2;
}.play;
)

s.scope;


(
~sig = Signal.sineFill(4096, [1,0.5,0.2,0.2,0.15,0.1], [0,pi,0,pi,0,0]);
~wt = ~sig.asWavetable;
r{
	Buffer.freeAll;
	s.sync;
	~buf = Buffer.alloc(s, 8192);
	s.sync;
	~buf.sendCollection(~wt);
	s.sync;
	~buf.plot;
}.play(AppClock);
)


(
{
	var sig, mod;
	mod = SinOsc.ar(MouseY.kr(10,10000,1), mul:400);
	sig = Osc.ar(~buf, MouseX.kr(20,2000,1) + mod) * 0.15!2;
}.play;
)

(
{.
	var sig, mod;
	mod = Osc.ar(~buf, MouseY.kr(10,10000,1), mul:1000);
	sig = Osc.ar(~buf, MouseX.kr(20,2000,1) + mod) * 0.15!2;
}.play;
)

//a more complex example

(
SynthDef.new(\oscfm, {
	var sig, mod, env;

	//modulator
	mod = Osc.ar(\buf.ir(0), \modfreq.kr(1000), mul:\modamp.kr(1000));

	//a chorus of 5 slightly detuned voices
	5.collect({
		var spread;
		spread = LFNoise1.kr(0.05).bipolar(\dev.ir(0.1)).midiratio;

		//carrier
		sig = Osc.ar(\buf.ir(0), \freq.kr(200) * spread + mod);
	}).sum;

	env = Env(
		[0,1,0],
		[\atk.ir(0.02), \rel.ir(0.5)],
		[\atkcrv.ir(1), \relcrv.ir(-3)]
	).ar(2);
	sig = Pan2.ar(sig, \pan.ir(0), \amp.kr(0.2));
	sig = sig * env;
	Out.ar(\out.ir(0), sig);
}).add;
)

Synth(\oscfm, [\buf, ~buf]); //default sound

(
//with custom arg values
Synth(\oscfm, [
	\buf, ~buf,
	\freq, 50,
	\modfreq, 200,
	\modamp, 500,
	\rel, 4,
	\amp, 0.2,
]);
)

(
// a pattern-generated texture
p = Pbind(
	\instrument, \oscfm,
	\buf, ~buf,
	\dur, Pexprand(0.1,1.5),
	\freq, Pwrand([50,100,200],[0.8,0.1,0.1],inf)
	* Pwrand([0,7,12,17,28],[0.6,0.1,0.1,0.1,0.1],inf).midiratio,
	\dev, Pexprand(0.05,0.2),
	\modfreq, Prand([50,100,200,400,600,800],inf),
	\modamp, Pexprand(40,1000),
	\atk, Pexprand(0.1,2.5),
	\rel, Pexprand(3,5),
	\amp, Pexprand(0.05,0.15),
	\pan, Pwhite(-0.3,0.3),
);

~player = p.play;
)

~player.stop;

/////////////////////

Buffer.freeAll;

//sine1: creating a wavetable by specifying amplitudes of harmonics
~buf = Buffer.alloc(s, 8192);
~buf.sine1(1/(1..16), asWavetable:true);
~buf.plot;

(
{
	var sig;
	sig = Osc.ar(~buf, [1,1.01] * MouseX.kr(100,800,1).poll) * 0.12;
}.play;
)

(
//sine2: specification of frequencies (i.e. harmonic #s) and amplitudes
~buf.sine2(
	Array.exprand(24, 1, 16).round.sort,
	Array.exprand(24, 0.1, 1).sort.reverse,
	asWavetable:true
);
~buf.plot;
)

(
{
	var sig;
	sig = Osc.ar(~buf, MouseX.kr(100,800,1).poll) * 0.07!2;
}.play;
)


(
//non-integer harmonic numbers result in wavetable discontinuities
//and may alias at high frequencies
~buf.sine2(
	[1.2],
	[1],
	asWavetable:true
);
~buf.plot;
)

(
{
	var sig;
	sig = Osc.ar(~buf, MouseX.kr(100,800,1).poll) * 0.07!2;
}.play;
)

//see also Buffer instance method 'sine3' which allows phase specifications

//////////////////////////////

Buffer.freeAll;
~buf = Buffer.alloc(s, 8192);
(
//sine2: specification of frequencies (i.e. harmonic #s) and amplitudes
~buf.sine2(
	Array.exprand(24, 1, 16).round.sort,
	Array.exprand(24, 0.1, 1).sort.reverse,
	asWavetable:true
);
)

//another more complex example:
//two detuned chords using wavetable synthesis and some filtering/panning

(
//run me 2-3 times for richer chorus effect
[0,0,12,12,19,24,26,31,33,35].do({
	arg n;
	n = (n + 36).midicps * rrand(-0.15,0.15).midiratio;
	{
		var sig;
		sig = Osc.ar(~buf, n) * 0.1;
		sig = sig * SinOsc.kr(Rand(0.1,0.15), Rand(0,2pi)).range(0.2,1);
		sig = LPF.ar(sig, n * 2);
		sig = Pan2.ar(sig, rrand(-0.9,0.9));
		sig = sig * Env([0,1,0],[4,4],[1,-1]).kr(2)
	}.play;
});
)


(
//run me 2-3 times for richer chorus effect
[-1,-1,11,11,19,26,28,30,31,33,38].do({
	arg n;
	n = (n + 36).midicps * rrand(-0.15,0.15).midiratio;
	{
		var sig;
		sig = Osc.ar(~buf, n) * 0.1;
		sig = sig * SinOsc.kr(Rand(0.1,0.15), Rand(0,2pi)).range(0.2,1);
		sig = LPF.ar(sig, n * 2);
		sig = Pan2.ar(sig, rrand(-0.9,0.9));
		sig = sig * Env([0,1,0],[4,4],[1,-1]).kr(2)
	}.play;
});
)

////////////
//creating wavetables using Env

Buffer.freeAll;

(
~env = Env(
	[0]++Array.rand(10, -1.0, 1.0).normalize(-1,1)++[0],
	Array.exprand(11, 0.01, 1),
	Array.rand(11, -4.0, 4.0)
);
~env.plot;
~wt = ~env.discretize(4096).asWavetable;
r{
	Buffer.freeAll;
	s.sync;
	~buf = Buffer.sendCollection(s, ~wt);
}.play;
)

~buf.plot; //env -> wavetable format, stored in buffer

Window.closeAll;

s.scope;

(
{
	var sig;
	sig = Osc.ar(~buf, [100,100.5]) * 0.1!2;
	sig = LPF.ar(sig, 3000);
}.play;
)

s.defaultGroup.set(\gate, 0, \fadeTime, 10); //if creating lots of function-dot-play Synths, this will fade them all out

//VOsc allows interpolation between multiple wavetables

//allocate some number of consecutive buffers
~buf = Buffer.allocConsecutive(4, s, 8192);

(
//create 4 envelopes, convert to wavetable format, and load into buffers
4.do({
	arg n;
	~sig = Env(
		[0,-1,1,0.5,-0.5,0.9,-0.8,0.2,0],
		Array.fill(8, {exprand(0.1,1)}),
		Array.fill(8, {rrand(-3.0,3.0)})
	);
	~sig = ~sig.discretize(4096);
	~wt = ~sig.asWavetable;
	~buf[n].sendCollection(~wt);
});
)

~buf.do({arg n; n.plot}); //plot all four buffers
s.scope;

(
//move the mouse horizontally to interpolate across (i.e. "morph" between) these four wavetables
{
	var sig;
	sig = VOsc.ar(MouseX.kr(~buf[0].bufnum, ~buf[3].bufnum).poll, [100,100.5]) * 0.12;
}.play;
)

//a more interesting example:
s.scope;

(
{
	var sig;
	sig = 8.collect({
		VOsc.ar(
			LFNoise1.kr(0.1).range(~buf[0].bufnum, ~buf[3].bufnum),
			100 * rrand(-0.12,0.12).midiratio * [0.5,1].choose
		) * 0.2;
	});
	sig = Splay.ar(sig);
}.play;
)

s.defaultGroup.set(\gate, 0, \fadeTime, 4);
