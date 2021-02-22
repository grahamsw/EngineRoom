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

];











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
SynthDef(\fm1,
    {
        | freq=440, amp=0.1, ratio = 1, index=1, atk = 0.01, dec=0.3, rel = 0.1, gate=1, pos = 0, out=0 |
        var sig, env, mod;
        var modFreq = freq * ratio;
        var modAmp =freq * ratio * index;
        ["modFreq:  " + modFreq, "modAmp: " + modAmp].postln;
        env = EnvGen.kr(Env.adsr(atk, dec, releaseTime:rel ),gate:gate, doneAction:2);
        mod = SinOsc.ar(modFreq, mul: modAmp);
        sig = SinOsc.ar(freq + mod);
       // sig = sig * env;
        sig = sig * amp;
        sig = Pan2.ar(sig, pos);
        Out.ar(out, sig);
    }
).add;

)
(
~ratio =  Bus.control(s,1);
~index =  Bus.control(s,1);
~freq = Bus.control(s,1) ;
)

(
~ratio.set(17);
~index.set(5);
~freq.set(100)

)

x = Synth(\fm1)
x.map(\freq, ~freq, \ratio, ~ratio, \index, ~index);
x.free;


Pdef(\freq).


(
Pbindef(\fmp1,
    \instrument, \fm1,
    \degree, Pseq([1], inf),
    \dur, 1,
    \ratio, 1,
    \index, 1
)
)
(
t =  TempoClock;

Pbindef(\fmp1).play(t, quant: 4)
)

Pcable


Pbindef(\fmp1, \index, 5, \ratio, Pseq([1,5,17], inf)).quant_(4)

)

