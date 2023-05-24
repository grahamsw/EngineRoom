(

(PathName(thisProcess.nowExecutingPath).parentPath ++ "config.sc").load;
//++ "config.sc".load;

~loadBuff = {
	|filename, isAbsolute = false|
	var fn = if (isAbsolute, {filename}, {PathName(thisProcess.nowExecutingPath).parentPath ++ filename});
	Buffer.read(s, fn);
};

~make_intervals = {|n, total|
    (n.collect {1.0.rand}).normalizeSum * total
};

~loadEventSounds = {
    ~eventSounds.keys.do{ |key|
        ~eventSounds[key].do {
            |entry|
            entry[\buffer] = ~loadBuff.(entry[\file]);
        }
    }
};

~chooseClip = { |event_name|
    var option = ~eventSounds[event_name].choose;
    var buffer = option[\buffer];
    var clip = option[\clips].choose;
    (\buffer: buffer, \start: clip[\start], \length: clip[\length]);
};

~basicTone = {|freq| Synth(\basic,  [\freq, freq])};

~randPos = {
    rand(2.0) - 1.0
};

~randAmp = {
    rand(0.09) + 0.01; // range 0.01 to 0.1
};

~playClip = {|event_name|
        var clip = ~chooseClip.(event_name);
        Synth("playbuf",
            [
                buf:clip[\buffer],
                amp:~randAmp.(),
                start_secs:clip[\start],
                secs:clip[\length],
                pan:~randPos.()]);
};

// the "channel name" that OSC listens on
~impl_osc_name = "/implOsc";

~allocBusses = {

};

~initServerNodes = {
    ~fxGroup = Group.new;
};


// SynthDefs for the Synths used in the piece
~defineSynths = {
    SynthDef.new(\basic, {
        arg freq=500, atk=0.002, sus=0, rel=1,
        pan=0, amp=0.1, out=0;
        var sig, env;
        env = EnvGen.ar(
            Env.new([0,1,1,0],[atk,sus,rel],[2,0,-2]),
            doneAction:2
        );
        sig = SinOsc.ar(freq);
        sig = Pan2.ar(sig, pan, amp) * env;
        Out.ar(out, sig);
    }).add;

    // play buf starting at start_secs
SynthDef("playbuf", {
        |buf=0, amp=0.1, start_secs=0, secs=1, pan=0, out=0|
    var start, end, sig, env;
    start = start_secs * BufSampleRate.kr(buf);
        sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf), startPos:start, loop: 0);
        env = EnvGen.kr(Env([0, 1, 1,0], [0.01, secs, 0.01 ]),doneAction:2);
        sig = sig * env;
        Out.ar(out,
            Pan2.ar(sig, pan, amp)
        );
    }).add;
};

// list of Pbinds
~definePbinds = {
    // this is just used to signal that the framework is running
    // will stop after a couple of repeats
    ~start = EventPatternProxy(
        Pbind(
            \instrument, \basic,
            \note, Pseq([0, 2, 4,8], 2),
            \sus, Pwhite(2.0, 6.0, inf),
            \dur, 1
    ));

    ~clock = TempoClock.new(1).permanent_(true);
};

//performance events:
// Dictionary of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths directly via Routines
// (control FX synths, for example, for fade in/out etc)
// might be called manually, or from a Pattern or a Routine, or from
// a GUI, or MIDI, or from external code via OSC
//
// This is how you structure the composition

~events = [
    \startup: {~start.play(~clock, quant:1);},
    \play_site_events: {| event_name, num_events, interval|
        ~site_events[event_name][\running_event].stop;
        ~site_events[event_name][\running_event] = if(num_events == 0, {},
            {
                {
                    // wrap this in a loop in case the signals are interrupted
                    // this way it will keep playing events with the old frequency
                    loop {
                        var intervals = ~make_intervals.(num_events, interval);
                        intervals.do {|intvl|
                            intvl.wait; // wait first, otherwise every time this gets
                                        // called you get a sound immediately
                            ~site_events[event_name][\play_event].();
                        }
                    }
                }.fork;
        });
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
 //   ~buffs = ~loadBuffs.('sounds');
    ~birds = ~loadEventSounds.();
    s.sync;
    ServerTree.add({
        s.bind({
            ~initServerNodes.value;
        })
    });
    ServerTree.run;
    ~addControllers.();
    s.sync;

    // play startup sound
  //  ~events.[\startup].()
};
~definePbinds.value;
)

/*
~events[\play_site_events].(\home_page_view,10, 30)
~events[\play_site_events].(\grant_interaction,2, 30)
~events[\play_site_events].(\email_signup, 1, 30)
~events[\play_site_events].(\program_page_view,14, 10)
~events[\play_site_events].(\careers_page_view,14, 10)

~sparrow.play
Synth("playbuf", [buf:~sparrow, amp:0.2, start_secs:6.75, secs:0.7, pan:1]);
Synth("playbuf", [buf:~sparrow, amp:0.1, start_secs:6.75, secs:1, pan:0]);
~randAmp.()
*/
