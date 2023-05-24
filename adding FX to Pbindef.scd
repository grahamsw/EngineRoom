
(
SynthDef(\nofx2, {
	|in, out = 0|
	Out.ar(out, In.ar(in, 2));
}).add;


SynthDef.new(\reverb, {
	arg in=0, drylevel=0.7, wetlevel=0.3, out=0;
	var sig, reverb;
	sig = In.ar(in, 2);
	reverb = In.ar(in, 2);
	reverb = LPF.ar(GVerb.ar(sig, 250, 4), 900);
	sig = (sig * drylevel) + (reverb * wetlevel);
	Out.ar(out, sig);
}).add;


SynthDef.new(\flanger, {
	arg in=0, out=0;
	var sig, flanger;
	sig = In.ar(in, 2);
	flanger = In.ar(in, 2);

	//Note for the curious: a flanger effect is created by summing a signal with a delayed copy of itself, in which the delay time is varying (typically sinusoidally). This creates predictable patterns of constructive and destructive interference, resulting in a sweeping resonance effect that follows the pattern of the sine wave (in this case, the pitch of the resonance varies between 100 and 1000 Hz)
	flanger = CombL.ar(sig, 0.01, SinOsc.ar(0.1, pi/2).exprange(0.001,0.01), 0.03);
	sig = (sig + flanger) * 0.5;

	Out.ar(out, sig);
}).add;


)


(
~audioGroup = Group.new;
~fxGroup = Group.new(~audioGroup, \addAfter);

~audioBus = Bus.audio(s, 2);
~nofx = Synth(\nofx2, [\in, ~audioBus], ~fxGroup);
)

Synth(\basic,[\out, ~audioBus], target:~audioGroup);
~reverbFx = Synth(\reverb, [\in, ~audioBus], target:~flangerFx, addAction:\addReplace);
~nofx = Synth(\nofx2, [\in, ~audioBus], target:~flangerFx, addAction:\addReplace);

~reverbFx.set(\drylevel, 0.50, \wetlevel, 0.5)
~flangerFx = Synth(\flanger, [\in, ~audioBus], target:~reverbFx, addAction:\addReplace);

(
Pbindef(
	\p,
	\instrument, \basic,
	\note, Pseq([0,1,2,7],inf),
	\out, ~audioBus,
	\group, ~audioGroup
);
)

Pbindef(\p).play(quant:4)
Pbindef(\p, \dur, Pseq([1], inf)).quant_(4)
Pbindef(\p, \amp, 0.21).quant_(4)
Pbindef(\p, \dur, 0.125).quant_(4)
Pbindef(\p, \rel, 0.125).quant_(4)
Pbindef(\p, \amp, Pseq([0.3, 0.1, 0.1], inf)).quant_(4)

Pbindef(\p).stop


(
Pbindef(
	\q,
	\instrument, \default,
	\degree, Pseq([8,5,3,1],inf),
	\out, ~audioBus,
	\group, ~audioGroup
);
)

Pbindef(\q).play(quant:4)
Pbindef(\q, \amp, 0.03).quant_(4)
