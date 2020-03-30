(
// see https://docs.google.com/drawings/d/1IcqFmk9DcE8ZPDrfxwas2uyjUz4zR4-34ApoXiAC4a0/edit?usp=sharing
// for out of date code diagram
// TODO update diagram


// ---------------------------------------------------------
// this is the single file framework.
// run this in Supercollider, then all other work gets done in Python
// ---------------------------------------------------------


// the "channel name" that OSC listens on
~impl_osc_name = "/implOsc";

// the channel, IP and port that the python client listens on
~controllerOscReceiveChannel = "/fromSC";
~controllerIp = "127.0.0.1";
~controllerPort = 5771;

~traceOsc = true;



~makeEvents = {
	"making events".postln;
	~events = Dictionary.new;

	// for sustained synths, with parameters that will be changed, and
	// then explicitly delted. including effects
	~events.add(\initSynth -> {
		|msg|
		var config = ~msg2Config.(msg);
		~initSynth.(config);
	});

	// for synths that play and then delete themselves
	~events.add(\playSynth -> {
		|msg|
		//[msg[2], msg.drop(3)].postln;
		Synth(msg[2], msg.drop(3));
	});

	// creates an audio bus and returns its bus number
	~events.add(\createBus -> {
		|msg|
		var bus, key = msg[2];
		["key: ", key].postln;

		bus = Bus.audio(s);
		~audioBusses[key] = bus.index;
		~sendToController.(key, ~audioBusses[key]);
	});

	// this is the catch-all. We can extend this
	// framework's capabilities by loading new code.
	// primarily used to add SynthDefs, but if necessary
	// can add new event handlers, patterns, whatever
	// is needed
	~events.add(\loadCode -> {
		|msg|
		msg[2].asString.loadRelative;
	});
};

// the message here will be sent via OSC from Python
// it will be decoded into a config object
~msg2Config = {
	|msg|
	var ctls, synth, busNum, ret;
	synth = (\name: msg[2], \key: msg[3], \killEventName: msg[4]);
//	busNum = msg[5];
	ctls = [];
	msg.drop(5).clump(3).do({
		|ctl|
		ctls = ctls.add((\controlName: ctl[0], \eventName:ctl[1], \initialValue: ctl[2]));
	});
    ret = (\synth: synth, \busNum: busNum, \controls: ctls);
	ret.postln;
	ret;
};


// creates a control bus for each named parameter of the synth, then maps the parameter to that
// control bus.
// Also creates an event handler to listen for named events that will set the value of the named
// control bus (so the client can control the synth
// Also adds a named kill event that will destroy the synth
~initSynth = {
	|config|
	"initing synth".postln;
	~synths[config[\synth][\key]] = Synth(config[\synth][\name]);
	config[\controls].do({
		|controlSettings|
		~controlBusses.add(controlSettings[\eventName] -> Bus.control(s));
		~controlBusses[controlSettings[\eventName]].set(controlSettings[\initialValue]);
		~synths[config[\synth][\key]].map(controlSettings[\controlName], ~controlBusses[controlSettings[\eventName]]);

	~events.add(controlSettings[\eventName] -> {
		|msg|
		~controlBusses[controlSettings[\eventName]].set(msg[2]);
	});
	~events.add(config[\synth][\killEventName] -> {
		|msg|
		~synths[config[\synth][\key]].free;
	})
	});
};



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


~init = {
	"~init".postln;
	~out = 0;
	~controlBusses = Dictionary.new;
	~audioBusses = Dictionary.new;
	~synths = Dictionary.new;
	~oscSender = NetAddr.new(~controllerIp, ~controllerPort);

};

~cleanup = {
	"~cleanup".postln;
//	~synths.asPairs.do({ |(k,v)| v.free;});
//	~controlBusses.asPairs.do({ |(k,v)| v.free;});
	~osc.free;
};

// for communicating back to the external OSC sender (python)
~sendToController = {
	|key, value|
	["about to send", key, value].postln;
	["controller ip", ~controllerIp, "controller port", ~controllerPort].postln;
	~oscSender.sendMsg(~controllerOscReceiveChannel, key, value);
};

// pretty powerful, generic OSC handler for mapping OSC messages
// (from any source) to events
// Could be replaced with MIDI or some other controller as desired
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


