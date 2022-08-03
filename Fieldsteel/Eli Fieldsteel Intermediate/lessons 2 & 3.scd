s.boot;
(
Window.closeAll;
~sig = Signal.sineFill(4096, [1, 0.5, 0.2, 0.2, 0.15, 0.1],[0, pi,0,pi,0,0]);
~sig.plot;

~wt =  ~sig.asWavetable;
r{

    Buffer.freeAll;
    s.sync;
    ~buf = Buffer.alloc(s,2*4096);
    s.sync;
    ~buf.sendCollection(~wt);
    s.sync;
    ~buf.plot;

}.play(AppClock);

)

(
SynthDef(\oscfm,
    {
        var sig, mod, env;
        mod = Osc.ar(\buf.ir(0), \modfreq.kr(1000), mul:\moddamp.kr(1000));
        sig = 5.collect({
            var spread = LFNoise1.kr(0.05).bipolar(\dev.ir(0.1)).midiratio;
            Osc.ar(\buf.ir(0), \freq.kr(200) * spread + mod)
        }).sum;
        env = Env(
            [0,1,0],
            [\atk.ir(0.02), \rel.ir(0.5)],
            [\atkcrv.ir(1), \relcrv.ir(-1)]
        ).kr(2);
        sig = Pan2.ar(sig, \pan.ir(0), \amp.kr(0.2));
        sig = sig * env;
        Out.ar(\out.ir(0), sig);
}).add;
)

Synth(\oscfm, [\buf, ~buf])


(
p = Pbind(
    \instrument, \oscfm,
    \bf, ~buf,
    \dur, Pexprand(0.1, 1.5),
    \freq, Pwrand([50,100,200],[0.8, 0.1, 0.1], inf) * Pwrand([0,7,12,17,28],[0.6,0.1, 0.1,0.1,0.1], inf).midiratio,
    \dev, Pexprand(0.05, 0.2),
    \modfreq, Prand([50, 100, 200, 400, 600, 800], inf),
    \modamp, Pexprand(40, 1000),
    \atk, Pexprand(0.1, 2.5),
    \rel, Pexprand(3, 5),
    \amp, Pexprand(0.05, 0.15),
    \pan, Pwhite(-0.3, 0.3),
);
)

p.play

s.defaultGroup.set(\gate, 0, \fadeTime, 4)
~buf = Buffer.alloc(s, 2**13);

~buf.sine3(
    1/(1..32),asWavetable:false).plot

~buf.plot

{SoundIn.ar(0!2)}.play



b = Buffer.alloc(s, s.sampleRate * 1)

b.plot


(
x = {
    var sig;
    sig = SoundIn.ar(0);
    RecordBuf.ar(sig, b, \offset.kr(0), \reclev.kr(1).varlag(0.3), \prelev.kr(-3.dbamp).varlag(0.3), \run.kr(1), \loop.kr(1));
    PlayBuf.ar(1!2, b, loop:1);
}.play
)
x.play


~shortbuf = Buffer.alloc(s, s.sampleRate * 0.2)
(
x = {
    var sig;
    sig = SoundIn.ar(0);
    RecordBuf.ar(sig, \buf.ir(0),
        \offset.kr(0),
        \reclev.kr(1).varlag(0.3),
        \prelev.kr(-3.dbamp).varlag(0.3),
        \run.kr(1),
        \loop.kr(1)
    );
    PlayBuf.ar(1!2, \buf.ir(0), loop:1);
}.play(args:[\buf, ~shortbuf])
)


x.set(\reclev, 0, \prelev, 1);

x.set(\reclev, 0.7, \prelev, 0.3)
b.play()

b.zero


Buffer.freeAll;
b = Buffer.alloc(s, s.sampleRate * 3);

(
SynthDef(\read, {
    var sig, ptr;
    ptr = Phasor.ar(\trig.tr(0), 1, 0, BufFrames.ir(\buf.ir(0)), 0);
    sig = BufRd.ar(1!2,\buf.ir(0), ptr);
    Out.ar(\out.ir(0), sig);
}).add;

SynthDef(\write, {
    var sig, ptr;
    sig = SoundIn.ar(0);
    ptr = Phasor.ar(\trig.tr(0), 1, 0, BufFrames.ir(\buf.ir(0)), 0);
    BufWr.ar(sig, \buf.ir(0), ptr);
}).add;
)

b.plot
(
b.zero;
Synth(\write, [\buf, b]);
Synth(\read, [\buf, b]);
)