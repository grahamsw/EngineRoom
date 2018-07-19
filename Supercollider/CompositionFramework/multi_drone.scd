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
~impl_osc_name = "/sprite_Osc";

// for modularity define synths in their own files
~synthFiles = ["spriteSynth.scd"];

/*
these are the heart of any implementation:
the synths and the routines that are created
with them, and the events that trigger these routines
- along with any effects, buffers and
busses that they need
*/
~makeEvents = {
	"~makeEvents".postln;
	~events = Dictionary.new;
	~events.add(\setProp -> {
		| msg |
		var val, prop, name;
		name = msg[2];
		prop = msg[3];
		val  = msg[4];
		//[name, prop, val].postln;
		//~synths[name].postln;
		~synths[name].set(prop, val.asFloat);
	});
	~events.add(\addSynth -> {
		|msg|
		var name, freq, amp, rate, attack, pos;
		name = msg[2];
		freq = msg[3];
		amp  = msg[4];
		rate = msg[5];
		attack = msg[6];
		pos = msg[7];
		[name, freq, amp, rate, attack, pos].postln;
		~synths[name] = Synth(\sprite, [\freq, freq,
			                            \amp, amp,
			                            \rate, rate,
			                            \attack, attack,
			                            \pos, pos
		                               ]);
	});
	~events.add(\clearAll -> {
		~synths.keysValuesDo {
			|key, value|
			value.free;
			~synths.removeAt(key);
	};

	});

};
~defineSynths = {
	"~defineSynths".postln;

	~synthFiles.do { |filename| filename.loadRelative;};
};

~makeBusses = {
	~bus = Dictionary.new;
	~bus.add(\reverb -> Bus.audio(s,2));
};

// may be needed
~makeBuffers = {
	// read any sound files the synths will need

};

~addInititialSynths = {
	"~addInititialSynths".postln;

};

~init = {
	"~init".postln;
	~out = 0;
	~traceOsc = false;
	~synths = Dictionary.new;
};

~cleanup = {
	"~cleanup".postln;
	~osc.free;
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



~fw.loadRelative;

)