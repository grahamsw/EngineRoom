(
SynthDef(\sinPerc, {|freq=440, pos = 0, level = 0.125, detune = 0.025|
	var sig =
	Mix.fill(10, { SinOsc.ar(freq + Rand(0, freq*detune))});
	sig = FreeVerb.ar(sig * EnvGen.kr(Env.perc));
	DetectSilence.ar(sig, -96.dbamp, doneAction:2);
	Out.ar(0, Pan2.ar(sig, pos, level));
}).add;

SynthDef(\impPerc, {|freq=440, pos = 0, level = 0.125, detune = 0.025|
	var sig =
	Mix.fill(10, { Impulse.ar(freq + Rand(0, freq*detune))});
	sig = FreeVerb.ar(sig * EnvGen.kr(Env.perc));
	DetectSilence.ar(sig, -96.dbamp, doneAction:2);
	Out.ar(0, Pan2.ar(sig, pos, level));
}).add;


SynthDef(\pulsePerc, {|freq=440, pos = 0, level = 0.125, detune = 0.025|
	var sig =
	Mix.fill(10, { Pulse.ar(freq + Rand(0, freq*detune), width:0.1)});
	sig = FreeVerb.ar(sig * EnvGen.kr(Env.perc));
	DetectSilence.ar(sig, -96.dbamp, doneAction:2);
	Out.ar(0, Pan2.ar(sig, pos, level));
}).add;


SynthDef(\sawPerc, {|freq=440, pos = 0, level = 0.125, detune = 0.025|
	var sig =
	Mix.fill(10, { Saw.ar(freq + Rand(0, freq*detune))});
	sig = FreeVerb.ar(sig * EnvGen.kr(Env.perc));
	DetectSilence.ar(sig, -96.dbamp, doneAction:2);
	Out.ar(0, Pan2.ar(sig, pos, level));
}).add;


)



Synth(\sinPerc)
Synth(\impPerc)
Synth(\pulsePerc)
Synth(\sawPerc)




s.options.memSize = 2 ** 24


(
p = Pseq([0,2,4,3,10,13,122,6,5,7], inf).asStream;
q = Pseq([1,1,2,1,4,1,3,3,1], inf).asStream;
~density = Pseq([1,2,4,1,3], inf).asStream;
~interval = Pseq([3,4,7,6], inf).asStream;
~octave = Pseq([-1,0,0,1],inf).asStream;


{
	inf.do{
		var den = ~density.next;
		den.do{
			var delta = ~interval.next;
			var oct = ~octave.next;
			Synth(\sinPerc, [\freq, (p.next + 70 + delta +(12 * oct)).midicps,\level, 0.1/den])};
		(q.next * 0.125).wait;
	};
}.fork
)


(
var mel = [0,3,5,6,7,9,10], rhy = [1,1,3,2,1,2];
var pan = Array.series(5, -1, 2/4);

var arrPseq = Array.fill(4, {Pseq(mel, inf).asStream});
var durPseq = Array.fill(4, {Pseq(rhy, inf).asStream});
var panPseq = Array.fill(4, {Pseq(pan, inf).asStream});

4.do{|i|
	{
		inf.do{
			var freqSeq = arrPseq[i];
			var freq = (12 * i + freqSeq.next+48).midicps;
			var durSeq = durPseq[i];
			var dur = durSeq.next * 0.125*(i + 1);
			var pan = panPseq[i].next;
			Synth(\sinPerc, [\freq, freq, \pos, pan, \level, 0.07]);
			dur.wait;
		}
	}.fork;
}
)
	