// Execute the following in order
(
// allocate a Buffer
s = Server.local;
b = Buffer.alloc(s, 44100 * 4.0, 1); // a four second 1 channel Buffer
)
​
// record for four seconds
(
SynthDef(\help_RecordBuf, { arg bufnum = 0;
    RecordBuf.ar(SoundIn.ar, bufnum, doneAction: Done.freeSelf, loop: 0);
}).play(s,[\out, 0, \bufnum, b]);
)
​
// play it back
(
SynthDef(\help_RecordBuf_playback, { arg out = 0, bufnum = 0;
    var playbuf;
    playbuf = PlayBuf.ar(1,bufnum);
    FreeSelfWhenDone.kr(playbuf); // frees the synth when the PlayBuf is finished
    Out.ar(out, playbuf);
}).play(s, [\out, 0, \bufnum, b]);
)


b.play

b.numChannels

(
s.meter;
s.plotTree;
s.scope;
)
(

{
    var sig;
    var rate = 40;
    sig = GrainBuf.ar(
        2,
        Impulse.ar(rate),
        0.5,
        b,
        MouseX.kr(0.5, 2, 1).poll ,
        (
            Phasor.ar(0, MouseY.kr(0.1, 5).poll * BufRateScale.ir(b), 0, BufSamples.ir(b)-1) +
            LFNoise1.ar(100).bipolar(0.001 * SampleRate.ir))/BufSamples.ir(b),
        2,
        0,
        -1,
        512
    );

}.play;)



(\amp: 1).play


(
SynthDef(\scatter, {
    |out = 0, buf=0, tfreq=20, rate=1, posStart=(-0.8), posEnd=0.8, posShiftDur=5|
    var sig, trigger, pan, phasor;
    trigger = Impulse.ar(tfreq);
    pan = Line.ar(posStart, posEnd, posShiftDur)+ (LFNoise0.ar(tfreq)*EnvGen.ar(Env(times:[posShiftDur/2, posShiftDur/2])));
    phasor =  (Phasor.ar(0, 1 * BufRateScale.ir(b), 0, BufSamples.ir(b)-1) +
            LFNoise1.ar(100).bipolar(0.001 * SampleRate.ir))/BufSamples.ir(b);
    sig = GrainBuf.ar(
        2,
        trigger,
        2/tfreq,
        buf,
        rate,
        phasor,
        pan:pan
    );
    Out.ar(out, sig);
}).add;
)



Synth(\scatter, [\buf, b, \tfreq, 200, \posStart, -1, \posEnd, 1])





​