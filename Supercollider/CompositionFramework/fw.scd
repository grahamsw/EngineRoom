(

/*
these are the heart of any implementation:
the synths and the events that are created
with them - along with any effects and buffers and
busses that they need

the ~implementation file will define



*/


~implementation = "testImp.scd";
~traceOsc = false;

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


// these implementations will work as is for many
// pieces, but can be overridden if desired


~init = {
	"~init".postln;
	~out = 0;
};

~cleanup = {
	"~cleanup".postln;
	~osc.free;
};

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


// -----------
// boilerplate
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

~makeNodes = {
	"~makeNodes".postln;
	s.bind({
		~mainGroup = Group.new;
		~effectsGroup = Group.after(~mainGrp);
	});
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