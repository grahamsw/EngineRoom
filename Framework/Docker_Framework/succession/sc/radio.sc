(

// the "channel name" that OSC listens on
~impl_osc_name = "/implOsc"; // "OSC_CHANNEL".getenv;

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
    ~clock = TempoClock.new(1).permanent_(true);

    ~accompaniment = EventPatternProxy();
    ~set_acc_chord.("<c4 e c5>");


};

//performance events:
// array (or dictionary) of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths directly via Routines
// (control FX synths, for example, for fade in/out etc)
// might be called manually, or from a Pattern or a Routine, or from
// a GUI, or MIDI, or from external code via OSC
~set_acc_chord = {|chord|
    ~acc = Panola.new(chord);
    ~acc_notes = ~acc.midinotePattern.list;

        ~accompaniment.source_(
            Pbind(
            \instrument, \default,
            \midinote, Pseq(~acc_notes, inf),
            \amp, Pseq([0.15, 0.1, 0.12, 0.1]*0.5, inf),
            \dur, Pseq([0.25], inf)
        )
        ).quant_(1);
};

~events = [
    \start: {
        "start".postln;
        ~accompaniment_player = ~accompaniment.play(~clock, quant:4);},
	\stop: {~accompaniment_player.stop;},

    \minor: {
        ~set_acc_chord.("<c4 e- c5>");
    },
    \major: {
        ~set_acc_chord.("<c4 e c5>");
    }


].asDict;

/////////////////////////////////
// code that doesn't change
////////////////////////////////
~loadBuffs = {
	|foldername, isAbsolute = false|
	var fn = if (isAbsolute, {foldername}, {PathName(thisProcess.nowExecutingPath).parentPath ++ foldername});
	PathName(fn).files.collect({
		|f|
		Buffer.read(s, f.fullPath);
	});
};

// pretty powerful, generic OSC handler for mapping OSC messages
// (from any source) to events
// Could be replaced with MIDI or some other controller as desired
// (Arduino, Wii, etc)
~traceOsc = true;
~addControllers = {
	"~addControllers".postln;
	   	~osc.free;
		~osc = OSCFunc({
		|msg|
		// msg sent from Python as
		//     sendSC(~impl_osc_name, [eventName, parameter_1, parameter_2, ... ])
		// msg is received as
		//     [~impl_osc_name, eventName, parameter_1, parameter_2, ....]
		//g
		var eventName = msg[1];
		if (~traceOsc)
		{
			("got " ++ msg).postln;

		};

		if (~events[eventName] != nil)
		{
			msg.drop(2).postln;
            ~events[eventName].(*msg.drop(2));
		}
		{
			if (~traceOsc)
			{
				(eventName ++ " not found").postln;
			}
		};
	}, ~impl_osc_name);
};


s.newBusAllocators;
~allocBusses.();

ServerTree.removeAll;

s.waitForBoot {

	s.freeAll;
	Buffer.freeAll;
	s.sync;
	~defineSynths.value;
	s.sync;
	~buffs = ~loadBuffs.('sounds');
	s.sync;
	ServerTree.add({
            s.bind({
                ~initServerNodes.value;
            })
        });
    ServerTree.run;
    ~addControllers.();
    s.sync;



};

~definePbinds.value;

)

~events[\start].();
~events[\stop].();
~events[\minor].();
~events[\major].();