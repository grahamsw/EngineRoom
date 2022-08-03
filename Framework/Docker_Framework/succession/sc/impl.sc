Quarks.install("panola");

~melodies = Dictionary.new;
~clocks = Dictionary.new;

~getClock = {|key|
    ~clocks.atFail(key, {
        ~clocks[key] = TempoClock.new;
        ~clocks[key];
    });
};

~getMelody = {|key|
    ~melodies.atFail(key, {
        ~melodies[key] = (
            \proxy: EventPatternProxy(),
            \instrument: \default,
            \out: 0
        );
        ~melodies[key];
    });
};

~setProxy = {|proxy, melody, instrument, repeats |
    var panola = Panola.new(melody);
    var midinotes = panola.midinotePattern.list;
    var durs = panola.durationPattern.list;
    var amps = panola.volumePattern.list;
    // if the change/play message is sent over OSC
    // I won't be able to send numeric inf, so handle the
    // symbol \inf
    repeats = (repeats == \inf).if({inf}, {repeats});
    proxy.source_(
        Pbind(
            \instrument, instrument,
            \midinote, Pseq(midinotes, repeats),
            \amp, Pseq(amps, repeats),
            \dur, Pseq(durs, repeats)
        )
    );
};

//performance events:
// array (or dictionary) of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths directly via Routines
// (control FX synths, for example, for fade in/out etc)
// might be called manually, or from a Pattern or a Routine, or from
// a GUI, or MIDI, or from external code via OSC

~events = [
    \set_clock: {|bpm, key=\default|
        ~getClock.(key).tempo_(bpm/60);
    },

    \start: {
        |melodyKey, melody, repeats=\inf, instrument=\default, quant=4, clock=\default|
        var mm = ~getMelody.(melodyKey);
        ~setProxy.(mm[\proxy], melody, instrument, repeats);
        mm[\instrument] = instrument;
        mm[\player] =  mm[\proxy].play(~getClock.(clock), quant:quant);

    },


    \stop: {
        |melodyKey|
        ~getMelody.(melodyKey)[\player].stop;
    },

    \change: {
        |melodyKey, melody, repeats=\inf|
        var mm = ~getMelody.(melodyKey);
        ~setProxy.(mm[\proxy], melody, mm[\instrument], repeats);
    },

].asDict;




~allocBusses = {

};

~initServerNodes = {
    ~fxGroup = Group.new;
};


// SynthDefs for the Synths used in the piece
~defineSynths = {
    // using default (piano) for now

};

// list of Pbinds
~definePbinds = {
    // for this the pbinds are created dynamically by events
    // passing in Panola strings
};


