t's create a synthdef using Karplus-Strong

SynthDef(\ks_guitar, { arg note, pan, rand, delayTime, noiseType=1;

	var x, y, env;

	env = Env.new(#[1, 1, 0],#[2, 0.001]);

	// A simple exciter x, with some randomness.

	x = Decay.ar(Impulse.ar(0, 0, rand), 0.1+rand, WhiteNoise.ar);

 	x = CombL.ar(x, 0.05, note.reciprocal, delayTime, EnvGen.ar(env, doneAction:2));

	x = Pan2.ar(x, pan);

	Out.ar(0, LeakDC.ar(x));

}).add;



// and play the synthdef
(

{

	20.do({

		Synth(\ks_guitar, [\note, 10+(400.rand),

					\pan, 1.0.rand2,

					\rand, 0.1+0.1.rand,

					\delayTime, 2+1.0.rand]);



	  (1.0.rand + 0.5).wait;

	});

}.fork

)

(
SynthDef(\viol,
    {
        var sig, env, n = 8;
        sig = Mix.fill(n, {
            |i|
            LFSaw.ar(VarLag.kr(\freq.kr(440), \lag.kr(0.1),-1, \exp) * Rand(1.001, 1.01) * (1+i),  mul:\amp.kr(0.1));
        });
        env = Env.adsr(\atk.kr(0.01), \decay.kr(0.3), \sus.kr(0.5), \release.kr(0.5)).kr(gate: \gate.kr(1));
        sig = sig * env / n;
        Out.ar(\out.kr(0), Pan2.ar(sig, \pos.kr(0)));
}).add;


)

x = Synth(\viol)
r = Routine({
    loop({

        x.set(\freq, rrand(30, 70).midicps);
        0.5.wait;
    })

   y =  y.stop


})
