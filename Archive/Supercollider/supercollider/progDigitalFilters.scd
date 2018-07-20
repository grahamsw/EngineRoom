
/* Low Pass Filtering */

(
var in, out, order = 4, cutoff = 1000, dur =2;
in = {WhiteNoise.ar(EnvGen.ar(Env.linen(0.01, dur-0.02, 0.01), doneAction:2))};
out = Array.fill(order+1, {|i| if(i > 0, {{LPF.ar(out[i-1], cutoff)}}, {in})});
Routine{(order+1).do{|i| {out[i]}.play;
	dur.wait}}.play;
)

{Saw.ar()}.play

/* jurassic park sound effects */
(
SynthDef(\pulsetrain, {
	|dur = 2, fundstart = 16, fundend=16, harmnum=50|
	var amp, gliss, input, output;
	amp = EnvGen.ar(Env([0.001, 0.707, 0.25, 0.001], [0.2, 0.5, 0.3]*dur, \exp), doneAction:2);
	gliss = EnvGen.ar(Env([fundstart, fundstart, fundend, fundend], [0.2, 0.6, 0.2] * dur, \exp));
	input = Blip.ar(gliss, harmnum, amp);
	output = LPF.ar(input, 1500);
	Out.ar(0, input);
}).add;
)

(
var fundstart, fundend, harmnum;
fundstart = [16.0, 8.5, 53.0];
fundend = [14.5, 9.0, 49.0];
harmnum = [50, 10, 40];
Pbind(
	\instrument, \pulsetrain,
	\dur, Pseq([5], inf),
	\fundstart, Pseq(fundstart),
	\fundend, Pseq(fundend),
	\harmnum, Pseq(harmnum)
).play;
)
t = Synth(\pulsetrain, [\dur, 10, \fundstart, 10, \fundend, 13, \harmnum, 14]);


/* high pass filtering */

(
var in, out, order=4, cutoff = 1000, dur=2;
in = {WhiteNoise.ar(EnvGen.ar(Env.linen(0.01, dur-0.02, 0.01), doneAction:2))};
out = Array.fill(order+1, {|i| if (i>0, {{HPF.ar(out[i-1], cutoff)}}, {in})});
Routine{(order+1).do{|i| {out[i]}.play; dur.wait}}.play
)

/* band pass */

(
var in, out, rq, cutoff = 1000, dur=2;
in = {WhiteNoise.ar(EnvGen.ar(Env.linen(0.01, dur - 0.02, 0.01), doneAction:2))};
rq = [0.1, 0.2, 0.4, 0.5, 1];
Routine{(rq.size).do {|i| {BPF.ar(in, cutoff, rq[(rq.size - i - 1)])}.play; dur.wait;}}.play
)

/* resonance */

// Darth Vader
(
SynthDef(\formant, {|centre=440, bwidth=1, amp=1, dur=1|
	var env, input, rq, output;
	env = EnvGen.ar(Env([0.01, 1, 0.7, 0.01]*amp, [0.2, dur-0.5, 0.3], \exp), doneAction:2);
	input = WhiteNoise.ar*env;
	rq = bwidth/centre;
	output = Resonz.ar(input, centre, rq);
	Out.ar(0, output);
}).add;
)
(
a = [600, 60, 0, 1040, 70, -7, 2250, 110, -9, 2450, 120, -9, 2750, 130, -20];
e = [400, 40, 0, 1620, 80, -12, 2400, 100, -9,2800, 120, -12, 3100, 120, -18];
i = [250, 60, 0, 1750, 90, -30, 2600, 100, -16, 3050, 130, -22, 3340, 120, -28];
o = [400, 40, 0, 750, 80, -11, 2400, 100, -21, 2600, 120, -20, 2900, 120, -40];
u = [350, 40, 0, 600, 80, -20, 2400, 100, -32, 2675, 120, -28, 2950, 120, -36];

Routine{[a,e,i,o,u].do{|m|
	5.do{|n|
		Synth(\formant, [
			\centre, m[(n*3)],
			\bwidth, m[(n*3+1)],
				\amp, m[(n*3+2)].dbamp
			]);
		};
		1.wait;
	};
	}.play;
)

