
(

SynthDef(\node, {
    |freq=0, mult=1, ampbus=0, pos=0, out=0|
    var sig, amp;
    sig = SinOsc.ar(In.kr(freq) * mult);
    amp = In.ar(ampbus, 1);
    Out.ar(out, Pan2.ar(sig * amp, pos ))
}).add;

SynthDef(\amper, {
    |amps = #[0, 1,0], times = #[3,3],  out=0|
    Out.ar(out, EnvGen.ar(Env(amps, times)));
}).add;


SynthDef(\line, {
    |from=0, to=1, time=1, curve=(1),e out=0|
    Out.ar(out, EnvGen.ar(Env([from, to], [time], curve)));
}
).add;

SynthDef(\master, {
    |adsr=#[0.01, 0.1, 0.5, 1], gate=1, in, out=0|
    var sig = In.ar(in, 2);
    var env = EnvGen.kr(Env.adsr(adsr[0], adsr[1], adsr[2], adsr[3]),gate, doneAction:Done.freeGroup);
    Out.ar(out, sig * env);
}).add;

~playFluxx = {|params,  baseFreq, adsr, gate=1|
    var all;

    var sig = Bus.audio(s, 2);
    var grp = Group.new;


    params.do({|p| p[\amp] = Bus.audio(s, 1) });
    ~freq = Bus.control(s, 1).set(baseFreq);

    m = Synth(\master, [\adsr, adsr, \gate, gate, \in, sig,\out, 0], grp);



    all = params.collect({
        |p|
        [
            Synth(\node, [\freq, ~freq, \mult, p[\freqMult] , \ampbus, p[\amp], \pos, p[\pos], \out, sig],grp),
            Synth(\line, [\from, p[\from], \to, p[\to], \time, p[\time], \curve, p[\curve], \out,p[\amp]], grp)
        ]
    });
    [m, grp, sig]
};

)
().play
(

var params = [
    (\freqMult:  1, \from: 0.0, \to: 0.1, \time: 0.01, \curve: (9), \pos: 0),
    (\freqMult:  2, \from: 0.0, \to: 0.2, \time: 0.5, \curve: (9), \pos: 0 ),
    (\freqMult:  5, \from: 0.4, \to: 0.0, \time: 3, \curve: (-2), \pos: 0 ),
    (\freqMult: 10, \from: 0.5, \to: 0.0, \time: 4, \curve: (-15), \pos: 0),
    (\freqMult: 11, \from: 0.5, \to: 0.0, \time: 4, \curve: (-15), \pos: -1),
    //    (\freqMult: 13.5, \from: 0.5, \to: 0.0, \time: 9, \curve: (-1), \pos: -1),
    //(\freqMult: 21.5, \from: 0.5, \to: 0.0, \time: 9, \curve: (-1), \pos: -1 )
];


r = ~playFluxx.(params, 250, #[0.01, 2, 0.1,  6]);
//~playFluxx.(params, 500 * 2 /3);
//~playFluxx.(params, 500 * 7 /3)




)

r[0].release
(
SynthDef(\ff, {
    |low, high, outbuff|
    Out.kr(outbuff, LFTri.kr(0.1).range(low, high))}
).add;



f = Synth(\ff, [\low, 45, \high, 49, \outbuff, ~freq]);
)

m.set(\gate, 0)
f.set(\low, 100, \high, 120)
~freq.get({arg value; value.postln});

//Env([0, 4, 0], [1,1], [5, -5]).plot





