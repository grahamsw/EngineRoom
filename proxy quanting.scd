(
~synth1 = {
    |freq = 440, amp = 0.1, gate = 1, pan = 0, out = 0|
    var env, snd;
    env = EnvGen.kr(Env.adsr, gate, doneAction:2);
    snd = SinOsc.ar(freq, phase:2pi.rand, mul:amp);
    Out.ar(out, Pan2.ar(snd * env, pan ));
};
)

(
~synth2 = {
    |freq = 440, amp = 0.1, gate = 1, pan = 0, out = 0|
    var env, snd;
    env = EnvGen.kr(Env.adsr, gate, doneAction:2);
    snd = Saw.ar(freq, phase:2pi.rand, mul:amp);
    Out.ar(out, Pan2.ar(snd * env, pan ));
};
)
Ndef(\b, ~synth1)
(
Ndef(\b).quant = 16;
Ndef(\b).set(\freq, 600);
Ndef(\b).set(\amp, 0.05)


Ndef(\b).fadeTime = 1;
)
(
Ndef(\c, {
    LFNoise0.kr(2).range(100, 600)
}
)
)
(
Ndef(\pan, {
    -1; //LFNoise0.kr(0.1).range(-1.0, 1.0)
})
)

(
Ndef(\b, {
    |freq = 440, amp = 0.1, gate = 1, pan = 0|
    var env, snd;
    env = EnvGen.kr(Env.adsr, gate, doneAction:2);
    snd = Pulse.ar(Ndef(\c), mul:amp);
    Pan2.ar(snd * env, Ndef(\pan) );
});
)

Ndef(\b).clear(5)

Ndef(\b).set(\gate, 1)
Ndef(\b).play
Ndef(\b).bus

ProxySynthDef

().play
s.sta
(
Pbind(
    \amp, 0,
    \dur, 1

)
)