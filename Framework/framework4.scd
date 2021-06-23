(

// the "channel name" that OSC listens on
~impl_osc_name = "/implOsc";


~allocBusses = {
    ~reverbBus = Bus.audio(s, 2);
};

~initServerNodes = {
    ~fxGroup = Group.new;
    ~reverb = Synth(\reverb, [\in, ~reverbBus], ~fxGroup);
};


// SynthDefs for the Synths used in the piece
~defineSynths = {
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

    SynthDef.new(\reverb, {
        arg in=0, drylevel=0.7, wetlevel=0.3, out=0;
        var sig, reverb;
        sig = In.ar(in, 2);
        reverb = In.ar(in, 2);
        reverb = LPF.ar(GVerb.ar(sig, 250, 4), 900);
        sig = (sig * drylevel) + (reverb * wetlevel);
        Out.ar(out, sig);
    }).add;

   SynthDef(\churchbell, // a church bell (by Risset, described in Dodge 1997)
        {arg freq=440, amp=0.1, out=0, sust=4, pan=0;
            var env, partials, addPartial, son, delay;

            freq = freq * 2;
         //   sust = 4;
            amp = amp/11;
            partials = Array.new(9);
            delay = Rand(0, 0.001);

            //bell = SinOsc(freq);

            addPartial = { |amplitude, rel_duration, rel_freq, detune, pan=0|
                partials.add((
                    Pan2.ar(
                        FSinOsc.ar(freq*rel_freq+detune, Rand(0, 2pi), amp * amplitude* (1 + Rand(-0.01, 0.01))), pan)
                    * EnvGen.kr(
                        Env.perc(0.01, sust*rel_duration* (1 + Rand(-0.01, 0.01)), 1, -4).delay(delay), doneAction: 0))
                ).tanh /2
        };

        //addPartial.(1, 1, 0.24, 0, Rand(-0.7, 0.7));
        addPartial.(1, 1, 0.95, 0, Rand(-0.7, 0.7));
        addPartial.(0.67, 0.9, 0.64, 1, Rand(-0.7, 0.7));
        addPartial.(1, 0.65, 1.23, 1, Rand(-0.7, 0.7));
        addPartial.(1.8, 0.55, 2, 0, 0); // root
        addPartial.(2.67, 0.325, 2.91, 1, Rand(-0.7, 0.7));
        addPartial.(1.67, 0.35, 3.96, 1, Rand(-0.7, 0.7));
        addPartial.(1.46, 0.25, 5.12, 1, Rand(-0.7, 0.7));
        addPartial.(1.33, 0.2, 6.37, 1, Rand(-0.7, 0.7));

        son = Mix(partials).tanh;
        son = DelayC.ar(son, 0.06, Rand(0, 0.02));
        EnvGen.kr(Env.perc(0.01, sust * 1.01), doneAction:2);

        Out.ar(out, son);
}).add;
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
    \start: {~player = ~bells.play(~clock, quant:4);},
	\stop: {~player.stop;},
    \setRate: {|rate|
        var durMin = rate.linlin(0, 60, 0.1, 0.02).postln;
        var durMax = rate.linlin(0, 60, 2, 0.1).postln;
        rate.postln;


//# this is low wind
//['durs'](rand_gen([0.1, 0.5, 1, 1.5, 2], allowRepeats=False))
//#setters['fs'](rand_gen([300, 450, 600, 750], allowRepeats=False))

//# slightly more agitated
//setters['durs'](rand_gen([0.5, 0.1, 1], allowRepeats=False))
//#setters['fs'](rand_gen([750, 900, 1000, 1150, 1270], allowRepeats=False))

//# even more agitated
//setters['durs'](rand_gen([0.05, 0.1, 0.02, 0.05], allowRepeats=False))
//#setters['fs'](rand_gen([1000, 1150, 1270, 1500, 800], allowRepeats=False))
        ~bells.source_(
            Pbind(
              \instrument, \bell,
              \fs, Prand([300, 450, 600, 750, 900, 1000], inf),
              \t60, Pseq([3,5,6], inf),
              \amp, Pseq([0.01, 0.02, 0.01, 0.01, 0.04], inf),
              \pitchy, 3,
              \dur, Pwhite(durMin, durMax, inf)
        )).quant_(1);
    }

].asDict;

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

/////////////////////////////////
// code that doesn't change
////////////////////////////////


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







~events[\start].()
~events[\setRate].(30)
~events[\stop].()
