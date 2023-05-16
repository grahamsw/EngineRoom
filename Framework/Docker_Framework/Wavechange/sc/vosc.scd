(
s.waitForBoot({

    var numBufs = 8;

    // allocate table of consecutive buffers
    ~bufs = Buffer.allocConsecutive(numBufs, s, 1024, 1);
    s.sync;

    ~bufs.do({ arg buf, i;
        var n, a;

        // generate array of harmonic amplitudes
        n = (i+1)**2;
        a = Array.fill(n, { arg j; ((n-j)/n).squared.round(0.001) });

        // fill table
        // argument '7': flag for the \sine1 wave fill method
        // see "Wave Fill Commands" in the Server Command Reference
        s.performList(\sendMsg, \b_gen, buf.bufnum, \sine1, 7, a);

        s.sync;
    });
    "Buffers prepared.".postln;
})
)

// play the synth, indexing into the buffers with MouseX
(
x = SynthDef("help-VOsc",{ arg out = 0, bufoffset = 0;
    // mouse x controls the wavetable position
    var bufindex = MouseX.kr(0, ~bufs.size - 1) + bufoffset;

    Out.ar(out,
        VOsc.ar(bufindex, [120, 121], 0, 0.3)
    )
}).play(s,[\out, 0, \bufoffset, ~bufs.first.bufnum]);
)
(
SynthDef("help-VOsc3",{ arg out=0, bufoffset=0, freq=240;
    var x;
    // mouse x controls the wavetable position
    x = MouseX.kr(0,7);
    Out.ar(out,
        VOsc3.ar(bufoffset+x, freq+[0,1],freq+[0.37,1.1],freq+[0.43, -0.29], 0.3)
    )
}).play(s,[\out, 0, \bufoffset, 0]);
)

// fill the buffers with new harmonics on-the-fly
(
~bufs.do({ arg buf, i;
    var a;
    a = Array.fill(i, 0) ++ [0.5, 1, 0.5];
    s.performList(\sendMsg, \b_gen, buf.bufnum, \sine1, 7, a);
});
)

~gen_buff =  {
    Env(
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
).asSignal(512);
};

// new harmonics...
(
~bufs.do({ arg buf, i;
    a = Array.fill(32,0);
    12.do({ arg i; a.put(32.rand, 1).postln });
    s.performList(\sendMsg, \b_gen, buf.bufnum, \sine1, 7, a);
});
)

// new harmonics...
(
~bufs.do({ arg buf, i;
    var a = Array.fill((i+1)**2, { arg j; 1.0.rand2 });
    s.performList(\sendMsg, \b_gen, buf.bufnum, \sine1, 7, a);
});
)

// cleanup
(
x.free;
~bufs.do(_.free);
)