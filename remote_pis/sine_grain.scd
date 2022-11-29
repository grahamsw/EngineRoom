fork{

var winenv;
SynthDef(\sin_grain_test, { |out, impulseFreq = 1000, freq=400, gate = 1, pan, amp = 1, envbuf|
    var env = EnvGen.kr(
        Env([0, 1, 0], [1, 1], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: Done.freeSelf
    );
    Out.ar(out,
        GrainSin.ar(2, Impulse.ar(impulseFreq), 0.001, freq, pan, envbuf) * env);
}).add;

s.sync;


// a custom envelope
winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);
z = Buffer.sendCollection(s, winenv.discretize, 1);
s.sync;

Pmono(  \sin_grain_test,
        \impulseFreq, Pwhite(500, 1500),
        \freq, Pwhite(30, 3000),
        \amp, Pwhite(0.4, 0.4),
        \envbuf, z,
        \pos, Pwhite(-1, 1),
        \dur, Pwhite(0.01, 0.1)

).play;

}

