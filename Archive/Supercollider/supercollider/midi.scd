
(
MIDIClient.init;
MIDIClient.sources.postln;
MIDIClient.sources[3].postln;

MIDIIn.connect(0,MIDIClient.sources[3])
)

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
}


MIDIIn.control = { | src, chan, num, val|
	//[src, chan,num,val/127].postln;
	switch (num,
	 ~controls[\c1],  { ~synth.set(\carrfreq, ~val2Freq.value(val, 100, 1000))},
	 ~controls[\c2],     { ~synth.set(\modfreq,  ~val2Freq.value(val, 100, 1000))},
	 ~controls[\c3],     { ~synth.set(\modindex, 2 * val/127.0)},
	 ~controls[\c4],     { ~synth.set(\amp,       val/127.0)}
	)
}

(
SynthDef(\FM, {
	| carrfreq = 440, modfreq = 1, modindex = 0, amp=0.5|
	//e = EnvGen.kr(Env([0,0.4, 0.3, 0], [0.2, 1.2, 0.2]), doneAction:2);
	Out.ar(0,SinOsc.ar(carrfreq + (modindex*modfreq*SinOsc.ar(modfreq)),0, amp))}
).add;
)

~synth = Synth(\FM);



(

MIDIIn.noteOn = { arg src, chan, midinote, velocity;
	var carrfreq, modfreq, modindex;
	carrfreq = midinote.midicps;
	modfreq = carrfreq * velocity/127.0;
	//modindex = ~bend * 10;
	[midinote, velocity].postln;
	//Synth(\fmratio, [\modfreq, midinote.midicps, \cmratio, velocity/127.0, \index, 1-(velocity/127.0)]);
	Synth(\PMCrotale,[\midi,midinote,\amp,velocity/127.0])
	//Synth(\FM, [\carrfreq, carrfreq, \modfreq, modfreq, \modindex, modindex]);
};

)
(
SynthDef(\sound,{arg freq=440, amp=0.1;
var saw, filter, env;

saw= Saw.ar(freq);

filter= Resonz.ar(saw,1000,0.1)*amp;

Out.ar(0,filter.dup(2))
}).add
)
a= Synth(\sound,[\freq,77,\amp,0.9]); //create running synth
MIDIIn.control = { arg src, chan, num, val;   a.set(\amp, val/127) };


}; //control change messages have a 7 bit value

MIDIIn.bend = { | src, chan, bend|
	~bend = bend/8192/2;
	[chan,~bend].postln;
	 };
//pitch bend has a 14 bit range and is a bipolar signal (so bend/8192 will remap the range to -1.0 to 1.0)
// actually this is 0 to 1

)

