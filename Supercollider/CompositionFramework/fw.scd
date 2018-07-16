(

~init = {

};

~addEffectSynths = {

};

~makeEvents = {

};

~defineSynths = {

};

~addControllers = {

};

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

~makeNodes = {
	s.bind({
		~mainGrp = Group.new;
		~effectsGrp = Group.after(~mainGrp);
	});
};

~serverTree = {
	"~serverTree".postln;
	~makeNodes.value;
	~addEffectSynths.value;
	~makeEvents.value;
	~addControllers.value;
};

~serverQuit = {
	"~serverQuit".postln;
	s.newBusAllocators;
	ServerBoot.removeAll;
	ServerTree.removeAll;
	ServerQuit.removeAll;
};

~serverBoot = {
	"~serverBoot".postln;
	~init.value;
};

~configServer.value;
s.waitForBoot({

	s.sync;

	~defineSynths.value;

	s.sync;


	ServerTree.add(~serverTree);
	s.freeAll;
	s.sync;

	"done".postln;

});

)