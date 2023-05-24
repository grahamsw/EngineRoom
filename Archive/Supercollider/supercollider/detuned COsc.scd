

(
~coscbuff = Buffer.alloc(s, 2048, 1);
~coscbuff.sine1(1.0/(1..6), true, true, true);



SynthDef(\cosc,
    {
        |freq = 400, amp = 0.1, gate = 1, buf=0, beats=1, pos = 0, out = 0|

        var sig, env;
        env =  EnvGen.kr(Env.adsr, gate);
        sig = COsc.ar(buf, freq, beats, amp);
        Out.ar(out, Pan2.ar(env * sig, pos));
}).add;

)

x = Synth(\cosc, [\buf, ~cosbuff])

x.set(\freq, 200)
x.set(\beats, 2)(
    x.set(\amp, 0.1)

x.set(\gate, 0)