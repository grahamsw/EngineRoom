//MUS 499C Spring 2021
//HW 1
//Due Thursday, Feb 18th by 3pm

/*
Compose a 3-4 minute synthesis composition in SuperCollider, relying primarily on FM synthesis and/or wavetable synthesis, by using and developing techniques demonstrated during livestream lectures from weeks 2 & 3, as well as SuperCollider tutorials 21 through 24.

YouTube playlists:
https://www.youtube.com/playlist?list=PLPYzvS8A_rTbTAn-ZExGuVFZgVMwYi1kJ
https://www.youtube.com/playlist?list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC

Livestream code files:
https://uofi.box.com/s/imuha2oexqypskkrel8g41x7tto5dtqf

There are very few restrictions or guidelines beyond this! Simply:

1. You can copy code from the livestream code files, but add some changes and developments of your own, or even better, code your SynthDefs from scratch as a good learning exercise.

2. You can start using unorganized, piecemeal code sketches, but in the end you should format your code using the performance structure from HW 0 (or something similar) so that everything can be setup with one keystroke, with a separate chunk of code below that for performing the piece. I'm flexible on this — I just want it to be easy for me to run your pieces!

3. Make it sound awesome!

When finished, title your scd file "LastName_HW1.scd" and upload it to the course website.
*/


(
// these functions are all defined by the composer, and may be
// redefined, with care, and rerun while the piece is running
// in order to extend it and continue experimentation

~allocBusses = {
	// alloc busses for the synths
};

~initServerNodes = {
	// create groups and FX nodes
};

// SynthDefs for the Synths used in the piece
~defineSynths = {

    SynthDef(\fm3,
        {
            | freq=440,  mRatio = 1, cRatio = 1, index = 1, iScale=5, amp = 0.2, atk = 0.01, rel = 0.1, cAtk = 4, cRel = (-4), pan=0, out=0 |
            var car, mod, env, iEnv;
            iEnv  = EnvGen.kr(
                Env(
                    [index, index * iScale, index],
                    [atk, rel],
                    [cAtk, cRel]
                )
            );
            env = EnvGen.kr(
                Env.perc(atk, rel, curve:[cAtk, cRel]),
                doneAction:Done.freeSelf
            );
            mod = SinOsc.ar(freq * mRatio, mul:freq*mRatio * iEnv);
            car = SinOsc.ar(freq * cRatio + mod) * env * amp;
            car = Pan2.ar(car, pan);
            Out.ar(out, car);
    }).add;
};

// list of Pbinds
~definePbinds = {

};

//performance events:
// array (or dictionary) of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths via Routines
// might be called manually, or from GUI, or MIDI, or from external
// code via OSC
~events = [


].asDict;











/////////////////////////////////
// code that doesn't change
////////////////////////////////
s.newBusAllocators;
~allocBusses.value;

ServerTree.removeAll;

~loadBuffs = {
	|foldername, isAbsolute = false|
	var fn = if (isAbsolute, {foldername}, {PathName(thisProcess.nowExecutingPath).parentPath ++ foldername});
	PathName(fn).files.collect({
		|f|
		Buffer.read(s, f.fullPath);
	});
};

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
};

~definePbinds.value;

)







(
Synth(\fm3, [\freq, 60.midicps, \rel, 0.1, \index, 2, \iScale, 0.04, \cRel, 12])

(
t = TempoClock;
Pbindef(\fmer,
    \instrument, \fm,
    \midinote, Pseq([60, 64, 67, 59], inf),
    \dur, 1

);
Pbindef(\fmer).play(t, quant:2);
)

Pbindef(\fmer, \amp, 0.9, \atk, 1 \rel, 5, \cAtk, 4).quant_(2)
Pbindef(\fmer, \index, Pseq([1], inf), \legato, 5).quant_(2)

Pbindef(\fmer, \iScale, Pseq([0.2,0.9], inf)).quant_(2)
Pbindef(\fmer, \cRatio, Pn(Pgeom(0.1, 1.6,10), inf).trace).quant_(2)


Synth(\fm3, [freq, 440,  mRatio, 1, cRatio, 1, index = 1, iScale=5, amp = 0.2, atk = 0.01, rel = 0.1, cAtk = 4, cRel = (-4), pan=0, out=0 |