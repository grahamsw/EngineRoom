(
SynthDef(\gabberkick, {
     var snd;
     snd = SinOsc.ar(Env([1000, 69, 60], [0.015, 0.1], \exp).ar * [-0.1,
0, 0.1].midiratio);
     snd = Mix(snd);
     snd = (snd * 10).tanh;
     snd = (snd * 5.1).atan;
     snd = BPeakEQ.ar(snd, XLine.kr(2000, 100, 0.3), 2.0, 8);
     snd = snd + DelayC.ar(snd, 0.1, SinOsc.ar(4).range(0.0, 0.001));
     snd = RLPF.ar(snd, 6000, 0.7);
     snd = snd * Env([0, 1, 0.7, 0.7, 0], [0.001, 0.01, 0.3,
0.02]).ar(2);
     snd = (snd * 0.6).clip(-1, 1);
     Out.ar(\out.kr(0), Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1)));
}).add;
)


Synth.new(\gabberkick)


(
SynthDef(\aouw, {
     var in, snd;
     snd = SinOsc.ar(Env([5000, 69, 60], [0.015, 0.1], \exp).ar * [-0.1,
0, 0.1].midiratio, 0.5pi);
     snd = snd.sign - snd;
      snd = Mix(snd) * Env.perc(0.001, 0.3).ar;
    snd = (snd * Line.kr(1, 2, 0.05)).tanh;
     snd = BPeakEQ.ar(snd, XLine.kr(100, 1000, 0.7), 0.3, 10);
     snd = (snd * 4).tanh * 5;
     snd = BPeakEQ.ar(snd, XLine.kr(800, 100, 0.7), 0.4, 6);
     snd = (snd * 5).atan;
     snd = RHPF.ar(snd, XLine.kr(800, 100, 0.7), 0.3);
     snd = BHiShelf.ar(snd, 100, 1, -8);
     snd = (snd * 10).tanh;
     snd = snd * Env.linen(0.001, 0.3, 0.08).ar(2);
/*	*/
     Out.ar(\out.kr(0), Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1)));
}).add;
)

Synth.new(\aouw)




