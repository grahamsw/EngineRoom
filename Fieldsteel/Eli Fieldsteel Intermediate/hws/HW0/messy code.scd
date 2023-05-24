//MUS 499C Spring 2021
//HW 0
//Due Thursday, Feb 4th by 3pm

/*
The following code constitutes sketches for a larger project-to-be, but it's messy, and unorganized. First, save this code as a new scd filed named LastName_HW0.scd, then edit that new code file using techniques shown during the first lecture. In particular:

1. The code that handles the "setup" aspects of the piece should all be inside one large enclosure of parentheses, including a 'waitForBoot' function, so that the entire piece can be set up and ready to go with a single keystroke.

2. The buffer code should be adapted to use the 'thisProcess.nowExecutingPath' approach.

3. The performance events should be organized into a single collection (e.g. an array).

4. An appropriate function should be added to ServerTree, so that the effects group and reverb synth are properly rebuilt if the user presses command-period.

5. Below the large enclosure of setup code, add some code that allows the user to run performance events in a simple way, by accessing and evaluating performance events in the collection you created in step 3. If you like, you can make something fancier (for example, you could add some GUI code to the setup clump that creates a window with an "event" button).

When finished, your folder should contain "LastName_HW0.scd," the original "messy code.scd" file, and the "sounds" folder containing the single marble sample. Compress this folder as a zip file and upload it to the course website.
*/
~loadBuffs = {
	|foldername, isAbsolute = false|
	var fn = if (isAbsolute, {foldername}, {PathName(thisProcess.nowExecutingPath).parentPath + foldername});
	PathName(fn).files.collect({
		|f|
		Buffer.read(s, f.fullPath);
	})
}



s.boot;

(
SynthDef(\hihat, {
	var sig;
	sig = SinOsc.ar(12000) * Env.perc(0.001,0.01).ar * 0.1;
	sig = sig + (SinOsc.ar(2000) * Env.perc(0.001,0.02).ar * 0.02);
	sig = sig + (
		BPF.ar(WhiteNoise.ar(1), 9000, 0.5) * Env.perc(0.0001,0.1,1,-7).ar
	);
	sig = sig * Env.perc(0.0001,0.1,1,-5).ar(2);
	sig = Pan2.ar(sig, \pan.ir(0), \amp.ir(1));
	Out.ar(\out.kr(0), sig);
	Out.ar(\outfx.ir(0), sig * \send.ir(-30).dbamp);
}).add;
)

//testing
Synth(\hihat);

Synth(\hihat, [\pan, [-1,1].choose, \amp, 0.3]);

(
SynthDef(\hum, {
	var sig, env;
	sig = LFTri.ar(\freq.ir(55));
	sig = RLPF.ar(sig, \lpf.ir(110), \rq.ir(0.3), 1/\rq.ir(0.3).sqrt);
	env = Env(
		[0,1,1,0],
		[\atk.ir(2), \sus.ir(0.05), \rel.ir(2)],
		[\atkcrv.ir(2), 0, \relcrv.ir(-2)]
	).ar(2);
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.ir(0), \amp.kr(0.1));
	Out.ar(\out.ir(0), sig);
	Out.ar(\outfx.ir(0), sig * \send.ir(-30).dbamp);
}).add;
)

Synth(\hum); //probably inaudible on most laptop speakers, use headphones

Synth(\hum, [\freq, 200, \lpf, 400]); //laptop-friendly frequency


~marble = Buffer.read(s, "/Users/eli/Desktop/HW Week 1/sounds/marbleroll.aiff");

~marble.play; //testing

(
SynthDef(\smpl, {
	var sig, env;
	sig = PlayBuf.ar(1, \buf.ir(0), BufRateScale.ir(\buf.ir(0)) * \rate.ir(1), 1, \spos.ir(0), \loop.kr(1));
	env = env = Env(
		[0,1,1,0],
		[\atk.ir(4), \sus.ir(0.05), \rel.ir(2)],
		[\atkcrv.ir(2), 0, \relcrv.ir(-2)]
	).ar(2);
	sig = sig * env;
	sig = Pan2.ar(sig, \pan.ir(0), \amp.kr(0.4));
	Out.ar(\out.ir(0), sig);
	Out.ar(\outfx.ir(0), sig * \send.ir(-30).dbamp);
}).add;
)

