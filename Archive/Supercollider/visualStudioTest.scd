s.waitForBoot{
    SynthDef(\sss, {
        |freq = 400, amp = 0.5|
        Out.ar(0, SinOsc.ar(freq, mul: amp));
    }).add;
s.sync;
Synth(\sss);
};

