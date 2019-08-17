(

/*
see code diagram at
https://docs.google.com/drawings/d/1IcqFmk9DcE8ZPDrfxwas2uyjUz4zR4-34ApoXiAC4a0/edit?usp=sharing

This is based on the excellent tutorial and example code by Eli Fieldsteel
https://www.youtube.com/watch?v=P85X1Ut3Hfc

In it he presents a framework for composing longer SuperCollider pieces.

I have restructured his code, factoring the  code that doesn't need to change
between implementations into its own file, and relabelling things.

Can't recommend the tutorials enough.

*/

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
	~makeEvents.();
	~addControllers.();
};


~main = {
	~configServer.();

	s.waitForBoot({
		s.sync;
		ServerTree.add(~serverTree);
		s.freeAll; // this triggers the ServerTree actions
		s.sync;
		"done".postln;

	});
};

// call exactly one function at root
~main.();

)