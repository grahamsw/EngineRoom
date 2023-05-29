~voscs = ();

~createVoscObject = {
    | out = 0, freq = 80, amp = 0.5,
    detuneLow = 0.05, detuneHigh = 0.2,
    durLow = 0.15, durHigh = 0.55,
    buffSet = 1, controlSynth = \passThroughPan,
    pan = 0
    |
    var ob = (
        \out: out,
        \freq:freq, \amp:amp,
        \detuneLow:detuneLow, \detuneHigh:detuneHigh,
        \durLow:durLow, \durHigh:durHigh,
        \buffs:  ~makeBufs.(buffSet),
        \playBus: Bus.audio(s, 1),
        \pan: pan

    );
    var buffs = ob[\buffs];
    ob[\controlSynth] = Synth(controlSynth, [\in, ob[\playBus], \out, out, \pan, pan ]);
    ob[\pVosc] = Pmono(\VoscChorus,
        \out, ob[\playBus],
        \dur, Pwhite(Pfunc({ob[\durLow]}), Pfunc({ob[\durHigh]})),
        \bufindex, Pbrown(buffs[0].bufnum, buffs[buffs.size - 2].bufnum, 0.3),
        \detune, Pbrown(Pfunc({ob[\detuneLow]}), Pfunc({ob[\detuneHigh]})),
        \freq, Pfunc({ob[\freq]}),
        \amp, Pfunc({ob[\amp]})
    );

    ob;
};


~freeBufs = {
    | bufs |
    bufs.do {|buf|
        buf.free;
    }
};

/*
~makeBufs1 = {
| numbuffs = 8|

var makeWaveform = {
|numLevs = 7|
var numPts = numLevs + 1;
var levs = {rrand(-1.0,1.0)}!numLevs;
var peak = levs.abs.maxItem;
levs = levs * peak.reciprocal;
Env(
[0]++ levs ++ [0],
{exprand(0.01,1)}!numPts,
{exprand(0.1,4)}!numPts
).asSignal(512).asWavetable;

};

~freeBufs.(~bufs);
~numbuffs = numbuffs;
~bufs = numbuffs.collect({
| i |
Buffer.loadCollection(s, makeWaveform.((i + 1) * 3));
});
~buffbase = ~bufs[0].bufnum;
};
*/

~makeBufs = {
    | which=1 |
    var numbuffs = 8;
    var buffs = Buffer.allocConsecutive(numbuffs, s, 1024, 1);
    buffs.do({ arg buf, i;
        var n =(numbuffs), a;
        a = switch(which,
            1, {Array.fill(i+1, { arg j; ((n-j)/n).squared.round(0.001) })},
            2, {Array.fill(i, 0) ++ [0.5, 1, 0.5];},
            3, {a = Array.fill(32,0);
                12.do({a.put(32.rand, 1).postln });
                a},
            //a = Array.fill((i+1)**2, { arg j; 1.0.rand2 });
            {Array.fill((i+1)**2, {1.0.rand2 })}
        );
        a.postln;
        buf.sine1(a);
    });
    buffs;
};

//~makeBufs.(1).do({|i| i.plot})

~loadBuffs = {

};


~allocBusses = {

};

~initServerNodes = {
    ~fxGroup = Group.new;
};

// SynthDefs for the Synths used in the piece
~defineSynths = {
    SynthDef(\VoscChorus,{
        |out = 0, bufindex = 0, freq=400, detune=0.15, amp=1|
        var rats = Rand(0.08, 0.15)!8;
        var cfreq = freq  * (LFNoise1.kr(rats).bipolar(detune).midiratio);
        var sig = VOsc.ar(bufindex.lag(0.1), cfreq, Rand(0, 2pi), amp);
        sig = Splay.ar(sig);
        sig = LeakDC.ar(sig);
        Out.ar(out, sig * amp);
    }).add;

    SynthDef(\reverb, {
        | out = 0, mix = 0.1|
        var dry = In.ar(out);
        var wet =FreeVerb.ar(dry,0.45,2.0,0.5);
        wet = DelayN.ar(wet, 0.03, 0.03);
        wet = SplayAz.ar(2, wet);
        wet = LPF.ar(wet, 1500);
        XOut.ar(out, mix, wet);
    }).add;

    SynthDef(\passThrough, {
        |in, out = 0|
        Out.ar(out, In.ar(in));
    }).add;

     SynthDef(\passThroughPan, {
        |in, out = 0, amp=1, pan=0|
        Out.ar(out, Pan2.ar(In.ar(in), pan, amp));
    }).add;
};

// list of Pbinds
~definePbinds = {

};

//performance events:
// array (or dictionary) of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths directly via Routines
// might be called manually, or from a Pattern or a Routine, or from
// a GUI, or MIDI, or from external code via OSC

~events = [
    \start: {
      //  ~reverb = Synth(\reverb, [\mix, 0.2]);
    },
    \addVosc: {
        |key|
        ~voscs[key] = ~createVoscObject.();
    },
    \playVosc: {
        |key|
        ~voscs[key][\stream] = ~voscs[key][\pVosc].play;
    },
    \stopVosc: {
        |key|
        ~voscs[key][\stream].stop;
    },
    \setFreq: {
        |key, freq|
        ~voscs[key][\freq] = freq;
    },
    \setDetune: {
        |key, detuneLow=0.05, detuneHigh=0.2|
        ~voscs[key][\detuneLow] = detuneLow;
        ~voscs[key][\detuneHigh] = detuneHigh;
    },
    \setDur: {
        |key, durLow=0.15, durHigh=0.55|
        ~voscs[key][\durLow] = durLow;
        ~voscs[key][\durHigh] = durHigh;
    },
    \setAmp: {
        |key, amp|
        ~voscs[key][\amp] = amp;
    },
    \setReverbMix: {
        |mix|
        ~reverb.set(\mix, mix);
    }
].asDict;

~runstart = {



~events[\start].();
~events[\addVosc].(\bass);
~events[\playVosc].(\bass);
~events[\setFreq].(\bass,100);
~events[\setAmp].(\bass, 0.5);
~events[\setDetune].(\bass, 0.1, 0.15);


~events[\addVosc].(\aa);
~events[\playVosc].(\aa);
~events[\setFreq].(\aa,200);
~events[\setAmp].(\aa, 0.3);
~events[\setDetune].(\aa, 1, 2);




~events[\addVosc].(\bb);
~events[\playVosc].(\bb);
~events[\setFreq].(\bb, 300);
~events[\setAmp].(\bb, 0.3);
~events[\setDetune].(\bb, 0.1, 0.12);


~voscs[\bb][\controlSynth].set(\pan, 1, \amp, 0.5);
~voscs[\aa][\controlSynth].set(\pan, -1, \amp, 0.5);
~voscs[\bass][\controlSynth].set(\pan, 1, \amp, 0.5);
}
