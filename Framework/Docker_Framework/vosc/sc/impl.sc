~voscs = ();
~numBuffsets = 4;

~out = 0;

~allocBusses = {

};

~initServerNodes = {

};

// list of Pbinds
~definePbinds = {
    ~pbinds = ();
    ~pbinds[\first] =  Pbind(
        \instrument, \VoscPlayer,
        \bufSet, Prand([0,1,2,3], inf).trace,

        \bufLow, Pfunc({|e| ~buffsets[e[\bufSet]][0] }),
        \bufHigh,Pfunc({|e| ~buffsets[e[\bufSet]][7] }),
        \bufSteps, 100,
        \detuneLow, 0.15,
        \detuneHigh, 0.2,
        \detuneSteps,100,
        \freq, Prand([80, 160, 240, 320], inf),
        \amp, 0.3,
        \panLow, -1,
        \panHigh, 1,
        \panSteps, 30,
        \spread, 0,
        \releaseTime, 15,
        \legato, Pwhite(3, 5),
        \dur, Pwhite(20, 70, inf)
    )
};

//performance events:
// array (or dictionary) of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths directly via Routines
// might be called manually, or from a Pattern or a Routine, or from
// a GUI, or MIDI, or from external code via OSC

~events = [
    \start: {

        ~rand = {1000000.rand.round(1)};
        ~reverb = Synth(\reverb, [\mix, 0.2]);
        ~runstart.()
    },
    \setReverbMix: {
        |mix|
        ~reverb.set(\mix, mix);
    },
    \startPbind: { |key|
        Pdef(key,
            ~pbinds[key]).play;
    },
    \stopPbind: {|key|
        Pdef(key).stop;
    }
].asDict;


