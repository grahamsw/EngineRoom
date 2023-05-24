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
    ~scale1 = Buffer.loadCollection(s, Scale.minorPentatonic.degrees);
    // this is from Eli Fieldsteel
    SynthDef(\d2k,
        {
            |buf, rate = 1, inote=36, gate=1|
            var sig, index, pch, freq;
            index = LFDNoise3.kr(rate!4).range(0,5);
            index = index * BufFrames.kr(buf);
            pch = DegreeToKey.kr(buf, index) + inote;
            pch = pch + LFNoise1.kr(rate!4).bipolar(0,12);
            freq = pch.midicps.lag(0.02);
            sig = VarSaw.ar(freq, mul:0.2);
            sig = Splay.ar(sig, 0.75);

            sig = sig * EnvGen.kr(
                Env([0,1,0,0], [0.05, 4,7], [0, -2, 0], 1), gate, doneAction:2);

            sig = sig.blend(
                CombN.ar(sig, 0.25, 0.25, 2),
                0.5);

            sig = sig.blend(
                LPF.ar(GVerb.ar(sig.sum, 200,3), 1000), 0.4);

            Out.ar(0, sig);

        }
    ).add;


    SynthDef(\harms,
        {
            |freq = 400, amp = 0.2, tf = 3, atk = 0.01, decay = 3|
            var sig = Mix.fill(8, {
                |n|
                SinOsc.ar(freq * (1+n)) * Decay2.ar(Dust.ar(tf * Rand(0.1, 1)), atk, decay, 1/(1+n))
            });
            Out.ar(0, sig/20 * amp);
    }).add;

};

// list of Pbinds
~definePbinds = {
   ~clock = TempoClock.new(1).permanent_(true);
};

//performance events:
// array (or dictionary) of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths directly via Routines
// (control FX synths, for example, for fade in/out etc)
// might be called manually, or from a Pattern or a Routine, or from
// a GUI, or MIDI, or from external code via OSC

~events = [
    \start: {
        //~synth = Synth(\harms, [\freq, 400, \amp, 1])
        ~synth = Synth(\d2k, [\buf, ~scale1]);
    },
    \setInote:{ |inote| ~synth.set(\inote, inote)},
    \setRate: {|rate| ~synth.set(\rate, rate)},

    \setAmp: { |amp| ~synth.set(\amp, amp)},
    \setDecay: { |decay| ~synth.set(\decay, decay)},
    \setFreq: { |freq| ~synth.set(\freq, freq)},
    \setAtk: { |atk| ~synth.set(\atk, atk)},
    \setTf: { |tf| ~synth.set(\tf, tf)},
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

    ~events[\start].();
/*
    s.sync;
    ~events[\setFreq].(300);
    ~events[\setAmp].(0.8);
    ~events[\setDecay].(5);
    NetAddr.langPort.postln;
*/
};

~definePbinds.value;

)


// for testing - in use these get called from python
//~events[\start].()
//~events[\setRate].(15, 60)
//~events[\stop].()
/*
~events[\setFreq].(300)
~events[\setAmp].(0.8)
~events[\setDecay].(3)

    \setAmp: { |amp| ~synth.set(\amp, amp)},
    \setDecay: { |decay| ~synth.set(\decay, decay)},
    \setFreq: { |freq| ~synth.set(\freq, freq)},
    \setAtk: { |atk| ~synth.set(\atk, atk)},
    \setTf: { |tf| ~synth.set(\tf, tf)},

*/
//~events[\setInote].(60)
//~events[\setRate].(1/4)
//gii NetAddr.langPort.postln