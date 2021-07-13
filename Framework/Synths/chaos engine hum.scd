//Chaos engine hum
(
SynthDef(\chaosEngine,
{
    var amp = \amp.kr(0.5);
    var root = \root.kr(50);

        Out.ar(\out.ir(0),

            SinOsc.ar(\base.kr(10) + (root * SinOsc.kr([root, root + \throb.kr(1)], 0, SinOsc.kr(101, Saw.kr(0.12345, 678, 9), 0.2, 0.8), Pulse.kr([\pulse.kr(25), \pulse.kr(25) +0.5], 0.25, 0.125, -0.25))), mul:\amp.kr(0.5)));
}).add;


)

x  = Synth(\chaosEngine)
x.set(\root, 100)
x.set(\throb, 0.2)
x.set(\base, 10)
x.set(\amp, 0.2)

x.set(\pulse,200 )