(
  SynthDef(\input_writer, {
        var mic;
        mic = SoundIn.ar(\inbus.kr(0));
        Out.ar(\outbus.kr(0), mic);
    }).add;

SynthDef(\scramble, {
	var sig, chain, size=2048;
	sig = In.ar(\inbus.kr(0));
/*     chain = FFT(LocalBuf(size), sig);
     chain = PV_BinScramble(chain, \wipe.kr(0), \width.kr(0), \trig.tr(0));
     sig = IFFT(chain) * \amp.kr(0.5);*/
	Out.ar(\outbus.kr(0), sig );
}).add;
)

~bus = Bus.audio(s, 1)

Synth(\input_writer, [\outbus, ~bus])
s.latency = 0.01

s.latency
s.reboot
s.meter
(


~scrambler = Synth(\scramble,[\inbus, ~bus]
)


~scrambler.set(\wipe, 0.1, \width, 0.71, \trig, 1);
x.free;
