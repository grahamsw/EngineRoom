(

// the "channel name" that OSC listens on
~impl_osc_name = "/implOsc";

~sections = Dictionary.new;

~allocBusses = {
    ~reverbBus = Bus.audio(s, 2);
};

~initServerNodes = {
    ~fxGroup = Group.new;
    ~reverb = Synth(\reverb, [\in, ~reverbBus], ~fxGroup);
};


// SynthDefs for the Synths used in the piece
~defineSynths = {
    SynthDef(\sonifier, {
		|freq = 400, amp=0.1, rate=20|
		var sound, env;
		sound = SinOsc.ar(freq, mul:amp);
		env = Pulse.ar(freq: rate, width: 0.5);
        sound = LPF.ar(env * sound, 5000);
		Out.ar(0, sound);
}).add;


    SynthDef.new(\reverb, {
        arg in=0, drylevel=0.7, wetlevel=0.3, out=0;
        var sig, reverb;
        sig = In.ar(in, 2);
        reverb = In.ar(in, 2);
        reverb = LPF.ar(GVerb.ar(sig, 250, 4), 900);
        sig = (sig * drylevel) + (reverb * wetlevel);
        Out.ar(out, sig);
    }).add;

};
// list of Pbinds
~definePbinds = {

};

//performance events:
// array (or dictionary) of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths directly via Routines
// (control FX synths, for example, for fade in/out etc)
// might be called manually, or from a Pattern or a Routine, or from
// a GUI, or MIDI, or from external code via OSC

~setSection = {|section, count|
    var rate = count.linlin(0, 100, 0.1, 40);
    ["setSection", section, count, rate].postln;
    ~sections[section].set(\rate, rate);

};

~createSection = {|section|
    ["createSection", section, ~freqs[section]].postln;
    Synth(\sonifier, [\freq, ~freqs[section] ]);
};

~stopSection = {|section|
    ["stopSection", section].postln;
    ~sections[section].free;

};

~events = [
    \startSections: {|... sections|
        sections.do{|section|
            ~sections[section] = ~createSection.(section);
        }
    },

    \stopSections: {
        ~sections.values.do{|value|
            value.free;
        }

    },

    \setSections: {|... args|
        var pairs= args.clump(2);
        pairs.do{|pr|
            ~setSection.(pr[0], pr[1]);
        };
    },

].asDict;

/////////////////////////////////
// code that doesn't change
////////////////////////////////

// pretty powerful, generic OSC handler for mapping OSC messages
// (from any source) to events
// Could be replaced with MIDI or some other controller as desired
// (Arduino, Wii, etc)
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
		//
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

ServerTree.removeAll;

s.waitForBoot {
	s.freeAll;
	Buffer.freeAll;
	s.sync;
	~defineSynths.value;
	s.sync;
	~buffs = ~loadBuffs.('sounds');
	s.sync;
	ServerTree.add({
            s.bind({
                ~initServerNodes.value;
            })
        });
    ServerTree.run;
    ~addControllers.();
};

~definePbinds.value;

)


// for testing - in use these get called from python
~events[\startSections].(*~ss)
~events[\stopSections].()
~events[\setSections].(*~sa)
~sections.postln


~freqs = Dictionary.newFrom(List["one", 200, "two", 300, "three", 400]);

~ss = ["one", "two", "three"]
~sa = ["one",10, "two", 12,"three", 3]
~sections["three"].free

