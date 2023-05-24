s.boot;

MIDIClient.init;
MIDIIn.connectAll;

MIDIFunc.trace(true);
(
SynthDef(\harm, {
    |harm=8, out = 0|
    Out.kr(out, harm.lag(0.1));
}).add;

SynthDef(\vib, {
    |vib=1, out = 0|
    var sig = SinOsc.kr(6.5).bipolar(vib.lag(0.05)).midiratio;
    Out.kr(out, sig);
}).add;

SynthDef(\tri, {
    |freq = 200, vibin = 0, harmin = 0,gate=1, amp = 0.1, out = 0|
    var sig, env, harm, vib;
    harm = In.kr(harmin, 1);
    vib = In.kr(vibin, 1);
    freq = freq * vib;
    sig = {Saw.ar(freq + Rand(-2.0, 2.0))}!8;
    sig = Splay.ar(sig);
    sig = RLPF.ar(sig, (freq * harm).clip(20,20000), 0.5);
    env = EnvGen.ar(Env.adsr(0.001,0.3,0.5, 0.5), gate:gate, doneAction:2);
    sig = sig * env * amp;
    Out.ar(out, sig);
}).add;
)







(
~notes = Array.fill(128, nil);

MIDIdef.noteOn(\on, {
    |val, num|
    [val,num].postln;
    ~notes[num] = Synth(\tri, [
        \freq, num.midicps.postln,
        \vibin, ~vibbus,
        \harmin, ~harmbus,
        \amp, val.linlin(0, 127, -30, -6).dbamp.postln,
        \gate, 1
    ]);


});

MIDIdef.noteOff(\off, {
    |val, num|
    ~notes[num].set(\gate, 0);
    ~notes[num] = nil;
});

MIDIdef.cc(\harm, {
    |val, num|
    ~harm.set(\harm, val.linlin(0, 127, 2, 20));

},  4);

MIDIdef.cc(\vib, {
    |val, num|
    ~vib.set(\vib, val.lincurve(0, 127, 0, 1,3));

},  1)
)

(
~harmbus = Bus.control(s,1);
~vibbus = Bus.control(s,1);


~harm = Synth(\harm, [\out, ~harmbus, \harm, 9], s.defaultGroup, \addBefore);

~vib = Synth(\vib, [\out, ~vibbus, \vib, 0.5], s.defaultGroup, \addBefore);
)

(
~harm.set(\harm, 9);
~vib.set(\vib, 0.1);
~harmbus.getSynchronous;
~vibbus.getSynchronous;
)
