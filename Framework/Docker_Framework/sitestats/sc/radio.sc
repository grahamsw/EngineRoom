(
~loadBuff = {
	|filename, isAbsolute = false|
	var fn = if (isAbsolute, {filename}, {PathName(thisProcess.nowExecutingPath).parentPath ++ filename});
	Buffer.read(s, fn);
};



~make_intervals = {|n, total|
    (n.collect {1.0.rand}).normalizeSum * total
};

// returns a function that when evaluated (in Pfunc, say)
// returns intervals n of which will add up to total.
~durer = {|n, total|
    var ris = nil;
    var next_dur = {
        var ret = ris.next;
        if (ret == nil, {
            ris = Routine {
                ~make_intervals.(n, total).do {|i| i.yield}
            };
            ret = ris.next;
        });
        ret;
    };
    next_dur;
};

// placeholders - to be redefined to something interesting, like
// bird calls

~basicTone = {|freq| Synth(\basic,  [\freq, freq])};
~site_events = [
    \home_page_view: (\play_event: {
        Synth("playbuf", [buf:~sparrow, amp:0.1, start_secs:6.75, secs:0.7, pan:0]);
             }
    ),
    \program_page_view: (\play_event: {~basicTone.(400)}),
    \where_we_work_page_view: (\play_event: {~basicTone.(500)}),
    \editorial_page_view: (\play_event: {~basicTone.(600)}),
    \about_page_view: (\play_event: {~basicTone.(700)}),
    \careers_page_view: (\play_event: {~basicTone.(800)}),
    \grant_interaction: (\play_event: {~basicTone.(900)}),
    \video_play: (\play_event: {~basicTone.(1000)}),
    \email_signup: (\play_event: {~basicTone.(1100)})
].asDict;

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
    ~startbells = EventPatternProxy(
        Pbind(
            \instrument, \basic,
            \note, Pseq([0, 2, 4,8], 2),
            \sus, Pwhite(2.0, 6.0, inf),
            \dur, 1
    ));

    ~clock = TempoClock.new(1).permanent_(true);
};

//performance events:
// array (or dictionary) of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths directly via Routines
// (control FX synths, for example, for fade in/out etc)
// might be called manually, or from a Pattern or a Routine, or from
// a GUI, or MIDI, or from external code via OSC

~events = [
    \startup: {~startbells.play(~clock, quant:1);},
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
    ~buffs = ~loadBuffs.('sounds');
    ~sparrow = ~loadBuff.("sounds/sparrow_1.wav");
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
~events[\play_site_events].(\video_play,4, 10)

~sparrow.play
Synth("playbuf", [buf:~sparrow, amp:0.2, start_secs:6.75, secs:0.7, pan:1]);
Synth("playbuf", [buf:~sparrow, amp:0.1, start_secs:6.75, secs:1, pan:0]);

*/