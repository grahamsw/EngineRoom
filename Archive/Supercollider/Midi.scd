// connects a basic synth to any MIDI controller

(


~notes = Array.newClear(128);

s.waitForBoot({
    s.sync;

  SynthDef(\tone, {
    | freq = 440, amp = 0.3, gate = 1|
    var sig, env;
	sig = Mix.ar(SinOsc.ar(freq * [1, 1.0001]));
    env = EnvGen.kr(Env.adsr, gate, doneAction:2);
	sig = FreeVerb.ar(sig * env * amp, 0.1, 0.5);
    Out.ar(0, sig);
  }).add;
    s.sync;
});

MIDIClient.init;
MIDIIn.connectAll;
MIDIdef.freeAll;

MIDIdef.noteOn(\noteOnTest, {
  | vel, nn, chan, src |
  [vel, nn].postln;
  ~notes[nn] = Synth(\tone,
                    [
                       \freq, nn.midicps,
                       \amp, vel.linexp(1,127, 0.1, 0.4),
                       \gate, 1,

                    ]
                    );
  });

MIDIdef.noteOff(\noteOffTest, {
  | vel, nn |
  [vel, nn].postln;
  ~notes[nn].set(\gate, 0);
  ~notes[nn] = nil;
  });
)

