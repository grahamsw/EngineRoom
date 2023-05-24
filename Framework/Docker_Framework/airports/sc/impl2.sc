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
	SynthDef("help-PingPong",{ arg out=0,bufnum=0,feedback=0.5,delayTime=0.2;
    var left, right;
    left = Decay2.ar(Impulse.ar(0.7, 0.25), 0.01, 0.25,
        SinOsc.ar(SinOsc.kr(3.7,0,200,500)));
    right = Decay2.ar(Impulse.ar(0.5, 0.25), 0.01, 0.25,
        Resonz.ar(PinkNoise.ar(4), SinOsc.kr(2.7,0,1000,2500), 0.2));

    Out.ar(0,
        PingPong.ar(bufnum, [left,right], delayTime, feedback, 1)
    )
    }).add();
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
    \start: {~player =

        b = Buffer.alloc(s,44100 * 2, 2);
        Synth("help-PingPong", [\out, 0, \bufnum, b.bufnum,\feedback,0.5,\delayTime,0.1]);},

	\stop: {~player.stop;}

].asDict;

/*
~events[\start].()
~events[\stop].()
~events[\setNote].(2)
~events[\setClock].(0.3)
*/