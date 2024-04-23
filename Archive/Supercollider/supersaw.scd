
(
SynthDef(\superSaw2, {
    |freq = 400, amp=0.5, detuneFreq=0.5, detune=0.01, spread=0.1, pan=0, gate=1, out=0, atk = 0.01, rel=1, thickness=16, phaseFreq=0.1, phaseMax = 0.1|
    var maxThickness = 8;
    var sig = Array.fill(maxThickness, 0);
    var env = EnvGen.ar(Env.asr(atk,1, rel), gate, doneAction:2);
    var freqShift = SinOsc.ar(phaseFreq,).range(1-phaseMax, 1+phaseMax);
    maxThickness.do({
        |i|
        var sFreq = LFNoise1.ar(detuneFreq).range((1-detune)*freq, (1+detune)*freq);
        sig[i] = Saw.ar(sFreq * freqShift);
    });
    Out.ar(out, Splay.ar(sig, spread, amp, pan)*env);
}).add;
)


(
SynthDef(\superSaw, {
    |freq = 400, amp=0.5, detuneFreq=0.5, detune=0.01, spread=0.1, pan=0, gate=1, out=0, atk = 0.01, rel=1|
    var thickness = 8;
    var sig = Array.fill(thickness, 0);
    var env = EnvGen.ar(Env.asr(atk,1, rel), gate, doneAction:2);
    thickness.do({
        |i|
        var sFreq = LFNoise1.ar(detuneFreq).range((1-detune)*freq, (1+detune)*freq);
      //  var sPhase = Rand(0, 2pi);

        sig[i] = Saw.ar(sFreq);
    });
    Out.ar(out, Splay.ar(sig, spread, amp, pan)*env);
}).add;
)

(
Pdef(
    \poo,

    Pbind(
        \instrument, \superSaw,
        \midinote, Pseq([60, 62, 63, 62]+ 4, inf),
        \amp, 0.1,
        \detune, 0.01,
        \detuneFreq, 10,
        \dur, 0.125,
        \pan, Pseq([-1, -0.8, -0.6, -0.4, 0, 0.4, 0.7, 1], inf),
        \legato, 1
))
)
(
Pdef(
    \poo2,

    Pbind(
        \instrument, \superSaw,
        \midinote, Pseq([[48, 55], [43, 48]], inf),
        \amp, 0.2,
        \detune, 0.01,
        \detuneFreq, 10,
        \dur, 4,
        \phaseFreq, 0.0131,
        \phaseMax, 0.005,
        \pan, 0, //Pseq([-1, -0.8, -0.6, -0.4, 0, 0.4, 0.7, 1].reverse, inf),
        \legato, 1
))
)
Pdef(\poo2).play(quant:4)
(
Pdef(
    \poo3,
    Pbind(
        \instrument, \superSaw,
        \midinote, Pseq([40, 43, 42, 40], inf),
        \atk, 0.05,
        \rel, 0.5,
        \amp, 0.2,
        \detune, 0.01,
        \detuneFreq, 0.1,
        \dur, 4,
        \pan, 0,
        \legato, 1)
)
)


Pdef(\poo3).play(quant:4)

Ppar([Pdef(\poo2), Pdef(\poo2)])
[\poo, \poo2].do({|d| Pdef(d).stop})


x=Synth(\superSaw, [\freq, [300, 150], \amp, 0.15, \detuneFreq, 0.5, \detune, 0.001, \spread, 0.1, \pan, [-0.5, 0.5]])
x.set(\freq, 150)
x.set(\detune, 0.1)
x.set(\spread, 1)
x.set(\pan, 0)
x.map(\pan, {SinOsc.kr(0.1)}.play)
x.set(\detuneFreq, 100)

x.set(\gate,0)
