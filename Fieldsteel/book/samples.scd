().play
(
x = {
    |gate=1|
    var env, sig;
    env = EnvGen.kr(Env([0, 1, 0.05, 1, 0], [2, 4, 2, 3], -20, 3, 2),gate, doneAction:0);
    sig = SinOsc.ar;
    sig  = env * sig;
    sig!2
}.play
)
    Env([0, 1, 0.1, 1, 0], [2, 4, 2, 3], -20).plot


x.set(\gate, 1)


(
    f = {|t_gate=1|
        var sig, env;
        env = EnvGen.kr(envelope:Env.new([0, 1, 0.2, 0], [0.01, 0.3, 4], [0, -1, 0]), gate:t_gate, doneAction:0);
        sig = SinOsc.ar(350) * 0.3;
        sig = sig * env;
        sig = sig!2;
    }.play
)

f.set(\t_gate,1)

{ SinOsc.ar(330, mul:0.2)!2}.play



(
{
    var mod, sig, modHz;
    modHz = XLine.kr(1, 250, 10);
    mod = SinOsc.ar(modHz).range(0, 1);
    sig = SinOsc.ar(750, mul:mod);
    sig = sig*0.2!2;
}.play;
)

(
x =
{
    |freq = 400, modFreq = 100, modAmp = 300, amp = 0.1|
    var sig, mod;

    mod = SinOsc.ar(modFreq, mul:modAmp);
    sig = SinOsc.ar(freq + mod);
    sig = sig*amp!2;
}.play
)

x.set(\modFreq, 200)
x.set(\modAmp, 30)


(
{

    var sig, mod1, mod2;
    mod2 = SinOsc.ar(0.2, mul:450);
    mod1 = SinOsc.ar(500, mul:800);
    sig = SinOsc.ar(1000 + mod1 + mod2);
    sig = sig * 0.2 ! 2;
}.play
)


(

x = {
    var sig, mod;
    mod = LFTri.ar(0.2).range(0, 1);
    sig = VarSaw.ar(400, width:mod);
    sig = sig * 0.2 ! 2;
}.play;
)

{LFTri.ar}.plot



(
~wt = Signal.sineFill(8192, [1, 0.5, 0.25], [0, pi, pi/2]).asWavetable;
b = Buffer.loadCollection(s, ~wt);
)

{Osc.ar(b, 400)*0.2!2}.play

Buffer.freeAll


(
b = Buffer.allocConsecutive(4, s, 16384);
~wt = [
    Signal.sineFill(8192, 1!4, 0!4),
    Signal.sineFill(8192, 1/(1..50), 0!50),
    Signal.sineFill(8192, [1/(1, 3..50), 0!25].lace(50), 0!50),
    Signal.sineFill(8192, Array.exprand(50, 0.001, 1).sort.reverse, {rrand(0, 2pi)}!50)
];


b.do({|buf, i| buf.loadCollection(~wt[i].asWavetable)});
)

~wt.plot

(
{
    var sig, bufmod;
    bufmod = SinOsc.kr(0.5, 3pi/2).unipolar(2.999);
    sig = VOsc.ar(b[0].bufnum + bufmod, 200);
 //   sig = sig * 0.2 ! 2;
}.play
)


(
~wt = Env.new([-1,0,1], [1,1], [4, -4]).asSignal(8193);
b = Buffer.loadCollection(s, ~wt.asWavetableNoWrap);
)

~wt.plot


(
{
    var sig, index;
    index = SinOsc.ar(XLine.kr(50,200, 10));
    sig = Shaper.ar(b, index);
    sig = sig * 0.2 !2;
}.play
)

(
x=
{
    |hh=8|
    var sig, freq;
    freq = LFDNoise1.kr(hh).exprange(120, 2000);
    sig = SinOsc.ar(freq);
    sig * 0.2 !2;
}.play
)

x.set(\hh, 158)



({LFNoise0.ar(XLine.kr(100, s.sampleRate, 8))*0.1!2}.play)

({LFNoise1.ar(XLine.kr(100, s.sampleRate, 8))*0.1!2}.play)

({LFNoise2.ar(XLine.kr(100, s.sampleRate, 8))*0.1!2}.play)

({LFDNoise0.ar(XLine.kr(100, s.sampleRate, 8))*0.1!2}.play)

({LFDNoise1.ar(XLine.kr(100, s.sampleRate, 8))*0.1!2}.play)

({LFDNoise3.ar(XLine.kr(100, s.sampleRate, 8))*0.1!2}.play)


(x = {
    var sig, cutoffHigh, cutoffLow;
    cutoffHigh = LFTri.kr(0.1, pi/).exprange(100, 10000);
    cutoffLow = LFTri.kr(0.1, 0).exprange(100, 10000);
    sig = PinkNoise.ar;
    sig = LPF.ar(HPF.ar(sig, cutoffHigh), cutoffLow);
}.play
)





(
x = {
    var sig, cutoff, rq;
    cutoff = LFTri.kr(0.1, 3).exprange(100, 10000);
    sig = PinkNoise.ar;
    rq = MouseX.kr(0.01,1,1).clip(0.01,1);
    [rq, 1/rq.sqrt].poll(1);
    sig = BPF.ar(sig, cutoff, rq, 1/rq.sqrt)*0.5!2;
}.play
)


(
x = {
    var sig, cutoff;
    sig = WhiteNoise.ar;
    7.do({sig = LPF.ar(sig, 1000)});
    sig * 0.8 ! 2;
}.play;
)

