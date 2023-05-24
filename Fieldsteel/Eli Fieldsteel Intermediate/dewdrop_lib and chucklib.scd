m = MixerChannel(\fig1, s, 1, 2)

b = MixingBoard(\Fig1, nil, m)



(SynthDef(\fig1, {
    |outbus, lowfreq = 220, hifreq = 1200, decay = 0.05|
    var trig = Impulse.kr(8);
    Out.ar(outbus, SinOsc.ar(TExpRand.kr(lowfreq, hifreq, trig))*Decay2.kr(trig, 0.01, decay));
}).add;

)

a = m.play(\fig1,[\lowfreq: 100, hifreq:2000, decay:0.1])

m.automate(\pan, {SinOsc.kr(LFNoise1.kr(0.5).exprange(0.4, 5.0))})

m.watch(\pan)

(
r =  MixerChannel(\rvb, s, 2,2,level:1, completionFunc:{|chan|
    "creating reverb synth".postln;
    chan.playfx({|outbus|
        var sig = In.ar(outbus, 2);
        FreeVerb2.ar(sig[0], sig[1], 1, 0.6, 0.5)
    });
});
b.add(r)
)

m.newPostSend(r, 0.6)
b.postSettings
m.levelTo(0,15)
m.free
r.free

(
v = Voicer(10, \default );

v.mapGlobal(\pan, nil, 0, \bipolar);
v.mapGlobal(\amp, nil, 0.1, ControlSpec(0.01, 1));
v.mapGlobal(\legato, nil, 1, ControlSpec(0.01, 10));
v.mapGlobal(\detune, nil, 0, ControlSpec(0.0, 1 ));
v.gui
)

(
p = Pbind(
    \type, \voicerNote,
    \voicer, v,
    \degree, Pn(Pseries(0, 1, 8),inf),
   // \amp, Pwhite(0.05, 0.15, inf),
    \dur, 0.125,
    \detune, [1,2]
).play

)

(\detune: [1,3]).play




v.trigger([440,660],1)
v.release(660)
v.gate(400, 2.0, 1, [pan:-0.5])


(
r = {
    loop{
        [60,62,64,65,67,69,71,72].do({|midi|
            v.gate(midi.midicps, 0.1, 1, [amp: rrand(0.06, 0.15)],lat:0.1);
            0.125.wait;
        });
    }
}.fork
)

r.stop


().play


(
v = Voicer(10, \default);
k = VoicerMIDISocket(0, v);

k.addControl(1, \pan, 0, \bipolar);
v.gui;
/*
k.midiToFreq = TuningRatios(12, tunings:[ 1, 135/128, 9/8, 6/5, 5/4, 4/3, 45/32, 3/2, 14/9, 27/16, 16/9, 15/8]);*/

k.noteOnArgsPat = Pbind(\amp, Pkey(\velocity).linlin(0, 127, 0.01, 0.2));

)
d
v.free
s.latency
)


(

(

i = Instr([\test, \miditest], {

	arg freq = 440, gate = 0, env, pb = 1, ffreq = 1000, rq = 1;

	var out, amp;

	amp = Latch.kr(gate, gate);	// velocity sensitivity

	out = EnvGen.kr(env, gate, doneAction:2) *

		RLPF.ar(Pulse.ar(freq * pb, 0.25, amp), ffreq, rq);

	[out,out]

}, [\freq, \amp, nil, nil, \freq, \rq]);



v = Voicer(10, i, [\env, Env.adsr(0.01, 0.2, 0.75, 0.1), \rq, `0.2]);



k = VoicerMIDISocket(0, v);

k.addControl(1, \ffreq, 1000, \freq);   // filt. cutoff by mw

k.addControl(\pb, \pb, 1, 3);	// 3-semitone bend



v.gui;	// the controllers show up in the window, w/ visual feedback when you move the wheels

)
)