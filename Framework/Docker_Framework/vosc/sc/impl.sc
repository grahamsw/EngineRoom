~voscs = ();
~numBuffsets = 4;

~out = 0;

~allocBusses = {

};

~initServerNodes = {

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

        ~rand = {1000000.rand.round(1)};
        ~reverb = Synth(\reverb, [\mix, 0.2]);
        ~runstart.()
    },
    \setReverbMix: {
        |mix|
        ~reverb.set(\mix, mix);
    }
].asDict;


