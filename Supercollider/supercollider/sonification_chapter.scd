(

q = q ? ();
q.execdata = ();
q.execdata.years = (1977 .. 2008);
q.execdata.regions = (
	Total: [1099, 1, 0, 2, 0, 1, 2, 5,21,18,18,25, 11,16, 23, 14, 31, 38, 31, 56, 45, 74, 68, 98, 85, 66, 71, 65, 59, 60, 53, 42, 37],
	Northeast: [4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0],
	Midwest: [ 129, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 5, 1, 1,4, 3, 11, 9, 10, 5, 12, 5, 10, 9, 7, 7, 14, 6, 5, 2],
	South: [933, 0, 0, 2, 0, 0, 3, 5, 21, 16, 18, 24, 10, 13, 17, 13, 26, 30, 26, 41, 29, 60, 55, 74, 76, 50, 61, 57, 50, 43, 44, 36, 35],
	West: [67, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 1, 2, 1, 0, 4, 4, 2, 2, 7, 4, 8, 11, 4, 4, 1, 1, 0, 2, 2, 3, 1, 0],
	Texas: [423, 0, 0, 0, 0, 0, 1, 0, 3, 6, 10, 6, 3, 4, 4, 5, 12, 17, 14, 19, 3, 37, 20, 35, 40, 17, 33, 24, 23, 19, 24, 26, 18]
);
q.getReg = { | q, regName| q.execdata.regions[regName].drop(1)};
)
(
[
q.getReg(\Total).size,
q.getReg(\Northeast).size,
q.getReg(\Midwest).size,
q.getReg(\South).size,
q.getReg(\West).size,
	q.getReg(\Texas).size,].postln;

)

s = Server.local
(
Pbindef(\exec,
	\instrument, \organdonor,
	\note, Pseq(q.getReg(\Total)),
	\octave, 3,
	\dur, 5 / q.execdata.years.size
).play;
)

Pbindef(\exec, \note, Pseq(q.getReg(\Northeast)));
Pbindef(\exec, \note, Pseq(q.getReg(\West)));
Pbindef(\exec, \note, Pseq(q.getReg(\South)));

b = Buffer.sendCollection(s, q.getReg(\Northeast), 1);
(
Ndef(\exec, {|dur=5, scale = 50, offset = 200|
	var vals = PlayBuf.ar(1, b, dur / SampleRate.ir);
	Pan2.ar(
		SinOsc.ar(vals * scale + offset), 0,
		EnvGen.kr(Env.linen(0.01, dur, 0.01, 0.2), doneAction:2));
}).play;
)


(
SynthDef(\noisepulse, {
	|out = 0, sustain= 1.0, numPulses=0, pan=0.0, amp=0.2|
	Out.ar(out,
		PanAz.ar(4,
			PinkNoise.ar *  Decay2.ar(Impulse.ar(numPulses/sustain, 0, numPulses.sign), 0.001, 0.2),
			pan,
			EnvGen.kr(Env.linen(0.0, 0.995, 0.0), levelScale:amp, timeScale: sustain, doneAction:2)
		)
	);
}).add;
SynthDef(\tick, {
	|out = 0, amp = 0.2, pan|
	OffsetOut.ar(out, Pan2.ar(Impulse.ar(0) * Line.kr(amp, amp, 0.001, doneAction: 2), pan))
}).add;
)

(instrument: \noisepulse, numPulses: 10, legato: 1, dur:2).play;
(instrument: \tick).play;

(
Tdef(\execs, {
	var yearDur = 2;
	var region, numExecs, numyears = q.execdata.years.size;
	[\Northeast, \Midwest, \West, \South].do { |regName, i|
		region = q.execdata.regions[regName].postln;
		q.execdata.years.do { |year, i|
		numExecs = region[i + 1];
		[regName, year, numExecs].postln;
		(instrument: \tick).play;
		if (numExecs > 0) {
			(instrument: \noisepulse, legato: 1, numPulses: numExecs, dur: yearDur).play;
		};
		yearDur.wait;
	};
	yearDur.wait;
	};
}).play
)
