// busses and nodes may be needed for effects, and control
// otherwise these two functions can be left empty
"loading".postln;

~allocBusses = {
    ~fxBus = Bus.audio(s, 2);
};

~initServerNodes = {
    ~fxGroup = Group.new;
};

// SynthDefs for the Synths used in the piece
~defineSynths = {
    SynthDef.new(\reverb, {
	arg in=0, drylevel=0.7, wetlevel=0.3, out=0;
	var sig, reverb;
	sig = In.ar(in, 2);
	reverb = In.ar(in, 2);
	reverb = LPF.ar(GVerb.ar(sig, 250, 4), 900);
	sig = (sig * drylevel) + (reverb * wetlevel);
	Out.ar(out, sig);
}).add;


    SynthDef(\drone, {
        |freq=440, amp=0.5, gate=1, pan=0, out=0|
        var signal = Mix.fill(3, {|i| LFSaw.ar(freq + (0.125*i), 1/6)});
        var throb = LFPulse.kr(freq: 10, iphase:Rand.new(0.0, 2pi), width:0.9).range(0.5, 1);

        var env = EnvGen.kr(Env.adsr(attackTime:0.001, decayTime:0.1, sustainLevel:1), gate:gate, doneAction:Done.freeSelf);
        Out.ar(out, Pan2.ar(signal *env *amp * throb, pos:pan));
    }).add();



    SynthDef(\drone2, {
        |freq=440, amp=0.5, gate=1, pan=0, out=0|
        var signal = Mix.fill(3, {|i| LFSaw.ar(freq + (0.125*i), 1/6)});
        var throb = LFPulse.kr(freq: 10, iphase:Rand.new(0.0, 2pi), width:0.9).range(0.5, 1);

        var env = EnvGen.kr(Env.adsr(attackTime:0.001, decayTime:0.1, sustainLevel:1), gate:gate, doneAction:Done.freeSelf);
        Out.ar(out, Pan2.ar(signal *env *amp * throb, pos:pan));
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

~drones = [].asDict;

~events = [
    \createFx: {
        ~reverb = Synth(\reverb, [\in, ~fxBus, \drylevel, 0.7, \wetlevel, 0.3, \out, 0;], ~fxGroup)
    },

    \playDrone: {
        |id, freq= 50, amp=0.2, pan=0|
        ~drones[id]  = Synth(\drone, [\freq, freq, \amp, amp, \pan, pan, \out, ~fxBus]);
    },
    \setDrone: {
        |id, freq, amp, pan|
        ~drones[id].set(\freq, freq, \amp, amp, \pan, pan);
    },

    \killDrone:{
        |id|
        ~drones[id].free;

    },

    \setClock: {|tempo|
        ~clock.tempo = tempo;
    }

].asDict;
s.gui
//
/*
x = Synth(\drone, [\freq, 40, \out, ~fxBus])
x.set(\freq, 64)
x.set(\amp, 0.2)
x.set(\pan, 0.7)

y = Synth(\drone, [\freq, 40])
y.set(\freq, 47)
y.set(\amp, 0.2)
y.set(\pan, -0.7)

z = Synth(\drone, [\freq, 68, \amp, 0.2])
z.set(\freq, 56)
z.set(\amp, 0.3)

().play
~events[\start].()
~events[\stop].()
~events[\setNote].(2)
~events[\setClock].(0.3)

~events[\playDrone].(\drone1, 40, 0.2, 0)
~events[\playDrone].(\drone2, 50, 0.2, -0.9)
~events[\playDrone].(\drone3, 100, 0.2, 0.9)


~events[\setDrone].(\drone1, 33, 0.2, 1)
~events[\setDrone].(\drone2, 75, 0.3, 0)
~events[\setDrone].(\drone3, 90, 0.1, -1)

~events[\killDrone].(\drone1);
~events[\killDrone].(\drone2);
~events[\killDrone].(\drone3);

0.midiratio
)
3.collect{|i| (0.125*i);}

(
~pb = EventPatternProxy(
    Pmono(\drone, \freq, Pseq([40, 43, 47], inf), \amp, 0.2, \pan, Pwhite(-1.0, 1.0), \dur, 0.5)
)
)

~pb.play
(
~pb.source_(
    Ppar( [
    Pmono(\drone, \freq, Pseq([90, 79, 91], inf), \amp, 0.05, \pan, -0.5, \dur, 7, \out, ~fxBus),
    Pmono(\drone, \freq, Pseq([72, 75, 81], inf), \amp, 0.05, \pan, 0.5, \dur, 6, \out, ~fxBus),
    Pmono(\drone, \freq, Pseq([152, 75, 37], inf), \amp, 0.05, \pan, 0, \dur, 5, \out, ~fxBus),

    ])
)
)

~pb.stop

~events[\createFx].()
*/

//~reverb.set(\wetlevel, 0.7, \drylevel, 0.3)