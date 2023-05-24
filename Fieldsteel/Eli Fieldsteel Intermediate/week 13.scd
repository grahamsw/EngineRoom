(
Window.closeAll;

w = Window.new("week 13", Rect(70,100,
    500,500), resizable:false, border:true
)
.alwaysOnTop_(true)
.front;

u = UserView.new(w, w.view.bounds)
    .background_(Color.gray(0.1));


u.drawFunc_({
    Pen.width_(4);
    64.do({|n|
        var x = 60 + (n*6);
        var y = b.getnSynchronous.at(n) * 40;
        Pen.strokeColor_(Color.blue);
        Pen.line(x@300, x@(300-y));
        Pen.stroke;

    });
});

)
)
p.pop
u.animate_(true)


(
x = {
    var sig, chain;
    sig = PinkNoise.ar(0.5);
    sig = BPF.ar(sig, SinOsc.kr(0.1, 3pi/2).exprange(200, 18000),0.2, 4);
    chain = FFT(LocalBuf(128),sig);


    chain = chain.pvcollect(128, {
        |mag, phs, bin, index|
        Out.kr(index, mag);
        [mag, phs];
    },1, 64);

    sig = IFFT(chain);

    sig!2;
}.play;
)
    x.free
(
s.newBusAllocators;
Bus.control(s,1); // throw this one away
b = Bus.control(s, 64);
)

v = b.getnSynchronous


s.options.numWireBufs_(512)
s.reboot