(
x = {
    var sig, cutoff, freq;
    freq = LFNoise0.kr(1).range(25, 49).round(1).midicps;
    cutoff = VarSaw.kr(2, width:0.1).exprange(50, 10000);
    sig = Pulse.ar(freq * [0.99, 1.01]);
    sig = RHPF.ar(sig, cutoff, MouseX.kr(0.01, 1));
    sig = sig*0.1 !2;
}.play
)








{VarSaw.kr(1, width:0.1).exprange(50, 10000)}.plot(1)


(
x = {
    var sig, exc;
    exc = Impulse.ar(1);
    sig = Ringz.ar(
        in:exc,
        freq: 800,
        decaytime: 1/3
    );
    sig = sig * 0.2 ! 2;
}.play
)



(
x = {
    var sig, exc;
    exc = PinkNoise.ar(1);
    sig = Resonz.ar(
        in:exc,
        freq: 800,
        bwr: 0.001,
        mul: 1/0.001.sqrt
    );
    sig = sig * 0.5 ! 2;
}.play
)


(
{
    var sig, mod;
    mod = SinOsc.kr(0.1, 3pi/2).exprange(0.2,4);
    sig  = SinOsc.ar(300, mul:mod);
    sig = Wrap.ar(sig, -1, 1);
    sig = sig * 0.2 !2;
}.play;
)


(
{
    var sig, mod;
    mod = SinOsc.kr(0.1, 3pi/2).exprange(0.2,4);
    sig  = SinOsc.ar(300, mul:mod);
    sig = sig.tanh;
    sig = sig * 0.2 !2;
}.play;
)


(
{
    var sig, mod;
    mod = SinOsc.kr(0.1, 3pi/2).exprange(0.2,4);
    sig  = SinOsc.ar(300, mul:mod);
    sig = sig.tanh;
    sig = sig * 0.2 !2;
}.play;
)




(
x = {
    var sig, mod;
    mod = SinOsc.ar(0.1).range(0.01, 0.5);
    mod = SinOsc.ar().range(0, mod);
    sig = PinkNoise.ar(mod);
    sig !2
}.play)


(
x = {
    var sig, mod;
    mod = SinOsc.ar(0.2, 3pi/2).exprange(0.02, 1);
    sig = SinOsc.ar(300);
    sig = sig.round(mod);
    sig * 0.2 ! 2;
}.play
)


(
x = {
    var sig, modRate, modRes;
    modRate = SinOsc.ar(0.2, 3pi/2).exprange(SampleRate.ir/2, SampleRate.ir/100);
    modRes = SinOsc.ar(0.1, pi/2).exprange(0.2, 0.7);
    sig = SinOsc.ar(300);
  //  sig = Latch.ar(sig, Impulse.ar(modRate));
    sig = sig.round(modRes);
    sig * 0.2 ! 2;
}.play
)




// Buffers
(
~filename = "C:/Users/graha/OneDrive/Desktop/sound/eli Tutorial Piece/buffers/deskBells/deskBell08_G.aiff";
~buff = Buffer.read(s, ~filename);
)
~buff.plot

~buff.bufnum;
~buff.duration

~buff.numFrames
~buff.numChannels
~buff.sampleRate

s.options.sampleRate

~pwd = PathName(".".resolveRelative)
~pwd.folders.collect({|f| f.folderName})

["aif", "aiff", "wav"].includesEqual("aif")


44100/48000


b = Buffer.alloc(s, s.sampleRate * 0.5, 1);

(
{

    var sig = SinOsc.ar(ExpRand(200, 1200));
    sig = sig * Env.perc(0.01, 0.49).ar(2);
    RecordBuf.ar(sig, b, recLevel:0.5, preLevel: 0.5);
    sig = sig *0.25!2;
}.play;
)

b.plot

b.zero

(
x = {
    var sig, freq;
    freq = TExpRand.ar(200, 1200, Dust.ar(12));
    sig = SinOsc.ar(freq.lag(0.02));
    RecordBuf.ar(sig, b, recLevel:1, preLevel: 0.5,loop:1);
    sig = PlayBuf.ar(1, b, BufRateScale.kr(b), loop:1)*0.25!2;
  //  sig = sig*(0.25)!2;
}.play
)

x.release(2)

y = {PlayBuf.ar(1, b, BufRateScale.kr(b), loop:1)*0.25!2}.play

y.release(2)
b.numChannels
b = Buffer.alloc(s, s.sampleRate *2, 2)
(
b.zero;

 x = {
    var sig, frq, phs, delay;
    frq  = TExpRand.ar(200, 1200, Dust.ar(2)!2);
    sig = SinOsc.ar(frq.lag(0.02));
    phs = Phasor.ar(0, BufRateScale.kr(b), 0, BufFrames.kr(b));
    BufWr.ar(sig, b, phs);
    delay=BufRd.ar(2, b, phs-SampleRate.ir/1);
    sig = sig + (delay*0.5);
    sig = sig *0.25;

}.play
)


(
b.zero;

x = {
    var freq, phs, sig;
    freq =  TExpRand.ar(200, 1200, Dust.ar(12)!2);
    sig = SinOsc.ar(freq.lag(0.02), mul: 0.25);
    sig = sig * Line.kr(0, 1, 0.02);
    phs = Phasor.ar(0, BufRateScale.kr(b), 0, BufFrames.kr(b));
    sig = sig + (BufRd.ar(2, b, phs) * 0.75);
    BufWr.ar(sig, b, phs);
    sig = sig * 0.25;

}.play;
)

x.release(2)