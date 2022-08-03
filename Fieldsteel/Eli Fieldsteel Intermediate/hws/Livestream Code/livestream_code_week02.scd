s.boot;

//simple sinosc synthdef

(
SynthDef(\fm, {
	var sig, env;
	env = Env([0,1,0], [\atk.ir(0.01),\rel.ir(3)], [1,-1]).ar(2);
	sig = SinOsc.ar(\freq.kr(400));
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.2));
	sig = sig * env;
	Out.ar(\out.ir(0), sig);
}).add;
)

(
p = Routine({
	loop{
		Synth(\fm);
		3.wait;
	}
}).play;
)

p.stop;

////////////////////////////

//adding a modulator with modfreq and modamp controls
//output is added to main (carrier) sinosc

(
SynthDef(\fm, {
	var sig, mod, env;
	env = Env([0,1,0], [\atk.ir(0.01),\rel.ir(3)], [1,-1]).ar(2);
	mod = SinOsc.ar(\modfreq.kr(600), mul:\modamp.kr(300));
	sig = SinOsc.ar(\freq.kr(400) + mod);
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.2));
	sig = sig * env;
	Out.ar(\out.ir(0), sig);
}).add;
)

//"classical" computer music lol

(
p = Routine({
	loop{
		Synth(\fm,
			[
                \freq, exprand(100,200).round(50),
				\modfreq, exprand(1000,2000),
				\modamp, exprand(1000,2000),
				\rel, 0.1,
			]
		);
		exprand(0.01,0.5).wait;
	}
}).play;
)

p.stop;

//for visual reference
s.scope;
FreqScope.new;

////////////////////////////

//for more musical pitch control, modulator frequency should be dependent on carrier frequency, based on a ratio (e.g. modfreq:freq = 2:1):
//simple ratios e.g. 2, 3, 1.5, produce harmonic spectra
//non-integer ratios e.g. 1.6273 produce inharmonic spectra

(
SynthDef(\fm, {
	var sig, mod, env;
	env = Env([0,1,0], [\atk.ir(0.01),\rel.ir(3)], [1,-1]).ar(2);
	mod = SinOsc.ar(\freq.kr(400) * \ratio.kr(2), mul:\modamp.kr(600));
	sig = SinOsc.ar(\freq.kr(400) + mod);
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.2));
	sig = sig * env;
	Out.ar(\out.ir(0), sig);
}).add;
)

(
p = Routine({
	loop{
		//higher ratio = wider spacing of sideband pairs
        Synth(\fm, [\freq, rrand(60, 67).midicps, \ratio, rrand(1,10).postln]);
		2.wait;
	}
}).play;
)

p.stop;


/////////////////////

//by expressing modulator frequency and modulator amplitude as a ratio, it is easier to control the number of sideband pairs using a value called 'index of modulation', equal to modamp/modfreq. index roughly approximates the number of audible sideband pairs:

(
SynthDef(\fm, {
	var sig, mod, env;
	env = Env([0,1,0], [\atk.ir(0.01),\rel.ir(3)], [1,-1]).ar(2);
	mod = SinOsc.ar(
		\freq.kr(400) * \ratio.kr(2),
		mul:\freq.kr(400) * \ratio.kr(2) * \index.kr(1)
	);
	sig = SinOsc.ar(\freq.kr(400) + mod);
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.1));
	sig = sig * env;
	Out.ar(\out.ir(0), sig);
}).add;
)

(
p = Routine({
	loop{
		Synth(\fm, [\freq, 50, \index, rrand(1,10).postln]);
		2.wait;
	}
}).play;
)

p.stop;

//////////////

//using an envelope to control modulation index can result in more expressive and interesting sounds:

(
SynthDef(\fm_index, {
	var sig, mod, env, ienv;
	ienv = Env([1,\ipeak.ir(7),1], [\iatk.ir(0.01),\irel.ir(0.2)], [1,-3]).ar;
	env = Env([0,1,0], [\atk.ir(0.01),\rel.ir(3)], [1,-1]).ar(0.2);
	mod = SinOsc.ar(
		\freq.kr(400) * \ratio.kr(2),
		mul:\freq.kr(400) * \ratio.kr(2) * ienv
	);
	sig = SinOsc.ar(\freq.kr(400) + mod);
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.1));
	sig = sig * env;
	Out.ar(\out.ir(0), sig);
}).add;
)

