// busses and nodes may be needed for effects, and control
// otherwise these two functions can be left empty
"loading".postln;

~allocBusses = {

};

~initServerNodes = {
   // ~fxGroup = Group.new;
};

// SynthDefs for the Synths used in the piece
~defineSynths = {

   SynthDef(\reverb, {
        | out = 0, mix = 0.1|
        var dry = In.ar(out);
        // this is a change from the original
        // in which even the dry signal has the FreeVerb applied
        // personally I think there's enough mud
        var wet =FreeVerb.ar(dry,0.45,2.0,0.5);

        wet = DelayN.ar(wet, 0.03, 0.03);
        wet = CombN.ar(wet, 0.1, {Rand(0.01,0.099)}!32, 4);
        wet = SplayAz.ar(2, wet);
        wet = LPF.ar(wet, 1500);
        5.do{wet = AllpassN.ar(wet, 0.1, {Rand(0.01,0.099)}!2, 3)};
    XOut.ar(out, mix, wet);
    }).add;


 	SynthDef(\bell, {
			|
			freq=556, findex=0, frate=2,
			dur=5, pos=0,
			amp=0.25,
			out=0
			|
			var sigA, sigB, sigC, sig, env, fmod;
			env = EnvGen.ar(Env.triangle(5), doneAction:2);
			fmod = findex * SinOsc.kr(frate, mul:0.5, add:0.5) * Line.kr(0, 1, 7);
			sigA = Pulse.ar(freq + fmod, LFNoise2.kr(1).range(0.2, 0.8) );
			sigB = VarSaw.ar(freq + fmod);
			sigC = WhiteNoise.ar() * 0.125;
			sig = SelectX.ar(LFNoise2.kr(2).range(0, 2), [sigA, sigB, sigC]);
			sig = LPF.ar(sig, freq*4 );
			sig = sig * env * amp;
			Out.ar(out, Pan2.ar(sig, pos));
		}).add;


};

// list of Pbinds
~definePbinds = {
        ~root = -13;

    Pdef(\octaves, Pbind(
        \type, \rest,
        \root, Pxrand([-13, -1, 4, 7], inf).trace,
        \dur, Pwhite(10.0, 25.0, inf)
    ).collect({|event|
        ~last_root = event;
    }));


	Pdef(\main, Pfxb(Pbind(
			\instrument, \bell,
			\root, Pfunc({~last_root[\root]}),
			\octave, Pwrand([4, 5, 6, 7], [6,8,3,1].normalizeSum, inf),
			\degree, Prand(Scale.phrygian.degrees, inf),
			\ctranspose, Pwhite( -0.05, 0.05, inf),
			\amp, 2 * Pexprand(0.001, 0.7) * (1/(Pkey(\octave)+1)),
			\findex, Pexprand(2, 20),
			\frate, Pwhite(1, 25, inf),
			\pos, Pwhite(-0.8, 0.8, inf),
			\dur, Pwhite(0.1, 0.5)
    ), \reverb, \mix, 0.5));



};

//performance events:
// array (or dictionary) of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths directly via Routines
// might be called manually, or from a Pattern or a Routine, or from
// a GUI, or MIDI, or from external code via OSC


~events = [
    \start: {
        "poo".postln;
        Ppar(
        [Pdef(\octaves),
                Pdef(\main)]).play;
    }

].asDict;

~last_root