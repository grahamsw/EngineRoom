(
SynthDef(\gs, {
    |sync=1, dens=20, grainDur=0.1, durRand=1, buf=0,
    rate=1, pos=0, posSpeed=1, posRand=0,
    grainEnv=(-1), pan=0, panHz=0.1, panRand=0,
    atk=1, sus=2, rel=1, c0=1, c1=(-1), amp=1, out=0|

    var sig, env, densCtrl, durCtrl, panCtrl, posCtrl;

    env=EnvGen.ar(Env([0,1,1,0], [atk, sus, rel], [c0, 0, c1]), doneAction:2);

    densCtrl = Select.ar(sync, [Dust.ar(dens), Impulse.ar(dens)]);
    durCtrl = grainDur * LFNoise1.kr(100).exprange(1/durRand, durRand);
    posCtrl = Phasor.ar(0, posSpeed * BufRateScale.ir(buf), 0, BufSamples.ir(buf)-1);
    posCtrl = posCtrl + LFNoise1.kr(100).bipolar(posRand*SampleRate.ir);
    posCtrl = posCtrl / BufSamples.ir(buf);
    posCtrl = posCtrl + pos;

    panCtrl = pan + LFNoise1.kr(panHz).bipolar(panRand);

    sig = GrainBuf.ar(
        2,
        densCtrl,
        durCtrl,
        buf,
        rate,
        posCtrl,
        2,
        panCtrl,
        grainEnv
    );
    sig = sig * env * amp;
    Out.ar(out, sig);
}).add;
)
(
Synth(
    \gs,[
        \buf, b,
        \sync, 0,
        \dens,400,
        \dur, 0.2,
        \posSpeed, 1.15,
        \pos, 0.2,
        \amp, 0.3,
        \sus, 5,
        \rate, 4.midiratio

])
)

o = ServerOptions.new
o.memSize = 4096 * 8


(

~r0 = Routine({
    loop{
        (1..8).choose.do({
            var rate=[0, 2, 3, 7, 9, 10].choose + 70;
            rate = rate.midicps * [2,1,0.5, 0.25].choose;
            4.do({
                Synth(
                    \gs,[
                        \buf, b,
                        \sync, 1,
                        \dens, rate * rrand(-0.15, 0.15).midiratio,
                        \dur, 0.02,
                        \posSpeed, 0,
                        \pos, [0.3, 0.4, 0.5, 0.6].choose,
                        \amp, exprand(0.05, 0.15),
                        \sus, 0,
                        \atk, exprand(1,4),
                        \rel, exprand(3,6),
                        \pan, rrand(-0.8, 0.8)
                ]);
            });
            exprand(1, 8).wait;
        });
    };
}).play
)