p = ProxySpace.push(s);

~out.play
(
~out = { arg freqOffest;
    var ctl;
    ctl = Control.names(\array).kr(Array.rand(8, 400, 1000));
    Pan2.ar(Mix(SinOsc.ar(ctl + freqOffest, 0, 0.1 / 8)), LFNoise0.kr(2))
};
)

().play
~out.setn(\array, Array.exprand(8, 400, 2000));
~out.set(\freqOffest, rrand(300,200));
~out.map(\freqOffest, ~lfo);

// a simpler short form for this is:
(
~out = { arg freqOffest=0, array = #[ 997, 777, 506, 553, 731, 891, 925, 580 ];
    Pan2.ar(Mix(SinOsc.ar(array + freqOffest, 0, 0.1 / 8)), LFNoise0.kr(2))
};
)