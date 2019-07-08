
//Making a custom hard sync oscillator using an EnvGen and a trigger source
{EnvGen.ar(Env([0,0,1,-1,0],MouseY.kr(0,1)*[0,128,256,128]/SampleRate.ir),Impulse.ar(MouseX.kr(10,300,'exponential')))}.play

(
{
loop({
    {
        var mod = SinOsc.kr(Rand(0.1, 0.9), 0, Rand(5, 20));
        Pan2.ar(DynKlang.ar(`[ Array.rand(12, 200.0, 2000.0), 1, mod ]), 1.0.rand)
            * EnvGen.kr(Env.sine(4), 1, 0.02, doneAction: 2);
    }.play;
    2.wait;
})
}.fork;
)



(
// change the buffer while its playing
s = Server.local;
b = Buffer.alloc(s, 4096, 1);
 b.sine1(1.0/(1..6), true, true, true);

SynthDef("help-Osc",{ arg out=0,bufnum=0;
    Out.ar(out,
		Osc.ar(bufnum, [MouseY.kr(78, 82),MouseX.kr(78, 82)], 0, 0.2)
    )
}).play(s,[\out, 0, \bufnum, b.bufnum]);

)
