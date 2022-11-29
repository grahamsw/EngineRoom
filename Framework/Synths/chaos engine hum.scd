//Chaos engine hum
(
SynthDef(\chaosEngine,{
    |amp = 0.5, root = 50, base=10, pulse=25, throb = 1, out = 0|
    var xaos = SinOsc.kr([root, root + throb], 0, SinOsc.kr(101, Saw.kr(0.12345, 678, 9), 0.2, 0.8), Pulse.kr([pulse, pulse +0.5], 0.25, 0.125, -0.25));
    var snd = SinOsc.ar(base + (root * xaos), mul:amp);
    Out.ar(out, snd);
}).add;
)

x  = Synth(\chaosEngine)
x.set(\root, 100)
x.set(\throb, 2)
x.set(\base, 200)
x.set(\amp, 0.2)

x.set(\pulse,20 )

(
{
    var base = 200;
    var root = 50;
    var throb = 1;
    var pulse=25;
    base + (root *
    SinOsc.kr(
        freq:[root, root + throb],
        phase:0,
        mul:SinOsc.kr(101, Saw.kr(0.12345, 678, 9), 0.2, 0.8),
        add:Pulse.kr([pulse, pulse +0.5], 0.25, 0.125, -0.25)
       )
)}.plot(1)
)