
~clockbus = Bus.control(s,1);
(
var maxDivision = 96;
var f = {
	~clock = {

		|bpm = 60|
		var tick = Impulse.kr(bpm/60.0 * maxDivision);
		var count = PulseCount.kr(tick);
		Out.kr(~clockbus, count);
	}.play;
	"clock reinit".postln;
};

f.();
//ServerTree.removeAll;
//ServerTree.add(f, s);
~tc = {
	|div|
	(In.kr(~clockbus) / (maxDivision / div)).floor;
};
~tg = {
	|div|
	Trig1.kr(((In.kr(~clockbus) % (maxDivision / div)).floor < 1),0.01);
};
~tc = {
	|div|
	(In.kr(~clockbus) / (maxDivision / div)).floor;
};
~gate = {
	|div, n, seqs|
	Mix(seqs.collect({|c| (~tc.(div) %n).floor eq: c}) * ~tg.(div));
};
)

s.meter.window.alwaysOnTop_(true);

~clock.set(\bpm, 80);

Ndef(\bass).fadeTime_(2).play;
(
Ndef(\bass, {
	var gate = ~tg.(4);
	var note =TIRand.kr(50,50,gate);
	Pan2.ar(PMOsc.ar(note.midicps, note.midicps*0.5, TIRand.kr(1,8,gate), 0.0, EnvGen.kr(Env.perc(0.0, 0.5), gate)))*0.2;
})
)
Ndef(\arp).fadeTime_(2).playN(outs:[0,1,16,17], amps:[0.4,0.4,0.08, 0.08]);

(
Ndef(\arp, {
	var gate = ~tg.(4);
	var note = TChoose.kr(gate, [55,58,62,65]) + 12;
		Pan2.ar(PMOsc.ar(note.midicps, note.midicps * 0.5*TIRand.kr(1,4,gate),  TIRand.kr(1,4,gate), 0.0, EnvGen.kr(Env.perc(0.0, 1.0), gate)))*0.2;
	}

)
)
