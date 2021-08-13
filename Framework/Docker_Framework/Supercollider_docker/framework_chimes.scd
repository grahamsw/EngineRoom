(

// the "channel name" that OSC listens on
~impl_osc_name = "/implOsc";

~allocBusses = {

};

~initServerNodes = {
    ~fxGroup = Group.new;
};


// SynthDefs for the Synths used in the piece
~defineSynths = {

    SynthDef("PMCrotale", {
        arg freq = 400, tone = 3, art = 1, amp = 0.2, pan = 0;
        var env, out, mod;


        env = Env.perc(0, art);
        mod = 5 + (1/IRand(2, 6));

        out = PMOsc.ar(freq, mod*freq,
            pmindex: EnvGen.kr(env, timeScale: art, levelScale: tone),
            mul: EnvGen.kr(env, timeScale: art, levelScale: 0.3));

        out = Pan2.ar(out, pan);

        out = out * EnvGen.kr(env, timeScale: 1.3*art,
            levelScale: Rand(0.1, 0.5), doneAction:2);
        Out.ar(0, out); //Out.ar(bus, out);

    }).add;
    SynthDef(\bell, {
	|fs=1, t60=1, pitchy=1, amp=0.25, gate=1, pos=0, out = 0|
	var sig, exciter;
	//exciter = Impulse.ar(0);
	exciter = WhiteNoise.ar() * EnvGen.ar(Env.perc(0.001, 0.05), gate) * 0.25;
	sig = Klank.ar(
		`[
			[1, 2, 2.803, 3.871, 5.074, 7.81, 10.948, 14.421],   // freqs
			[1, 0.044, 0.891, 0.0891, 0.794, 0.1, 0.281, 0.079], // amplitudes
			[1, 0.205, 1, 0.196, 0.339, 0.047, 0.058, 0.047]*t60     // ring times
		],
		exciter,
		freqscale:fs*pitchy);
	sig = FreeVerb.ar(sig) * amp;
	DetectSilence.ar(sig, 0.001, 0.5, doneAction:2);
	Out.ar(out, Pan2.ar(sig, pos));
}).add

};

// list of Pbinds
~definePbinds = {
    ~bells = EventPatternProxy(
            Pbind(
              \instrument, \PMCrotale,
              \note, Pseq([0, 2, 4,8], inf),
              \sust, Pwhite(2.0, 6.0, inf),
              \dur, 1
        ))
    ;

	~clock = TempoClock.new(1).permanent_(true);
};

//performance events:
// array (or dictionary) of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths directly via Routines
// (control FX synths, for example, for fade in/out etc)
// might be called manually, or from a Pattern or a Routine, or from
// a GUI, or MIDI, or from external code via OSC

~events = [
    \start: {~player = ~bells.play(~clock, quant:1);},
	\stop: {~player.stop;},
    \setRate: {|rate, maxRate|
        var durMin, durMax, fss, minFs, notes;
        [rate, maxRate].postln;
        durMin = rate.linlin(0, maxRate, 0.1, 0.02);
        durMax = rate.linlin(0, maxRate, 2, 0.1);
        fss = [300,450, 600, 750, 900, 1000, 1150, 1270, 1500, 1800];
        minFs = (rate.linlin(0, maxRate, 0, (fss.size)-5)).asInteger;
        notes = fss[minFs..(minFs+4)];

        ~bells.source_(
            Pbind(
              \instrument, \bell,
              \fs, Prand(notes, inf),
              \t60, Pseq([3,5,6], inf),
              \amp, Pseq([0.01, 0.02, 0.01, 0.01, 0.01]*2, inf),
              \pitchy, 3,
              \dur, Pwhite(durMin, durMax, inf)
        )).quant_(1);
    }
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
    s.sync;
    ~events[\start].();
    NetAddr.langPort.postln;

};

~definePbinds.value;

//~events[\start].();
)


// for testing - in use these get called from python
//~events[\start].()
//~events[\setRate].(15, 60)
//~events[\stop].()
