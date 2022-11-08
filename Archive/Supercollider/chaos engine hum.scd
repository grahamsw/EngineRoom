//Chaos engine hum
(
z = {
    SinOsc.ar(
        \a.kr(10) +
           (\b.kr(50) *
            SinOsc.kr(
                       [\c.kr(50), \d.kr(51)],
                        mul:SinOsc.kr(
                                 \e.kr(101),
                                 Saw.kr(\f.kr(0.12345), \g.kr(678), 9),            0.2, 0.8),
            Pulse.kr([25, 25.5], 0.25, 0.125, -0.25))),
        mul:\amp.kr(0.5));
}.play();

)
(

z.set(\a, 10);
z.set(\b, 60);
z.set(\e, 1000);
z.set(\f, 0.5);
z.set(\g, 20000);
)
(
{
\a.kr(10) +
           (\b.kr(50) *
        SinOsc.kr([\c.kr(50), \d.kr(51)], mul:SinOsc.kr(                          \e.kr(101), phase:Saw.kr(\f.kr(0.12345), \g.kr(678), 9), mul:0.2, add:0.8))
    )
}.plot(1)
)

{(8!2)}.play