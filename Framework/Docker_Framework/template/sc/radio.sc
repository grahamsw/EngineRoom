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
	sig = SinOsc.ar(freq);
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

// list of Pbinds
~definePbinds = {
     ~pb = EventPatternProxy(
            Pbind(
              \instrument, \tone,
              \note, 7,
              \amp, 0.5,
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
    \start: {~player = ~pb.play(~clock, quant:4);},
	\stop: {~player.stop;},
    \setNote: {|note|
        ~pb.source_(
            Pbind(
              \instrument, \tone,
              \note, note,
              \dur, 1
        )).quant_(1);
    }

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

    ~events[\start].();   
    s.sync;
 
 
 
    NetAddr.langPort.postln;

};

~definePbinds.value;

)


// ~events[\setNote].(5);
// Synth(\tone)