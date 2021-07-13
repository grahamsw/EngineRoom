(

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


~basicTone = {|freq| Synth(\basic,  [\freq, freq])}

~site_events = [
    \home_page_view: (\play_event: {~basicTone.(300)}),
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
        |buf=0, rate=1, amp=0.1, start_secs=0, secs=(-1), pan=0, out=0|
        var sig = PlayBuf.ar(1, buf, rate * BufRateScale.ir(buf), doneAction:2);
       // var env = EnvGen.kr(Env([0, 1, 1,0], [0.01, ]))
        Out.ar(out,
            Pan2.ar(sig, pan, amp)
        );
    }).add;

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
        |fs=1, t60=1, pitchy=1, amp=0.25, gate=1, pan=0, out = 0|
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
        Out.ar(out, Pan2.ar(sig, pan));
    }).add


};

// list of Pbinds
~definePbinds = {
    // this is just used to signal that the framework is running
    // will stop as soon as any other signal has been received
    ~startbells = EventPatternProxy(
        Pbind(
            \instrument, \PMCrotale,
            \note, Pseq([0, 2, 4,8], 2),
            \sust, Pwhite(2.0, 6.0, inf),
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
        if(num_events == 0, {},{
        ~site_events[event_name][\running_event] =
        {
            // wrap this in a loop in case the signals are interrupted
            loop {
                var intervals = ~make_intervals.(num_events, interval);
                intervals.do {|interval|
                    interval.wait; // wait first, otherwise every time this gets you get a sound immediately
                    ~site_events[event_name][\play_event].();
                }
            }
        }.fork;
        nil;
        });
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

    // play startup sound
    ~events.[\startup].()


};

~definePbinds.value;


)




// for testing - in use these get called from python
//~events[\start].()
//~events[\setRate].(15, 60)
//~events[\stop].()

~events[\play_site_events].(\home_page_view,10, 30)
~events[\play_site_events].(\grant_interaction,2, 30)
~events[\play_site_events].(\email_signup, 0, 30)
~events[\play_site_events].(\video_play,4, 10)

