// busses and nodes may be needed for effects, and control
// otherwise these two functions can be left empty

~freeBufs = {
    | bufs |
    bufs.do {|buf|
        buf.free;
    }
};
~makeBufs1 = {
    | numbuffs = 8|

    var makeWaveform = {
        |numLevs = 7|
        var numPts = numLevs + 1;
        var levs = {rrand(-1.0,1.0)}!numLevs;
        var peak = levs.abs.maxItem;
        levs = levs * peak.reciprocal;
        Env(
        [0]++ levs ++ [0],
        {exprand(0.01,1)}!numPts,
        {exprand(0.1,4)}!numPts
    ).asSignal(512).asWavetable;

    };

    ~freeBufs.(~bufs);
    ~numbuffs = numbuffs;
    ~bufs = numbuffs.collect({
        | i |
        Buffer.loadCollection(s, makeWaveform.((i + 1) * 3));
    });
    ~buffbase = ~bufs[0].bufnum;
};

~allocBufs = {
    |numbuffs|
    ~freeBufs.(~bufs);
    // allocate table of consecutive buffers
    ~bufs = Buffer.allocConsecutive(numbuffs, s, 1024, 1);
    ~buffbase = ~bufs[0].bufnum;
    ~numbuffs = numbuffs;
};

~makeBufs2 = {
    | numbuffs = 8 |
    ~allocBufs.(numbuffs);
    ~bufs.do({ arg buf, i;
        var n, a;
       // a = makeArray.(n);
        // generate array of harmonic amplitudes
//        a = Array.fill(n, { arg j; ((n-j)/n).squared.round(0.001) });
//        a = Array.fill(i, 0) ++ [0.5, 1, 0.5];
//     a = Array.fill(32,0);
//     12.do({ arg i; a.put(32.rand, 1).postln })
        a = Array.fill((i+1)**2, { arg j; 1.0.rand2 });
        buf.sine1(a);
    });

};



~loadBuffs = {
	~makeBufs2.();
};

//        n = (i+1)**2;
~allocBusses = {

};

~initServerNodes = {
    ~fxGroup = Group.new;
};

// SynthDefs for the Synths used in the piece
~defineSynths = {

    SynthDef("VoscChorus",{
        |out = 0, bufindex = 0, freq=400, detune=0.15, amp=1|
        var rats = Rand(0.08, 0.15)!8;
        var cfreq = freq  * (LFNoise1.kr(rats).bipolar(detune).midiratio);
        var sig = VOsc.ar(bufindex.lag(0.1), cfreq, Rand(0, 2pi), amp);
        sig = Splay.ar(sig);
        sig = LeakDC.ar(sig);
        Out.ar(out, sig * amp);
    }).add;

    SynthDef(\reverb, {
        | out = 0, mix = 0.1|
        var dry = In.ar(out);

        var wet =FreeVerb.ar(dry,0.45,2.0,0.5);

        wet = DelayN.ar(wet, 0.03, 0.03);
  //      wet = CombN.ar(wet, 0.1, {Rand(0.01,0.099)}!32, 4);
        wet = SplayAz.ar(2, wet);
        wet = LPF.ar(wet, 1500);
        //  5.do{wet = AllpassN.ar(wet, 0.1, {Rand(0.01,0.099)}!2, 3)};
        XOut.ar(out, mix, wet);
    }).add;

};

// list of Pbinds
~definePbinds = {
    ~pVosc = Pmono(\VoscChorus,
        \dur, Pwhite(0.15, 0.55).trace,
        \bufindex,  Pbrown(0, Pfunc({~numbuffs - 1}), 0.3).trace,
        \detune, Pbrown(0.05, 0.2).trace,
        \freq, 80, //Pbrown(60, 120).round(5).trace,
        \amp, 0.5

    );





};

//performance events:
// array (or dictionary) of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths directly via Routines
// might be called manually, or from a Pattern or a Routine, or from
// a GUI, or MIDI, or from external code via OSC

~events = [
    \start: {
        ~reverb = Synth(\reverb, [\mix, 0.2]);
        ~pVosc.play;
/*        ~vosc = Synth("VoscChorus", [\out, 0,
                         \bufindex, ~bufs[1].bufnum,
                         \freq, 80,
                         \detune, 0.15,
                         \amp, 0.5])*/
          },
    \setBufindex: {
        |bufindex|
        // make sure bufindex is allowed
        bufindex = 0.max(~numbuffs.min(bufindex));
        ~vosc.set(\bufindex, bufindex);
    },
    \stop: {
        ~pVosc.stop;
    },
    \setFreq: {
        |freq|
        ~vosc.set(\freq, freq);
    },
    \setDetune: {
        |detune|
        ~vosc.set(\detune, detune);
    },
    \setAmp: {
        |amp|
        ~vosc.set(\amp, amp);
    },
    \setReverbMix: {
        |mix|
        ~reverb.set(\mix, mix);
    },
    \regenBufs: {
        |which, how_many=8|
        ~events[\stop];
        if(which==1, {~makeBufs1.(how_many)},
            {
                ~makeBufs2.(how_many)
            }
        );
        ~events[\start].();
    }
].asDict;

