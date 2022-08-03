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
    SynthDef(\airport, {
	Out.ar(0, SawDPW.ar(440, mul:0.5));
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
    \start: {~player = Synth(\airport)},
	\stop: {~player.stop;}

].asDict;

/*
~events[\start].()
~events[\stop].()
~events[\setNote].(2)
~events[\setClock].(0.3)
*/