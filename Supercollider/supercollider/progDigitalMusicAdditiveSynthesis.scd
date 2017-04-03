// Bell: Jean-Claude Risset
(
SynthDef(\bell, {|fund = 440, dur = 1|
	var freqs, offsets, amps, durs, env, envBell, mixer;
	freqs = [0.58, 0.58, 0.91, 0.91, 1.6, 1.2, 2, 2.7, 3, 3.75, 4.09];
	offsets = [0, 1, 0, 1.7, 0, 0, 0, 0, 0, 0, 0];
	amps = [1, 0.67, 1, 1.8, 1.67, 2.67, 1.46, 1.33, 1.33, 1, 1.33].normalizeSum;
	durs = [1, 0.9, 0.65, 0.55, 0.35, 0.325, 0.25, 0.2, 0.15, 0.1, 0.075];
	mixer = Mix.fill(freqs.size, {|i|
		var amp, freq;
		freq = fund * freqs[i] + offsets[i];
		amp = amps[i];
		env = EnvGen.kr(Env.perc(releaseTime:dur * durs[i] - 0.01));
		SinOsc.ar(freq, mul:amp * env)});
	envBell = EnvGen.kr(Env.perc(releaseTime:dur-0.01), doneAction:2);
	Out.ar(0, mixer * envBell)
}).add;
)

Synth(\bell, [\dur, 70, \fund, 440]);

Pbind(\freq, Pseq([440, 550, 660]), \instrument, \bell, \dur, 10,	\amp, 0.5).play;

// Shepard Tone

(
var ampTable, freqTable, b1, b2;
ampTable = Signal.hanningWindow(1024).squared;
freqTable = Signal.newClear(1024).waveFill({|i|
	(0.5 ** i * 20000)}, 0, 10);
b1 = Buffer.loadCollection(s, freqTable);
b2 = Buffer.loadCollection(s, ampTable);
{
	var freqs, amps, phasor, ratescale, rate, phases;
	ratescale = 1024/44100/10;
	rate = 0.1;
	phasor = Phasor.ar(0, rate * ratescale, 0, 1024);
	phases = (0..9)*0.1 * 1024 + phasor;
	freqs = BufRd.ar(1, b1.bufnum, phases);
	amps = BufRd.ar(1, b2.bufnum, phases);
	Mix.ar(SinOsc.ar(freqs)*amps)*0.1;
}.play;
)

f = Signal.newClear(1024).waveFill({|i|
	20000 - (0.5 ** i * 20000)}, 0, 10);

f.plot
// simple ring modulation
(
{
	var mod, car, output;
	mod = SinOsc.ar(200);
	car = SinOsc.ar(500);
	output =  car * mod;
}.play;
)

// more ring modulation
(
SynthDef(\ringmod,
	{
		|carNote = 0, modNote = 0, dur = 1 |
		var mod, car, env;
		mod = SinOsc.ar((modNote + 60).midicps);
		car = SinOsc.ar((carNote + 60).midicps, mul: mod);
		env = EnvGen.kr(Env.triangle(dur:dur), doneAction:2);
		Out.ar(0, car * env);
}).add;
)
(
var cars, mod;
cars = Pseq([2,4,5, 7, 9, 11, 12, 14, 12, 11, 9, 7, 5, 4, 2, 0]);
mod = -15;
Pbind(
	\instrument, \ringmod,
	\carNote, cars,
	\modNote, mod,
	\dur, 1/4).play;
)


// Daleks - complex RM with a 30 Hz modulator

(
o = {
	var mod = SinOsc.ar(30);
	var fn = Platform.resourceDir ++ "/" ++ "sounds/a11wlk01-44_1.aiff";
	b = Buffer.cueSoundFile(s, fn, 0, 1, pow(2, 16));
	c = DiskIn.ar(1, b.bufnum, 1);
	c*mod;
}.play;
)
c.release; b.close; b.free; o.free;

/* Amplitude Modulation */
(
{
	var mod, car;
	mod = SinOsc.ar(200);
	car = SinOsc.ar(500, mul:(1 + mod)/2);
}.play;
)

{SinOsc.ar(500)}.play

{SinOsc.ar(440, 0, 0.5, 0.5) }.scope


