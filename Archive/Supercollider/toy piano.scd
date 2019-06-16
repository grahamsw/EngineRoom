(
SynthDef(\ping, { |out, freq=440, amp=0.1, impdecay=0.01, attack=0.0001,sustain=0.1, famt=3, ffreq=1000, hdur=0.1|
   var snd, trig, decay;
   trig = Impulse.ar(0);
   decay = Decay2.ar(trig, attack, impdecay) * 1;
	snd = Mix(Ringz.ar(decay, freq*[1,2], sustain));
	snd = snd + Mix(SinOsc.ar(freq*[Rand(1,1.1),Rand(1.4, 1.6), Rand(1.9,2.1), Rand(3.9, 4.1)], mul:Decay2.ar(trig, 0.01,hdur)));
   	snd = BLowPass.ar(snd, ffreq * decay.linexp(0,1,1,famt), 0.1);
   	snd = snd * EnvGen.ar(Env.linen(0, sustain/Rand(1.0,4.0), 0.1), doneAction:2);
	OffsetOut.ar(out, (snd * amp)!2);
}).add;
)
(
Ndef(\ping, Pbind(
	\instrument, \ping,
	\scale, Scale.mixolydian,
	\n, Pwhite(1,4,inf),
	\octave, Pclump(Pkey(\n), Prand([6,7], inf)),
//	\degree, Pclump(Pkey(\n), Pwrand([0,2,3,4,5,6], [10,7,3,5,2,1].normalizeSum, inf)),
	\degree, Pclump(Pkey(\n), Place([[0,1,2,3,4], [2,3,4,5,6], [4,3,4,3,6,7], [0,2,1,2,1,4,3,3,5]], inf)),
	\attack, Pclump(Pkey(\n), Pwhite(0.0005, 0.001)),
	\sustain, Pfunc{ |e| e.octave / 4 } + Pwhite(0.01, 0.5, inf),
	\strum, Prand([0, 1/3, 1/4, 1/16, 1/32, 1, 2], inf),
	\detune, Pclump(Pkey(\n), Pwhite(-2.0, 2.0, inf)),
	\ffreq, Pclump(Pkey(\n), Pwhite(200.0, 2000.0, inf)),
	\famt, Pclump(Pkey(\n), Pwhite(3,6, inf)),
	\hdur, Pclump(Pkey(\n), Pwhite(0.05, 0.3, inf)),
	\impdecay, Pclump(Pkey(\n), Pwhite(0.001, 0.01, inf)),
	\amp, Pclump(Pkey(\n), Pwhite(0.01, 0.1, inf)) * 0.3,
	\dur, Prand([1,2,4]/2, inf) + Pwhite(-0.1, 0.1, inf)
)).play;
)


Ndef(\ping)[10] = \filter -> { |in|
	var amp = LFNoise2.kr(0.1).range(0.001, 0.1);
	in * SinOsc.ar(LFNoise2.kr(0.1).range(60.midicps,61.midicps) / 4, 0, amp, 1-amp)
};

Ndef(\ping)[15] = \filter -> { |in| Compander.ar(in, in, 0.1, 1, 0.3) };