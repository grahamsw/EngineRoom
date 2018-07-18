(

// -----------
// Boilerplate
// -----------

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
	~makeEvents.();
	~addControllers.();
};


~main = {
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
};

~main.();

)