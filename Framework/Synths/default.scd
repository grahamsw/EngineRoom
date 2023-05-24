(
SynthDef(\default,
         {
        arg out=0, freq=440, amp=0.1, pan=0, gate=1;
 var z;
 z = LPF.ar(
				Mix.new(VarSaw.ar(freq + [0, Rand(-0.4,0.0), Rand(0.0,0.4)], 0, 0.3, 0.3)),
				XLine.kr(Rand(4000,5000), Rand(2500,3200), 1)
			) * Linen.kr(gate, 0.01, 0.7, 0.3, 2);
OffsetOut.ar(out, Pan2.ar(z, pan, amp));
}).add
 )
 

Synth(\harpsichord1)

SynthDef("harpsichord1", { arg out = 0, freq = 440, amp = 0.1, pan = 0;
    var env, snd;
	env = Env.perc(level: amp).kr(doneAction: 2);
	snd = Pulse.ar(freq, 0.25, 0.75);
	snd = snd * env;
	Out.ar(out, Pan2.ar(snd, pan));
}).add;
