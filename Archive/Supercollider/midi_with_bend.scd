(

SynthDef(\multi, {
	var sig, amp, env;
	env = EnvGen.kr(
		Env.new([0,1,0], [10, 10], [1, -1]), doneAction:2);

	amp = SinOsc.kr({ExpRand(0.2, 12)}!16).range(0,1);
	sig = SinOsc.ar({ExpRand(50, 1200)}!16);
	sig = sig * amp * env;
	sig = Splay.ar(sig) * 0.5;
	Out.ar(0, sig);
}
).add;
)

x = Synth(\multi);


(
SynthDef(\iter, {
	   var snd = Mix.fill(10, {
				 VarSaw.ar(	100 * {Rand(0.99, 1.02)}!2, mul:0.05)
		});
		Out.ar(0, snd * 0.5 );
}).add;
)


Synth(\iter)


(
SynthDef(\blip, {
	| out = 0|
	var freq, trig, sig;
	freq = LFNoise0.kr(3).exprange(300, 1200).round(300);
	sig = SinOsc.ar(freq) * 0.25;
	trig = Dust.kr(2);
	sig = sig * EnvGen.kr(Env.perc(0.01, 0.2), trig);
	sig = Pan2.ar(sig, LFNoise1.kr(10));
	Out.ar(out, sig);
}).add;

Synth(\blip);

)

(SynthDef(\reverb, {
	|in, out = 0|
	var sig;
	sig = In.ar(in,2);
	sig = FreeVerb.ar(sig, 0.5, 0.8, 0.2);
	Out.ar(out, sig);
}).add;
)


Synth(\blip)

().play

y = Synth.new(\reverb, [\in, ~b]);
x = Synth.new(\blip, [\out, ~b]);

~b = Bus.audio(s, 2)
~b.index

x.free
y.free
s.freeAll


~folder = PathName.new("C:/Windows/media");
~folder.entries

(
MIDIClient.init;
MIDIIn.connectAll;

MIDIClient.sources.postln;
MIDIClient.sources[1].postln;

MIDIIn.connect(0,MIDIClient.sources[1]);
)


(
SynthDef(\tone, {
		|freq = 440, amp=0.3, gate=0, bend = 0|
		var sig, env;
	sig = LFTri.ar(freq * bend.midiratio)!2;
	    env = EnvGen.kr(Env.adsr, gate, doneAction:2);
	   Out.ar(0, sig * env * amp);
}).add;

)




x = Synth(\tone, [\gate, 1]);
x.set(\gate, 0)
(
~notes = Array.newClear(128);
~bend = 8192;


MIDIdef.noteOn(\noteOnTest, {
	|vel, nn, chan, src|
	[vel, nn, chan, src].postln;
	~notes[nn] = Synth(\tone,
		[
			\freq, nn.midicps,
			\amp, vel.linexp(1, 127, 0.01, 0.4),
			\gate, 1,
			\bend, ~bend.linlin(1, 16383, -2, 2)
	]);

});

MIDIdef.noteOff(\noteOffTest, {
	|vel, nn|
	~notes[nn].set(\gate, 0);
	~notes[nn] = nil;
});


MIDIdef.bend(\bendTest, {
	|val, chan, src|
	[val, chan, src].postln;
	~bend = val;
	~notes.do{|synth| synth.set(\bend, ~bend.linlin(1, 16383, -2, 2))};
});
)

});


)





	