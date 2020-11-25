y = NodeProxy.audio(s, 2);
z = NodeProxy.audio(s, 2);

// use them in calculation
z.play;
z.source = { (y * 0.5) };


// set its source now.
y.source = { LFTri.ar([300, 300.5]) * SinOsc.ar(295)} ;

// the source can be of various type, one of them would be a number:
y.source = 0.0;

// post the source
y.source;

// end them, free their bus number
y.clear;
z.clear;


ServerTree.removeAll

p = ProxySpace.push
~x = {SinOsc.kr(4)}
~y = {SinOsc.kr(1/5).range(1, 5)};
~z = {LFSaw.ar(400 * ~x ) * LFTri.kr(1/3).range(0, 0.3)}

~z.play

~x = {SinOsc.kr(~y)}

p.clear(2).pop
