
(
~dp = {|p, n =10|
	var strm = p.asStream;
	strm.nextN(n);
}
)

// distributions
(
~pd = {
	|p, num=100|
	p.asStream.nextN(num).plot
}
)
l = (1..10);



~dp.(Pseq(list: (0..3), repeats:2, offset:1))
~dp.(Prand(list:l, repeats:14))
~dp.(Pxrand(list:l, repeats:14))
~dp.(Pser(list: l, repeats:2, offset:3))
~dp.(Pseries(start:0, step:6, length:20))
~dp.(Pshuf(list:l, repeats:2), n:30)

Shuffle the list in random order, and use the same random order repeats times. Like list.scramble.
~dp.(Pwrand(l, l.normalizeSum, 100))

Choose randomly, according to weighted probabilities (same as list.wchoose(weights)).
~dp.(Pseries(start: -81, step:3, length:29))
Arithmetic series (addition).
~dp.(Pgeom(start:1, grow:0.1, length:50))

//Geometric series (multiplication).
~dp.(Pwhite(lo: 1, hi: 5, length:34))
//Random numbers, equal distribution ("white noise"). Like rrand(lo, hi) .
~dp.(Pexprand(lo:1, hi:5, length:34))
Random numbers, exponential distribution. Like exprand(lo, hi) .
~dp.(Pbrown(lo:1, hi:100, step:6, length:30))
Brownian motion, arithmetic scale (addition).
~dp.(Pfunc({2}, {"poo".postln}))
a = Pfunc({2}, {"poo".postln}).asStream
a.reset
Get the stream values from a user-supplied function.
~dp.(Pfuncn({[\poo, \plop].choose}, 23))
Get values from the function, but stop after repeats items.
~dp.(Prout({var n = 0;
	loop{
		n = n + 1;
		n.yield;
	}
}))
)

[l,l].flatten

~dp.(Pslide(list:l, repeats:6, len:3, step:-1, start:1, wrapAtEnd:true))
//Play overlapping segments from the list.

~dp.(Pwalk(list:l, stepPattern: Pseq([1,2], inf), directionPattern: Pseq([1,-1],inf), startPos:0))
// Random walk over the list.

~dp.(Place(list:[[1,2],[3,4,5],[6,7]], repeats:4, offset:1))
//Interlace any arrays found in the main list.

~dp.(Ppatlace([Pseq([1,2,3],1), Pseq([4,5],10)], repeats:2, offset:0))
//Interlace any patterns found in the main list.
Ptuple(list, repeats)
//Collect the list items into an array as the return value.

p = Ppatlace([Pwhite(1, 5, 5), Pgeom(10, 1.01, 10)], inf);
x = p.asStream;
x.all;


l = [1,2,3,4,5,6]
~dp.(Pseq([1,2,3], 4, 2))

~dp.(Prand(l, 23))
~dp.(Pxrand(l, 23))
~dp.(Pshuf(l, 2))
(
var a, b;
a = Pseq([1, 2, 3], inf);
b = Pseq([65, 76], inf);
c = Ptuple([a, a, b], inf);
x = c.asStream;
8.do({ x.next.postln; });
)


(
var a, b;
a = Pseq([1, 2, 3], inf);
b = Pseq([65, 76], 3); // stops after 3 cycles
c = Ptuple([a, b], 1); // stops after 4 cycles
~dp.(c)
//x = c.asStream;
//8.do({ x.next.postln; });
)



~pd.(Pgbrown(lo:0.0, hi:100.0, step:0.1, length:1000))
//Brownian motion, geometric scale (multiplication).
~pd.(Pbeta(lo:0.0, hi:100.0, prob1:1, prob2:1, length:inf))
//Beta distribution, where prob1 = α (alpha) and prob2 = β (beta).
~pd.(Pcauchy(mean:0.0, spread:1, length:inf),1000)
Cauchy distribution.
Pgauss(mean, dev, length)
Guassian (normal) distribution.
Phprand(lo, hi, length)
Returns the greater of two equal-distribution random numbers.
Plprand(lo, hi, length)
Returns the lesser of two equal-distribution random numbers.
Pmeanrand(lo, hi, length)
Returns the average of two equal-distribution random numbers, i.e., (x + y) / 2.
Ppoisson(mean, length)
Poisson distribution.
Pprob(distribution, lo, hi, length, tableSize)
Arbitrary distribution, based on a probability table.

