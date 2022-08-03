p.pop

// a SynthDef, creating single-channel grain when instantiated
(
SynthDef(\grain, { |out=0, freq=300, amp=0.3|
    OffsetOut.ar(out, Pulse.ar(freq) * EnvGen.kr(Env.perc, doneAction: Done.freeSelf) * amp)
}).add;
)

// number of channels
~numChans = 5;

// values in a Pattern may be set in various ways
// here we use control buses, except for \dur which
// doesn't accept a control bus in parallel playing streams
// therefore we use PatternProxies
~durs = ~numChans.collect({ |i| PatternProxy(0.5 + (i/10)) });

// other parameters could as well be controlled in PatternProxies,
// yet, control buses are convenient either
~freqs = Bus.control(s, ~numChans);
~freqs.setn(Array.geom(~numChans, 300, 1.1));
~amps = Bus.control(s, ~numChans);
~amps.setn(0.2!~numChans);
Pset
// the Pattern: a Ppar holding one Pbind for each channel,
// all wrapped in a Pdef
(
Pdef(\ppar,
    Ppar({ |i|
        Pbind(
            \instrument, \grain,
            // we only set a single channel
            \dur, ~durs[i],
            \freq, ~freqs.subBus(i).asMap,
            \amp, ~amps.subBus(i).asMap,
            // the Pattern will play to a yet unknown private bus
            // we only want to make sure the offset is right
            \channelOffset, i,
        )
    }!~numChans)
)
)

// initialize an Ndef that will hold the Pdef as its source
// make sure the Ndef gets initialized to the right number of channels by calling 'mold'
Ndef(\ppar).mold(~numChans, \audio, \elastic);
Ndef(\ppar)[0] = Pdef(\ppar);

// mix the 5 channel audio coming from Ndef(\ppar) down to stereo
// Splay will spread the channels over the stereo panorama
// possibly use headphones to clearly identify the effect
Ndef(\stereo, { Splay.ar(\in.ar(0!~numChans)) });

// concatenate the Ndefs, so Ndef(\ppar)'s out will feed into Ndef(\stereo)'s in
Ndef(\stereo) <<> Ndef(\ppar);
Ndef(\stereo).play;

// change durations
~durs.do({ |pp, i| pp.source = Pseq(Array.fib(5, i/10 + 0.1, i+1/5), inf) });
~durs.do({ |pp, i| pp.source = 0.5 + (i/10) });
~durs.do({ |pp| pp.source.postcs });

// frequencies
~freqs.setn(Array.geom(~numChans, 250, 1.6));
~freqs.setn(Array.geom(~numChans, 300, 1.1));

// add a filter Ndef
(
Ndef(\filter, {
    HPF.ar(
        \in.ar(0!~numChans),
        SinOsc.ar({|i| 2 + i}!~numChans) + 1 * \multFreq.kr(Array.geom(~numChans, 400, 2))
    )
}).mold(~numChans, \audio, \elastic);
)

// set a fadeTime for smooth transitions and add the filter to the chain
#[ppar, stereo, filter].do({ |k| Ndef(k).fadeTime_(3) });
Ndef(\stereo) <<> Ndef(\filter) <<> Ndef(\ppar);

// set filter param, considering fadeTime
Ndef(\filter).xset(\multFreq, Array.rand(~numChans, 20, 10000));

Ndef.clear;
Pdef.clear;