(
//testing
Synth(\smpl, [\buf, ~marble, \rate, 0.7, \pan, -1]);
Synth(\smpl, [\buf, ~marble, \rate, 0.71, \pan, 1]);
)

(
SynthDef(\reverb, {
	var sig, wet;
	sig = In.ar(\in.ir(0), 2);
	sig = FreeVerb2.ar(sig[0], sig[1], mix:1, room:0.99, damp:0.99);
	sig = LPF.ar(sig, 900);
	Out.ar(\out.ir(0), sig);
}).add;
)

s.newBusAllocators;
~reverbBus = Bus.audio(s, 2);

~fxGroup = Group.new;
~reverb = Synth(\reverb, [\in, ~reverbBus], ~fxGroup);

Synth(\hihat, [\out, 0, \outfx, ~reverbBus, \send, -3]); //testing, should hear reverb

(
~hatPat = Pbind(
	\instrument, \hihat,
	\dur, 1/4,
	\pan, Pseq([-0.8,0.8],32),
	\amp, Pseq( Array.geom(16, 0.0012, 1.5) ++ Array.geom(16, 0.8, 2/3), 1),
	\out, 0,
	\outfx, ~reverbBus,
	\send, -10,
);
)

//testing
~hatPlayer = ~hatPat.play;

~hatPlayer.stop;

(
~humPat = Pbind(
	\instrument, \hum,
	\dur, Pseq([3/4, 3/4, 1], 1),
	\midinote, Pseq([45, 48, 55], 1),
	\lpf, Pkey(\midinote).midicps * 2,
	\amp, 0.07,
	\atk, 0,
	\sus, 0,
	\rel, 2,
	\relcrv, -8,
	\out, 0,
	\outfx, ~reverbBus,
	\send, -10,
);
)

//testing this little 3-note sequence
~humPlayer = ~humPat.play;

(
~hum2Pat = Pbind(
	\instrument, \hum,
	\dur, Pexprand(0.2,0.7,inf),
	\midinote, Pwhite(30.0, 40.0, inf),
	\amp, 0.04,
	\atk, 2,
	\sus, 0,
	\rel, 2,
	\relcrv, -4,
	\out, 0,
	\outfx, ~reverbBus,
	\send, -10,
);
)

//testing low freq drone generator
~hum2Player = ~hum2Pat.play;

~hum2Player.stop;

(
~marblePat = Pbind(
	\instrument, \smpl,
	\buf, ~marble,
	\dur, 1,
	\atk, 2,
	\sus, 0,
	\rel, 3,
	\rate, Pfuncn({ Array.rand(2, -8.3, -8.0).midiratio }, inf),
	\spos, Pfuncn({ Array.rand(2, 0, 1000) }, inf),
	\amp, Pexprand(0.1, 0.2, inf),
);
)

//testing sample sequencer
~marblePlayer = ~marblePat.play;

~marblePlayer.stop;

//performance events:

//event 0 - play this pattern twice
Pseq([ ~hatPat ], 2).play;

//event 1
//play two patterns in parallel, then play the hi-hat pattern indefinitely
(
~comboPat = Pseq([
	Ppar([~hatPat, Pseq([~humPat], 3)], 1),
	Pseq([~hatPat],inf)
]).play;
)

//event 2
(
//play these two patterns (both indefinite length)
~hum2Player = ~hum2Pat.play;
~marblePlayer = ~marblePat.play;
)

//event 3 - stop this pattern
~hum2Player.stop;

//event 4 - stop another pattern
~marblePlayer.stop;


//event 5 - last, stop the hi-hat pattern from event 2
~comboPat.stop;