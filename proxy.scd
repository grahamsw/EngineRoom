s.boot;

p = ProxySpace.new.push;
// a stable output location,
// connected (by .play) to the hardware output
~out = { \in.ar(0!2) }; ~out.play;

// a sawtooth oscillator
~osc = { |freq = 60, amp = 0.1|
    Saw.ar(freq, amp).dup
};

// connect to output
~osc <>> ~out;

// detune it
~osc = { |freq = 460, amp = 0.1, detun = 1.106|
    Mix(Saw.ar(freq * [1, detun], amp)).dup
};

// a filter -- \in.ar(0!2) defines an audio input
~lpf = { |ffreq = 800, rq = 0.651|
    RLPF.ar(\in.ar(0!2), ffreq, rq)
};

// repatch
~osc <>> ~lpf <>> ~out;

// amp envelope
~eg = { |gt = 1|
    \in.ar(0!2) * EnvGen.kr(
        Env.adsr(0.01, 0.1, 0.6, 0.1),
        gt
    )
};
~lpf <>> ~eg <>> ~out;

// now too quiet
~osc.set(\amp, 0.2);

// run some notes
TempoClock.tempo = 124/60;

~player = Pbind(
    \skipArgs, [\amp],
    \midinote, Pseq([Pn(36, { rrand(3, 8) }), 39], inf),
    \dur, Pwrand([0.25, 0.5], [0.9, 0.1], inf)
);

// filter eg
~ffreq = 400;
~feg = { |t_trig = 1, freqMul = 25|
    var eg = EnvGen.kr(
        Env.perc(0.01, 0.1, level: freqMul),
        t_trig, levelBias: 1
    );
    (~ffreq.kr(1) * eg).clip(20, 20000)
};

// patch the filter envelope to the filter's frequency input
~lpf.set(\ffreq, ~feg);

~feg.set(\freqMul, 40);
~lpf.set(\rq, 0.1);

// change the pattern to accent only some notes
~player =  Pbind(
    \skipArgs, [\amp],
    \midinote, Pseq([Pn(36, { rrand(3, 8) }), 39], inf),
    \dur, Pwrand([0.25, 0.5], [0.9, 0.1], inf),
    \t_trig, Pwrand([0, 1], [0.7, 0.3], inf)
);

// we're done, remove everything
p.clear;
p.pop;