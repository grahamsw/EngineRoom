s.boot;

{PinkNoise.ar(0.1!2)}.play

//////////////////
//NodeProxy

n = NodeProxy.new(s, \audio, 2);
n.play;

n.source = {LFTri.ar([300,302] * 0.5) * 0.06 * SinOsc.kr(0.5).range(0.2,0.8)};
n.source = {BPF.ar(PinkNoise.ar(0.5!2), 500, 0.1, 2)};
n.source = nil;

//release/create monitoring process
n.stop;
n.play;

//release/create source process
n.release;
n.release(5);
n.send;

//end both processes
n.end;
n.play;

//end and reset proxy to neutral state
n.clear;
n.clear(5);

/////////////////////
//fade times

n.fadeTime;
n.fadeTime_(5);
n.fadeTime;

n.source = {LFTri.ar([300,302] * 0.5) * 0.06 * SinOsc.kr(0.5).range(0.2,0.8)};
n.source = {LFTri.ar([300,302]) * 0.06 * SinOsc.kr(0.5).range(0.2,0.8)};
n.source = {LFTri.ar([300,302] * -2.midiratio) * 0.06 * SinOsc.kr(0.5).range(0.2,0.8)};
n.source = nil;

////////////////
//rhythm and quantizing

n.fadeTime_(0.02);
n.source = {LFTri.ar([300,302] * 3.midiratio) * 0.1 * LFPulse.kr(4, 0, 0.1)};
n.source = nil;

t = TempoClock.new(84/60).permanent_(true);
t.tempo;
t.beatDur;

(
n.source = {
	var sig, f;
	f = t.tempo;
	sig = LFTri.ar([300,302] * 5.midiratio);
	sig = sig * 0.1;
	sig = sig * LFPulse.kr(f*2, 0, 0.1)
};
)

n.source = nil;

n.clock_(t);
n.quant_(4);

(
n.source = {
	var sig, f;
	f = t.tempo;
	sig = LFTri.ar([300,302] * 5.midiratio);
	sig = sig * 0.1;
	sig = sig * LFPulse.kr(f*2, 0, 0.1)
};
)

n.fadeTime_(5);

n.source = nil;

/////////////////////////////////////
//Ndef

n.clear;

Ndef(\n).play;
Ndef(\n).fadeTime_(4);
Ndef(\n).clock_(t);
Ndef(\n).quant_(1);

(
Ndef(\n, {
	var sig, f;
	f = t.tempo;
	sig = PinkNoise.ar(0.5!2);
	sig = BPF.ar(sig, SinOsc.kr(f/4).exprange(200,2000), 0.1, 4);
	sig = sig * LFPulse.kr(f*8, [0,0.1], 0.2);
});
)

Ndef(\n, { });
Ndef(\n).clear;

(
//proxy attributes can be strung together in a single code expression
Ndef(\n)
.fadeTime_(4)
.clock_(t)
.quant_(1)
.play;
)

/////////////////////////////
//ProxySpace

~a = 5;
~b = 7;

true
false
nil
thisProcess
currentEnvironment;

~x = 17;

\lunch.envirPut("pizza");

currentEnvironment;

~lunch

e = Environment.new;
e.push;

currentEnvironment;

~k = 8;
~drink = "orange fanta";

currentEnvironment;

e;

e.pop;

currentEnvironment;

currentEnvironment.keys.do({arg key; currentEnvironment.removeAt(key)});

~lunch

currentEnvironment;

(
//create clock if one does not already exist
//t = TempoClock.new(84/60).permanent_(true);
p = ProxySpace.new(s, clock:t);
p.quant_(4);
p.push;
)

currentEnvironment;

//inside a ProxySpace, every environment variable is a NodeProxy
~sig;
~sig.play;

~sig = {PinkNoise.ar(0.1!2)};
~sig = nil;

~sig.fadeTime_(4);

~sig.clock;
~sig.quant;
~sig.quant_(0.5);

~sig2;
~sig2.quant;

p.clear;

(
SynthDef.new(\filtsaw, {
	var sig, env;
	sig = VarSaw.ar(\freq.kr(100), Rand(0.0,1.0), 0.001);
	sig = RLPF.ar(sig, \cf.kr(500), \rq.kr(0.5));
	env = Env.perc(\atk.ir(0.002), \rel.ir(0.3)).ar(2);
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.2));
	Out.ar(\out.ir(0), sig);
}).add;
)

(
x = Pbind(
	\instrument, \filtsaw,
	\dur, 0.25,
	\midinote, Pseq([28,28,40,28,40],inf) + [0,0.1],
	\cf, (Pkey(\midinote).midicps * 8).min(20000),
	\rq, Pexprand(0.1,0.5,inf),
	\pan, Pwhite(-0.2,0.2,inf),
).play;
)

x.stop;

~pat.play;

~pat.clock.tempo;
~pat.quant;

~pat.fadeTime_(1);

//Pbind is also a valid source for a NodeProxy
//dur value is automatically treated as beats on ProxySpace's clock
//EventStreamPlayer is automatically quantized based on ProxySpace's global quant value

(
~pat = Pbind(
	\instrument, \filtsaw,
	\dur, Prand([0.25,0.5],inf),
	\midinote, Pseq([28,28,40,28,40],inf) + [0,0.2] + Prand([12,0],inf),
	\cf, (Pkey(\midinote).midicps * 8).min(20000),
	\rq, Pexprand(0.1,0.5,inf),
	\pan, Pwhite(-0.2,0.2,inf),
);
)

~pat = nil;

//next time:
//how to use buffers? (this doesn't work in a ProxySpace)
~buf = Buffer.read(s, "/Users/eli/Documents/Illinois/Teaching/AY 2020-2021/Spring 2021/MUS 499C/Livestream Code/livestream_code_week11/delay.aiff");

//modularity

//applying effects

