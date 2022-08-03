// busses and nodes may be needed for effects, and control
// otherwise these two functions can be left empty
"loading".postln;

~allocBusses = {

};

~initServerNodes = {
    ~audioGroup = Group.new;
    ~fxGroup = Group.new(~audioGroup, \addAfter);
};

// SynthDefs for the Synths used in the piece
~defineSynths = {

    ~hz = Ndef(\hz, {440});

    SynthDef(\reverb, {
        | in, out = 0, mix = 0.1|
        var dry = In.ar(in);
        // this is a change from the original
        // in which even the dry signal has the FreeVerb applied
        // personally I think there's enough mud
        var wet =FreeVerb.ar(dry,0.45,2.0,0.5);

        wet = DelayN.ar(wet, 0.03, 0.03);
        wet = CombN.ar(wet, 0.1, {Rand(0.01,0.099)}!32, 4);
        wet = SplayAz.ar(2, wet);
        wet = LPF.ar(wet, 1500);
        5.do{wet = AllpassN.ar(wet, 0.1, {Rand(0.01,0.099)}!2, 3)};
        Out.ar(out, (wet * mix) + (dry * (1-mix)));
    }).add;

    // with a simple envelope to delete the synth (though it is
    // used continuously in this piece)
    SynthDef(\bassNote, {
        |freq, gate=1, out=0|
        var snd, env;
        env = EnvGen.kr(Env.adsr, gate, doneAction:2);
        snd=SinOsc.ar(freq/4,
            mul:SinOsc.kr(Rand(0.001,0.01)).range(0.05,0.15));
        snd=snd+SinOsc.ar(freq/2,
            mul:SinOsc.kr(Rand(0.001,0.01))
            .range(0.001,0.05));
        Out.ar(out, snd!2 * env);
    }).add;

    SynthDef.new(\comb_piano, {
        arg out=0, amp=0.125, freq=220,
        noise_hz = 4000, noise_attack=0.002, noise_decay=0.06,
        tune_up = 1.0005, tune_down = 0.9996, string_decay=6.0,
        lpf_ratio=2.0, lpf_rq = 4.0, hpf_hz = 40, damp=0, damp_time=0.1;

        var noise, string, delaytime, lpf, noise_env, snd, damp_mul;

        damp_mul = LagUD.ar(K2A.ar(1.0 - damp), 0, damp_time);

        noise_env = Decay2.ar(Impulse.ar(0));
        noise = LFNoise2.ar(noise_hz) * noise_env;

        delaytime = 1.0 / (freq * [tune_up, tune_down]);
        string = Mix.new(CombL.ar(noise, delaytime, delaytime, string_decay * damp_mul));

        snd = RLPF.ar(string, lpf_ratio * freq, lpf_rq) * amp;
        snd = HPF.ar(snd, hpf_hz);

        Out.ar(out, snd.dup);
        DetectSilence.ar(snd, doneAction:2);
    }).add;

    SynthDef(\polyperc,
        {
            | freq = 440, amp = 0.5, out = 0|
            var snd=( EnvGen.ar(Env.perc(releaseTime:4), doneAction:2) *
                MoogFF.ar(Pulse.ar(freq,mul:1.0), freq*1.5)
            );
            Out.ar(out, snd);
        }
    ).add;

    SynthDef(\chord_tone, {
        |freq = 440, amp = 0.5, out = 0|

        var snd =
        Mix.fill(2,{
            |i|
            var snd;
            snd=Saw.ar(freq, mul:amp);
            snd=LPF.ar(snd,LinExp.kr(SinOsc.kr(rrand(1/30,1/10),rrand(0,2*pi)),-1,1,freq, freq*5));
            snd=DelayC.ar(snd, rrand(0.01,0.03), LFNoise1.kr(Rand(5,10),0.01,0.02)/15 );
            snd = Pan2.ar(snd,VarLag.kr(LFNoise0.kr(1/3),3,warp:\sine))/7;

        });
        Out.ar(out, snd);

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

    SynthDef(\dk, {
        |chord = #[0,4,7,12], note = 60, amp = 0.5, out = 0|
        var snd = DynKlank.ar(`[(note + chord).midicps, nil, [1, 1, 1, 1]], PinkNoise.ar([0.004, 0.004]));
        Out.ar(out, snd * amp);
    }).add;

    SynthDef(\airport, {
        | hz=440,amp=0.5, out = 0 |

        var note=hz.cpsmidi;
        var snd,snd2,intro;

        // these notes are directly from Eno's Music for Airports
        // each phrase is one line, and played through
        var airports=[
            [5,7,4,2,0,12,7,5,7,4,2,0],
            [5,7,4,2,0,12,4,7,5,0],
            [-5,2,0,4,7,12,5,2,7,4,0,7,2,5,5,2,4,0],
            [7,7,2,4,4,4,2,0,7,0,0],
        ];
        // these are some chords I made up that sound nice with it
        var planes=[
            [0,4,7,12],
            [4,7,11,16],
            [-3,0,4,7],
            [-3,0,5,9],
        ];

        // setup the note change variables
        var seq,seqnote,notepulse,noterate;
        var planeseq,planenotes,planeenv,planenotechange;
        // piano stuff
        var noise, string, delaytime, lpf, noise_env,pianosnd,pianosnd2, damp_mul,pianohz,noise_hz;
        var noise_attack=0.002, noise_decay=0.06,
        tune_up = 1.0005, tune_down = 0.9996, string_decay=6.0,
        lpf_ratio=2.0, lpf_rq = 4.0, hpf_hz = 40, damp=0, damp_time=0.1;

        // chord and note changes (random)
        planenotechange=Dust.kr(1/30)+Impulse.kr(0);
        planeenv=1-EnvGen.kr(Env.perc(3,10,0.9),planenotechange);
        planenotes=Demand.kr(TDelay.kr(planenotechange,3),0,Dxrand(planes,inf));
        notepulse=1;
        noterate=TChoose.kr(Dust.kr(notepulse)+Impulse.kr(0),[0.02,0.05,1,2,0.5,0.25,2]/2)*Rand(0.78,1.32);
        notepulse=Impulse.kr(noterate);
        seq=Demand.kr(Dust.kr(0.1)+Impulse.kr(0),0,Dxrand(airports,inf));
        seqnote=Demand.kr(notepulse,0,Dseq(seq,inf));
        // bass note
        snd=SinOsc.ar((note-24).midicps,mul:SinOsc.kr(Rand(0.001,0.01)).range(0.05,0.15));
        snd=snd+SinOsc.ar((note-12).midicps,mul:SinOsc.kr(Rand(0.001,0.01)).range(0.001,0.05));
        // chords
        snd=snd+(planeenv*Mix.ar(Array.fill(8,{arg i;
            var snd;
            snd=Saw.ar((note+planenotes[i%4]+Select.kr(DC.kr(i%4)<1,[24.neg,36.neg])).midicps,mul:0.9);
            snd=LPF.ar(snd,LinExp.kr(SinOsc.kr(rrand(1/30,1/10),rrand(0,2*pi)),-1,1,hz,hz*5));
            snd=DelayC.ar(snd, rrand(0.01,0.03), LFNoise1.kr(Rand(5,10),0.01,0.02)/15 );
            Pan2.ar(snd,VarLag.kr(LFNoise0.kr(1/3),3,warp:\sine))/7
        })));
        //	snd=MoogLadder.ar(snd.tanh,LinExp.kr(VarLag.kr(LFNoise0.kr(1/6),6,warp:\sine),-1,1,hz*2,hz*60));
        snd=snd+(0.55*DynKlank.ar(`[[(note+planenotes[0]).midicps, (note+planenotes[1]).midicps, (note+planenotes[2]).midicps, (note+planenotes[3]).midicps], nil, [1, 1, 1, 1]], PinkNoise.ar([0.004, 0.004])));

        // piano sound from https://github.com/catfact/zebra/blob/master/lib/Engine_DreadMoon.sc#L20-L41
        noise_hz=VarLag.kr(LFNoise0.kr(1/10),10).range(2000,5000);
        pianohz=A2K.kr((note+seqnote-12).midicps);
        noise_env = Decay2.ar(Impulse.ar(noterate));
        noise = LFNoise2.ar(noise_hz) * noise_env;
        damp_mul = LagUD.ar(K2A.ar(1.0 - damp), 0, damp_time);
        delaytime = 1.0 / (pianohz * [tune_up, tune_down]);
        string = Mix.new(CombL.ar(noise, delaytime, delaytime, string_decay * damp_mul));
        pianosnd = RLPF.ar(string, lpf_ratio * pianohz, lpf_rq) * amp;
        pianosnd = HPF.ar(pianosnd, hpf_hz);

        // polyperc sound
        pianosnd2=(
            EnvGen.ar(Env.perc(releaseTime:4),notepulse)*
            MoogFF.ar(Pulse.ar((note+seqnote).midicps,mul:1.0),(note).midicps*1.5)
        );

        // mix between polyperc and piano sound randomly	snd=snd+SelectX.ar(SinOsc.kr(LFNoise0.kr(0.1).range(0.01,0.1)).range(0.1,0.9),[pianosnd*0.3,pianosnd2]);
        snd=LPF.ar(snd,(note+36).midicps);
        snd=HPF.ar(snd,120);
        snd=snd*EnvGen.ar(Env.new([0,0,1],[0.5,3]));

        // final output
        Out.ar(out, snd*amp);
    }).add();
};

// list of Pbinds
~definePbinds = {
    ~chords=[
        [0,4,7,12],
        [4,7,11,16],
        [-3,0,4,7],
        [-3,0,5,9],
    ].collect({|c|
        [(c+60).midicps]

    });

    Pdef(\chords,
        Pbind(
            \instrument, \chord,
            \chord, Pxrand(~chords, inf).trace,
            \filterhz, 440,
            \klangamp, 0.05,
            \amp, 0.3,
            \dur, Pwhite(5, 30, inf).trace,
            \out, ~fxBus
        );
    );
    ~airports=[
    [5,7,4,2,0,12,7,5,7,4,2,0],
    [5,7,4,2,0,12,4,7,5,0],
    [-5,2,0,4,7,12,5,2,7,4,0,7,2,5,5,2,4,0],
    [7,7,2,4,4,4,2,0,7,0,0],
].collect({|a| Pseq((a+60).midicps,1)});

    Pdef(\piano,
        Pbind(
            \instrument, Pwrand([\comb_piano, \polyperc], [0.9, 0.1], inf),
            \freq, Pswitch(~airports, Prand([0,1,2,3], inf)),
            \dur, 1+Prand([0.02,0.05,1,2,0.5,0.25,2]/2, inf).trace*rrand(0.78,1.32),
            \legato, 2,
            \amp, 0.1,
            \out, ~fxBus
        )
    );

};

//performance events:
// array (or dictionary) of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths directly via Routines
// might be called manually, or from a Pattern or a Routine, or from
// a GUI, or MIDI, or from external code via OSC


~events = [
    \start: {
        ~fxBus =  Bus.audio(s, 2);
        ~fx = Synth(\reverb, [\in, ~fxBus, \mix, 0.5], ~fxGroup);
        //      ~player = Synth(\airport, [\out, ~fxBus], ~audioGroup);

    },
    \startBass: {~bass = Synth(\bassNote, [\freq, ~hz, \out, ~fxBus], ~audioGroup)},
    \startChords: {Pdef(\chords).play(quant:1)},
    \stop: {~player.stop;},
    \setMix: {|mix| ~fx.set(\mix, mix);},
    \startPiano: {Pdef(\piano).play(quant:1)}

].asDict;

().play
Pdef(\piano).
/*
~fx.free
~events[\start].()
~events[\startBass].()
~events[\startChords].()
~events[\startPiano].()
~events[\stop].()
~events[\setNote].(2)
~events[\setClock].(0.3)
~events[\setMix].(1)
().play
~bass.set(\freq, 880)
*/