//compare:
(
//static index
p = Routine({
	loop{
		Synth(\fm, [\freq, rrand(40,50).midicps, \rel, 0.3, \index, 7]);
		0.25.wait;
	}
}).play;
)

p.stop;

(
//dynamic index:
p = Routine({
	loop{
		Synth(\fm_index, [\freq, rrand(40,50).midicps, \rel, 0.3]);
		0.25.wait;
	}
}).play;
)

p.stop;

/////////////////

//modulators in series
//mod modulates sig, but mod2 also modulates the frequency of mod

(
SynthDef(\fm, {
	var sig, mod, mod2, env;
	env = Env([0,1,0],[\atk.ir(0.01),\rel.ir(10)],[1,-1]).ar(2);
	mod2 = SinOsc.ar(
		\freq.kr(400) * \ratio2.kr(0.5/400),
		mul: \freq.kr(400) * \ratio2.kr(0.5/400) * \index2.kr(16)
	);
	mod = SinOsc.ar(
		(\freq.kr(400) * \ratio.kr(8/400)) + mod2,
		mul: \freq.kr(400) * \ratio.kr(8/400) * \index.kr(16);
	);
	sig = SinOsc.ar(\freq.kr(400) + mod);
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.2));
	sig = sig * env;
	Out.ar(\out.ir(0), sig);
}).add;
)

//modulators in the default sound are intentionally slow in order to make the serial modulator effect more audible — notice how the fluctuations in carrier frequency themselves are modulated sinusoidally (the fluctuations move fast-slow-fast-slow)
Synth(\fm, [\freq, 500]);

//some wacky examples:
//alien police siren
Synth(\fm, [\freq, 500, \ratio, 2, \ratio2, 0.01]);

//ratios slightly away from integers often produce interesting results that "move" slightly
Synth(\fm, [\freq, 50, \ratio, 2.002, \index, 200, \ratio2, 3.001, \index2, 10]);

//it's not hard to overdrive numbers into white noise territory
Synth(\fm, [\freq, 50, \ratio, 20, \index, 350, \ratio2, 1.1, \index2, 100]);

//////////////////////////

//modulators in series
//two modulators operate on a carrier frequency simultaneously
//in other words, the modulators are summed and then applied

(
SynthDef(\fm, {
	var sig, mod, mod2, env;
	env = Env([0,1,0],[\atk.ir(0.01),\rel.ir(10)],[1,-1]).ar(2);
	mod2 = SinOsc.ar(
		\freq.kr(400) * \ratio2.kr(1/400),
		mul: \freq.kr(400) * \ratio2.kr(1/400) * \index2.kr(100)
	);
	mod = SinOsc.ar(
		(\freq.kr(400) * \ratio.kr(8/400)),
		mul: \freq.kr(400) * \ratio.kr(8/400) * \index.kr(20);
	);
	sig = SinOsc.ar(\freq.kr(400) + mod + mod2);
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.2));
	sig = sig * env;
	Out.ar(\out.ir(0), sig);
}).add;
)

//modulators in the default sound are intentionally slow in order to make the parallel modulator effect more audible — notice how there are two carrier fluctuations happening simultaneously - one at 1 Hz and another at 8 Hz
Synth(\fm);

//try making some wacky examples on your own!

/////////////////////

//oscillator self-modulation
(
SynthDef(\fmfb, {
	var sig, fb;
	fb = LocalIn.ar(1);
	sig = SinOsc.ar(MouseY.kr(20,20000,1) + (fb * MouseX.kr(1,10000,1)));
	LocalOut.ar(sig);
	sig = Pan2.ar(sig, 0, 0.2);
	Out.ar(0, sig);
}).add;
)

//vertical mouse position controls carrier freq (& mod freq, since they're the same signal)
//horizontal mouse position controls modulator amplit
//reminds me of [screaming, cats, theremin, dial-up modem, no-input mixer].choose
Synth(\fmfb);

s.scope;

//different control block sizes can have a significant effect on the flavor! (change and reboot the server for the change to take effect)
s.options.blockSize_(512);
s.options.blockSize_(8);
s.reboot;