
(
// these functions are all defined by the composer, and may be
// redefined, with care, and rerun while the piece is running
// in order to extend it and continue experimentation

~allocBusses = {
	// create nodes for the FXs
};

~initServerNodes = {
	// create groups and FX nodes
};

// SynthDefs for the Synths used in the piece
~defineSynths = {
SynthDef( \mridangam, { |out = 0, t_amp =0.1|
    var sound;

    sound = Resonz.ar(
        WhiteNoise.ar(70) * Decay2.kr( t_amp, 0.002, 0.1 ),
        60.midicps,
        0.02,
        4
    ).distort * 0.4;

    Out.ar(out, sound);
    DetectSilence.ar(sound, doneAction: Done.freeSelf);
}).add;

SynthDef( \drone, { |out|
    var sound;
    sound = LPF.ar(
        Saw.ar([60, 60.04].midicps)
        +
        Saw.ar([67, 67.04].midicps),
        108.midicps,
        0.007
    );
    Out.ar(out, sound);
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

];











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

s.newBusAllocators;
~allocBusses.value;

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
};

~definePbinds.value;

)
(
{
    loop({
        var v = rrand(1, 7);
        Synth(\mridangam, [\out, v.linlin(1,7, -1, 1), \t_amp, v.linlin(1,7,0.1, 0.5)]);
        v*0.125.wait;
    })
}.fork
)







