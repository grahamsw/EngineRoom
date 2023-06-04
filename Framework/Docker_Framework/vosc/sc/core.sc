(

~includes = ["synths.sc", "impl.sc"];

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
//~runstart.()
};
)



//~events[\start].()
(
v = Synth(\VoscPlayer, [
        out:0,
    bufLow:~buffsets[1][0], bufHigh:~buffsets[1][7], bufSteps:30,
        detuneLow:0.15, detuneHigh:0.2, detuneSteps:100,
        freq:90,
        amp:0.5,
        panLow:-1, panHigh:0, panSteps:30, spread:0,
        releaseTime:10,
        gate:1
])

)
v.set(\freq, 180)
v.set(\bufLow,~buffsets[0][0], \bufHigh,~buffsets[0][6], \bufSteps, 100)
v.set(\releaseTime, 3)
v.set(\gate, 0)
~buffsets