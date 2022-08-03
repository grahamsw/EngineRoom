//Line6 Loop Pedal Emulation
//(condensed into one SynthDef)
//FEEDBACK WARNING! USE HEADPHONES!

(
~mainOut = 0;
~micIn = 0;
s.waitForBoot({

	Buffer.freeAll;
	s.sync;
	~b = Buffer.alloc(s, s.sampleRate * 300);

	SynthDef(\looper, {
		var mic, trig, max, ptr, loop, rec, mix;
		var xfade = \xfade.kr(0.02);
		var buf = \buf.kr(0);
		mic = SoundIn.ar(\in.ir(0));
		trig = Trig1.ar(\trig.tr(0), ControlDur.ir);
		max = Sweep.ar(trig, SampleRate.ir * \run.kr(0));
		ptr = Phasor.ar(trig, 1, 0, max, 0);
		loop = BufRd.ar(1, buf, ptr);
		rec = sum([
			mic * \reclev.kr(0).varlag(xfade,-2),
			loop * \prelev.kr(0).varlag(xfade,-2)
		]);
		rec = rec * \recAmp.kr(1).varlag(xfade,-2);
		BufWr.ar(rec, buf, ptr);
		mix = sum([
			loop * \loopAmp.kr(1).varlag(xfade,-2),
			mic * \micAmp.kr(1).varlag(xfade,-2)
		]);
		mix = mix * \mixAmp.kr(1).varlag(xfade,-2);
		Out.ar(\out.ir(0), mix!2);
	}).add;

	s.sync;

	~looper = Synth(
		\looper, [
			\in, ~micIn,
			\buf, ~b.bufnum,
			\out, ~mainOut
		]
	);
});
)

//initial start record
~looper.set(\trig, 1, \run, 1, \reclev, 1, \prelev, 1, \xfade, 0.02);

//stop recording/overdubbing, begin/continue looping
~looper.set(\run, 0, \reclev, 0, \prelev, 1);

//start overdubbing (slight attenuation on existing content to prevent buildup)
~looper.set(\run, 0, \reclev, 1, \prelev, -1.dbamp);

//gradually fade loop content on each loop, without recording new audio
~looper.set(\run, 0, \reclev, 0, \prelev, -3.dbamp);

//reset, clear buffer, and immediately begin recording again
~b.zero; ~looper.set(\trig, 1, \run, 1, \reclev, 1, \prelev, 1, \xfade, 0.02);

//reset, clear buffer, but do not begin recording again
~b.zero; ~looper.set(\trig, 1, \run, 0, \reclev, 0, \prelev, 0, \xfade, 0.02);

//fade loop signal out of/into main mix
~looper.set(\loopAmp, 0, \xfade, 3);
~looper.set(\loopAmp, 1, \xfade, 3);