(
SynthDef(\am, {
	|modFreq = 200, carFreq = 500, dur = 1|
	var mod, car, env;
	mod = SinOsc.ar(modFreq, 3pi/2, 1/2, 1/2);
	car = SinOsc.ar(carFreq, mul:mod);
	env = EnvGen.kr(Env.linen(dur * 0.05, dur * 0.9, dur * 0.05), doneAction: 2);
	Out.ar(0, car * env);
}).add;
)
(
SynthDef(\rm, {
	|modFreq = 200, carFreq = 500, dur = 1|
	var mod, car, env;
	mod = SinOsc.ar(modFreq);
	car = SinOsc.ar(carFreq);
	env = EnvGen.kr(Env.linen(dur * 0.05, dur * 0.9, dur * 0.05), doneAction:2);
	Out.ar(0, car * mod * env);
}).add;
)

(
var freqs, patt1, patt2, patt3, patt4;
freqs = [81, 72, 79, 76].midicps;
patt1 = Pbind(
	\instrument, \rm,
	\modFreq, 200,
	\carFreq, Pser(freqs, 2),
	\dur, 2);
patt2 = Pbind(
	\instrument, \am,
	\modFreq, 200,
	\carFreq, Pser(freqs,2),
	\dur, 2);

patt3 = Pbind(
	\instrument, \rm,
	\modFreq, 93,
	\carFreq, Pser(freqs, 4),
	\dur, 1/8);

patt4 = Pbind(
	\instrument, \am,
	\modFreq, 93,
	\carFreq, Pser(freqs, 4),
	\dur, 1/8);

(patt1 ++ patt2 ++ patt3 ++ patt4).play;
)

/* AM tremolo */
(
SynthDef(\am,
	{
		|modFreq = 200, carFreq = 500, dur = 1, amp = 1|
		var mod, car, env;
		mod = SinOsc.ar(modFreq, 3pi/2, 1/2, 1/2);
		car = SinOsc.ar(carFreq);
		env = EnvGen.kr(Env.linen(dur * 0.05, dur * 0.9, dur * 0.05, amp, \sine), doneAction:2);
		OffsetOut.ar(0, car * mod * env);
}).add;
)

(
var freqs, durs, amps, mods;
freqs = Pseq([72, 67, [69, 72, 76, 79], 0, [67, 70, 74, 77], [67, 71, 74, 77], [69, 72, 76, 79], 0]).midicps;
durs = Pseq([1,1,2/3, Rest(1/3), 1/2, 1/3, 2, Rest(1/6)]);
amps = Pseq([1,1,1/4, 1, 1/4, 1/4, 1/4, 1]);
mods = Pseq((6!6) ++(3!2));
Pbind(
	\instrument, \am,
	\modFreq, mods,
	\carFreq, freqs,
	\dur, durs,
	\amp, amps
).play;
)

(
SynthDef(\ami, {
	|modFreq = 200, carFreq = 500, index = 1, ratio = 1, dur = 1, amp = 1|
	var mi, unmod, mod, car, env;
	mi = Line.ar( index, 0, dur);
	unmod = SinOsc.ar(carFreq, mul: 1 - mi);
	mod = SinOsc.ar(carFreq * ratio, 3pi/2, mi/2, mi/2);
	car = SinOsc.ar(carFreq, mul:mod);
	env = EnvGen.kr(Env.linen(dur * 0.05, dur * 0.9, dur * 0.05, amp, \sine), doneAction:2);
	OffsetOut.ar(0, (car + unmod)*env);
	}
).add;
)
(
SynthDef(\rmi, {
	|modFreq = 200, carFreq = 500, index = 1, ratio = 1, dur = 1, amp = 1|
	var mi, unmod, mod, car, env;
	mi = Line.ar(index, 0, dur);
	unmod = SinOsc.ar(carFreq, mul: 1 - mi);
	mod = SinOsc.ar(carFreq*ratio, mul:mi);
	car = SinOsc.ar(carFreq, mul:mod);
	env = EnvGen.kr(Env.linen(dur * 0.05, dur * 0.9, dur * 0.05, amp, \sine), doneAction:2);
	OffsetOut.ar(0, (car + unmod)*env);
	}
).add;
)

Synth(\ami, [\dur, 4, \carFreq,300, \modFreq, 450]);

Synth(\rmi, [\dur, 4])


(
var patt1, patt2;
patt1 = Pbind(
	\instrument, \ami,
	\carFreq, Pseq([[77, 81, 84].midicps]),
	\index, 0.25,
	\ratio, 0.4,
	\strum, 1,
	\dur, Pseq([4, 3.9, 3.8]),
	\amp, 1/6
);
patt2 = Pbind(
	\instrument, \rmi,
	\carFreq, Pseq([[72, 76, 79]].midicps),
	\index, 1,
	\ratio, 0.4,
	\dur, 4,
	\amp, 1/5
);
(patt1++patt2).play;
)

