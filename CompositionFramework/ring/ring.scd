(
// path to boilerplate might change
~fw = "../boilerplate/boilerplate.scd";
"../../RingMotives/006_rhine.scd".loadRelative;

~makeEvents = {
	"~makeEvents".postln;
	~events = Dictionary.new;

	~events.add(\playRhine -> {
		"playing \\theRhine".postln;
		Pdef(\theRhine).play;
	});

	~events.add(\stopRhine -> {
		"stopping \\theRhine".postln;
		Pdef(\theRhine).stop();
	});
};

~defineSynths = {
	"~defineSynths".postln;
// no synths yet, using default instrument
};

~makeBusses = {
	"~makeBusses".postln;
	~bus = Dictionary.new;
};
~makeBuffers = {
	// read any sound files the synths will need

};

// these implementations will work as is for many
// pieces, but can be overridden if desired

// start up synths (reverb, say)
~addInititialSynths = {
	"~addInititialSynths".postln;

};

~init = {
	"~init".postln;
	~out = 0;
	~impl_osc_name = "/ringOsc";
	~traceOsc = true;
};

~cleanup = {
	"~cleanup".postln;
	~osc.free;
};

~addControllers = {
	"~addControllers".postln;
	   	~osc.free;
		~osc = OSCFunc({
		|msg|
		// msg sent from Python as
		//     send(~impl_osc_name, [eventName, parameter_1, parameter_2, ... ])
		//       or
		//     s = sender(~impl_osc_name)
		//     s(eventName, parameter_1, parameter_2, ....)
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

~fw.loadRelative;


)

~events[\playRhine].()
