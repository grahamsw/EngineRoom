
(
MIDIClient.init;
MIDIClient.sources.postln;
MIDIClient.sources[3].postln;

MIDIIn.connect(0,MIDIClient.sources[3]);


~controls = Dictionary.with(*
	[
		\c1 -> 71, // pots, 0 -> 127
		\c2 -> 72,
		\c3 -> 73,
		\c4 -> 74,
		\c5 -> 22,
		\c6 -> 23,
		\c7 -> 26,
		\c8 -> 27,
		\c9 -> 20, // slider, 0 -> 127
		\c10 -> 32,  // button, val always 0
		\c11 -> 113, // button val 1 press, 0 release
		\c12 -> 116, // button val 1 press, 0 release
		\c13 -> 117, // button val 1 press, 0 release
		\c14 -> 118, // button val 1 press, 0 release
	]
);


~val2Freq = {|val, min=100, max=1000, warp=\exp|
	var out;
	~controlSpec = ControlSpec(min, max, warp);
	out = ~controlSpec.map(val/127.0);
	out.postln;
	out
};
~modfreq = 1;
~modindex = 1;

MIDIIn.control = { | src, chan, num, val|
	//[src, chan,num,val/127].postln;
	switch (num,
	 ~controls[\c1],  { ~modfreq = 1000 * val / 127.0 * 2},
	 ~controls[\c2],     { ~modindex =  val / 127.0 * 2}
	)
};


SynthDef(\FM, {
	| carrfreq = 440, modfreq = 1, modindex = 0, amp=0.5|
	[carrfreq, modfreq, modindex, amp].postln;
	e = EnvGen.kr(Env([0,1, 0.8, 0] * amp , [0.01, 1.2, 0.01]), doneAction:2);
	Out.ar(0,SinOsc.ar(carrfreq + (modindex*modfreq*SinOsc.ar(modfreq)),0, e))}
).add;


MIDIIn.noteOn = { arg src, chan, midinote, velocity;
	var freq = midinote.midicps;
	[freq, ~modfreq, ~modindex, velocity].postln;
	Synth(\FM, [\carrfreq, freq, \modfreq, ~modfreq, \modindex, ~modindex, \amp, velocity/127.0]);
};
)