(
p = Pbind(
    \degree, Pseq(#[0, 0, 4, 4, 5, 5, 4], 1),
    \dur, Pseq(#[0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1], 1)
).play;
)

(
p = Pbind(
    \degree, Pslide((-6, -4 .. 12), 8, 3, 1, 0),
    \dur, Pseq(#[0.1, 0.1, 0.2], inf),
    \sustain, 0.15
).play;
)\\
\
Pslide(#[1, 2, 3, 4, 5, 6, 7, 8], 10, 3, 1, 0, false).asStream.all;

Pslide(#[1, 2, 3, 4, 5, 6, 7, 8], 10, 3, 1, 0, false).clump(3).asStream.all;



(
p = Pbind(
    \degree, Prand([0, 1, 2, 4, 5], inf),
    \dur, 0.25
).play;
)

// Pxrand: same as above but never repeats a pitch twice in a row
(
p = Pbind(
    \degree, Pxrand([0, 1, 2, 4, 5], inf),
    \dur, 0.25
).play;
)


// Pshuf: randomly ordered once and repeated
(
p = Pbind(
    \degree, Pshuf([0, 1, 2, 4, 5], inf),
    \dur, 0.25
).play;
)

(
p = Pbind(
    \degree, Pwrand((0..7), [4, 1, 3, 1, 3, 2, 1].normalizeSum, inf),
    \dur, 0.25
).play;
)


// Hanon exercise
(
p = Pbind(
    \degree, Ppatlace([
        Pseries(0, 1, 8),    // first, third etc. notes
        Pseries(2, 1, 7)    // second, fourth etc. notes
    ], inf),
    \dur, 0.25
).play;
)
(
~dp.(Ppatlace([
        Pseries(0, 1, 8),    // first, third etc. notes
        Pseries(2, 1, 7)    // second, fourth etc. notes
], inf)).clump(2).do(_.postln)
)


(
p = Pbind(
    \degree, Ptuple([
        Pseries(7, -1, 8),
        Pseq([9, 7, 7, 7, 4, 4, 2, 2], 1),
        Pseq([4, 4, 4, 2, 2, 0, 0, -3], 1)
    ], 1),
    \dur, 1
).play;
)

(
p = Pbind(
    \degree, Pseries(-7, 1, 15),
    \dur, Pgeom(0.5, 0.89140193218427, 15)
).play;
)


p = Pbind(\degree, Pwhite(0, 7, inf), \dur, 0.25, \legato, 1).play;
p.stop;

p = Pmono(\default, \degree, Pwhite(0, 7, inf), \dur, 0.25).play;
p.stop;





(
// first, pitches ascending by 1-3 semitones, until 2 octaves are reached
var    pitches = Pseries(0, Pconst(24, Pwhite(1, 3, inf)), inf).asStream.all,
        // randomly block 1/3 of those

    mask = pitches.scramble[0 .. pitches.size div: 3];
pitches.nextN(20).postln;
mask.nextN(20).postln;
p = Pbind(
    \arpeg, Pseq(pitches[ .. pitches.size - 2] ++ pitches.reverse[ .. pitches.size - 2], inf),
        // if the note is found in the mask array, replace it with Rest
        // then that note does not sound
    \note, Pif(Pfunc { |event| mask.includes(event[\arpeg]) }, Rest(0), Pkey(\arpeg)),
    \octave, 4,
    \dur, 0.125
).play;
)


(
SynthDef(\bass, { |out, freq = 440, gate = 1, amp = 0.5, slideTime = 0.17, ffreq = 1100, width = 0.15,
        detune = 1.005, preamp = 4|
    var    sig,
        env = Env.adsr(0.01, 0.3, 0.4, 0.1);
    freq = Lag.kr(freq, slideTime);
    sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
        * EnvGen.kr(env, gate, doneAction: Done.freeSelf);
    sig = LPF.ar(sig, ffreq);
    Out.ar(out, sig ! 2)
}).add;
)

// Scale segments, in the sequence: up, up, down (repeat)
(
TempoClock.default.tempo = 1;
p = Pbind(
    \degree, Pseq([
        Pseries({ rrand(0, 7) }, 1, { rrand(4, 8) }),    // up (step = 1)
        Pseries({ rrand(0, 7) }, 1, { rrand(4, 8) }),    // up (step = 1)
        Pseries({ rrand(7, 14) }, -1, { rrand(4, 8) })    // down (step = -1)
    ], inf),
    \dur, 0.125
).play;
)

p.stop;
(
TempoClock.default.tempo = 132/60;
p = Pxrand([
    Pbind(            // repeated notes
        \instrument, \bass,
        \midinote, 36,
        \dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.5], 1),
        \legato, Pseq([0.9, 0.3, 0.3, 0.3, 0.3], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,        // octave jump
        \midinote, Pseq([36, 48, 36], 1),
        \dur, Pseq([0.25, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,        // tritone jump
        \midinote, Pseq([36, 42, 41, 33], 1),
        \dur, Pseq([0.25, 0.25, 0.25, 0.75], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,        // diminished triad
        \midinote, Pseq([36, 39, 36, 42], 1),
        \dur, Pseq([0.25, 0.5, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    )
], inf).play(quant: 1);
)

p.stop;
(
var    n = 10,
    scaleSegments = Array.fill(n, { |i|
        if(i.odd) {
            Pseries(11, -1, rrand(5, 10))
        } {
            Pseries(rrand(-4, 4), 1, i+2)
        }
    });


scaleSegments.do({|seg| seg.asStream.nextN(11).postln});


TempoClock.default.tempo = 1;
p = Pbind(
    \degree, Pswitch(scaleSegments, Pseq([Pwhite(0, n-1, 4), Pwhite(0, n-1, 1).select(_.odd)], inf)),
    \dur, 0.125
).play;


)

p.stop;


~dp.(Pwhite(0, 10-1, 1).select(_.odd))
~dp.(Pwhite(0, 10-1, 4))
p=[Pwhite(0, 10-1, 4), Pwhite(0, 10-1, 1).select(_.odd)]


~dp.(Pseq([Pwhite(90, 99, 4), Pwhite(0, 10-1, 1).select(_.odd)], inf))


(
var a, b;
a = Pseq([1, 2, 3], 2);
b = Pseq([65, 76]);
c = Pswitch([a, b, 800], Pseq([2, 2, 0, 1], inf));
x = c.asStream;
24.do({ x.next.postln; });
)


(
d = (
	\aa: 1,
	\bb: 4,
	\cc: 7
);
)

~pw = Pxrand([\aa,\bb,\cc], inf)

~dp.(~pw)
~dp.(Psym(Pxrand([\aa,\bb,\cc], inf), d))


~dp.(Pswitch([\aa,\bb,\cc], Pxrand([0,1,2], inf)))

Quarks.folder
Quarks.install("https://github.com/supercollider-quarks/MathLib.git");


a = WeighBag.with((1..5), #[4, 2, 2, 2, 1]);
({ a.wchoose } ! 100).histo(5, 1, 5);

~dp.(Pseq([100,101,102],1) +.x Pseq(#[0, 4], 1),20)


(
p = Pbind(
    \midinote, Pwhite(48, 72, inf) +.x Pseq(#[0, 4, 7, 11], 1),
    \dur, 0.125
).play;
)

(
p = Pbind(
    \degree, Pseries(4, Pwhite(-2, 2, inf).reject({ |x| x == 0 }), inf).fold(-7, 11),
    \dur, Prorate(0.6, 0.5)    // actually yields 0.3, 0.2, 0.3, 0.2...
).play;
)


~dp.(Pn(Pseq([1,2],1), 4))
	