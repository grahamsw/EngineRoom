(

// the "channel name" that OSC listens on
~impl_osc_name = "/implOsc"; // "OSC_CHANNEL".getenv;

~allocBusses = {

};

~initServerNodes = {
    ~fxGroup = Group.new;
};


// SynthDefs for the Synths used in the piece
~defineSynths = {
    // using default (piano) for now

};

~melodies = Dictionary.new;

~getMelody = {|key|
    var default = (\melody: EventPatternProxy(), \player: 0);
    ~melodies.atFail(key, {
        ~melodies[key] = default;
        default;
    });
};

~setMelody = {|melody, proxy|
    var panola = Panola.new(melody);
    var midinotes = panola.midinotePattern.list;
    var durs = panola.durationPattern.list;
    var amps = panola.volumePattern.list;

    proxy.source_(
        Pbind(
            \instrument, \default,
            \midinote, Pseq(midinotes, inf),
            \amp, Pseq(amps, inf),
            \dur, Pseq(durs, inf)
        )
    );
};


// list of Pbinds
~definePbinds = {
    ~clock = TempoClock.new(1).permanent_(true);

    // for this the pbinds are created dynamically by events
    // passing in Panola strings




};

//performance events:
// array (or dictionary) of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths directly via Routines
// (control FX synths, for example, for fade in/out etc)
// might be called manually, or from a Pattern or a Routine, or from
// a GUI, or MIDI, or from external code via OSC

~events = [
    \start: {
        |melodyKey, melody, quant=4, clock=nil|
        var mm = ~getMelody.(melodyKey);
        clock = (clock == nil).if({~clock}, {clock});
        ~setMelody.(melody, mm[\melody]);
        mm[\player] =  mm[\melody].play(clock, quant:quant);
    },
	\stop: {
        |melodyKey|
        ~getMelody.(melodyKey)[\player].stop;
    },

    \change: {
        |melodyKey, melody|
        ~setMelody.(melody, ~getMelody.(melodyKey)[\melody]);
    },

].asDict;

/////////////////////////////////
// code that doesn't change
////////////////////////////////
~loadBuffs = {
	|foldername, isAbsolute = false|
	var fn = if (isAbsolute, {foldername}, {PathName(thisProcess.nowExecutingPath).parentPath ++ foldername});
	PathName(fn).files.collect({
		|f|
		Buffer.read(s, f.fullPath);
	});
};

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
		//g
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
    s.sync;



};

~definePbinds.value;

)

~events[\start].(\first, "c4 e g a");
~events[\start].(\second, "a3 a b c4");
~events[\change].(\second, "<a3_4\\vol[0.6] f b  f4>")
~events[\stop].(\first);
~events[\stop].(\second);
~events[\change].(\first, "c5_4\\vol[0.5] b4\\vol[0.1] a. g_8");
~events[\major].();
