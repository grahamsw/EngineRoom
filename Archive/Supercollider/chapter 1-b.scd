Env.perc(0, 1).plot
(
{
	var env = Env.perc(0, 1);
	PMOsc.ar(
		400, (5 + (1/IRand(2,6)))* 400,
		pmindex: EnvGen.kr(env, timeScale: 1, levelScale:3),
		mul:EnvGen.kr(env, timeScale:1, levelScale:0.3));
}.play
)



(
~delay = Bus.audio(s,2);
~mod = Bus.audio(s, 2);
~gate = Bus.audio(s, 2);
~kS = Bus.control(s, 2);
)

~controlSynth = {Out.kr(~kS, LFNoise0.kr(0.1))}.play;

~delaySynth = {Out.ar(0, AllpassC.ar(In.ar(~delay, 2), 2, [1.65, 0.15], 10))}.play(~controlSynth, addAction: \addAfter);
~modSynth = {Out.ar(~delay, In.ar(~mod, 2) * SinOsc.ar(In.kr(~kS)*500 + 2100))}.play(~delaySynth,addAction:\addBefore);

~gateSynth = {Out.ar([0, ~mod], In.ar(~gate, 2) * max(0, In.kr(~kS)))}.play(~modSynth, addAction: \addBefore);

~pbGroup = Group.before(~controlSynth);

~houston = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");
~chooston = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

{Out.ar(~gate, Pan2.ar(PlayBuf.ar(1, ~houston, loop:1), 0.5))}.play(~pbGroup);

{Out.ar(~gate, Pan2.ar(PlayBuf.ar(1, ~chooston, loop:1), -0.5))}.play(~pbGroup);


Platform.resourceDir

{PlayBuf.ar(1, ~houston, loop:1)}.play
	