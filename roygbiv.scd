().play


(

    // this first
var lfo = { |freq, phase, gate|
  var phasor = (Phasor.kr(gate, freq * 2pi / ControlRate.ir, 0, 2pi) + (phase * 2pi)).wrap(0, 2pi);
  SinOsc.kr(0, phasor);
};

var vco = { |freq, amp|
  var slop = 0.01;
  var rate = freq + LFNoise1.ar(LFNoise1.kr(1).range(0.2, 0.3), mul: slop * (freq / 1000));
  var phase = Phasor.ar(DC.ar(0), rate / SampleRate.ir, 0, 1) * 2pi;
  var k = 12000 * (SampleRate.ir/44100) / (freq * log10(freq));
  var sinSig = SinOsc.ar(0, phase);
  var cosSig = SinOsc.ar(0, phase + (pi/2));
  var sqSig = tanh(sinSig * k);
  var sawSig = sqSig * (cosSig + 1) * 0.5;
  [sqSig, sawSig] * amp;
};

SynthDef(\roygbiv, { |out = 0, midinote = 40, gate = 0|
  var note = midinote.lag2(0.03);
  var freq1 = (note + (lfo.(1.75, 0.75, gate) * 0.2)).midicps;
  var freq2 = (note - 12 + (lfo.(0.98, 0, gate) * 0.25)).midicps;
  var sig = vco.(freq1, 0.4)[1] + vco.(freq2, 0.1)[0] + WhiteNoise.ar(0.04);
  var env = Env.adsr(0.001, 3.3, 0.3, 0.17).ar(0, gate);
  var cutoff = 80 * (env * LFNoise1.kr(0.2).range(40, 45)).midiratio;
  sig = DFM1.ar(sig, cutoff, 0.05, 2.1);
  sig = sig * Env.adsr(0.001, 0, 1, 0.18).ar(0, gate);
  Out.ar(out, sig!2 * 0.22);
}).add;
)


( // then this
x.free; y.free; r.stop;

x = Synth(\roygbiv);

y = {
  var dry = BHiPass.ar(In.ar(0, 2), 80);
  var wet = NHHall.ar(LPF.ar(dry, 3000), 1.3, hiFreq: 2000, hiRatio: 0.1);
  ReplaceOut.ar(0, dry + (wet * 0.85));
}.play(addAction: 'addToTail');

r = fork {
  loop {
    x.set(\midinote, rrand(38, 52), \gate, 1);
    exprand(0.2, 2).wait;
    x.set(\gate, 0);
    exprand(0.01, 0.03).wait;
  }
}
)


// stop sound
r.stop; x.set(\gate, 0);

// free synths
x.free; y.free;