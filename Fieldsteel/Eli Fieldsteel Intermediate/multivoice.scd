(

SynthDef(\complex_bass, {
	|freqs = #[40, 80, 120, 160, 200, 240], amps = #[0.1, 0.1, 0.1, 0.1, 0.1, 0.1], gate = 1, pos = 0, out=0|
	var sound, env;
	sound = Mix(SinOsc.ar(freqs, mul:amps));
	env = EnvGen.kr(Env([0,1,1,0], [0.1, 1, 0.1], releaseNode:2), gate);
    sound = Pan2.ar(sound * env, pos);
	Out.ar(out, sound);
}).add;
)

(
SynthDef(\effect, {
	| in, ratio=0.5, out = 0 |
	var noise = PinkNoise.ar;
	Out.ar( out, (In.ar(in) + ratio * noise)/2);
}).add;
)

(
~synthgroup = Group.tail(s);
~fxgroup = Group.tail(s);

~effect_bus = Bus.audio(s, 1);
~audio_bus = Bus.audio(s,1);

)
(
x = Synth.head(~synthgroup,\complex_bass);
x.set(\freqs, #[40, 80, 160, 250, 350, 440]);
x.set(\amps, #[0.0, 0.0, 0.0, 0.0, 0.0, 0.5]);
x.set(\out, ~effect_bus);
)

e = Synth.tail(~fxgroup, \effect, [\in, ~effect_bus, \ratio, 0]);
e.set(\ratio, 0)
e.free

// Then place your effect:

~dist = Synth.tail(s, \effect, [\in,  ~audio_bus]);

// transfer the results to main out, with level scaling
// play at tail of s's default group (note that Function-play also takes addActions!

~xfer = { Out.ar(0, 0.25 * In.ar(b, 2)) }.play(s, addActio~n: \addToTail);

// And start your routine:

(
r = Routine({
    {
        Synth.tail(~synthgroup, "order-of-ex-pulse",
            [\freq, rrand(200, 800), \ffreq, rrand(1000, 15000), \pan, 1.0.rand2,
            \bus, b, \lfobus, l]);
        0.07.wait;
    }.loop;
}).play(SystemClock);
)

~dist.run(false);    // proves that the distortion effect is doing something
~dist.run(true);

// to clean up:
(
r.stop;
[~synthgroup, ~fxgroup, b, l, ~lfo, ~xfer].do({ arg x; x.free });
currentEnvironment.clear; // clear all environment variables
)

