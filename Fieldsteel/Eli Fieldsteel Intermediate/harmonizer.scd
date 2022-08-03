(
// these functions are all defined by the composer, and may be
// redefined, with care, and rerun while the piece is running
// in order to extend it and continue experimentation

~allocBusses = {
	// create nodes for the FXs
    ~inbus = Bus.audio(s, 1);
};

~initServerNodes = {
	// create groups and FX nodes
    // also creating the buffer we need here - so this has to happen after the server is booted
    Buffer.freeAll;
    ~writeBuff = Buffer.alloc(s, s.sampleRate * 5);
};

// SynthDefs for the Synths used in the piece
~defineSynths = {
    // writes a bus to a buffer
    SynthDef(\input_writer, {
        var mic, ptr, buf = \outbuf.kr(0);
        mic = In.ar(\inbus.kr(0));
        ptr = Phasor.ar(0, 1, 0, BufFrames.kr(buf));
        BufWr.ar(mic, buf, ptr);
    }).add;

    // uses granularization to transpose a buffer in real time
    // creating 4 parts
    SynthDef(\harmonizer, {
        var wet, mic, ptr, pos, dry;
        var wetRatio = \wetRatio.kr(0.5);
        var buf = \buf.kr(0);
        ptr = Phasor.ar(0, 1, 0, BufFrames.kr(buf));
        dry = BufRd.ar(1, buf, ptr);
        pos = (ptr/SampleRate.ir) - 0.03;

        wet = TGrains.ar(
            numChannels: 1,
            trigger: Impulse.kr(\trig.kr(100)),
            bufnum: buf,
            rate: \harm.kr(4).midiratio,
            centerPos: pos,
            dur: 0.05,
        );

        Out.ar(\out.kr(0), (wet * wetRatio  + dry * (1 - wetRatio)));
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
    \startInput,
    {{Out.ar(~inbus,SinOsc.ar(SinOsc.kr(1/5).range(100, 300)))}.play;
    y = Synth(\input_writer, [\outbuf, ~writebuf, \inbus, ~inbus]);
    x = Synth(\harmonizer, [\buf, b]);
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


~events[\startInput].value




x.set(\harm, -12 )
x.set(\trig, 400)

x.set(\wetRatio, 0)
r{
100.do { |n|
        x.set(\harm, (1*n/20);
        0.1.wait;
    }
}.play

{Out.ar(~inbus,SinOsc.ar(400))}.play;
