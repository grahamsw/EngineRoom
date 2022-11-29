(
s.waitForBoot({

	// cello like sound
	SynthDef(\cello, {
		|
		freq=440, amp=1.0, out=0, pan=0.0, rq=0.1,
		atk=0.01, dcy=0.1, sus=0.5, rls=0.4,
		gate=1, dur=2,
		aux=0, auxsend=0.1
		|
		var sig, env,width;
		env = EnvGen.ar(Env.adsr(atk, dcy, sus, rls), gate, doneAction:2);
		width = LFNoise2.kr(1).range(0.001, 0.01);
		sig = VarSaw.ar(freq+ SinOsc.ar(6,mul:Line.kr(0.0, 1, dur,doneAction:2)), width:width);
		sig = RLPF.ar(sig, freq*1, rq);
		sig = Decimator.ar(sig, 22050,2);
		sig = sig *env* amp;
		Out.ar(out, Pan2.ar(sig, pan));
		Out.ar(aux, sig*auxsend);
	}).add;

	// I also like to add some verb to make the sound more natural
	// like it is inside a real hall.
	// This reverb by Eli Fieldsteel (see his wavetable youtube tutorial)
	SynthDef(\reverb, {
		arg in=0, out=0, dec=4, lpf=1500;
		var sig;
		sig = In.ar(in, 2).sum;
		sig = DelayN.ar(sig, 0.03, 0.03);
		sig = CombN.ar(sig, 0.1, {Rand(0.01,0.099)}!32, dec);
		sig = SplayAz.ar(2, sig);
		sig = LPF.ar(sig, lpf);
		5.do{sig = AllpassN.ar(sig, 0.1, {Rand(0.01,0.099)}!2, 3)};
		sig = LPF.ar(sig, lpf);
		sig = LeakDC.ar(sig);
		Out.ar(out, sig);
	}).add;

	s.sync;

	~verbBus = Bus.audio(s,2);
	~verb = Synth(\reverb, [\in, ~verbBus]);
});
)

// let's define a simple melody lick
(
Pbindef(\cello_lick,
	\instrument, \cello,
	\scale, Scale.minor,
	\octave, Prand([3,4], inf),
	\degree, Prand([0,2,4,5,6,7], inf),
	\pan, 0.0,
	\dur, Pstutter(Prand([1,2,3,4], inf), Prand([0.25, 0.5, 1], inf)),
	\amp, 0.9,
	\atk, Pkey(\dur)*0.5,
	\dcy, Pkey(\dur)*0.05,
	\sus, Pwhite(0.4, 0.7, inf),
	\rls, Pkey(\dur)*0.4,
	\rq, Pwhite(1, 0.3,inf),
	\aux, ~verbBus,
	\auxsend, 0.1,
);
)
(
Pbindef(\cello_lick,
\instrument, \cello,
\scale, Scale.phrygian,
\octave, Prand([2,3], inf),
\degree, Prand([0,2,4,5,6,7], inf),
\pan, 0.0,
\dur, Pstutter(Prand([1,2,3,4], inf), Prand([0.25, 0.5, 1], inf)),
\amp, 0.9,
\atk, Pkey(\dur)*0.9,
\dcy, Pkey(\dur)*0.05,
\sus, Pwhite(0.7, 0.9, inf),
\rls, Pkey(\dur)*0.4,
\rq, Pwhite(1, 0.3,inf),
\aux, ~verbBus,
\auxsend, 0.1,
);

)

// let's play it
Pbindef(\cello_lick).play;
Pbindef(\cello_lick).stop;