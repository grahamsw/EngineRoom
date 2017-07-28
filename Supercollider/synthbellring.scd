(

SynthDef(\sinPerc, {|freq = 440, pos = 0, amp = 0.125, detune = 0.025|
	var sig = Mix.fill(10, {SinOsc.ar(freq + Rand(0, freq * detune))});
	sig = FreeVerb.ar(sig * EnvGen.kr(Env.perc));
	DetectSilence.ar(sig, -96.dbamp, doneAction:2);
	Out.ar(0, Pan2.ar(sig, pos, amp));
}).add;

)

(
SynthDef(\bell, {
	var pattern = LFPulse.kr(12, width:0.5);
	Out.ar(0, Mix.new(SinOsc.ar([440, 442, 670, 677], mul:[2,2, 1,1].normalizeSum) * pattern * LFPulse.kr(0.5)));
}).add;
)
Synth(\bell)