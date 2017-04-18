(

SynthDef(\sine, {
    | freq = 440, atk = 0.005, rel = 0.3, amp = 1, pan = 0 |
    var sig, env;
    sig = SinOsc.ar(freq);
    env = EnvGen.kr(Env([0, 1, 0], [atk, rel], [1, -1], doneAction: 2);
    sig = Pan2.ar(sig, pan, amp);
    sig = sig * env;
    Out.ar(0, sig);
}). add;
)

(
p = Pbind(
    \insturment, \sine,
    \dur, Pwhite(0.05, 0.5, inf),
    \freq, Pexprand(50, 4000), inf).trace,
    \atk, Pwhite(2.0, 3.0, inf),
    \rel, Pwhite(5.0, 10.0, inf),
    \amp, Pexprand(0.01, 0.2, inf),
    \pan, Pwhite(-0.8, 0.8, inf),
    ).play;
)

p.stop;
