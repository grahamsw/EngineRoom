(
~framework_osc_name = "/testImplOsc";
~out = 0;

~makeBuffers = {
	// read any sound files the synths will need

};

~makeBusses = {
	"~makeBusses now".postln;
	~bus = Dictionary.new;
	~bus.add(\reverb -> Bus.audio(s,2));
	~bus.add(\freq -> Bus.control(s, 1));
	~bus.add(\amp -> Bus.control(s, 1));
};

~addEffectSynths = {

};
//~bus[\amp].get({|x| x.postln;})
//~bus[\freq].set(400)

~makeEvents = {
	"~framework_addEvents".postln;
	~events = Dictionary.new;
	~events.add(\makeS -> {
		"\makeS playing".postln;
		~bus[\amp].set(0.1);
		~bus[\freq].set(440);
		~syn = Synth(\s, [\out, ~out]);

		~syn.map(\amp, ~bus[\amp]);
		~syn.map(\freq, ~bus[\freq]);
	});
	~events.add(\killS -> {
		"\killS playing".postln;
		~syn.set(\gate, 0);
	});
	~events.add(\setFreq -> {
		|msg|
		"\setFreq playing".postln;
		"freq is: ".post;
		msg[2].postln;
		~bus[\freq].set(msg[2]);
	});
	~events.add(\setAmp -> {
		|msg|
		"amp is: ".post;
		msg[2].postln;
		"\setAmp playing".postln;
		~bus[\amp].set(msg[2]);
	});
};

//~bus[\freq].set(0.400);

~defineSynths = {
	SynthDef(\s, {
		|freq = 440, amp = 1, out = 0, gate = 1|
		var signal = SinOsc.ar(freq, mul: amp);
		var env = EnvGen.kr(Env.adsr, gate, doneAction:2);
		Out.ar(out, signal * env);
	}).add;
};

// these implementations will work as is for many
// pieces, but can be overridden if desired

~init = {
	~out = 0;
};

~cleanup = {
	"~framework_cleanup".postln;
	~osc.free;
};

~addControllers = {
	"~addControllers now".postln;
	   	~osc.free;
		~osc = OSCFunc({
		|msg|
		var eventName = msg[1];
		msg.postln;
		("got " ++ eventName).postln;
		if (~events[eventName] != nil)
		{
			~events[eventName].(msg);
			eventName.postln;}
		{(eventName ++ " not found").postln};

	}, ~framework_osc_name);
};
)
//OSCFunc.trace(true, true)