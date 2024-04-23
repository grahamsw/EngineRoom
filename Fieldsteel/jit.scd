g = f.play


x.source = {SinOsc.ar([310, 302] * 1, mul: 0.1)}

x.source_(nil)
x.stop


x = NodeProxy().play(vol:0.1).fadeTime_(4)

x.numChannels

x.fadeTime

t =  TempoClock(110/60).permanent_(true)

x.clock_(t).quant_(4)

x.source_({SinOsc.ar([310, 302] * rrand(1.0, 2.0) * LFPulse.kr(t.tempo * 4), mul: 1)})

(
x.source_( Pbind(
    \dur, 1/4,
    \sustain, 0.1,
    \degree, Pseq([1,3,4,5], inf),
    \amp, 1
))
)

x.vol_(0.1)




x.fadeTime
x.monitor.fadeTime


y.vol_(0.1)

y = NodeProxy().fadeTime_(4).play(vol:0.1)
z = NodeProxy().fadeTime_(4).source_({SinOsc.ar([8, 100, 500, 2000, 10000])});

z.ar(2)

z.numChannels



y.source_({SinOsc.ar([200, 202] + (z.ar(2,LFSaw.ar(20).unipolar(5)) * 1000))})

z = N

z.source_({SinOsc.ar(51)})

[y, z].do{|t| t.clear(2)}


//// ------ Ndef -----------------

t = TempoClock(120/60).permanent_(true)

t.tempo
t.tempo_(90/60)

Ndef(\z).clock_(t).quant_(1).fadeTime_(2).play(vol:0.2)
Ndef(\z, {PinkNoise.ar(1!2)})

Ndef(\z).play(vol:0.1)

Ndef(\z, {LFTri.ar(400 !2) * LFPulse.kr(t.tempo * 4)})

Ndef(\z, Pbind(\dur, 0.5, \amp, 1, \sustain, 0.1, \degree, Pseq([0, 1, 4, 5], inf)))

Ndef(\z).clock.tempo

Ndef(\y).vol_(0.2)

Ndef(\y).clock_(t).quant_(1).fadeTime_(2).play(vol:0.2)

Ndef(\y, {SinOsc.ar([60, 60.2].midicps + (Ndef.ar(\z, 2) * 2000)) * LFPulse.kr(t.tempo * 4, 0, 0.2)})

Ndef(\z).stop(fadeTime:2)


Ndef(\delay).fadeTime_(4).play(vol:0.2)

Ndef(\delay, {CombL.ar(Ndef.ar(\y, 2), 0.5, 0.5,2) * 1})

Ndef(\y).stop(fadeTime:2)