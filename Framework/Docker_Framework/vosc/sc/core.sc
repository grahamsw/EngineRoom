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

~events[\startPbind].(\first)

~events[\stopPbind].(\first)


Pdef(\first).stop
, ~pbinds[\first]).play
~events[\setReverbMix].(0.9)
//~events[\start].()
(
v = Synth(\VoscPlayer, [
        out:0,
        bufLow:~buffsets[0][0], bufHigh:~buffsets[1][7], bufSteps:100,
        detuneLow:0.15, detuneHigh:0.2, detuneSteps:100,
        freq:190,
        amp:0.3,
        panLow:-1, panHigh:0, panSteps:30, spread:0,
        releaseTime:10,
        gate:1
])

)
v.set(\freq, 80)
v.set(\bufLow,~buffsets[0][0], \bufHigh,~buffsets[0][6], \bufSteps, 100)
v.set(\releaseTime, 3)
v.set(\gate, 0)
~buffsets

(
~voscs = ();
~runstart_params = [
    (\name:\bass,
        \freq: 80,
        \amp: 0.4,
        \buffSet: 3,
        \detuneLow:0.1,
        \detuneHigh:0.15,
        \panLow:-0.1,
        \panHigh:0.1,
        \spread:1),
    (\name:\aa,
        \freq: 160,
        \amp:0.3,
        \buffSet: 1,
        \detuneLow:1,
        \detuneHigh:2,
        \panLow:-0.5,
        \panHigh:0.5,
        \panSteps:50,
        \spread:0.5),
    (\name:\bb,
        \freq: 240,
        \amp: 0.2,
        \buffSet: 0,
        \detuneLow:0.1,
        \detuneHigh:0.12,
        \panLow:-1,
        \panHigh:1,
        \panSteps:10,
        \spread:0.3)];

~runstart_params.do({|ps|
    ~voscs[ps[\name]] = Synth(\VoscPlayer, [
        out:0,
        bufLow:~buffsets[ps[\buffSet]][0], bufHigh:~buffsets[ps[\buffSet]][7], bufSteps:100,
        detuneLow:ps[\detuneLow], detuneHigh:ps[\detuneHigh], detuneSteps:100,
        freq:ps[\freq],
        amp:ps[\amp],
        panLow:ps[\panLow], panHigh:ps[\panHigh], panSteps:ps[\panSteps], spread:ps[\spread],
        releaseTime:10,
        gate:1])
});
)

~runstart_params.do({|ps| ~voscs[ps[\name]].set(\gate, 0)})

