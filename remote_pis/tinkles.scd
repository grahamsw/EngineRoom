
s.options.bindAddress = "0.0.0.0"; // allow connections from any address
s.options.maxLogins = 2; // set to correct number of clients
s.options.memSize = 10 * 8192;
s.quit;
s.waitForBoot({
NetAddr.langPort.postln;
OSCFunc.newMatching({s.quit; 0.exit;}, '/s_quit');

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
    wet = CombN.ar(wet, 0.1, {Rand(0.01,0.099)}!32, 4);
    wet = SplayAz.ar(2, wet);
    wet = LPF.ar(wet, 1500);
    5.do{wet = AllpassN.ar(wet, 0.1, {Rand(0.01,0.099)}!2, 3)};
    XOut.ar(out, mix, wet);
}).add;


    SynthDef(\chord_tone, {
        |freq = 440, amp = 0.5, gate=1, out = 0|
        var env = EnvGen.kr(Env.asr(releaseTime:1), gate:gate,doneAction:2);
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

    SynthDef(\chord, {
        | chord = #[1,2,3,4], filterhz = 440, amp = 0.1, klangamp = 0.2, gate = 1, out = 0|
        var env= 1 - EnvGen.kr(Env.asr(3,10,5), gate, doneAction:2);
        var chrd = chord * ([24.neg.midiratio] ++ (36.neg.midiratio!3));
        var snd =  Mix.ar(Saw.ar(chrd, amp));


        snd = LPF.ar(snd,
            LinExp.kr(SinOsc.kr(rrand(1/30,1/10),
                rrand(0,2*pi)),-1,1,filterhz,filterhz*5)
        );

        snd = DelayC.ar(snd,
            rrand(0.01,0.03),
            LFNoise1.kr(Rand(5,10),0.01,0.02)/15
        );
        snd = Pan2.ar(snd,VarLag.kr(LFNoise0.kr(1/3),3,warp:\sine))/7;
        snd = snd + DynKlank.ar(`[chord, nil, [1, 1, 1, 1]],
            PinkNoise.ar([0.004, 0.004]))* klangamp;
        Out.ar(out, snd * env);

    }).add;

    s.sync;
      ~scales = [
            \major,
            \minor,
            \augmented,
            \augmented2,
            \diminished,
            \romanianMinor,
            \rast,
            \phrygian,
            \sikah,
            \scriabin,
            \hindu,
            \indian,
            \bastanikar,
            \locrian,
            \lydian,
            \diminished2,
            \zhi
        ].collect({
                    |scale|
                    Scale.at(scale).degrees
                });
     ~chords=[
        [0,4,7,12],
        [4,7,11,16],
        [-3,0,4,7],
        [-3,0,5,9],
    ].collect({|c|
        [(c+60).midicps]

    });
~rev = Synth(\reverb, [\mix, 0.2]);
    s.sync;
Pspawner({|sp|
    loop ({
        var scale, amps, chord, dur, total_dur, repeats;
        repeats = 5;
        dur = 0.15;
        scale = ~scales.choose;
            chord = Array.fill((scale.size/2),{|i| scale[(i*2)]});
            scale.postln;
            chord.postln;
        total_dur =  dur * scale.size * repeats;
        amps = [0.5] ++ (0.1!(scale.size-2));
            sp.seq(
              Ppar([
                    /*
               Pbind(
                    \instrument, \chord,
                    \chord, chord,
                        \amp, Pseq([0.1], 1),
                    \dur, total_dur
                )*/
              Pbind(
            \instrument, \chord_tone,
                        \degree,chord,
                        \amp, Pseq([0.05],1),
            \dur, total_dur,
            \out, 0
        ),
                Pbind(
                    \instrument, \pluck,
                    \degree, Pseq(scale, repeats),
                    \coef, 0.05,
                    \time, Pwhite(2, 3, inf),
                    \dur, dur,
                    \amp, Pseq(amps, inf),
                    \pan, Pwhite(-1.0, 1.0, inf)
                )

                    ])


            );
            sp.wait(0.15);




    })
    }).play;

})


