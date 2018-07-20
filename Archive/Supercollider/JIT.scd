(
s.boot;
p = ProxySpace.push(s);
)

~out.play;

~out = {SinOsc.ar([400, 408] * 0.8, 0, 0.2)};
~out = {SinOsc.ar([443, 600 - Rand(0, 200)], 0, 0.2)};
~out = {Resonz.ar(Saw.ar(40 + [0, 0.2], 1), [1200, 1600], 0.1) + SinOsc.ar(60*[1, 1.1], 0, 0.2)};
~out ={Pan2.ar(PinkNoise.ar(0.1), LFClipNoise.kr(2))};

~out = { arg rate = 2; Pan2.ar(PinkNoise.ar(0.1), LFClipNoise.kr(rate)) };
~out.set(\rate, 30);
~out = { arg rate = 2; Pan2.ar(Dust.ar(2000, 0.2), LFClipNoise.kr(rate)) };
~out.set(\rate, 0.1);


~lfo = { LFNoise2.kr(30, 300, 500) };
~out = { SinOsc.ar(~lfo.kr, 0, 0.15)  };
~out = { SinOsc.ar(~lfo.kr * [1, 1.2], 0, 0.1) * Pulse.ar(~lfo.kr * [0.1, 0.125], 0.5) };
~lfo = { LFNoise1.kr(30, 40) + SinOsc.kr(0.1, 0, 200, 500) };
~out = { SinOsc.ar(~lfo.kr * [1, 1.2], 0, 0.1)  };
~lfo = 410;

~lfo2 = { SinOsc.kr(0.5, 0, 600, 100)  };
~lfo = ~lfo2.abs;
~lfo2 = { SinOsc.kr(2, 0, 600, 100)  };

~lfo3 = { LFTri.kr(0.5, 0, 80, 300) };
~lfo = ~lfo2 + ~lfo3;
~lfo = ~lfo3;
~lfo = (~lfo3 / 50).sin * 200 + 500 * { LFTri.kr(~lfo.kr * 0.0015, 0, 0.1 * ~lfo3.kr / 90, 1) };
~lfo3 = { Mix(~lfo2.kr * [1, 1.2]) };

currentEnvironment.free; // free all node proxies
~out.stop;


~out.play;
p.free