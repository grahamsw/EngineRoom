(
// defaults that will be overloaded by loading the piece specific code
~implementation = "implementation.scd";

~framework_defineSynths = {nil};
~framework_createPermanentSynths = {nil};
~framework_addEvents = {
	//~events.add(\eventName -> {});
};
~framework_createBusses = {
	//~bus.add(\reverb -> Bus.audio(s,2));
};
~framework_attachControllers = {nil};

~implementation.loadRelative;

//1. server config

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
};

//2. initialize global variables
~out = 0;

//3. define piece-specific functions
~makeBusses = {
	~bus = Dictionary.new;
	~framework_createBusses.value;
};

~cleanup = {
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

//4. register functions with ServerBoot/Quit
~configServer.value;
ServerBoot.add(~makeBusses);
ServerQuit.add(~cleanup);

//5. boot server
s.waitForBoot({

	s.sync;

	//6a. Define SynthDefs
	~framework_defineSynths.value;
	~makeBusses.value;


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