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
    SynthDef(\violish,
        {
            var sig, env, n = 8;
            sig =

            Mix.fill(n, {
                |i|
                LFTri.ar(VarLag.kr(\freq.kr(440), \lag.kr(0.1),-1, \exp) * Rand(1.001, 1.01) * (1+i),  mul:\amp.kr(0.1)/(1+i));
            });
            env = Env.adsr(\atk.kr(0.01), \decay.kr(0.3), \sus.kr(0.5), \release.kr(0.5)).kr(gate: \gate.kr(1));
            sig = sig * env / n;
            Out.ar(\out.kr(0), Pan2.ar(sig, \pos.kr(0)));
    }).add;

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

    SynthDef.new(\reverb, {
        arg in=0, drylevel=0.7, wetlevel=0.3, out=0;
        var sig, reverb;
        sig = In.ar(in, 2);
        reverb = In.ar(in, 2);
        reverb = LPF.ar(GVerb.ar(sig, 250, 4), 900);
        sig = (sig * drylevel) + (reverb * wetlevel);
        Out.ar(out, sig);
    }).add;

   ~coscbuff = Buffer.alloc(s, 2048, 1);
   ~coscbuff.sine1(1.0/(1..6), true, true, true);

   SynthDef(\cosc,
            {
                |freq = 400, amp = 0.1, gate = 1, buf=0, beats=1, pan = 0, out = 0|

                var sig, env;
                env =  EnvGen.kr(Env.adsr, gate, doneAction:Done.freeSelf);
                sig = COsc.ar(buf, freq, beats, amp);
                Out.ar(out, Pan2.ar(env * sig, pan));
        }).add;

};

// list of Pbinds
~definePbinds = {

	t = TempoClock.new(30/60).permanent_(true);

	Pbindef(\p1,
		\instrument, \basic,
		\dur, Pn(Pseq([0.5, 0.25, 0.25, 1], 2), inf),
		\degree, 2,
        // \rel, 0.2,
		\atk, 0.01,
        \sus, 0.2,
		\amp, 0.05,
        \out, ~reverbBus
	);


	Pbindef(\p2,
		\instrument, \basic,
		\dur, Pn(Pseq([0.25, 0.25,0.25, 0.25, 0.5, 0.5], 2), inf),
		\degree, 4,
		\amp, 0.01,
        \out, ~reverbBus
	);

	Pbindef(\p3,
		\instrument, \basic,
		\dur, Pseq([0.25, 0.25,0.25, 0.25], inf),
		\degree, Pseq([7,6,5,4], inf),
		\amp, 0.01,
        \out, ~reverbBus
	);

	Pbindef(\p4,
		\instrument, \basic,
		\dur, Pseq([1], inf),
		\degree, Pseq([-2], inf),
		\amp, 0.01,
        \out, ~reverbBus
	);

    Pbindef(\c1,
        \instrument, \cosc,
		\dur, Pseq([0.5], inf),
        \degree, Pseq([-2, -3, -3, [-3,-5]], inf),
		\amp, 0.01,
        \buf, ~coscbuff,
        \out, ~reverbBus
    );

    Pdef(\v1, Pmono(
        \violish,
        \degree, Pseq([2,  -5], inf),
        \lag, Pseq([0.5, 0.5],inf),
        \dur,  2,
        \ctranspose, Pseq([-24, -24], inf),
		\amp, 0.3,
        \out, ~reverbBus
    ));
    "defining synths".postln;

    Pbindef(\c2,
        \instrument, \cosc,
        \degree, Pseq([[2,5],[4,6],[5,9],[7,9]], inf),
        \amp, Pseq([0.1,0.1, 0.05, 0.13]*0.1,inf),
        \ctranspose, -12,
        \dur, Pseq([0.5,0.5, 0.5, 0.5], inf),
        \legato, 1.55,
        \beats, 2.5,
        \buf, ~coscbuff,
        \out, ~reverbBus
    );
    "synths defined".postln;

};

