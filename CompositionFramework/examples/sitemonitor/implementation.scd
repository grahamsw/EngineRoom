(
// see https://docs.google.com/drawings/d/1IcqFmk9DcE8ZPDrfxwas2uyjUz4zR4-34ApoXiAC4a0/edit?usp=sharing
// for code diagram

// ---------------------------------------------------------
// This is an outline of an implementation
// Provide implementations for at least ~defineSynths
// and ~makeEvents.
// Define whatever other functions these need, and override
// any of the other "framework" functions as needed
// Once these are defined, and ~fw is pointing to the boilerplate file
// running this file will reboot the server, load all the initialization code,
// define synths and events, and wait for messages to trigger the events.
// All by typing Ctrl + Enter
// ---------------------------------------------------------

// this should point to the frameworks code, here it's in the
// same folder, usually it won't be
~fw = "../../boilerplate/boilerplate.scd";
~impl_osc_name = "/implOsc";

/*
these are the heart of any implementation:
the synths and the events that are created
with them - along with any effects and buffers and
busses that they need
*/
~makeEvents = {
	~events = Dictionary.new;
	~events.add(\init -> {
		|msg|
		"creating synth".postln;

		~synth = Synth(\sonifier, [\freq, 400, \amp, 0.1, \rate, 10]);
		~bus[\freq].set(300);
		~bus[\amp].set(0.1);
		~bus[\rate].set(20);

        ~synth.map(\freq, ~bus[\freq], \amp, ~bus[\amp], \rate, ~bus[\rate]);
	});
	~events.add(\rate -> {
		|msg|
		~bus[\rate].set(msg[2]);
	});
	~events.add(\freq -> {
		|msg|
		~bus[\freq].set(msg[2]);
	});
	~events.add(\amp -> {
		|msg|
		~bus[\amp].set(msg[2]);
	});
};

~defineSynths = {
SynthDef(\sonifier, {
	|freq, amp, rate|
	var sound, env;
	sound = SinOsc.ar(freq, mul:amp);
	env = Pulse.ar(freq: rate, width: 0.5);

	Out.ar(0, env * sound);
}).add;
};

~makeBusses = {
	~bus = Dictionary.new;
	~bus.add(\freq -> Bus.control(s, 1));
	~bus.add(\amp -> Bus.control(s,1));
	~bus.add(\rate -> Bus.control(s, 1));
};

// may be needed
~makeBuffers = {
	"make and fill any required buffers".postln;
	// read any sound files the synths will need

};

~addInititialSynths = {
	"~addInititialSynths".postln;

};

// -----------------------------------------------
// these implementations will work as is for many
// pieces, but can be overridden if desired
// -----------------------------------------------
~init = {
	"~init".postln;
	~out = 0;
	~traceOsc = true;
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