/* band pass filtering out 50HZ */

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");
r = {BRF.ar(
{BRF.ar(
	       {BRF.ar(PlayBuf.ar(1,b),
		           60,
		           2)
	       },
	       60, 2)},
60, 2)}.play;
{PlayBuf.ar(1, b)}.play;
r.release; b.{BRF.ar(close; b.free;



/*  allpass/phasing */

(
		{
			var dry, mod, wet, output;
			dry = SinOsc.ar(mul:1/2);
			mod = XLine.ar(1, 22050, 3, doneAction:2);
			wet = BAllPass.ar(dry, mod);
			output = wet - dry;
		}.play;
	)

	({
		var dry, mod, wet, output;
		dry = Blip.ar(100, 110, 1/2);
		mod = EnvGen.ar(Env([11000, 100, 11000], [5/2, 5/2], \exp), doneAction:2);
		wet = BAllPass.ar(dry, mod);
		2.do{wet = BAllPass.ar(wet, mod);};
		output = Pan2.ar((dry + wet)!2, [-1, 1]).sum;
		}.play;
	)

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
(
		{
			var dry, mod, wet, output;
			dry = PlayBuf.ar(1,b, BufRateScale.ir(b), loop:1);
			mod = SinOsc.ar(1/10).exprange(100, 11000);
			wet = BAllPass.ar(dry, mod);
			output = (dry + wet) / 2;
		}.play;
	)


	/*comb filter */
	(SynthDef(\comb, {|dur =1, amp=1, delayT=0, decayT=0|
		var mod, dry, wet, output;
		mod = XLine.ar(100, s.sampleRate/2, dur, doneAction:2);
		dry = SinOsc.ar(mod, mul:amp);
		wet = CombC.ar(dry, delayT, delayT, decayT);
		output = (dry + wet)/2;
		Out.ar(0, output);
		}).add;
	)

	(
		var delay=[0.002, 0.01, 0.05, 0.1, 1];
		Pbind(
			\instrument, \comb,
			\delayT, Pseq(delay),
			\dur, 3,
			\amp, 0.707,
		).play;
	)

	// synthetic piano

	(
		var n = 6;
		play({
			Mix.ar(Array.fill(n, {
				var delayTime, pitch, detune, strike, hammerEnv, hammer;
				pitch = (36 + 54.rand);
				strike = Impulse.ar(0.1 + 0.4.rand, 2pi.rand, 0.1);
				hammerEnv = Decay2.ar(strike, 0.008, 0.04);
				Pan2.ar(
					Mix.ar(Array.fill(3, {|i|
						detune = #[-0.05, 0, 0.04].at(i);
						delayTime = 1/(pitch + detune).midicps;
						hammer = LFNoise2.ar(3000, hammerEnv);
						CombL.ar(hammer, delayTime,
							delayTime,
							6)})),
					(pitch-36)/27 - 1)}))})
	)
//bubbles
	{
		CombC.ar(
			SinOsc.ar(
				LFSaw.ar(0.4, 0, 24, LFSaw.ar([8, 7.23], 0, 3, 80)).midicps, 0, 0.04), 0.2, 0.2, 4)
	}.play


	// echo
	b = Buffer.alloc(s, s.sampleRate);
	(
		SynthDef(\echo, {|buffer=0, delayT = 0.02|
		var env, in, ptr, tap, output;
		env = EnvGen.ar(Env([0, 1/2, 0,0], [1/40, 1/40, 38/40]), doneAction:2);
		in = SinOsc.ar(mul:env);
		ptr = DelTapWr.ar(buffer, in);
		tap = DelTapRd.ar(buffer, ptr, delayT);
		output = Mix.ar([in, tap]);
		Out.ar(0,output)
		}).add;
	)

	(
		var delay = [0.1, 0.05, 0.01];
		Pbind(
			\instrument, \echo,
			\buffer, b,
			\delayT, Pseq(delay),
		).play;
	)
	b.free;


	/* flanging */
	a = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");

	b = Buffer.alloc(s, a.numFrames, a.numChannels);
	(
	SynthDef(\flanger, { |bufsrc =0, bufdest=1, delay=0.02, dur = 5|
			var mod, src, tap, output;
			mod = EnvGen.ar(Env([0.001, delay, 0.001], [dur/2, dur/2], \exp), doneAction:2);
			src = PlayBuf.ar(bufdest.numChannels, bufsrc, loop:1);
			tap = CombC.ar(src, delay, mod, 0);
			output = Mix.ar([src, tap]);
			Out.ar(0, output);
		}).add;
	)

	x = Synth(\flanger, [\bufsrc, a, \bufdest, b]);
	a.close; a.free; b.close; b.free;


		/* chorus */
	a = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");

	b = Buffer.alloc(s, a.numFrames, a.numChannels);
	(
	SynthDef(\chorus, { |bufsrc =0, bufdest=1, delaymin=0.02,  delaymax=0.05, dur = 5|
			var mod, src, tap, output;
			mod = EnvGen.ar(Env([delaymin, delaymax, delaymin], [dur/2, dur/2], \exp), doneAction:2);
			src = PlayBuf.ar(bufdest.numChannels, bufsrc, loop:1);
			tap = CombC.ar(src, delaymax, mod, 0);
			output = Mix.ar([src, tap]);
			Out.ar(0, output);
		}).add;
	)

	x = Synth(\chorus, [\bufsrc, a, \bufdest, b]);
	a.close; a.free; b.close; b.free;


	//modelling (shite modelling)

	(
		SynthDef(\pluck, {|note=60, dur=1|
			var env, input, trigger,delayT, decayT=2, output;
			env = EnvGen.kr(Env.perc(releaseTime: dur-0.01 + decayT), doneAction:2);
			input = WhiteNoise.ar(0.02) * env;
			trigger = Impulse.ar(dur);
			delayT = 1/(note.midicps);
			output = Pluck.ar(input, trigger, delayT, delayT, 0.1);
			Out.ar(0, output);
		}).add;
	)

	(
		Pbind(
			\instrument, \pluck,
			\note, Pwhite(36, 84, 16),
			\dur, 1/4
		).play;
	)
	s.makeGui

	// reverb

	(
		z = ({
			var in, reverb;
			b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");
			in = PlayBuf.ar(1, b, loop:1);
			reverb = FreeVerb.ar(in);
			}.play
		)
	)
	z.free; b.close; b.free;

	// roll your own reverb
	(
		SynthDef(\reverb, {|freq = 440, amp=0.1, dur=10|
			var env, in, output=0, maxdelay=1, delay;
			env = EnvGen.ar(Env([0, amp, 0], [1/2, 1/2]));
			in = SinOsc.ar(freq, mul:env);
			delay = [0, 1/7, 1/5, 1/2];
			delay.size.do{|i| output = output+CombC.ar(in, maxdelay, delay[i], dur)};
			DetectSilence.ar(output, -60.dbamp, doneAction:2);
			Out.ar(0, output);
		}).add;
	)

	(

		var gbsus, dur;
		gbsus = [66, 73, 78, 82, 83, 88].midicps;
		dur = (10, 9.9..9.5);
		Routine {
			dur.size.do{ |i|
				Synth(\reverb, [\freq, gbsus[i], \dur, dur[i]]);
				0.1.wait;
			};
		}.play;
	)

	/* schroeder reverb */
	// this is excellent!
	(
		{
			var s, z, y;
			s = Mix.ar(Array.fill(10,
				{Resonz.ar(Dust.ar(0.2, 50), 200 + 3000.rand, 0.003)}));
			z = DelayN.ar(s, 0.048);
			y = Mix.ar(Array.fill(7, {CombL.ar(z, 0.1, LFNoise1.kr(0.1.rand, 0.04, 0.05), 15)}));
			4.do({ y = AllpassN.ar(y, 0.050, [0.050.rand, 0.050.rand], 1)});
			s + (0.2*y)
		}.play
	)
			