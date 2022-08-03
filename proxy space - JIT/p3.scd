~out = { SinOsc.ar([220, 330], ~out.ar(2).reverse * LFNoise2.kr(0.5, 4pi), 0.4) };

~out.clear

// there is no immediacy: hear the buffer size cycle
~out = { Impulse.ar(1 ! 2) + (~out.ar(2) * 0.99) };

~out.play

// SuperCollider 'differential equations'

~out = { SinOsc.ar(Slope.ar(~out.ar) * MouseX.kr(1000, 18000, 1)) * 0.1 + SinOsc.ar(100, 0, 0.1) };

(
~out = { var z, zz;
    z = Slope.ar(~out.ar);
    zz = Slope.ar(z);
    SinOsc.ar(Rand(300,410), z) *
    SinOsc.ar(zz * 410)
    * 0.1 + Decay2.ar(Pan2.ar(Dust.ar(600), MouseX.kr(-1,1)), 0.01, 0.05);
}
)


(
~out = { arg freqOffest;
    var ctl;
    ctl = Control.names(\array).kr(Array.rand(8, 400, 1000));
    Pan2.ar(Mix(SinOsc.ar(ctl + freqOffest, 0, 0.1 / 8)), LFNoise0.kr(2))
};
)

~out.play
~out.setn(\array, Array.exprand(8, 400, 2000));
~out.set(\freqOffest, rrand(300,200));
~out.map(\freqOffest, ~lfo);

// a simpler short form for this is:
(
~out = { arg freqOffest=0, array = #[ 997, 777, 506, 553, 731, 891, 925, 580 ];
    Pan2.ar(Mix(SinOsc.ar(array + freqOffest, 0, 0.1 / 8)), LFNoise0.kr(2))
};
)

// unary operators
~lfo2 = { SinOsc.kr(0.5, 0, 600, 100) };
~lfo = ~lfo2.abs;
~lfo2 = { SinOsc.kr(1.3, 0, 600, 100) };

// binary operators
~lfo3 = { LFTri.kr(0.5, 0, 80, 300) };
~lfo = ~lfo2 + ~lfo3;
~lfo = ~lfo3;
~lfo = (~lfo3 / 50).sin * 200 + 500 * { LFTri.kr(~lfo.kr * 0.0015, 0, 0.1 * ~lfo3.kr / 90, 1) };
~lfo3 = { Mix(~lfo2.kr * [1, 1.2]) };

currentEnvironment.free; // free all node proxies
~out.stop; // free the playback synth.

p.clear
~out.play

~out.clear(5)

~out1 = { SinOsc.ar(600, 0, 0.1) };
~out2 = { SinOsc.ar(500, 0, 0.1) };
~out3 = { SinOsc.ar(400, 0, 0.1) };
~out = ~out2 + ~out1 + ~out3;

~out = ~out1 + ~out2;
~out = ~out1;
10.do{|i| i.postln}
// another way is:
~out = { SinOsc.ar(600, 0, 0.1) };
~out.add({ SinOsc.ar(500, 0, 0.1) });
~out.add({ SinOsc.ar(400, 0, 0.1) });

// or with direct access:
(
10.do{|i|
    ~out[i] = { LFSaw.ar(\freq.kr([100, 101])* (1+(1*i))*rrand(0.99, 1.01), 0, 0.1/(1+i)) };
}
)
~x = {MouseX.kr(50, 100).round(10)}
~y = {MouseY.kr(50, 100).round(10)}

~out.set(\freq, [~x, ~y])
~out[1] = { SinOsc.ar(500, 0, 0.1) };
~out[2] = { SinOsc.ar(400, 0, 0.1) };





p.clear

~out.play;
~out = { Pan2.ar(SinOsc.ar(~lfo.kr, 0, 0.2), sin(~lfo.kr / 10)) }; // ~lfo is kept, as its parents.
~lfo = { LFNoise2.kr(3, 160, 400) };

p.keysValuesDo { arg key, proxy; [key, proxy.isPlaying].postln };
p.reduce; // all monitoring proxies (in this case ~out) are kept running.
// equivalent: p.reduce(to: [~out]);
p.keysValuesDo { arg key, proxy; [key, proxy.isPlaying].postln };

// to remove everything else:
p.postln;
p.clean; // all monitoring proxies (in this case ~out) are kept.
p.postln;

// after ~out is stopped, it is removed, too:
~out.stop; // stop monitor
p.clean;
p.postln; // empty space.


// you can .play .kr or .ar also a name that is not yet used.
// the rate is guessed as far as possible. on this topic see also: [the_lazy_proxy]

~myOut.play; // play some key (audio rate is assumed)

// the rate is determined from the first access:
// like this ~lfo becomes control rate

~myOut = { SinOsc.ar(~freq.kr * 2, 0, 0.1) };
~freq = 900;
~freq = { SinOsc.kr(115, 0, 70, 220) }

~myOut = { SinOsc.ar(~otherFreq.ar * 2, 0, 0.1) };
~otherFreq = { SinOsc.ar(115, 0, 70, 220) };

currentEnvironment.clear; // clear every proxy in this environment and remove them. (same: p.clear)



~out.play;
​
~out.fadeTime = 4;
~out = { SinOsc.ar(Rand(800, 300.0) * [1,1.1], 0, 0.1) };
~out = { SinOsc.ar(Rand(800, 300.0) * [1,1.1], 0, 0.1) };
~out.fadeTime = 0.01;
~out = { SinOsc.ar(Rand(800, 300.0) * [1,1.1], 0, 0.1) };
~out = { SinOsc.ar(Rand(800, 300.0) * [1,1.1], 0, 0.1) };
​
~out.free(3);    // release the synths and the group with a given fadeTime without changing proxy time
~out.stop;    // stop monitor


