
(
SynthDef(\wave, {
	| out = 0, freq = 440, amp = 0.1, sustain = 0.1, mod = 0.2|
	OffsetOut.ar(out,
		EnvGen.ar(Env.perc(ExpRand(0.001, 0.05), sustain, amp), doneAction:2)
		*
		SinOsc.ar(freq, SinOsc.ar(sustain.reciprocal * 8, [0, Rand(0, pi)], mod))
	)
}).add
)

p = ProxySpace.push
~out.play

~out.fadeTime = 3

(
~out = { |freq = 440, mod = 0.4, detune = 0.1, a_in = #[1,1]|
	freq = [freq, freq * ( 1 + detune)];
	LFTri.ar(LFTri.ar(mod * freq).range(freq * mod, freq)) * a_in * 0.2;
};
)

~mod2 = {LFNoise1.kr(1).range(0,1)};
~mod1 = {LFPulse.kr(~mod2.kr * 30,  + 1, 0, 0.3)}

~freq1 = { ~mod1.kr * 13100 + 100};
~freq2 = { LFTri.kr(30) * 200 + 300}

~audio1 = {BrownNoise.ar(LFClipNoise.kr(10.dup), 1)}
~audio2 = { SinOsc.ar(LFNoise2.kr(1.dup).exprange(4, 1000))}



	~out.map(\freq, ~freq1, \mod, ~mod2)
	~out.set(\detune, 0.1)

	~out.xmap(\freq, ~freq2, \mod, ~mod1)
	~out.xmap(\a_in, ~audio2)
	~out.xmap(\a_in, ~audio1)

	~out.xmap(\a_in, {[1,1]})

p.clear(2).pop

().play
Synth(\wave)
(
Tdef(\x, {
	x = 4; y = 13;
	loop {
		x = ( x * y) % 11;
	(instrument: \wave, note: x.postln, sustain: 0.5, octave: 6).play;
	0.125.wait;
}
}
).play
)
Tdef(\x).stop


(
Tdef(\a, {10.do { (instrument: \wave, freq: 50.rand + 1500).play; 0.03.wait}});

Tdef(\b, {[1, 5, 1, 2, 8, 4, 12].do { |x| (instrument: \wave, note: x + 8).play; 0.1.wait} });

Tdef(\c, { "c is just a waiting message".postln; 2.wait;});

Tdef(\x, {
	loop {
		Tdef(\a).embed;
		1.wait;
		Tdef(\b).embed;
		2.wait;
		Tdef(\a).fork;
		Tdef(\b).fork;
		Tdef(\c).embed;
	}
}).play
)

Tdef(\a, {inf.do { (instrument: \wave, freq:  50 + 1200).play; 0.1.wait;}});

Tdef(\a, { 10.do { (instrument: \wave, freq: 50.rand + 800).play; 0.1.wait;}});

Tdef(\x).stop


(

Tdef(\a, { |in|
	in.at(\n).do { |i|
		in = (instrument: \wave, detune: 5.rand2).putAll(in);
		in.postln.play;
		in.delta.wait;
	}
});
)

(
Tdef(\x, {|inevent|
	loop {
		Tdef(\a).embed((note:[15, 17], dur: 0.01, n: 13));
		1.wait;
		Tdef(\a).embed((note: 9, dur: 0.4, n: 4));
		1.wait;
	}
}).play;
)

().postln

History.start


Pdefn(\x, Pseq([0, 2, 0, 7, 6, 5, 4, 3], inf));
(
Task( {
	var stream = Pdefn(\x).asStream;
	var val;
	loop {
		val = stream.next;
		(instrument: \wave, note: val, \amp: 0.4).play;
		0.2.wait;
	}
}).play;
)

Pdefn(\x, Pseq([0, 2, 0, 8, 6, 5, 2, 3, 4, 5], inf));
Pdefn(\x, Pwhite(0, 22, inf).round);


Pdefn(\y, Pdefn(\x) + 2)

Pdefn(\z, Pdefn(\x) + Pseq([0, 5, 0, 7, 2], inf))

Pdefn(\a, Ptuple([Pdefn(\y), Pdefn(\z)]));

(
Task {
	var stream = Pdefn(\a).asStream;
	var val;
	loop {
		val = stream.next.postln;
		(instrument: \wave, note: val, sustain: rrand(0.5, 0.9), amp: 0.4).play;
		0.2.wait;
	};
}.play;
)

Pdefn(\x, Pseq([0,11], inf))
Pdefn(\x, Pseq([0,2,0,7,6, 5, 4, 3].scramble + 5, inf))
Pdefn(\z, Pdefn(\x) + Pseq([1,5,1,11,1], inf))

Pdefn(\a, 5)
Pdefn.clear

Pdef(\a).play
Pdef(\a, Pbind(\instrument, \wave))
Pdef(\a, Pbind(\instrument, \wave, \dur, Pseq([1,3,2,3], inf)/6, \amp, 0.4));
Pdef(\a).pause
Pdef(\a).resume
Pdef(\a).stop

PdefGui(Tdef(\x))
