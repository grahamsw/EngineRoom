
(
SynthDef(\sinewave,
	{
	| freq=440, phase=0, amp=1, add=0|
	var sin;
	sin = SinOsc.ar(freq, phase, amp, add);
	Out.ar(0, sin);
}).add;

)
(
t = Synth(\sinewave);
t.set(\freq, 550);
t.set(\freq, 880);
)

{RLPF.ar(Dust.ar([12, 15]), LFNoise1.ar([0.3, 0.2]).range(100, 3000), 0.02)}.play;

rrand(10, 12);


(
Pbind(
\degree, Pxrand([2, 3, 4, 5, 6], inf),
	\dur, Pseq
(
Pbind(
\degree, Pseq([0, −1, 2, −3, 4, −3, 7, 11, 4, 2, 0, −3], 5),
\dur, Pseq([0.2, 0.1, 0.1], inf),
\amp, Pseq([0.7, 0.5, 0.3, 0.2], inf),
\legato, 0.4
).play;
)([0.15, 0.1, 0.2, Rest(0.2)], inf),
\amp, 0.2,
\legato, 0.1
).play;
)

(
Pbind(
\freq, Pwhite(100, 500),
\dur, Prand([0.15, 0.25, 0.3], inf),
\amp, 0.2,
\legato, 0.3
).trace.play;
)


(
Pbind(
\note, Pslide([0, 2, 3, 5, 7, 8, 11, 12], 7, 3, 1),
\dur, 0.15;
).play;
)

(
Pbind(
\note, Pseq([[0, 3, 7], [2, 5, 8], [3, 7, 10], [5, 8, 12]], 3),
\dur, 0.15
).play;
)

(
Pbind(
\note, Pser([0, 2, 3, 5, 7, 8, 11, 12], 11),
\ctranspose, 5, // transpose an octave above (= 12 semitones)
\dur, 0.15;
).play;
)




( // open big block
Pbind(
\freq, Pn(Pseries(110, 111, 10)),
\dur, 1/2,
\legato, Pwhite(0.1, 1)
).play;
Pbind(
\freq, Pn(Pseries(220, 222, 10)),
\dur, 1/4,
	\legato, Pwhite(0.1, 1)
).play;
Pbind(
\freq, Pn(Pseries(330, 333, 10)),
\dur, 1/6,
\legato, 0.1
).play;
) // close big block


(
{
"one thing".postln;
3.wait;
"another thing".postln;
2.5.wait;
"one last thing".postln;
}.fork;
)

t)}


~scale = [0,1,2,3,4];
~scale.reverse + 7;


(
p = Pbind(
\midinote, Pseq([57, 62, 64, 65, 67, 69], inf),
\dur, 1/7
); // no .play here!
)

~player = p.play;

~player.stop;

~player.resume;


~player.stop;
~player.start;
~player.reset;

"hello".dup(4);

3.15159.round(0.1);

100.0.rand.round(0.01).dup(4);

dup(rand(100.0, 0.01), 4);

exprand(1.0,2.0);
dup({exprand(1.0,1000.0)}, 100);