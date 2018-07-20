



(
SynthDef(\syn, {|freq = 440, form1 = 1.4, form2=0.7, amp = 0.4, out = 0, tone = 1, dur = 1, t_gate = 1, pan = 0|
	var sound = Formant.ar(freq, formfreq: freq * form1, bwfreq: freq * form2, mul: amp) * EnvGen.kr(Env([0, 1, 1, 0], [0.1, dur-0.3, 0.2]), doneAction: 2);
	OffsetOut.ar(out, Pan2.ar(sound, pan))
}).add;

)
Synth(\syn)
(
Tdef(\x, {
	var notes = Pseq([1,2,3,4,5,6] + 50, inf).asStream;
	var durs = Pseq([1, 1, 1, 20,2].normalizeSum * 10, inf).asStream;
	var amps = Pwhite().asStream * 0.7;
	var form1s = Pseq([0.8, 0.9, 1.2, 1.4,  2], inf).asStream;
	var form2s = Pseq([0.8, 0.9, 1.2, 1.4,  2] * 0.8, inf).asStream;
	var pans = Pbrown(-1, 1).asStream;
	var dur = durs.next.postln("dur");
	loop
	{
		Synth(\syn, [\amp, amps.next * 0.125, \freq, notes.next.midicps, \pan, pans.next, \form1, form1s.next.postln, \form2, form2s.next.postln, \dur, dur]);
		dur.wait;
	}
}).play
)

Tdef(\x).stop;


