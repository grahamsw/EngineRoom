(
// defaults that will be overloaded by loading the piece specific code
~implementation = "tutorial_implementation.scd";
~implementation = "implementation.scd";

~framework_defineSynths = {nil};
~framework_attachControllers = {nil};

~framework_serverBoot = {nil};
~framework_createPermanentSynths = {nil};

~framework_addEvents = {
	//~events.add(\eventName -> {});
};
~framework_createBusses = {
	//~bus.add(\reverb -> Bus.audio(s,2));
};
~framework_cleanup = {nil};

~implementation.loadRelative;
~out = 0;

~configServer = {
	s = Server.local;
	s.options.numOutputBusChannels_(2);
	s.options.numInputBusChannels_(2);
	s.options.sampleRate_(44100);
	s.options.memSize_(2.pow(20));
	s.newBusAllocators;
	ServerBoot.removeAll;
	ServerTree.removeAll;
	ServerQuit.removeAll;

	ServerBoot.add(~makeBuffers);
	ServerQuit.add(~serverQuit);
};

~serverQuit = {
	~framework_cleanup.value;

	// repeats the cleanup in ~configServer
	s.newBusAllocators;
	ServerBoot.removeAll;
	ServerTree.removeAll;
	ServerQuit.removeAll;
};

~makeNodes = {
	s.bind({
		~mainGrp = Group.new;
		~effectsGrp = Group.after(~mainGrp);
		~framework_createPermanentSynths.value;
	});
};

~makeEvents = {
	~events = Dictionary.new;
	~framework_addEvents.value;

};

~attachControllers = {
	~framework_attachControllers.value;
};


~makeBusses = {
	~bus = Dictionary.new;
	~framework_createBusses.value;
};

~configServer.value;


//5. boot server
s.waitForBoot({

	s.sync;

	~framework_serverBoot.value;
	~framework_defineSynths.value;


	s.sync;


	//6b. register ServerTree functions
	ServerTree.add(~makeNodes);
	ServerTree.add(~makeEvents);
	ServerTree.add(~attachControllers);
	s.freeAll;

	s.sync;

	"done".postln;
});
)