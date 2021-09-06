(
MIDIClient.init;

MIDIClient.destinations;
m = MIDIOut.new(1);

)

(
CmdPeriod.add(
    {
90.do{
    |n|
    m.noteOff(0,n)
}
    }
)
)

// this is a great little hook
(
t = TempoClock(5);


p = Pdef(\k, Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, m,
    \chan, 0,
    \midinote, Pseq([10,2,3,5,7]+60, inf),
    \amp, Pexprand(5, 120,inf)/127,
    \sustain, 1,
    \dur, 1

)).play(t,quant:4)
)