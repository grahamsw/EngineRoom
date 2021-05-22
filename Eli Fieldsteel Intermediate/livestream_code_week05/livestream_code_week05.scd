s.boot;
f = "C://Users//graha//Documents//dev//github//EngineRoom//Eli Fieldsteel Intermediate//livestream_code_week05//whatHappens.aiff";
b = Buffer.read(s, f);
b.play;
b.duration;

//for granulating stereo files - just read one channel
b = Buffer.readChannel(s, "/Users/eli/Desktop/whatHappens.aiff", channels:[0]);
b.play;

(
SynthDef(\grainbuf, {
	var sig, env;
	env = Env([0,1,1,0], [\atk.ir(1),\sus.ir(4),\rel.ir(1)], [1,0,-1]).kr(2);

	sig = GrainBuf.ar(
		numChannels: 2,
		trigger: Dust.kr(40),
		dur: 0.1,
		sndbuf: \buf.kr(0),
		rate: BufRateScale.kr(\buf.kr(0)) * \rate.kr(1),
		pos: Line.kr(0,1,BufDur.kr(\buf.kr(0))),
		interp: 2,
		pan: 0,
		envbufnum: -1,
	);

	sig = sig * env * \amp.kr(0.5);
	Out.ar(\out.kr(0), sig);
}).add;
)

Synth(\grainbuf, [\buf, b, \amp, 1]);

/////////////////////////////////////////

(
SynthDef(\tgrains, {
	var sig, env;
	env = Env([0,1,1,0], [\atk.ir(1),\sus.ir(4),\rel.ir(1)], [1,0,-1]).kr(2);

	sig = TGrains.ar(
		numChannels: 2,
		trigger: Dust.kr(40),
		bufnum: \buf.kr(0),
		rate: \rate.kr(1),
		centerPos: \pos.kr(0.5),
		dur: 0.05,
		pan: 0,
		amp: 1,
	);

	sig = sig * env * \amp.kr(1);
	Out.ar(\out.kr(0), sig);
}).add;
)

Synth(\tgrains, [\buf, b, \pos, 4.0]);

///////////////////////////////////////////

c = Buffer.alloc(s, s.sampleRate * 3);
c.plot

(
SynthDef(\tgrains_live, {
	var sig, env, mic, ptr, pos, buf = \buf.kr(0);
	env = Env.asr(\atk.ir(0.1), \sus.ir(1), \rel.ir(1)).kr(2, \gate.kr(1));
	//mic = SoundIn.ar(0);
	ptr = Phasor.ar(0, 1, 0, BufFrames.kr(buf));
	//BufWr.ar(mic, buf, ptr);

	pos = (ptr/SampleRate.ir) - 0.25;
	pos = pos + LFNoise1.kr(100).bipolar(0.2);

	sig = TGrains.ar(
		numChannels: 2,
		trigger: Dust.kr(40),
		bufnum: buf,
		rate: \rate.kr(1),
		centerPos: pos,
		dur: 0.05,
		pan: 0,
		amp: 1,
	);

	sig = sig * env * \amp.kr(1);
	Out.ar(\out.kr(0), sig);
}).add;
)

Synth(\tgrains_live, [\buf, b]);

//discontinuity problems:

(
SynthDef(\tgrains_live, {
	var sig, env, mic, ptr, pos, buf = \buf.ir(0);
//	mic = SoundIn.ar(0);
	ptr = Phasor.ar(0, 1, 0, BufFrames.ir(buf));
//	BufWr.ar(mic, buf, ptr);
	pos = ptr/SampleRate.ir - 0.15; //breaks if - becomes +
	env = Env.asr(\atk.ir(1), \sus.ir(1), \rel.ir(1)).kr(2, \gate.kr(1));
	sig = TGrains.ar(
		numChannels: 2,
		trigger: Impulse.kr(20),
		bufnum: buf,
		rate: \rate.kr(2),
		centerPos: pos,
		dur: 0.3,
		pan: 0,
	);
	sig = sig * env * \amp.kr(1);
	Out.ar(\out.kr(0), sig);
}).add;
)
().play
c.zero;
Synth(\tgrains_live, [\buf, b]);

///////////////////
//lots of grain pointers

(
SynthDef(\tgrains_live, {
	var sig, env, mic, ptr, pos, buf = \buf.kr(0);
	env = Env.asr(\atk.ir(0.1), \sus.ir(1), \rel.ir(1)).kr(2, \gate.kr(1));
	mic = SoundIn.ar(0);
	ptr = Phasor.ar(0, 1, 0, BufFrames.kr(buf));
	BufWr.ar(mic, buf, ptr);

	pos = (ptr/SampleRate.ir) - 0.25;
	pos = pos - (0,0.25..1.5);
	pos = pos + LFNoise1.kr(100!7).bipolar(0.15);

	sig = TGrains.ar(
		numChannels: 2,
		trigger: Dust.kr(40),
		bufnum: buf,
		rate: \rate.kr(1),
		centerPos: pos,
		dur: 0.05,
		pan: 0,
		amp: Array.geom(7, 1, -3.dbamp),
	);

	sig = sig.sum;

	sig = sig * env * \amp.kr(1);
	Out.ar(\out.kr(0), sig);
}).add;
)

c.zero;
Synth(\tgrains_live, [\buf, c]);

/////////////////////////

~rbus = Bus.audio(s,2);

(
SynthDef(\reverb, {
	var sig, wet;
	sig = In.ar(\in.ir(0), 2);
	wet = GVerb.ar(sig.sum, 250, 4);
	wet = LPF.ar(wet, 1000);
	sig = sig.blend(wet, \mix.kr(0.2));
	Out.ar(\out.ir(0), sig);
}).add;
)

ServerTree.removeAll;
ServerTree.add({Synth(\reverb, [\in, ~rbus])});

c.zero;
Synth(\tgrains_live, [\buf, c, \out, ~rbus]);


/////////////////////////
//harmonizer

(
SynthDef(\tgrains_live, {
	var sig, env, mic, ptr, pos, buf = \buf.kr(0);
	env = Env.asr(\atk.ir(0.1), \sus.ir(1), \rel.ir(1)).kr(2, \gate.kr(1));
//	mic = SoundIn.ar(0);
	ptr = Phasor.ar(0, 1, 0, BufFrames.kr(buf));
//	BufWr.ar(mic, buf, ptr);

	pos = (ptr/SampleRate.ir) - 0.15;
//	pos = pos + LFNoise1.kr(100).bipolar(0.02);

	sig = TGrains.ar(
		numChannels: 2,
		trigger: Dust.kr(200),
		bufnum: buf,
		rate: \rate.kr(1) * \harm.kr([-12, -7, -4, 0]).midiratio,
		centerPos: pos,
		dur: LFNoise1.kr(100).exprange(0.06, 0.08),
		pan: LFNoise1.kr(100).bipolar(0.5),
		amp: 1,
	);

	sig = sig.sum;

	sig = sig * env * \amp.kr(0.5);
	Out.ar(\out.kr(0), sig);
}).add;
)
b.play
c.zero;
x = Synth(\tgrains_live, [\buf, b, \out, ~rbus]);
x.set(\harm, [-9, -7, -4, 0]);
x.set(\gate, 0);



