(
SynthDef
(\UGen_ex4a, {
	|id, limit=1|
	var src, pitch, hasPitch, keynum, outOfTune;
	src = SoundIn.ar(0);
	#pitch, hasPitch = Pitch.kr(src);
	//pitch.postln;
	pitch = pitch.cpsmidi;
	outOfTune = (pitch - pitch.round).abs < 0.25;
	SendTrig.kr(Trig.kr(outOfTune, limit), id, pitch.round);
	//Out.ar(0, src);
}).add;


SynthDef(\UGen_ex4b, {
	| id1, id2, limit = 1, thresh = 0.5|
	var src, amp, amptrig, timer;
	src = SoundIn.ar(0);
	amp = Amplitude.kr(src);
	amptrig = Trig.kr(amp > thresh, limit);
	timer = Timer.kr(amptrig);
	SendTrig.kr(amptrig, id1, amp);
	SendTrig.kr(amptrig, id2, timer);
}).add;


SynthDef(\UGen_ex4c, {
	| freq |
	Out.ar(1, SinOsc.ar(freq, 0, XLine.kr(0.1, 0.1, 0.5, doneAction: 2)));
}).add;


SynthDef(\UGen_ex4d, {
	| freq |
	Out.ar(1, LFNoise1.ar(200) * SinOsc.ar(freq, 0, XLine.kr(0.1, 0.00001, 0.5, doneAction: 2)));
}).add;

a = UniqueID.next;
b = UniqueID.next;
c = UniqueID.next;

e = Env([440, 880], [1], \exp);

o = OSCresponderNode(s.addr, '/tr', {
	|time, responder, msg|
	msg.postln;

	case
	{msg[2] == a}
	{Synth(\UGen_ex4c, [\freq, msg[3].midicps])}
	{msg[2] == b}
	{Synth(\UGen_ex4d, [\freq, e[msg[3]]])}
	{msg[2] == c}
	{SystemClock.sched(msg[3], {
		Synth(\UGen_ex4d, [\freq, 2000])
		})
	}
}).add;

SystemClock.sched(1.0, {
	"making responder synths".postln;
	Synth(\UGen_ex4a, [\id, a, \limit, 1]);
	Synth(\UGen_ex4b, [\id1, b, \id2, c, \limit, 0.2, \thresh, 0.001]);
});

CmdPeriod.doOnce({
	o.remove;
	"Removed OSC responder".postln;
})


)