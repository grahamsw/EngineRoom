// connects a basic synth to any MIDI controller

(
// can swap in another synth as long as it has a
// freq, amp, and gate
~midiSynth = \cosc;
~clock = TempoClock.new;
~notes = Array.newClear(128);
~isRecording = false;

s.waitForBoot({
    s.sync;

   ~coscbuff = Buffer.alloc(s, 2048, 1);
   ~coscbuff.sine1(1.0/(1..6), true, true, true);

   SynthDef(\cosc,
            {
                |freq = 400, amp = 0.1, gate = 1, buf=0, beats=1, pos = 0, out = 0|

                var sig, env;
                env =  EnvGen.kr(Env.adsr, gate);
                sig = COsc.ar(buf, freq, beats, amp);
                Out.ar(out, Pan2.ar(env * sig, pos));
        }).add;

  SynthDef(\midiSynth, {
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
    var amp = vel.linexp(1,127, 0.05, 0.3);
    var note = [~clock.beats.round(0.0125), amp.round(0.001), nn];
  note.postln;
  ~notes[nn] = Synth(~midiSynth,
                    [
                       \freq, nn.midicps,
                       \amp, amp,
                       \gate, 1,

                    ]
                    );
    if (~isRecording, {~history = ~history.add(note)});
  });


MIDIdef.noteOff(\noteOffTest, {
  | vel, nn |
  [nn].postln;
  ~notes[nn].set(\gate, 0);
  ~notes[nn] = nil;
  });

~startRecording = {
     ~history = [];
    ~isRecording = true;
    ~clock = TempoClock.new(1, 0)

};

~stopRecording = {
    ~isRecording = false;
};

~playback = {
    var midinotes, durs, amps, lastBeat = 0;
    amps = ~history.collect({
        |evt|
        evt[1];
    });

    midinotes = ~history.collect({
        |evt|
        evt[2];
    });

    durs = ~history.collect({
        |evt, ix|
        var lim = ~history.size - 1;
        if (ix < lim,
            {~history[ix + 1][0] - evt[0]},
            {1});
    });

    Pbind(\instrument, ~midiSynth, \amp, Pseq(amps, 1), \midinote, Pseq(midinotes, 1), \dur, Pseq(durs, 1)).play(t);
    [\amp, amps, \midinote, midinotes, \dur, durs];
};


)

(\midinote: 60).play
(\degree: 0).play
(\note: 0).play
(\degree: ).play
(\note: 2).play
(\midinote: 62).play
(\degree: 2).play
(\midinote: 59).play
(\degree:-1).play
(\midinote: 57).play
(\degree:-2).play
(\midinote:55).play
(\degree:-3).play

~startRecording.value

~history.do{
   |hist|
    hist.postln;
}
~clock.beats

~playback.value
~history.size - 1