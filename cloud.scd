(

SynthDef(\cloud,
    {
        | freq=300, amp=0.2, pan=0, spread=0.01, density=10, density_span = 0.05, freq_span=0.1, out=0|
        var sound, trigger, pan_rand, freq_rand, density_rand;
        density_rand = LFNoise1.ar(15).range(density*(1-density_span), density*(1+density_span));

        trigger = Impulse.ar(density_rand);
        freq_rand = LFNoise1.ar(15).range(freq * (1-freq_span), freq * (1+freq_span));
        sound = GrainSin.ar(1, trigger, 0.1,freq_rand);
        pan_rand = LFNoise1.ar(5).range(pan-spread, pan + spread);
        Out.ar(out, Pan2.ar(sound, pan_rand)* amp);
}).add;



)

(
x = Synth(\cloud, [\freq, 150, \freq_span, 0.005, \amp, 0.2, \spread, 0.0, \density, 15, \pan, 0]);
y = Synth(\cloud, [\freq, 200, \pan, -0.5, \amp, 0.17, \density, 25]);
z = Synth(\cloud, [\freq, 220,\freq_span, 0.005, \pan, 0.5, \amp, 0.15, \density, 15]);
t = Synth(\cloud, [\freq, 250,\freq_span, 0.05, \pan, 0.5, \amp, 0.15, \density, 15]);
)

x.set(\amp, 0.4)
x.set(\density, 35)
y.set(\spread, 0.0)
x.set(\pan, 1)
x.set(\freq_span, 0.005)
x.set(\freq, 350)


y.set(\density, 25)
y.set(\amp, 0.172)
y.set(\freq, 240)
y.set(\freq_span, 0.00)




z.set(\freq, 220)
z.set(\freq_span, 0.005)
z.set(\density, 15)
z.set(\amp, 0.0)