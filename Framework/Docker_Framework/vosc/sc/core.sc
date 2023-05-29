(

~includes = ["impl.sc"];

~includes.do({|include|
    (PathName(thisProcess.nowExecutingPath).parentPath ++ include).load;
});

// the "channel name" that OSC listens on
~impl_osc_name = "/implOsc"; // "OSC_CHANNEL".getenv;

/////////////////////////////////
// code that doesn't change
////////////////////////////////


// Generic OSC handler for mapping OSC messages
// (from any source) to events
// Could be replaced with MIDI or some other controller as desired
~traceOsc = true;
~addControllers = {
	"~addControllers".postln;
	   	~osc.free;
		~osc = OSCFunc({
		|msg|
		// msg sent from Python as
		//     sendSC(~impl_osc_name, [eventName, parameter_1, parameter_2, ... ])
		// msg is received as
		//     [~impl_osc_name, eventName, parameter_1, parameter_2, ....]
		// and calls
		// ~events[eventName].(paramter_1, parameter_2, ...)
		var eventName = msg[1];
		if (~traceOsc)
		{
			("got " ++ msg).postln;

		};

		if (~events[eventName] != nil)
		{
			msg.drop(2).postln;
            ~events[eventName].(*msg.drop(2));
		}
		{
			if (~traceOsc)
			{
				(eventName ++ " not found").postln;
			}
		};
	}, ~impl_osc_name);
};


s.newBusAllocators;
~allocBusses.();
o = s.options;
o.memSize =  32 * 8192;

ServerTree.removeAll;

s.waitForBoot {

	s.freeAll;
	Buffer.freeAll;
	s.sync;
	~defineSynths.value;
	s.sync;
	~buffs = ~loadBuffs.();
	s.sync;
	ServerTree.add({
            s.bind({
                ~initServerNodes.value;
            })
        });
    ServerTree.run;
    ~addControllers.();
    s.sync;

	"net address".postln;
	NetAddr.localAddr.postln;

~definePbinds.value;
s.sync;
~runstart.()
};
)
//~voscs[\bass][\buffSet].do {|buf| buf.plot}