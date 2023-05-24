

(
SynthDef(\grainbuf,  {
    var sig, env;
    env = Env([0, 1, 1, 0], [\atk.ir(1), \sus.ir(4), \rel.ir(1)], [1, 0, -1]).kr(2);
    sig = GrainBuf.ar(
        numChannels: 2,
        trigger: Dust.kr(40),
        dur: 0.05,
        sndbuf: \buf.kr(0),
        rate: BufRateScale.kr(\buf.kr(0)) * \rate.kr(1),
        pos: Line.kr(0, 1, BufDur.kr(\buf.kr(0))),
        interp: 2,
        pan: 0,
        envbufnum: -1
        );
    sig = sig * env * \amp.kr(0.5);
    Out.ar(\out.ir(0), sig);
}).add;

)

().play