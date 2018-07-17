(

~makeBusses = {
	"~makeBusses".postln;
	~bus = Dictionary.new;
	~bus.add(\reverb -> Bus.audio(s,2));
	~bus.add(\freq -> Bus.control(s, 1));
	~bus.add(\amp -> Bus.control(s, 1));
};

~makeEvents = {
	"~makeEvents".postln;
	~events = Dictionary.new;
	~events.add(\makeS -> {
		~bus[\amp].set(0.1);
		~bus[\freq].set(440);

		~syn = Synth(\s, [\out, ~out], ~mainGroup);
		~syn.map(\amp, ~bus[\amp]);
		~syn.map(\freq, ~bus[\freq]);
	});
	~events.add(\killS -> {
		~syn.set(\gate, 0);
	});
	~events.add(\setFreq -> {
		|msg|
		~bus[\freq].set(msg[2]);
	});
	~events.add(\setAmp -> {
		|msg|
		~bus[\amp].set(msg[2]);
	});
};

~defineSynths = {
	"~defineSynths".postln;
	SynthDef(\s, {
		|freq = 440, amp = 1, out = 0, gate = 1|
		var signal = SinOsc.ar(freq, mul: amp);
		var env = EnvGen.kr(Env.adsr, gate, doneAction:2);
		Out.ar(out, signal * env);
	}).add;
};

~makeBuffers = {
	// read any sound files the synths will need

};

// these implementations will work as is for many
// pieces, but can be overridden if desired


~addEffectSynths = {
	"~addEffectSynths".postln;

};

~init = {
	"~init".postln;
	~out = 0;
	~impl_osc_name = "/implOsc";
	~traceOsc = false;
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

)


//~bus[\amp].get({|x| x.postln;})
//~bus[\freq].set(400)
//OSCFunc.trace(true, true)