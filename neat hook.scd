// this is a great little hook
(
p = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, m,
    \chan, 0,
    \midinote, Pseq([10,2,3,5,7]+60, inf),
    \amp, Pexprand(5, 100,inf)/127,
    \sustain, 0.02,
    \dur, 0.15

).play
)