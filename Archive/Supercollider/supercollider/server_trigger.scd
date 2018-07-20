(
SynthDef(\UGen_ex4a, {
	|id, limit=1|
	var src, pitch, hasPitch, keynum, outOfTune;
	src = SoundIn.ar(0);
	#pitch, hasPitch = Pitch.kr(src);
	pitch = pitch.cpsmidi;
	outOfTune = (pitch - pitch.round).abs < 0.25;
	SendTrig.kr(Trig.kr(outOfTune, limit), id, pitch.round);
}).add;




SynthDef(\UGen_ex4b, {
	| id1, id2, limit=1, thresh=0.5|
	var src, amp, amptrig, timer;
	src = SoundIn.ar(0);
	amp = Amplitude.kr(src);
	amptrig = Trig.kr(amp > thresh, limit);
	timer = Timer.kr(amptrig);
	SendTrig.kr(amptrig, id1, amp);
	SendTrig.kr(amptrig, id2, timer);
}).add;

SynthDef(\UGen_ex4c, {
	|freq|
	Out.ar(1, SinOsc.ar(freq, 0, XLine.kr(0.1, 0.00001, 0.5, doneAction:2)));
}).add;

SynthDef(\UGen_ex4d, {
	|freq|
	Out.ar(1, LFNoise1.ar(200) * SinOsc.ar(freq, 0, XLine.kr(0.1, 0.00001, 0.5, doneAction:2)));
}).add;
)


#a, b, c = 3.collect({UniqueID.next});

e = Env([400, 880], [1], \exp);

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
		Synth(\UGen_ex4d, [\freq, 2000]);
	})}
}).add;

SystemClock.sched(1.0, {
	Synth(\UGen_ex4a, [\id, a, \limit, 1]);
	Synth(\UGen_ex4b, [\id1, b, \id2, c, \limit, 0.2, \thresh, 0.25]);
});


{LFNoise1.ar(200) * SinOsc.ar(500, 0, XLine.kr(1, 0.00001, 2))}.play