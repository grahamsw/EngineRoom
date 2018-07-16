(


// these are the heart of any implementation:
// the synths and the events that are created
// with them - along with any effects and buffers and
// busses that they need

~makeBuffers = {
	// read any sound files the synths will need

};

~makeBusses = {
	~bus = Dictionary.new;
	~bus.add(\reverb -> Bus.audio(s,2));
};

~addEffectSynths = {

};

~makeEvents = {

};

~defineSynths = {

};

// these implementations will work as is for many
// pieces, but can be overridden if desired

~init = {
	~out = 0;
};

~cleanup = {
	"~framework_cleanup".postln;
	~osc.free;
};

~addControllers = {
	/*
	"~addControllers".postln;
		~osc = OSCFunc({
		|msg|
		var eventName = msg[1];
		("got " ++ eventName).postln;
		if (~events[eventName] != nil)
		{~events[eventName].value;eventName.postln;}
		{(eventName ++ " not found").postln};
	}, ~framework_osc_name);
	*/
};

~implementation = "testImp.scd";

// -----------
// boilerplate
// -----------

~implementation.loadRelative;

~configServer = {
	"~configureServer".postln;
	s = Server.local;
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
//OSCFunc.free
~makeNodes = {
	s.bind({
		~mainGrp = Group.new;
		~effectsGrp = Group.after(~mainGrp);
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