(
Server.default = s = Server.local;
s.boot;
s.makeGui;
s.scope(2);
)

a = Pbind.new.play(quant:1.0);
a.stop


Pbind(\freq, 330).play(quant:1.0);

(
Pbind(
	\dur, 0.125,
	\midinote, Pseq([0, 4, 0, 7, 4, 0, 0] + 60, inf),
	\amp, Prand([0.125, 0.2, 0.25], inf)
).play(quant:1.0)
)

(
Pbind(
	\freq, Pseq([125,250, 200, 300], inf)
).play.quant(0.75)
)

(
Pbind(
	\freq, Pseq([250], inf)
).play.quant(0.5)
)
(
a = [8, 1, 1, 1].normalizeSum;
Pbind(
	\midinote, Pwrand([0,1,2,3] + 60,  [2,1,6,3].normalizeSum, 5)
).play
)

a = Pseq([1, 3, 400],1);

[8, 1, 1, 1].normalizeSum

x = a.asStream
x.next
y = a.asStream
y.next



(
var a,x,y;

a = Pshuf((1..10), inf);
x = a.asStream;
y = a.asStream;

x.nextN(10).postln;
y.nextN(10);
)


(
var a =  Pshuf([1, 1, 0, 1, 0], 3);
Pbind(
	\dur, 0.125,
	\midinote, a * 7 + 60,
	\amp, a * 0.1
).play
)


(
Pbind(
	\freq, Pseq([Pseq([100, 200, 300], 2), 400, 500, 600],inf)
).play;
)


Pbind(\midinote, [1,5,8,10] + 60).play

(
Pbind(
	\midinote, [61, 61.04]
).play
)

p = Pbind(
        \note, Pxrand([
                Pn([1,5,8], 2),
                Pn([0,2,7], 2),
                [-1,4,10],
                [-4,5,9]
        ], 100),
        \dur, 0.5
).play



(
SynthDef(\alicepavelinstr, {arg out=0, alice=440, pavel=0.5, pan=0.0, gate=1;
			var z;
			z = Resonz.ar(Pulse.ar(alice, pavel),XLine.kr(5000,1000),0.1,5) * Linen.kr(gate, 0.01, 0.1, 0.3, 2);
			Out.ar(out, Pan2.ar(z, pan));
			 }
).add
)

(
var clock;

clock = TempoClock(1.5); // tempoclock at 90 bpm

Pbind(
	\alice, Pseq(440*[1,2,3],inf),   // freq
	\pavel, Pseq([0.1,0.5, 0.8],inf),		// pulse width
	\dur, Pseq([0.5,0.25,0.25],inf),				// duration of event in beats
	\legato, 0.5,							// proportion of inter onset time to play
	\instrument, \alicepavelinstr			// your own synthesiser
).play(clock);
)


(
Pbind(// cobinding of properties
	[\freq, \amp],
	Pseq([
		[440,0.4],
		[330,0.1],
		Pfuncn({
			[550.rand, 0.8.rand]
		}, 1)
	], inf)
).play
)


(
	var melodypat, basspat;

	melodypat = Pbind(
			[\midinote, \dur],
			Pseq([
				[60, 0.75],[64, 0.5],[66, 0.5],[69, 0.25],
				[67,0.75],[64,0.5],[60,0.5],[57,0.25]
			],inf)
	);

	basspat = Pbind(
			\midinote, Pseq([48, 42], inf),
			\dur, 1
	);

	Ppar([ melodypat, basspat ]).play(TempoClock(1));
)



(
p = Prout({
	var x0, y0, x, y;
	x0 = 0; y0 = 0;

	loop({
		x = y0 + 1 - (1.4 * x0 * x0);
		y = 0.3 * x0;
		x0=x; y0=y;
		[x, (y*14).asInteger].yield;
	});
});


//)

//p.asStream.nextN(20).postln

// \degree is the degree of the scale provided in \scale-
// this is where the dorian tuning comes from
b = Pbind(\scale, [0,2,4,5,7,9,11], \dur,0.125,[\pan, \degree], p);

// the order of arguments in Pbindf has been switched since SC2- this may change back again- be careful!
Ptpar([ 0.0, Pbindf(b, \octave, 4,\stretch, 3.0), 4.0, b]).play(TempoClock(1));





