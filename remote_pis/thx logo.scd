(
s.waitForBoot({

	SynthDef(\voice, {
		|
		freq=440, time=5, pan=0.0
		gate=0, atk=1, rls=5, sus=0.7,
		detune=0, width=0.5, amp=0.0, amptime=5,
		ampFreqRel = 1.0,
		out=0, bus=0, fxsend=0.0
		|
		var env, sig;
		env = EnvGen.ar(Env.asr(atk, sus, rls), gate, doneAction:2);
		freq = VarLag.kr(freq, time, warp:\exponential);
		sig = VarSaw.ar([freq, freq+detune, freq-detune], width:width);
		amp = VarLag.kr(amp, amptime, warp:\exponential);
		sig = Mix.ar(sig) * env * amp * ampFreqRel;
		Out.ar(out, Pan2.ar(sig, pan));
		Out.ar(bus, Pan2.ar(sig, pan));
	}).add;

	// a reverb by Eli Fieldsteel
	SynthDef(\reverb, {
		arg in=0, out=0, dec=4, lpf=1500, amp=0.1;
		var sig;
		sig = In.ar(in, 2).sum * amp;

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
	~verbBus = Bus.audio(s, 2);

	s.sync;

	~rev = Synth(\reverb, [\in, ~verbBus, \out, 0]);

	~notes = [26,38,45,50,57,62,69,74,81,86,90];
	~synths = [];
	~notes.size.do({
		|item, i|
		// normalized index
		var nIndex  = i/~notes.size;
		//inverse normalized index
		var inIndex = (~notes.size - i)/~notes.size;
		~synths = ~synths ++ Synth(\voice,
		[
			\gate, 0,
			\atk, 3,
			\sus, 0.08,
			\detune, 0.001,
			\width, 0.1,
			\pan, 0.0 + rrand(-0.3, 0.3) * nIndex,
			\amp, 0.1,
			\ampFreqRel, inIndex,
			\out, 0,
			\bus, ~verbBus,
			\fxsend, 0.0
		]);
	});

	~incipit = Routine({
		~synths.do({
			|item|
			item.set(\gate, 1, \amp, 0.3, \amptime, 8);
		});
		{
			var time = rrand(0.5,2);
			~synths.do({
				|item|
				item.set(\freq, rrand(200, 400.0), \time, time);
			});
			wait(time);
		}.loop;
	});

	~move = Routine({
		~synths.do({
			|item, i|
			item.set(\freq, ~notes[i].midicps, \time, 8, \amp,0.7, \amptime, 8);
		});
	});

	~finish = Routine({
		~synths.do({
			|item, i|
			item.set(\rls, 1, \gate, 0);
		});
	});
});
)

(
~playMe = Routine({
	~incipit.reset;
	~incipit.play;
	8.wait;
	~incipit.stop;
	~move.reset;
	~move.play;
	16.wait;
	~finish.play;
}).play;
)

s.freeAll