//performance events:
// array (or dictionary) of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths directly via Routines
// (control FX synths, for example, for fade in/out etc)
// might be called manually, or from a Pattern or a Routine, or from
// a GUI, or MIDI, or from external code via OSC
~events = [
	\start1: {Pbindef(\p1).play(t, quant:2);},
	\start2: {Pbindef(\p2).play(t, quant:2);},
	\start3: {Pbindef(\p3).play(t, quant:2);},
	\start4: {Pbindef(\p4).play(t, quant:2);},
	\startC1: {Pbindef(\c1).play(t, quant:2);},
	\startC2: {Pbindef(\c2).play(t, quant:2);},
	\startV1: {Pdef(\v1).play(t, quant:2);},

    \change1: {
        Pbindef(\p1,
            \degree, Pseq([7,5,2,4],inf),
            \amp, 0.04,
            \atk, 0.01,
            \sus, 0.2).quant_(2);

    },
    \change2: {
        Pbindef(\p2,
            \degree, Pseq([2, 4, 2, 2, 4, 4], inf),
            \amp, 0.03).quant_(2);
    },
    \change2_2: {
        Pbindef(\p2,
            \degree, Pseq([2, 4, 0, 1, 2, 2], inf),
            \amp, 0.03).quant_(2);
    },
    \change3: {
        Pbindef(\p3,
            \degree, Pseq([7,6,5,4], inf),
            \dur, 0.125,
            \amp, 0.008,
            \rel, 1,
            \pos, Pwhite(-1.0, 1.0, inf)).quant_(2);

    },
    \change3_2: {
        Pbindef(\p3,
            \degree, Pseq([7,6,7,6], inf),
            \pos, Pwhite(-1.0, 1.0, inf)).quant_(2);

    },

    \change4: {
        Pbindef(\p4,
            \degree, Pseq([[-2, -5]], inf),
            \amp, Pseq([[0.05, 0.1]], inf),
            \rel, [4,6],
            \atk, [0.01, 0.05]).quant_(2);
    },

    \changeC1: {
        Pbindef(\c1,
		    \dur, Pseq([0.25, 0.25, 1, 0.125,0.125,0.125,0.125], inf),
		    \degree, Pseq([-2, -2, -5, -5,-5,-5,-5], inf),
            \beat, 3
            ).quant_(2);
    },

	\stop1: {Pbindef(\p1).stop;},
	\stop2: {Pbindef(\p2).stop;},
	\stop3: {Pbindef(\p3).stop;},
	\stop4: {Pbindef(\p4).stop;},
	\stopC1: {Pbindef(\c1).stop;},
	\stopC2: {Pbindef(\c2).stop;},
	\stopV1: {Pdef(\v1).stop;}
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
			~events[eventName].(msg);
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

(
~sequence = [
    [\start1, 2],
    [\start2, 2],
    [\start3, 2],
    [\start4, 4],

    [\change1, 2],
    [\change2, 2],
    [\change3, 2],
    [\change4, 2],

    [\startV1, 4],

    [\startC2, 4],
  //  [\changeC1, 4],

    [\change2_2, 2],
    [\change3_2, 2],

    [\change2, 4],
    [\change3, 4],

    [\change3_2, 2],
    [\change2_2, 2],

    [\change3, 4],
    [\change2, 4],

    [\stop1, 6],
    [\stop3, 2],
    [\stop2, 2],
    [\stopC2, 6],

    [\stop4, 4],
    [\stopV1, 4]

];

~playEvent =  {
    |ee|
    ee[0].postln;
    ~events[ee[0]].value;
    (4*ee[1]).wait;
};

r = Routine({
    ~sequence.do({
        |ee|
        ~playEvent.(ee);
    });

});

r.play;
)



(
q = {|skip|
    Routine({
    ~sequence.selectIndices({|item,ix| ix < skip}).do({
        |ix|
        ~sequence[ix][0].postln;
        ~events[~sequence[ix][0]].value;
    });
    ~sequence.rejectIndices({|item,ix| ix < skip}).do({
        |ix|
        ~sequence[ix][0].postln;
        ~events[~sequence[ix][0]].value;
            (4* ~sequence[ix][1]).wait;
    });

});};
    q.(8).play;
)





