t = TempoClock(110/60).permanent_(true)

p = ProxySpace(clock:t).fadeTime_(0.02).quant_(nil).push

~sig.fadeTime
~sig.clock.tempo

~sig.quant

~sig.play(vol:0.1)

~sig = {LPF.ar(Saw.ar([60, 61] * 3.midiratio),~lfo.kr(1))}


~lfo = {SinOsc.kr(p.clock.tempo).exprange(100, 4000)}



~x.play(vol:0.1)

~y.vol_(0.1)

~x = {Ringz.ar(~trig.ar, [782, 1032], 1.4) * SinOsc.ar(12 * ~p.kr(1, ~count.kr))}

~y = {CombL.ar(~trig.ar, 0.5, 1/[792, 1031]/5, 0.2)}

~trig = {Impulse.ar(p.clock.tempo * [2, 5]/4)}

~x.stop(fadeTime:3); ~y.play(fadeTime:3);

~p = [1,5,2, 1.2, 5]

~count = {(PulseCount.ar(~trig.ar) % 1e5).poll}

p.pop

p[\x].play


Ndef(\n).fadeTime_(0.5).play(vol:0.1)

Ndef(\n, {Splay.ar(BPF.ar(BrownNoise.ar(1),([58, 60, 63, 65] + 2).midicps, 0.001, 50))})


(
Tdef(\npat,
    {
    loop {
        [4, 3, -2, 7].do{
                |n|
                Ndef(\n,    {Splay.ar(BPF.ar(BrownNoise.ar(1),([58, 60, 63, 65] + n +[12, 0]).midicps, 0.001, 50))});
                2.wait;
            }
        }
    }
).play
)

Tdef(\npat).stop

Ndef(\n).end(2)

Ndef.clear