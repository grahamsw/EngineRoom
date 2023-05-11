(

// the "channel name" that OSC listens on
~impl_osc_name = "/implOsc"; // "OSC_CHANNEL".getenv;

~setServerOptions = {
    s.options.memSize_(2.pow(16));
    //s.options.inDevice_("ASIO : ASIO Digidesign Driver Mbox2");
    //s.options.outDevice_("ASIO : ASIO Digidesign Driver Mbox2");
    s.options.inDevice_(nil);
    s.options.outDevice_(nil);
    s.options.sampleRate_("44100");
};


~allocBusses = {
	~bus = Dictionary.new;
	~bus.add(\reverb -> Bus.audio(s, 2));
	~bus.add(\delay -> Bus.audio(s, 2));
	~bus.add(\endstage -> Bus.audio(s, 2));
};

~initServerNodes = {

	~src = Group.new;
	~efx = Group.after(~src);
	~estg = Group.after(~efx);

	~revSynth = Synth(\reverb, [
		\in, ~bus[\reverb],
		\out, ~bus[\endstage]
	], ~efx, \addToTail);

	~delSynth = Synth(\delay, [
		\in, ~bus[\delay],
		\dry, 0.5,
		\dtime, t.beatDur * 0.75,
		\decay, t.beatDur * 2.5,
		\out, ~bus[\endstage]
	], ~efx, \addToHead);

	~compSynth = Synth(\comp, [
		\in, ~bus[\endstage],
		\out, ~out
	], ~estg)
};


// SynthDefs for the Synths used in the piece
~defineSynths = {
 // instruments
    	SynthDef(\reverb, {
		var sig;
		sig = In.ar(\in.ir(0), 2);
        // sig = MiVerb.ar(
        //     sig,
        //     \time.kr(0.9),
        //     \drywet.kr(0.75),
        //     \damp.kr(0.5),
        //     \hp.kr(0.05),
        //     diff: \diff.kr(0.625),
        //     mul: \revAmp.kr(0.dbamp)
        // );

		Out.ar(\out.ir(0), sig);
	}).add;

	SynthDef(\delay, {
		arg dry;
		var sig;

		sig = In.ar(\in.ir(0), 2);

		sig = AllpassC.ar(
			sig,
			\maxdel.kr(2),
			\dtime.kr(0.2),
			\decay.kr(1),
			\delAmp.kr(0.dbamp)
		);

		Out.ar(\out.ir(0), sig * dry);
		Out.ar(\fx.ir(0), sig * (1-dry));
	}).add;

	SynthDef(\comp, {
		var sig;
		sig = In.ar(\in.ir(0), 2);
		sig = Compander.ar(
			sig,
			sig,
			\thresh.kr(0.6),
			\slopeBelow.kr(1.0),
			\slopeAbove.kr(0.66),
			mul: \compAmp.kr(3.dbamp)
		);
		Out.ar(\out.ir(0), sig);
	}).add;
// saw drone
SynthDef(\saw, {
	arg dry = 0.5, rq = 0.5;
	var sig, env, dt;

	env = Env.adsr(\atk.ir(0.1), \dec.ir(0.2), \suslev.ir(1), \rel.ir(2)).kr(2, \gate.kr(1));

	dt = LFNoise2.ar(0.25!5).bipolar(\dtune.kr(0.15)).midiratio;

	sig = VarSaw.ar(
		\freq.kr(220) * dt,
		0.0001,
		\width.kr(0.001),
		0.05
	).sum;

	sig = RLPF.ar(
		sig,
		SinOsc.ar(
			\sweep.kr(1/20),
			\sweepphase.kr(0)
		).range(
			\sweepmin.kr(800),\sweepmax.kr(2400)
		),
		rq,
		1/(rq.sqrt)
	);

	sig = sig * env * \amp.kr(-6.dbamp);

	//sig = Splay.ar(sig);
	sig = Pan2.ar(sig, 0);

	Out.ar(\out.ir(0), sig * dry);
	Out.ar(\sendbus.ir(0), sig * \send.kr(0.25));
	Out.ar(\fx.ir(0), sig * (1- dry));
}).add;

// a square & saw voice
SynthDef(\square, {
	arg dry = 0.5;
	var sig1, sig2, sig, env, freq, dt;

	freq = \freq.kr(220, 0.02);
	dt = LFNoise2.kr(\dtfreq.kr(0.2!5)).bipolar(\dtune.kr(0.15)).midiratio;
	freq = freq * dt;

	env = Env.adsr(\atk.ir(0.1), \dec.ir(0.2), \suslev.ir(1), \rel.ir(2), curve: \curve.kr(-2)).kr(2, \gate.kr(1));

	//square
	sig1 = PulseDPW.ar(
		freq,
		\pwidth.kr(0.5),
		mul: 0.1
	).sum;

	// saw
	sig2 = VarSaw.ar(
		freq,
		0,
		\swidth.kr(0.0001),
		mul: 0.1
	).sum;
	sig2 = LPF.ar(sig2, \cutoff.kr(3200));

	sig = sig1.blend(sig2, \blend.kr(0.5, 0.05));
	sig = sig * env * \amp.kr(-6.dbamp);

	//sig = Splay.ar(sig);
	sig = Pan2.ar(sig, 0);

	Out.ar(\out.ir(0), sig * dry);
	Out.ar(\sendbus.ir(0), sig * \send.kr(0.25));
	Out.ar(\fx.ir(0), sig * (1- dry));
}).add;


};

// list of Pbinds
~definePbinds = {
    ~scale = Scale.convert(Scale.dorian(\just), 31, "pseudoDorian");
    ~base = Pbind(
        //\scale, Scale.dorian(\pythagorean),	// set tonality
        \scale, ~scale,							// set tonality
        \ctranspose, -4,						// set tonality
        \group, ~src,							// put everything in its right group
        \out, ~bus[\endstage],					// output bus
        \fx, ~bus[\reverb],						// set effect bus
        \sendbus, ~bus[\delay]					// level of signal going to delay bus
    );

    ~drone = Pbind(
        \instrument, \saw,
        \octave, 3,
        \degree, Pxrand((0..7), inf).clump(2),
        \legato, Pwhite(0.95, 1.5),
        \dur, 16,
        \amp, -16.dbamp,
        \atk, 1.5,
        \rel, 2,
        \sweep, Pwhite(1/20, 8/60),
        \rq, Pwhite(0.2, 0.6),
        \sweepmin, Pwhite(440, 660),
        \sweepmax, Pwhite(6400, 8000),
        \sweepphase, Pwhite(0, pi),
        \pan, Pwhite(-0.9, 0.9),
        \dry, 0.333,
        \send, 0
    ) <> ~base;

    ~plucks = Pbind(
        \instrument, \saw,
        \suslev, Pwhite(0.05, 0.4),
        \atk, Pwhite(0.001, 0.1),
        \dec, Pwhite(0.05, 0.4),
        \rel, Pwhite(0.4, 1.8),
        \dry, Pwhite(0.5, 0.7),
        \amp, Pseq([-9, Pn(Pwhite(-18, -12), Pwhite(3, 7))].dbamp, inf),
        \pan, Pseq([
            Pseries(-0.5, 0.1, 10),
            Pseries(0.5, -0.1, 10)
        ], inf),
        \rq, Pwhite(0.1, 0.2),
        \sweepmin, 1200,
        \sweepmax, 1800,
        \legato, Pwhite(0.4, 0.7)
    ) <> ~base;

    // building on the plucks
    ~durReps = Pgeom(64, 0.75, inf).asStream;
    ~plucks1 = Pbind(
        \octave, Pseq([
            Pwrand([5, 6], [0.1, 0.9], 12),
            Pwrand([5, 6], [0.2, 0.8], 12),
            Pwrand([5, 6], [0.3, 0.7], 12),
            Pwrand([5, 6], [0.4, 0.6], 12),
            Pwrand([5, 6], [0.5, 0.5], 12),
            Pwrand([5, 6], [0.6, 0.4], 12),
            Pwrand([5, 6], [0.7, 0.3], 12),
            Pwrand([5, 6], [0.8, 0.2], 12),
            Pwrand([5, 6], [0.9, 0.1], inf),
        ]),
        \degree, Prand((-2..9), inf),
        \dur, Pdup(~durReps, Pgeom(0.0625, 1.25, 16)),
        \amp, -18.dbamp * Pwhite(0.95, 1.05),
        \send, Pwhite(0.1, 0.2)
    ) <> ~plucks;

    ~plucks2 = Pbind(
        \octave, 5,
        \dur, Pwrand([
            Pseq([0.5, 0.5]),
            Pseq([0.25, 0.25, 0.25, 0.25]),
            Pseq([1]),
        ], [
            0.4,
            0.2,
            0.4
        ].normalizeSum,
        inf),
        \degree, Prand([
            Pshuf([0, 2, 4, 6]),
            Pshuf([-1, 1, 3, 4]),
            Pshuf([1, 3, 5, 7])
        ], inf),
        \dry, Pwhite(0.2, 0.3),
        \send, 0.5
    ) <> ~plucks;

    ~rv = Pwhite(0.99, 1.01);
    ~squareMel = PmonoArtic(
        \square,
        \dur, 0.5,
        \octave, Prand([\, Pdup(4, Prand([5, 6]))], inf),
        \degree, Pwalk(
            (0..7),
            Prand([1, 2], inf),
            Pseq([1, -1], inf)
        ),
        \dry, 0.5 * ~rv,
        \dtune, 0.15 * ~rv,
        \atk, 0.07 * ~rv,
        \dec, 0.4 * ~rv,
        \suslev, 0.6 * ~rv,
        \rel, Pmeanrand(1.2, 2.8),
        \curve, -4 * ~rv,
        \pwidth, Pmeanrand(0.4,0.6),
        \swidth, Plprand(0.001, 0.3),
        \cutoff, Pwhite(3200,4800),
        \blend, Pseq([
            Pdup(12, Pseries(0.1, 0.025, 20)),
            Pdup(12, Pseries(0.6, -0.025, 20))
        ], inf),
        \amp, 0.35 * Pwhite(0.9, 0.99),
        \legato, Phprand(0.8, 1.1),
        \send, Pseq([
            Pdup(8, Pseries(0.2, 0.05, 8)),
            Pdup(8, Pseries(0.6, -0.05, 8))
        ], inf)
    ) <> ~base;

    ~pluckseg = Pbind(
        \send, Pseg([0.01, 0.6, 0.25], [60, 15], [\exp, \sine], 1),
        \amp, Pseq([-16, Pn(Pwhite(-24, -18), Pwhite(3, 7))].dbamp, inf),
    ) <> ~plucks2;

    ~pluckseg2 = Pbind(
        \octave, 4,
        \send, Pseg([0.01, 0.6, 0.25], [30, 60], [\exp, \sine], 1),
        \amp, Pseq([-16, Pn(Pwhite(-24, -18), Pwhite(3, 7))].dbamp, inf),
    ) <> ~plucks2;

    ~droneseg = Pbind(
        \amp, Pseg([-16, -18, -28].dbamp, [20, 50], [\lin, \exp])
    ) <> ~drone;

    t = TempoClock(60/60).permanent_(true);
};

//performance events:
// array (or dictionary) of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths directly via Routines
// (control FX synths, for example, for fade in/out etc)
// might be called manually, or from a Pattern or a Routine, or from
// a GUI, or MIDI, or from external code via OSC

~events = [
    \start: {

        ~out = 0;
        ~piece = Routine{
            ~plucks1.play(t).reset;
            32.wait;

            ~droneseg.play(t).reset;
            56.wait; // 52 sec.

            ~pluckseg.play(t);
            75.wait; // 163 sec.

            c = ~squareMel.play(t).reset;
            45.wait; // 208 sec.

            a = ~drone.play(t);
            45.wait; // 253 sec.

            a.stop;
            c.stop;

            ~pluckseg2.play(t); // runs for 90 sec -> 343 sec.
            16.wait; // 269

            c = ~squareMel.play(t).reset;
            32.wait; // finishes at 301 sec.

            c.stop;
        };
        h = ~piece.play(t);
        h.stop;
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


~setServerOptions.value;
~definePbinds.value;
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





}


)


// ~events[\setNote].(5);
// Synth(\tone)