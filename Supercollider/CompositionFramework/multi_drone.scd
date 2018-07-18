(
// see https://docs.google.com/drawings/d/1IcqFmk9DcE8ZPDrfxwas2uyjUz4zR4-34ApoXiAC4a0/edit?usp=sharing
// for code diagram

// ---------------------------------------------------------
// This is an outline of an implementation
// Provide implementations for at least ~defineSynths
// and ~makeEvents.
// Define whatever other functions these need, and override
// any of the other "framework" functions as needed
// ---------------------------------------------------------

// this should point to the frameworks code, here it's in the
// same folder
~fw = "boilerplate.scd";

/*
these are the heart of any implementation:
the synths and the events that are created
with them - along with any effects and buffers and
busses that they need
*/
~makeEvents = {
	"~makeEvents".postln;
	~events = Dictionary.new;
	~events.add(\makeS -> {
		~bus[\amp].set(0);
		~bus[\freq].set(440);

		~syn = Synth(\s, [\out, ~out], ~mainGroup);
		~syn.map(\amp, ~bus[\amp]);
		~syn.map(\freq, ~bus[\freq]);
	});
};

~defineSynths = {
	"~defineSynths".postln;

	SynthDef(\drone, {
		|freq = 440, amp = 0.1, rate = 4,  attack = 0.1, timbre = 0.5, t_gate=1, pos = 0, out = 0|
		var sig, env;

		Out.ar(out, sig);
	}).add;

};

~makeBusses = {
	~bus = Dictionary.new;
	~bus.add(\reverb -> Bus.audio(s,2));
};

// may be needed
~makeBuffers = {
	// read any sound files the synths will need

};

~addEffectSynths = {
	"~addEffectSynths".postln;
	// these probably read from the ~bus[\reverb]
	// bus and write to ~out

};

// -----------------------------------------------
// these implementations will work as is for many
// pieces, but can be overridden if desired
// -----------------------------------------------
~init = {
	"~init".postln;
	~out = 0;
	~traceOsc = false;
};

~cleanup = {
	"~cleanup".postln;
	~osc.free;
};

// pretty powerful, generic OSC handler for mapping OSC messages
// (from any source) to events
// Can be replaced with MIDI or some other controller as desired
// (Arduino, Wii, etc)
~addControllers = {
	"~addControllers".postln;
	   	~osc.free;
		~osc = OSCFunc({
		|msg|
		// msg sent from Python as
		//     sendSC(~impl_osc_name, [eventName, parameter_1, parameter_2, ... ])
		// msg is received as
		//     [~impl_osc_name, eventName, parameter_1, parameter_2, ....]
		//
		var eventName = msg[1];
		if (~traceOsc)
		{
			("got " ++ msg).postln;

		};

		if (~events[eventName] != nil)
		{
			~events[eventName].(msg);
		}
		{
			if (~traceOsc)
			{
				(eventName ++ " not found").postln;
			}
		};
	}, ~impl_osc_name);
};

// you might want something more elaborate than this,
// or you might just stick everything in the root,
// but this is a good, organized & flexible set up
~makeNodes = {
	"~makeNodes".postln;
	s.bind({
		~mainGroup = Group.new;
		~effectsGroup = Group.after(~mainGrp);
	});
};


~fw.loadRelative;

)