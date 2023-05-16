(
s.options.bindAddress = "0.0.0.0"; // allow connections from any address
s.options.maxLogins = 2; // set to correct number of clients
s.options.memSize = 10 * 8192;
s.quit;
s.waitForBoot({
NetAddr.langPort.postln;
OSCFunc.newMatching({s.quit; 0.exit;}, '/s_quit');

~freeBufs = {
    | bufs |
    bufs.do {|buf|
        buf.free;
    }
};

~makeBufs1 = {
    | numBufs = 8|

    var makeWaveform = {Env(
        [0]++
        {
            var levs, peak;
            levs = {rrand(-1.0,1.0)}!10;
            peak = levs.abs.maxItem;
            levs = levs * peak.reciprocal;
        }.value ++
        [0],
        {exprand(0.01,1)}!11,
        {exprand(0.1,4)}!11
    ).asSignal(512).asWavetable;};

    ~freeBufs.(~bufs);

    ~bufs = numBufs.collect({
        Buffer.loadCollection(s, makeWaveform.());
    });
    ~buffbase = ~bufs[0].bufnum;

};

~makeBufs2 = {
    | numBufs = 8 |
    ~freeBufs.(~bufs);
    // allocate table of consecutive buffers
    ~bufs = Buffer.allocConsecutive(numBufs, s, 1024, 1);
    ~buffbase = ~bufs[0].bufnum;

    ~bufs.do({ arg buf, i;
        var n, a;

        // generate array of harmonic amplitudes
        n = (i+1)**2;
        a = Array.fill(n, { arg j; ((n-j)/n).squared.round(0.001) });
        a = Array.fill(i, 0) ++ [0.5, 1, 0.5];
   //     a = Array.fill(32,0);
   //     12.do({ arg i; a.put(32.rand, 1).postln })
  //      a = Array.fill((i+1)**2, { arg j; 1.0.rand2 });
        // fill table
        // argument '7': flag for the \sine1 wave fill method
        // see "Wave Fill Commands" in the Server Command Reference
        s.performList(\sendMsg, \b_gen, buf.bufnum, \sine1, 7, a);

    });

};

SynthDef("VoscChorus",{
    |out = 0, bufindex = 0, freq=400, detune=0.15, amp=1|
    var rats = Rand(0.08, 0.15)!8;
    var cfreq = freq  * (LFNoise1.kr(rats).bipolar(detune).midiratio);
    var sig = VOsc.ar(bufindex, cfreq, Rand(0, 2pi), amp);
    sig = Splay.ar(sig);
    sig = LeakDC.ar(sig);
    Out.ar(out, sig * amp);
}).add;

    s.sync;
 ~makeBufs1.();
    s.sync;
~freqBus = Bus.control(s, 1);
~bufBus = Bus.control(s, 1);
~detuneBus =  Bus.control(s, 1);
//~buffbase = ~bufs[0].bufnum;


    s.sync;
x = Synth("VoscChorus", [\out, 0,
                         \bufindex, ~bufs[1].bufnum,
                         \freq, 40,
                         \detune, 0.15,
                         \amp, 0.5])

    s.sync;


z = {ReplaceOut.kr(~bufBus, LFNoise1.kr(1/10).range(~buffbase, ~buffbase + 6))}.play;

x.map(\bufindex, ~bufBus);

})


)
