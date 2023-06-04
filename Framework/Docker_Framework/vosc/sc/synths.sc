
// SynthDefs for the Synths used in the piece
~defineSynths = {

    SynthDef(\VoscPlayer, {
       |
        out=0,
        bufLow=0, bufHigh=0, bufSteps=10,
        detuneLow=0.01, detuneHigh=0.1, detuneSteps=10,
        freq=400,
        amp=0.5,
        panLow=(-1), panHigh=1, panSteps=10, spread=0,
        releaseTime=10,
        gate=1
        |

        var trigger = Impulse.kr(10);
        var bufindex, d_bufindex;
        var detune, d_detune;
        var pan, d_pan;
        var env, freqArray, rats;
        var sig;

        env = EnvGen.kr(Env.asr(releaseTime:releaseTime), gate, doneAction:2);
        d_bufindex = Dbrown(bufLow, bufHigh, (bufHigh-bufLow)/bufSteps);
        bufindex = Demand.kr(trigger, 0, d_bufindex);

        d_detune = Dbrown(detuneLow, detuneHigh, (detuneHigh - detuneLow)/detuneSteps);
        detune = Demand.kr(trigger, 0, d_detune);

        d_pan = Dbrown(panLow, panHigh, (panHigh-panLow)/panSteps );
        pan = Demand.kr(trigger, 0, d_pan);

        rats = {Rand(0.08, 0.15)}!8;
        freqArray = freq  * (LFNoise1.kr(rats).bipolar(detune).midiratio);
        sig = VOsc.ar(bufindex, freqArray, Rand(0, 2pi), amp);
        sig = Splay.ar(sig, spread, center:pan);
        sig = LeakDC.ar(sig);


        Out.ar(out, sig * env);
    }).add;


    SynthDef(\reverb, {
        | out = 0, mix = 0.1|
        var dry = In.ar(out);
        var wet =FreeVerb.ar(dry,0.45,2.0,0.5);
        wet = DelayN.ar(wet, 0.03, 0.03);
        wet = SplayAz.ar(2, wet);
        wet = LPF.ar(wet, 1500);
        XOut.ar(out, mix, wet);
    }).add;

};

~makeBufs = {
    | which=0, randSeed = 0 |
    var numbuffs = 8;
    var buffs = Buffer.allocConsecutive(numbuffs, s, 1024, 1);
    if (randSeed > 0, {thisThread.randSeed = randSeed});

    buffs.do({ arg buf, i;
        var n =(numbuffs), a;
        a = switch(which,
            0, {Array.fill(i+1, { arg j; ((n-j)/n).squared.round(0.001) })},
            1, {Array.fill(i, 0) ++ [0.5, 1, 0.5];},
            2, {a = Array.fill(32,0);
                12.do({a.put(32.rand, 1) });
                a},
            {Array.fill((i+1)**2, {1.0.rand2 })}
        );
    //    a.postln;
        buf.sine1(a);
    });
    buffs;
};

~loadBuffs = {
    ~buffsets = ~numBuffsets.collect{|i| ~makeBufs.(i)};
};

