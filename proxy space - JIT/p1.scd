
~out.play;|

~s1 = { Blip.ar(Rand(32,15), 100, 0.5) };
~s2 = { SinOsc.ar(400 * 0.midiratio, 0, 0.1) };
~s3 = { Pulse.ar(140, 0.2, 0.1) };


~out = { Pan2.ar(~mix.ar(1), MouseX.kr(-1,1)) };

~mix.read(~s1);
~mix.read(~s2);
~mix.read(~s4);


a = NodeProxy(s); a.play;
a.source = { Splay.ar(Blip.ar(\freq.kr(255!4))) * 0.2 };
a.set(\freq, 225!4 * 5);
a.set(\freq, 400!4)
a.source = { Splay.ar(SinOsc.ar(LFSaw.ar(\freq.kr(18 ! 4)) * 250 + 400)) * 0.2 };
b = NodeProxy(s); b.source = { MouseX.kr(0, 3) *  [1, 3, 56, 13] };
a.set(\freq, b);
a.clear; b.clear;


