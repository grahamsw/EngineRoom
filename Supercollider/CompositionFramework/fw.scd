(


// Point ~implementation to your own implementation file.
~implementation = "testImp.scd";

// ---------------------------------------------------------
// This is a sample implementation file
// Create your own, defining at least ~defineSynths
// and ~makeEvents.
// Define whatever other functions these need, and override
// any of the other "framework" functions as needed
// ---------------------------------------------------------

/*
these are the heart of any implementation:
the synths and the events that are created
with them - along with any effects and buffers and
busses that they need
*/
~makeEvents = {

};

~defineSynths = {

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
// or you not need it, but but this is a good start
~makeNodes = {
	"~makeNodes".postln;
	s.bind({
		~mainGroup = Group.new;
		~effectsGroup = Group.after(~mainGrp);
	});
};

// ----------------------------------------
// Boilerplate. This
// -----------
~implementation.loadRelative;

~configServer = {
	"~configServer".postln;
	s = Server.local;
	s.quit;
	s.options.numOutputBusChannels_(2);
	s.options.numInputBusChannels_(2);
	s.options.sampleRate_(44100);
	s.options.memSize_(2.pow(20));

	s.newBusAllocators;
	ServerBoot.removeAll;
	ServerTree.removeAll;
	ServerQuit.removeAll;

	ServerBoot.add(~serverBoot);
	ServerQuit.add(~serverQuit);
};

~serverTree = {
	"~serverTree".postln;
	~makeNodes.();
	~addEffectSynths.();
	~makeEvents.();
	~addControllers.();
};

~serverQuit = {
	"~serverQuit".postln;
	~cleanup.();
	s.newBusAllocators;
	ServerBoot.removeAll;
	ServerTree.removeAll;
	ServerQuit.removeAll;
};

~serverBoot = {
	"~serverBoot".postln;
	~init.();
	~makeBuffers.();
	~makeBusses.();
};

~configServer.();
s.waitForBoot({
	s.sync;
	~defineSynths.();
	s.sync;
	ServerTree.add(~serverTree);
	s.freeAll;
	s.sync;
	"done".postln;
});

)