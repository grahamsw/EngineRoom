{CombN.ar(CombN.ar(CombN.ar(CombN.ar(LFNoise0.ar(1000)))))}.scope

CombC.ar()
a = 9
(1..9)

(
SynthDef(\CombSwitch, {
    |which, in|
    var maxDepth = 10;
    var outputs = Array.newClear(maxDepth);
    outputs[0] = In.ar(in);
    (1..(maxDepth-1)).do({
        |i|
        outputs[i] = CombN.ar(outputs[i-1]);
    });
    Out.ar(0, Lag.ar(Select.ar(which, outputs)));

}).add;

)

(
b = Bus.audio(s, 1);
x.free;
x  = {Out.ar(b, SinOsc.ar(440, mul:0.5))}.play;
d = Synth(\CombSwitch, [\which, 0, \in, b]);

k = Bus.control(s);
{Out.kr(k, MouseX.kr(0, 10).round.poll)}.play;
d.map(\which, k);
)

(
r = {Out.ar(0, FreeVerb.ar(In.ar(55, 2), 2, mix: 0.6, room: 0.8, mul:0.5))}.play;

a = {Out.ar(55, SinOsc.ar([800, 840], mul:LFPulse.ar(2)))}.play
)

a = {Splay.ar(SinOsc.ar((1..9)*100, mul:0.1))}.play


(
d = {
    |fundamental = 100, base = 32|
    var harmonics = (1..4);
    var snd = BPF.ar(Saw.ar(base, LFPulse.ar(harmonics, width:0.1)),
        freq: harmonics * fundamental,
        rq: 0.01,
        mul: 40);
   // snd = Saw.ar(base, LFPulse.ar(harmonics, width:0.1));
    Splay.ar(snd);
}.play
)

d.set(\fundamental, 100)
d.set(\base, 200)


(
SynthDef(\wow, {
    |freq = 60, amp = 0.1, gate = 1, wowrelease = 3|
    var chorus, source, filtermod, env, snd;
    chorus = Lag.kr(freq, 2) * LFNoise1.kr([0.4, 0.5, 0.7 , 1, 2, 5, 10]).range(0.99, 1.01);
    source = LFSaw.ar(chorus) * 0.5;
    filtermod = SinOsc.kr(1/16).range(1, 10);
    env = Env.asr(1, amp, wowrelease).kr(2, gate);
    snd = LPF.ar(in:source, freq: freq * filtermod, mul: env);
    Out.ar(0, Splay.ar(snd))
}).add
)

x = Synth(\wow, [\amp, 0.5, \freq, 200])
x.set(\gate, 0)
(
z = Array.fill(6, {Synth(\wow, [\freq, rrand(40, 70).midicps, \amp, rrand(0.1, 0.5)])})

//z.do{|i| i.set(\gate, 0)}

SystemClock.sched(0, {z.choose.set(\freq, rrand(40,70).midicps); rrand(1, 3)})