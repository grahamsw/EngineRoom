(
// these functions are all defined by the composer, and may be
// redefined, with care, and rerun while the piece is running
// in order to extend it and continue experimentation

~allocBusses = {
    var arr;
	// create nodes for the FXs
    8.do({ arg i;
        var a;
        s.sendMsg(\b_alloc, i, 1024); // allocate table
        // generate array of harmonic amplitudes
        arr = Array.fill(i, 0) ++ [0.5, 1, 0.5];
        // fill table
        s.performList(\sendMsg, \b_gen, i, \sine1, 7, arr);
    });
};

~initServerNodes = {
	// create groups and FX nodes
};

// SynthDefs for the Synths used in the piece
~defineSynths = {
    SynthDef("help-VOsc",{ arg out=0, freq = 400,amp = 0.2, voscrate= 1,
        varlagrate = 1, gate=1, bufoffset=0;
        var x, env;
        env = EnvGen.kr(Env.adsr, gate, doneAction:Done.freeSelf);
        x = TRand.kr(0, 7, Impulse.kr(voscrate)).varlag(varlagrate);
        Out.ar(out,
            VOsc.ar(
                bufoffset+x,
                freq * [1, 1.01],
                mul:env * amp)
        );
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






