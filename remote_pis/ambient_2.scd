(
SynthDef(\param, { arg freq = 100, sustain, amp;
	var sig;
    sig = LFPar.ar(freq: freq,
        mul: EnvGen.kr(Env.perc(0.01, sustain, 0.5), doneAction:2) * amp);
	sig = Splay.ar(sig);
	Out.ar(0, sig);
}).add;

   SynthDef(\test_fx, {
        | out = 0, level=0.5|
        var sig = In.ar(out, 2);

        XOut.ar(out, level, SinOsc.ar([400, 440], mul:0.1));

}).add;

SynthDef(\echo, { arg out=0, maxdtime=0.2, dtime=0.2, decay=2, gate=1;
    var env, in;
    env = Linen.kr(gate, 0.05, 1, 0.1, 2);
    in = In.ar(out, 2);
    XOut.ar(out, env, CombL.ar(in * env, maxdtime, dtime, decay, 1, in));

}, [\ir, \ir, 0.1, 0.1, 0]).add;

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

    SynthDef(\param, { arg out=0, freq = 100,  amp=0.1;
        var sig;
        sig = LFPar.ar(freq: freq,
                  mul: EnvGen.kr(Env.perc(0.01, 1, 0.5), doneAction:2) * amp);
        sig = Splay.ar(sig);
        Out.ar(out, sig);
    }).add;


    SynthDef(\comb_piano, {
        arg out=0, amp=0.125, freq=220,
        noise_hz = 4000, noise_attack=0.002, noise_decay=0.06,
        tune_up = 1.0005, tune_down = 0.9996, string_decay=6.0,
        lpf_ratio=2.0, lpf_rq = 4.0, hpf_hz = 40, damp=0, damp_time=0.1;

        var noise, string, delaytime, lpf, noise_env, snd, damp_mul;

        damp_mul = LagUD.ar(K2A.ar(1.0 - damp), 0, damp_time);

        noise_env = Decay2.ar(Impulse.ar(0));
        noise = LFNoise2.ar(noise_hz) * noise_env;

        delaytime = 1.0 / (freq * [tune_up, tune_down]);
        string = Mix.new(CombL.ar(noise,
                                  delaytime,
                                  delaytime,
                                  string_decay * damp_mul));

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
			sig = sig * env * amp * 2;
			Out.ar(out, Pan2.ar(sig, pos));
		}).add;

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

)

(
~airports=[
    //   [6],[6],[6],[6]
    [5,7,4,2,0,12,7,5,7,4,2,0, \rest, \rest, \rest, \rest],
    [5,7,4,2,0,12,4,7,5,0, \rest, \rest, \rest, \rest],
    [-5,2,0,4,7,12,5,2,7,4,0,7,2,5,5,2,4,0, \rest, \rest, \rest, \rest],
    [7,7,2,4,4,4,2,0,7,0,0, \rest, \rest, \rest, \rest],
].collect({|a| Pseq((a+60).midicps,1)});
~airports = [
    Scale.minor.degrees.scramble ++ [\rest, \rest, \rest],
    Scale.minor.degrees.scramble ++ [\rest, \rest, \rest],
    Scale.minor.degrees.scramble ++ [\rest, \rest, \rest]
].collect({|a| Pseq((a+60).midicps,1)});
~chords=[
    [0,4,7,12],
    [4,7,11,16],
    [-3,0,4,7],
    [-3,0,5,9],
].collect({|c|[(c+60).midicps] });


Pdef(\piano,
    Pfxb(
        Pbind(
            \instrument, \comb_piano,
            \degree, Prand(Scale.phrygian.degrees, inf),
            \dur, 1 *rrand(0.78,1.32),
            \legato, 3,
            \amp, 0.02,
    ),\reverb, *[\mix, 0.1])
);


Pdef(\chords,
    Pfxb(
        Pbind(
            \instrument, \chord,
            \chord, Pxrand(~chords, inf),
            \filterhz, 440,
            \klangamp, 0.05,
            \amp, 0.3,
            \dur, Pwhite(5, 30, inf)

    ), \reverb, *[\mix, 0.1])
);

Pdef(\bass,
    Pfxb(
        Pmono( \bassNote,
            \freq, 440
        ),\reverb, *[\mix, 0.1]
    )
);

)

Ppar([Pdef(\piano),  Pdef(\bass)]).play


[Pdef(\piano), Pdef(\chords),
    Pdef(\bass)].do({|pp| pp.stop})
