MIDIClient.init;
MIDIIn.connectAll;

(



MIDIdef.noteOn(\noteOnTest, {
  | vel, nn, chan, src |
  [vel, nn].postln;
  ~notes[nn] = Synth(\tone,
                    [
                       \freq, nn.midicps,
                       \amp, vel.linexp(1,127, 0.1, 0.4),
                       \gate, 1,
                       \bend, ~bend.linlin(0, 16838, -2, 2),
                    ]
                    );
  });

MIDIdef.noteOff(\noteOffTest, {
  | vel, nn |
  [vel, nn].postln;
  ~notes[nn].set(\gate, 0);
  ~notes[nn] = nil;
  });

MIDIdef.bend(\bendTest, {
  | val, chan, src |
	[val, chan, src].postln;
  ~bend = val;
  ~notes.do{ |synth| synth.set(\bend, val.linlin(0, 16383, -2, 2))};
  });

MIDIIn.control = {
	| src, chan, num, val|
	[src, chan,num,val/127].postln;
}
)
  ~bend = 8192;


(

  (
  SynthDef(\tone, {
    | freq = 440, amp = 0.3, gate = 0, bend = 0 |
    var sig, env;
	sig = Mix.ar(SinOsc.ar(freq * bend.midiratio * [1, 1.004]));
    env = EnvGen.kr(Env.adsr, gate, doneAction:2);
		sig = FreeVerb.ar(sig * env * amp, 0.6, 0.5);
    Out.ar(0, sig);
  }).add;
  )
)
  ~notes = Array.newClear(128);



)


().play