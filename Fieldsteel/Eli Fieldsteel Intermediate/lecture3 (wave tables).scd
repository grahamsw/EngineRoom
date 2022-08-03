

// create cyclic shape (Env, Signal, Buffer)
// convert to Wavetable format
// load into Buffer
// use Wave Table oscillator UGen to read buffer at some Hz


(
Window.closeAll;
~sig = Signal.sineFill(4096, 1/(1..16));
~wt = ~sig.asWavetable;
Routine({
    Buffer.freeAll;
    s.sync;
    ~buf = Buffer.alloc(s, 8192);
    s.sync;
    ~buf.sendCollection(~wt);
    s.sync;
    ~buf.plot;
}).play(AppClock);
)
~buf

(\midinote:67).play
(
{ var sig;
    sig = Osc.ar(~buf, MouseX.kr(16, 5000,1).poll + Osc.ar(~buf, MouseY.kr(10, 10000), mul:100)) * 0.1!2;
}.play
)

Array.exprand(24, 1, 16).round.sort