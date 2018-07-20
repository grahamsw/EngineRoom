
(
SynthDef(\sineTing2, { arg out = 0, freq = 440, amp = 0.2,
attack = 0.01, decay = 0.1, pan = 0.0;
var ampComp, env;
 // axis is middle C, every 3 octaves down by 6db.
ampComp = (261/freq) ** 0.35;
env = Env.perc(attack,decay, amp * ampComp);
Out.ar(out,
Pan2.ar( SinOsc.ar(freq), pan)
* EnvGen.ar(env, doneAction: 2)
);
}).load(s);
)

Synth(\sineTing2)