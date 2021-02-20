
s.boot

// FM synth see also tutorials 21 & 22

(
SynthDef(\fm,
    {
        var sig, mod, env;
        mod = SinOsc.ar(\modfreq.kr(600), mul: \modamp.kr(300));
        env = Env([0,1,0], [\atk.ir(0.01), \rel.ir(3)], [-1,1]).ar(2);
        sig = SinOsc.ar(\freq.kr(440) + mod);
        sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.2));
        sig = sig * env;
        Out.ar(\out.ir(0), sig);
    }
).add;
)


(

p = Routine({
    loop {
        Synth(\fm,[
            \freq, exprand(20,20000),
            \modfreq, exprand(20,20000),
            \modamp, exprand(1, 20000),
            \rel, 0.1
    ]);
        exprand(0.01, 0.5).wait;
    }
}).play;
)

p.stop




(
    SynthDef(\fm, {
        var sig, mod, env;
    mod = SinOsc.ar(
        \freq.kr(300) * \ratio.kr(3),
        mul: \freq.kr * \ratio.kr * \index.kr(1)
    );
    env = Env([0,1,0],[0.05, 2], [-1,1]).ar(2);
        sig = SinOsc.ar(\freq.kr + mod);
        sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.2));
        sig = sig * env;
        Out.ar(\out.ir(0), sig);
    }
).add;
)
(
p = Routine({
    loop {
        Synth(\fm);
        1.wait;
    }
}).play;
)

p.stop

