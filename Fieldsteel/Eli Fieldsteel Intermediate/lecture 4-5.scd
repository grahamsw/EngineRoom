[60,64,65,69].do {_play}

(

r({
    [60, 72, 66, 63].do({
        |i|
        (\midinote: i).play;
        0.25.wait
    })


}).play

)

Window.blackout




(

~env = Env(
    [0]++Array.rand(10, -1.0, 1,0).normalize(-1,1)++[0],
    Array.exprand(11, 0.01, 1),
    Array.rand(11, -4.0, 4.0)
);
~env.plot;
~wt = ~env.discretize(4096).asWavetable;

r{Buffer.freeAll;
    s.sync;
    ~buf = Buffer.sendCollection(s, ~wt);

}.play;
)


~buf.plot;


(
s.scope;
{
    var sig;
    sig = Osc.ar(~buf, [100,101]*2 ) * 0.05!2;
    sig = LPF.ar(sig, 500);
}.play
)

s.defaultGroup.set(\gate,0, \fadeTime, 1)





RecordBuf/PlayBuf - runs through it consecutively
vs
BufRd /BufWr - ptr controlled - often by Phasor (or Line, or LFSaw)
(
SynthDef.new(\read,
    {
        var sig, ptr;
        ptr = Phasor.ar(\trig.tr(0), 1, 0, BufFrames.ir(\bur.ir(0)), 0);
        sig = BufRd.ar(1!2, \buf.ir(0), ptr);
        Out.ar(\out.ir(0), sig);
}).add;

SynthDef(\write, {
    var sig, ptr;
    sig = SoundIn.ar(0);
    ptr = Phasor.ar(\trig.tr(0),1, 0, BufFrames.ir(\buf.ir(0)),0);
    BufWr.ar(sig, \buf.ir(0), ptr);
}).add;


)
(
Buffer.freeAll;
b= Buffer.alloc(s, s.sampleRate * 3);

Synth(\read, [\])



x = {Sweep.kr.poll}.play

x.set(\trig, -1)


Pn()


(
SynthDef(\sweep, {
    Out.kr(\out.ir(0), Sweep.kr(\trig.kr(1), \rate.kr(1)).poll);
}).add;
)


y = Synth(\sweep)

y.set(\rate,-1)