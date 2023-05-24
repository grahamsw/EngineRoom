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
    SynthDef(\bass, { |out, freq = 440, gate = 1, amp = 0.5, slideTime = 0.17, ffreq = 1100, width = 0.15,
        detune = 1.005, preamp = 4|
        var    sig,
        env = Env.adsr(0.01, 0.3, 0.4, 0.1);
        freq = Lag.kr(freq, slideTime);
        sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
        * EnvGen.kr(env, gate, doneAction: Done.freeSelf);
        sig = LPF.ar(sig, ffreq);
        Out.ar(out, sig ! 2)
    }).add;

    SynthDef(\chord_tone, {
        |freq = 440, amp = 0.5, gate=1, out = 0|
        var env = EnvGen.kr(Env.asr, gate:gate,doneAction:2);
        var snd =
        Mix.fill(2,{
            |i|
            var snd;

            snd=Saw.ar(freq, mul:amp);
            snd=LPF.ar(snd,LinExp.kr(SinOsc.kr(rrand(1/30,1/10),rrand(0,2*pi)),-1,1,freq, freq*5));
            snd=DelayC.ar(snd, rrand(0.01,0.03), LFNoise1.kr(Rand(5,10),0.01,0.02)/15 );
            snd = Pan2.ar(snd,VarLag.kr(LFNoise0.kr(1/3),3,warp:\sine))/7;

        });
        Out.ar(out, snd * env);

    }).add;

    SynthDef(\bell, {
        |freq=1, t60=1, pitchy=1, amp=0.25, gate=1, pos=0, out = 0|
        var sig, exciter;
        //exciter = Impulse.ar(0);
        exciter = WhiteNoise.ar() * EnvGen.ar(Env.perc(0.001, 0.05), gate) * 0.25;
        sig = Klank.ar(
            `[
                [1, 2, 2.803, 3.871, 5.074, 7.81, 10.948, 14.421],   // freqs
                [1, 0.044, 0.891, 0.0891, 0.794, 0.1, 0.281, 0.079], // amplitudes
                [1, 0.205, 1, 0.196, 0.339, 0.047, 0.058, 0.047]*t60     // ring times
            ],
            exciter,
            freqscale:freq*pitchy);
        sig = FreeVerb.ar(sig) * amp;
        DetectSilence.ar(sig, 0.001, 0.5, doneAction:2);
        Out.ar(out, Pan2.ar(sig, pos));
    }).add;


    SynthDef(\pluck, {arg freq=440, amp=1, trig=1, time=2, coef=0.1, cutoff=2, pan=0;
        var pluck, burst;
        burst = LPF.ar(WhiteNoise.ar(1), freq*cutoff);
        pluck = Pluck.ar(burst, trig, freq.reciprocal, freq.reciprocal, time, coef:coef);
        DetectSilence.ar(pluck, 0.001, doneAction:2);
        Out.ar(0, Pan2.ar(pluck * amp, pan));
    }).add;

    SynthDef(\reverb, {
        | out = 0, mix = 0.1|
        var dry = In.ar(out);

        var wet =FreeVerb.ar(dry,0.45,2.0,0.5);

        wet = DelayN.ar(wet, 0.03, 0.03);
        //   wet = CombN.ar(wet, 0.1, {Rand(0.01,0.099)}!32, 4);
        wet = SplayAz.ar(2, wet);
        wet = LPF.ar(wet, 1500);
        //  5.do{wet = AllpassN.ar(wet, 0.1, {Rand(0.01,0.099)}!2, 3)};
        XOut.ar(out, Lag.kr(mix, 1), wet);
    }).add;

};

// list of Pbinds
~definePbinds = {





};

//performance events:
// array (or dictionary) of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths directly via Routines
// might be called manually, or from a Pattern or a Routine, or from
// a GUI, or MIDI, or from external code via OSC

~events = [
    \start: {
        ~scales = [
            \ionian,
            \dorian,
            \phrygian,
            \lydian,
            \mixolydian,
            \aeolian,
            \locrian
        ].collect({
            |scale|
            Scale.at(scale).degrees
        });

        // ~scales = [
        //     \major,
        //     \minor,
        //     \augmented,
        //     \augmented2,
        //     \diminished,
        //     \romanianMinor,
        //     //            \rast,
        //     \phrygian,
        //     //            \sikah,
        //     //            \scriabin,
        //     //            \hindu,
        //     //            \indian,
        //     //            \bastanikar,
        //     //            \locrian,
        //     \lydian,
        //     \diminished2,
        //     \zhi
        // ].collect({
        //     |scale|
        //     Scale.at(scale).degrees
        // });

        Pspawner({
            |sp|
            var scale, amps, chord, dur, total_dur, repeats, louder, quieter, slide_length, isSlide, bells, isBells, bellAmp, pbinds;
                sp.par(
                    Pmono(\reverb,
                        \mix, Pexprand(0.02, 0.4),
                        \dur, Pwhite(15, 30, inf)
                    )
                );
                sp.wait(1);
            loop ({
                sp.seq(
                    isSlide = 0.1.coin;
                    isBells = 0.1.coin;
                    bellAmp = if(isBells, {0.05}, {0});
                    slide_length = 3 + 4.rand;
                    repeats = if(isSlide, {7}, {5});
                    dur = 0.15;
                    louder = 0.45;
                    quieter = 0.1;
                    scale = ~scales.choose;
                    chord = Array.fill((scale.size/2),{|i| scale[(i*2)] - if([0,1].choose == 0, {12}, {0})});
                    bells = [scale[scale.size-1], scale[scale.size-4], scale[scale.size-3], scale[2]];
                    total_dur = if(isSlide, { dur * slide_length * repeats}, {dur * scale.size * repeats});
                    amps = if(isSlide,
                        {[louder] ++ (quieter!(slide_length-1))},
                        {[louder] ++ (quieter!(scale.size-2))}
                       // {[louder] ++ (quieter!rrand(3, scale.size-2))}//(scale.size-2))}
                    );
                    pbinds = [
                        Pbind(
                            \instrument, \chord_tone,
                            \degree,chord,
                            \amp, Pseq([0.07],1),
                            \dur, total_dur,
                            \out, 0
                        ),
                        Pbind(
                            \instrument, \pluck,
                            \degree, Pif(Pfunc({isSlide}),Pslide(scale, repeats, slide_length, wrapAtEnd:true), Pseq(scale, repeats)),
                            \coef, Pwhite(0.03, 0.1),
                            \time, Pwhite(2.0, 3.0, inf),
                            \dur, dur,
                            \amp, Pseq(amps, inf),
                            \pan, Pfunc({|ev| ev[\degree].linlin(0, 11, -0.5, 0.5)})
                    )];

                    pbinds = if (isBells,
                                {pbinds.add(Pbind(
                                        \instrument, \bell,
                                        \degree, Pseq(bells,1),
                                        \t60, 6,
                                        \pitchy, 4,
                                        \dur, 1,
                                        \amp, bellAmp
                                    ))},
                                {pbinds}
                                );

                    Ppar(pbinds);
                );
                sp.wait(dur);
            })
        }).play;
    }
].asDict;

