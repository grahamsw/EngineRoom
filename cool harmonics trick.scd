
// one way to do the harmonics trick (a la Equalizer )
(
SynthDef(\help_Buffer,{ arg out=0, bufnum;
    Out.ar( out,
        PlayBuf.ar(1,bufnum,BufRateScale.kr(bufnum))
    )
}).add;
Synth(\help_Buffer, [\bufnum, 0])
(
SynthDef("help-VOsc",{ arg out=0, freq = 400,amp = 0.2, voscrate= 1, gate=1, bufoffset=0;
    var x, env;
    env = EnvGen.kr(Env.adsr, gate, doneAction:Done.freeSelf);
    // mouse x controls the wavetable position
    x = MouseX.kr(0,7).poll;
//    x = TRand.kr(0, 7, Impulse.kr(voscrate)).varlag(1);
    Out(

// allocate and fill tables 0 to 7
8.do({ arg i;
    var n, a;
    // allocate table
    s.sendMsg(\b_alloc, i, 1024);
    // generate array of harmonic amplitudes
    n = (i+1)**2;
    a = Array.fill(n, { arg j; ((n-j)/n).squared.round(0.001) });
    // fill table
    s.performList(\sendMsg, \b_gen, i, \sine1, 7, a);
    // the argument '7' here is a flag for the \sine1 wave fill method -
    // see the "Wave Fill Commands" section in the Server Command Reference
});
).ar(out,
        VOsc.ar(bufoffset+x, freq * [1, 1.01], mul:env * amp)
    )
}).add; //.play(s,[\out, 0, \bufoffset, 0]);
)

(
8.do({ arg i;
    var a;
    s.sendMsg(\b_alloc, i, 1024); // allocate table
    // generate array of harmonic amplitudes
    a = Array.fill(i, 0) ++ [0.5, 1, 0.5];
    // fill table
    s.performList(\sendMsg, \b_gen, i, \sine1, 7, a);
});
)
x = Synth("help-VOsc")
x.set(\freq, 200)
x.set(\bufoffset, 0)

(
8.do({ arg i;
    var a;
    s.sendMsg(\b_alloc, i, 1024); // allocate table
    // generate array of harmonic amplitudes
    a = Array.fill(i, 0) ++ [0.5, 1, 0.5];
    // fill table
    s.performList(\sendMsg, \b_gen, i, \sine1, 7, a);
});
)

().play

(
Pbindef(\mario,
    \instrument, "help-VOsc",
    \degree, Pseq([0,1.9,4,7], inf)
);
)

t = TempoClock;
t.beats_(0.1)

Pbindef(\mario, \voscrate, 4, \dur, 2, \legato, 4).play(t, quant: 4)
12
Pbindef(\mario, \voscrate, 1, \degree, 0, \amp, 1, \dur, 10).play(t, quant: 4)

Pbindef(\mario, \voscrate, 1, \dur, 4, \legato, 2).quant_(4)

Pbindef(\mario, \gtranspose, -12).quant_(4)
Pbindef(\mario, \degree, Pseq([0, 2, 4, 9], inf)).quant_(4)
Pbindef(\mario, \dur, 0.125).quant_(4)
Pbindef(\mario, \voscrate, 0.37).quant_(1)

Pbindef(\mario).free(3)