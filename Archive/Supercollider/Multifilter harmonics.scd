
(

var sound = {
	var rq, i, f, w;
	i = 6;
	rq = 0.01;
	f = 100;
	w = WhiteNoise.ar;
	a = Array.series(i, f, f).postln;
	m =LPF.ar( Mix(BPF.ar(w, a, rq, i )), 700);
};

sound.scope(10);
)


(

~bus = Bus.audio(s, 1);
~filt = {
	|in|
	var input = In.ar(in);
	var i = 10;
	q = 0.01;
	f = 100;
	a = Array.series(i, f, f);
	n = BPF.ar(input, a, q, i);
	m = Mix.ar(n) * 0.2;
	[m, Silent.ar(1), input];
}.scope;
)

~bus.scope

~filt.set(\in, ~bus);

~source = { Out.ar(~bus, Pulse.ar(100, 0.1, mul:0.1))}.play
~source.free
~source = {Out.ar(~bus, Dust2.ar(100, mul:1))}.play
~source = {Out.ar(~bus, LFNoise0.ar(100, 0.1, mul:1))}.play
~source = {Out.ar(~bus, WhiteNoise.ar(100, 0.1, mul:1))}.play
~source = {Out.ar(~bus, BrownNoise.ar(100, 0.1, mul:1))}.play




