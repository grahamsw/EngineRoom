{WhiteNoise.ar(LFNoise2.kr(1))}.play

{WhiteNoise.ar(LFNoise2.kr(1).squared)}.play

{WhiteNoise.ar * Line.ar(1, 0, 0.02, doneAction: 2)}.play

{WhiteNoise.ar * EnvGen.ar(Env.perc(0, 0.02, curve: 0), Dust.kr(1))}.play

{LPF.ar(WhiteNoise.ar, 30) * 100}.play

{BPF.ar(WhiteNoise.ar, 30, 0.2) * 20}.play


(
~firegen = {
	var trigs, durscale, resfreq;
	var noise, hissing, crackles, lapping;
	// A common noise source
	noise = WhiteNoise.ar;
	// Hissing
	hissing = HPF.ar(noise, 1000) * LFNoise2.kr(1).squared.squared;
	// Crackle
	trigs = Dust.kr(1);
	durscale = TRand.kr(1, 1.5, trigs); // vary duration between default 20ms and 30ms
	resfreq = TExpRand.kr(100, 1000, trigs); // different resonant frequency for each one
	crackles = noise * EnvGen.ar(Env.perc(0, 0.02, curve: 0), trigs, timeScale: durscale);
	crackles = crackles + BPF.ar(crackles, resfreq, 20);
	// Flame
	lapping = LeakDC.ar(LeakDC.ar(BPF.ar(noise, 30, 0.2) * 50).clip2(0.9)) * 0.5;
	// Combine them:
	([crackles, hissing, lapping] * [0.1, 0.3, 0.6]).sum * 3
};
//~firegen.play
)

(
{
	BPF.ar(~firegen,  600, 1/0.2) +
	BPF.ar(~firegen, 1200, 1/0.6) +
	BPF.ar(~firegen, 2600, 1/0.4) +
	HPF.ar(~firegen, 1000)
}.play
)


(
SynthDef(\houseflyWing, { |out=0|
	var sig, downstroke, upstroke, wingFreq, wingRes;

	// this is already a preparation for fig 50.14 and is not described
	// in the pure data patch on fig 50.13
	wingFreq = In.ar(10,2);
	wingRes = In.ar(20,2);

	// Also, it is prepared for some other input from a different source,
	// to not only control the patch with the mouse movement.
	// See also the following URL for more information about the next lines:
	// http://supercollider.sourceforge.net/wiki/index.php/Boolean_logic_in_the_server
	wingFreq = Select.ar(wingFreq > 0, [K2A.ar(MouseX.kr(0, 300)), wingFreq]);
	wingRes = Select.ar(wingRes > 0, [K2A.ar(MouseY.kr(3,5)), wingRes]);

	sig = LFSaw.ar(wingFreq, 1, 0.5, 0.5);
	sig = ((sig * 0.2).min(sig * (-1) + 1)).min(sig.min(sig * (-1) + 1));
	sig = (sig * 6 - 0.5) * 2;

	downstroke = (wingRes) * sig.min(0);
	downstroke = (Wrap.ar(downstroke) * 2pi).cos * sig.min(0) * 0.5 + sig.min(0);
	upstroke = sig.max(0).cubed * 2;

	sig = downstroke + upstroke;
	sig = (sig - OnePole.ar(sig, exp(-2pi * (700 * SampleDur.ir)))).dup * 0.05;
	Out.ar(out, sig);
}).add;

)
x = Synth(\houseflyWing);
(
SynthDef(\buzzingHousefly, {
	var beatingFreq, resonanceMod;

	beatingFreq = OnePole.ar(WhiteNoise.ar, exp(-2pi * (4 * SampleDur.ir)));
	beatingFreq = OnePole.ar(beatingFreq, exp(-2pi * (4 * SampleDur.ir)));
	beatingFreq = beatingFreq * 700 + 220;

	resonanceMod = OnePole.ar(WhiteNoise.ar, exp(-2pi * (5 * SampleDur.ir)));
	resonanceMod = OnePole.ar(resonanceMod, exp(-2pi * (5 * SampleDur.ir)));

	Out.ar(10, [beatingFreq, (resonanceMod * 3) + beatingFreq]);
	Out.ar(20, (resonanceMod * 40 + 5)!2 );
}).add;
//y = Synth(\buzzingHousefly);
)

y = Synth(\buzzingHousefly);

y.free
x.free