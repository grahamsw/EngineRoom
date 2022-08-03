// busses and nodes may be needed for effects, and control
// otherwise these two functions can be left empty
"loading".postln;

~allocBusses = {

};

~initServerNodes = {
   // ~fxGroup = Group.new;
};

// SynthDefs for the Synths used in the piece
~defineSynths = {
    SynthDef(\demo, {
        |freq=440, amp=0.5, gate=1, attack=0.01, release=0.3, sustain=0.5,pan=0, out=0|
        var signal = Saw.ar(freq, amp);
        var env = EnvGen.kr(Env.adsr(attackTime:attack, decayTime:release, sustainLevel:sustain), gate:gate, doneAction:Done.freeSelf);
        Out.ar(out=out, Pan2.ar(signal*env, pos:pan));
    }).add();
};

// list of Pbinds
~definePbinds = {
     ~pb = EventPatternProxy(
            Pbind(
              \instrument, \demo,
              \note, 7,
              \amp, 0.5,
              \dur, 1
        ))
    ;
   ~clock = TempoClock.new(1).permanent_(true);
};

//performance events:
// array (or dictionary) of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths directly via Routines
// might be called manually, or from a Pattern or a Routine, or from
// a GUI, or MIDI, or from external code via OSC


~events = [
    \start: {~player = ~pb.play(~clock, quant:4);},
	\stop: {~player.stop;},
    \setNote: {|degree|
        ~pb.source_(
            Pbind(
              \instrument, \demo,
                \degree, Pseq((degree..(degree+3)),inf),
                \attack, Pseq([2,2,3,4]/100,inf),
                \decay, Pseq([2,1,4,3]/10,inf),
                \legato, 2,
                \amp, 0.3,

        )).quant_(1);
    },
    \setClock: {|tempo|
        ~clock.tempo = tempo;
    }

].asDict;

/*
~events[\start].()
~events[\stop].()
~events[\setNote].(2)
~events[\setClock].(0.3)
*/