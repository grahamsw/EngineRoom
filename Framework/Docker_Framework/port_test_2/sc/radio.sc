(

// the "channel name" that OSC listens on
~impl_osc_name = "/implOsc"; //"OSC_CHANNEL".getenv;

~allocBusses = {

};

~initServerNodes = {
    ~fxGroup = Group.new;
};



// SynthDefs for the Synths used in the piece
~defineSynths = {
  //basic enveloped sine
SynthDef(\tone, {
    var freq = \freq.kr(440);
    var atk = \atk.ir(0.001);
    var sus = \sus.ir(0.5);
    var rel = \rel.ir(0.2);
    var atkcrv = \atkcrv.ir(1);
    var relcrv = \relcrv.ir(-2);
    var pan = \pan.kr(0);
    var amp = \amp.kr(0.1);
    var out = \out.kr(0);


	var sig, env;
	sig = LFSaw.ar(freq);
	env = Env(
		[0,1,1,0],
		[atk, sus, rel],
		[atkcrv, 0, relcrv]
	).kr(2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	Out.ar(out, sig);
}).add;

};

~base = 53;
~rate = 0.25;
// list of Pbinds
~definePbinds = {
     ~pb = EventPatternProxy(
            Pbind(
              \instrument, \tone,
              \midinote, Pseq([0, 4, 7, 12] + ~base, inf),
              \amp, 0.1,
              \dur, ~rate
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
    \start: {~player = ~pb.play(~clock, quant:4);},
    \stop: {~player.stop;},
    \setNote: {|base|
        ~base = base;
        ~pb.source_(
            Pbind(
              \instrument, \tone,
              \midinote, Pseq([0, 4, 7, 12] + ~base, inf),
              \amp, 0.1,
              \dur, ~rate
        )).quant_(1);
    },
    \setRate: {|rate|
		~rate = rate;
        ~pb.source_(
            Pbind(
              \instrument, \tone,
              \midinote, Pseq([0, 4, 7, 12] + ~base, inf),
              \amp, 0.1,
              \dur, ~rate
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
    s.sync;
    NetAddr.langPort.postln;

};

~definePbinds.value;

)
//~base = 4

//~events[\setNote].(52);
// Synth(\tone)