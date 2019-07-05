(
// see https://docs.google.com/drawings/d/1IcqFmk9DcE8ZPDrfxwas2uyjUz4zR4-34ApoXiAC4a0/edit?usp=sharing
// for code diagram

// ---------------------------------------------------------
// This is an outline of an implementation
// Provide implementations for at least ~defineSynths
// and ~makeEvents.
// Define whatever other functions these need, and override
// any of the other "framework" functions as needed
// Once these are defined, and ~fw is pointing to the boilerplate file
// running this file will reboot the server, load all the initialization code,
// define synths and events, and wait for messages to trigger the events.
// All by typing Ctrl + Enter
// ---------------------------------------------------------

// this should point to the frameworks code
~fw = "../../boilerplate/boilerplate.scd";
// the "channel name" that OSC listens on
~impl_osc_name = "/implOsc";

/*
these are the heart of any implementation:
the synths and the events that are created
with them - along with any effects and buffers and
busses that they need
*/
~makeEvents = {
	"making events".postln;
	~events = Dictionary.new;

	~events.add(\initSynth -> {
		|msg|
		var config = ~msg2Config.(msg);
		~initSynth.(config);
	});
	~events.add(\playSynth -> {
		|msg|
		//[msg[2], msg.drop(3)].postln;
		Synth(msg[2], msg.drop(3));
	});

	~events.add(\loadCode -> {
		|msg|
		msg[2].asString.load;
	});
/*
	~events.add(\init1 -> {
		|msg|
		var config = (\synth:(\name:\sonifier, \key:\sonifier1,\killEventName:\killsonifier1),
		              \controls: [(\controlName:\freq,
					               \eventName:\freq1,
								   \initialValue:300),
								  (\controlName:\amp,
								   \eventName:\amp1,
								   \initialValue:0.1),
								  (\controlName:\rate,
								   \eventName:\rate1,
								   \initialValue:10)
								 ]);
		"creating synth".postln;
		~initSynth.(config);
	});


	~events.add(\init2 -> {
		|msg|

		var config =    (\synth:(\name:\sonifier2, \key:\sonifier2, \killEventName:\killsonifier2),
	          \controls: [(\controlName:\freq,
		                   \eventName:\freq2,
			               \initialValue:600),

	                       (\controlName:\amp,
		                   \eventName:\amp2,
			               \initialValue:0.01),

	                       (\controlName:\bwr,
		                   \eventName:\bwr,
			               \initialValue:0.6),

	                       (\controlName:\tremoloFreq,
		                   \eventName:\tremoloFreq,
			               \initialValue:0.1),

	                       (\controlName:\tremoloDepth,
		                   \eventName:\tremoloDepth,
			               \initialValue:0.05)
]);
		~initSynth.(config);
		"creating synth".postln;
	});
*/
};

// the message here will be sent via OSC from Python
// it will be decoded into a config object
~msg2Config = {
	|msg|
	var ctls, synth, ret;
	synth = (\name: msg[2], \key: msg[3], \killEventName: msg[4]);
	ctls = [];
	msg.drop(5).clump(3).do({
		|ctl|
		ctls = ctls.add((\controlName: ctl[0], \eventName:ctl[1], \initialValue: ctl[2]));
	});
    ret = (\synth: synth, \controls: ctls);
	ret.postln;
	ret;
};



~initSynth = {
	|config|
	"initing synth".postln;
	~synths[config[\synth][\key]] = Synth(config[\synth][\name]);
	config[\controls].do({
		|controlSettings|
		~bus.add(controlSettings[\eventName] -> Bus.control(s));
		~bus[controlSettings[\eventName]].set(controlSettings[\initialValue]);
		~synths[config[\synth][\key]].map(controlSettings[\controlName], ~bus[controlSettings[\eventName]]);

	~events.add(controlSettings[\eventName] -> {
		|msg|
		~bus[controlSettings[\eventName]].set(msg[2]);
	});
	~events.add(config[\synth][\killEventName] -> {
		|msg|
		~synths[config[\synth][\key]].free;
	})
	});
};

~defineSynths = {
	SynthDef(\sonifier, {
		|freq, amp, rate|
		var sound, env;
		sound = SinOsc.ar(freq, mul:amp);
		env = Pulse.ar(freq: rate, width: 0.5);

		Out.ar(0, env * sound);
	}).add;
		SynthDef(\sonifier2, {
		|freq=500, amp=0.4, bwr=0.5, tremoloFreq=0.1, tremoloDepth=0.95|
		var sound, res, env;
		sound = WhiteNoise.ar();
		res = Resonz.ar(sound, freq, bwr);
		env = SinOsc.kr(freq: tremoloFreq).range(1-tremoloDepth, 1);

		Out.ar(0, env * res * amp);
	}).add;
};

~makeBusses = {

};

// may be needed
~makeBuffers = {
	"make and fill any required buffers".postln;
	// read any sound files the synths will need

};

~addInititialSynths = {
	"~addInititialSynths".postln;
};

// -----------------------------------------------
// these implementations will work as is for many
// pieces, but can be overridden if desired
// -----------------------------------------------
~init = {
	"~init".postln;
	~out = 0;
	~traceOsc = false;
	~bus = Dictionary.new;
	~synths = Dictionary.new;
};

~cleanup = {
	"~cleanup".postln;
//	~synths.asPairs.do({ |(k,v)| v.free;});
//	~bus.asPairs.do({ |(k,v)| v.free;});
	~osc.free;
};

// pretty powerful, generic OSC handler for mapping OSC messages
// (from any source) to events
// Can be replaced with MIDI or some other controller as desired
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

~fw.loadRelative;

)
