{SinOsc.ar(500 + SinOsc.ar(2500, mul:400)) * 0.2!2}.play

(
SynthDef(\fm, {
    arg carHz = 500, modHz = 100, modAmp=200,atk=0.01, rel= 1, amp = 0.2, pan=0;
    var car, mod, env;
    env = EnvGen.kr(Env.perc(atk, rel), doneAction:2);
    mod = SinOsc.ar(modHz, mul:modAmp);
    car = SinOsc.ar(carHz + mod) * env * amp!2;
    car = Pan2.ar(car, pan);
    Out.ar(0,car);
}).add
)

(

SynthDef(\fm2, {
    arg freq = 500, mRatio = 1, cRatio=1, index=1, iScale=5, amp = 0.2, atk=0.01, rel=3, cAtk=4, cRel=(-4), pan=0;
    var car, mod, env, iEnv;
    iEnv = EnvGen.kr(Env(
        [index, index * iScale, index],
        [atk, rel],
        [cAtk, cRel]
    ));

    env = EnvGen.kr(Env.perc(atk, rel, curve:[atk, rel]), doneAction:2);
    mod = SinOsc.ar(freq * mRatio, mul:freq * mRatio * iEnv);
    car = SinOsc.ar(freq * cRatio + mod) * env * amp;
    car = Pan2.ar(car, pan);
    Out.ar(0, car);
}).add;
)

{SinOsc.ar(500 + SinOsc.ar(4, mul:4*60))*0.2!2}.play
{PMOsc.ar(500, 4, 60*0.2!2}.play

Synth(\fm2, [\freq, 47.midicps, \rel, 2, \index, 20, \iScale, 0.01, \mRatio, 0.5])
PMOsc

(
x = Pbind(
    \instrument, \fm2,
    \dur, 1/2,
    \freq, Pexprand(80, 1000).round(50),
    \cRatio, Pwhite(0.1, 5).round(1),
    \mRatio, Pwhite(1, 5).round(0.1),
    \pan, Pexprand(-1.0, 1)
).play

)

(
x = Pbind(
    \instrument, \fm,
    \dur, 1/8,
    \carHz, Pexprand(20, 1000),
    \modHz, Pexprand(20, 1000),
    \modAmp, Pwhite(20, 500),
    \atk, Pexprand(0.001, 0.5),
    \rel, Pexprand(0.1, 3),
    \amp, Pexprand(0.1, 0.4),
    \pan, Pexprand(-1.0, 1)
).play

)