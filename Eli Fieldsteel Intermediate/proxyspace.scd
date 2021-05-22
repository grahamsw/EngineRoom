(
t = TempoClock(60/60).permanent_(true);
p = ProxySpace.new(s, \funky, t);
p.quant_(4);
p.fadeTime_(1);
p.clock_(t);
p.push;
)

p.pop
p.push

(
~pat = Pbind(
    \degree, Pseq([0, 2, 4, 7], inf),
    \dur, Pseq([5, 3, 2,1].normalizeSum *2, inf),
    \amp, Pseq([1,0.5, 0.5, 0.7]/4, inf)
);

~pat2 = Pbind(
    \degree, Pseq([9,8,7,7], inf),
    \dur, Pseq([1]/2, inf),
    \amp, Pseq([0.1!2], inf)
)

)
~dur = Pbind(\dur, 0.125!2)

~pat2 =  ~dur <> ~pat2
~pat2.play
~pat.release
~pat2.release
~pat.play

currentEnvironment

~sig.play;
~sig.release
(

~amp = 0.1;
~sig = {
    var sig, width = 0.6, pulse=8;
    sig = SinOsc.ar(300) * LFPulse.ar(pulse, width:width).range(0.02, 0.99) * ~amp;

}



)

