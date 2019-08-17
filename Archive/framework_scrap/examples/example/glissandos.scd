(
// path to boilerplate might change
~fw = "../../boilerplate/boilerplate.scd";


~makeEvents = {
	"~makeEvents".postln;
	~events = Dictionary.new;
	~events.add(\makeS -> {
		~bus[\amp].set(0);
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
	SynthDef (\glissando, {
		| from = 200, to = 2000, len = 10, amp = 0.6, out = 0, pan=0|
		var pitchenv = Env([from, to], [len], 'exp');
		var ramp = 0.01;
		var sound = SinOsc.ar(EnvGen.kr(pitchenv));
		var ampenv = Env.linen(ramp, len-(2 * ramp), ramp, amp);
		sound = EnvGen.kr(ampenv, doneAction: 2) * sound;
		sound = Pan2.ar(sound, pan);
		Out.ar(0, sound);
	}).add;
};


~playGlissandos = {
	|freqFrom, freqTo, durFrom, durTo, ampFrom, ampTo, lenFrom, lenTo, panFrom, panTo |
	var pitchRange = Pwhite(freqFrom, freqTo, inf);
	var ret = Pbind(
		\instrument, \glissando,
		\from, pitchRange,
		\to, pitchRange,
		\dur, Pwhite(durFrom, durTo, inf),
		\amp, Pwhite(ampFrom, ampTo, inf),
		\len, Pwhite(lenFrom, lenTo, inf),
		\pan, Pwhite(panFrom, panTo, inf)
	);
	ret.play;
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
	~impl_osc_name = "/implOsc";
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

