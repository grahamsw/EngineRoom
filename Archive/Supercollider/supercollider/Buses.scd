s = Server.internal

~delay = Bus.audio(s,2);
~mod = Bus.audio(s, 2);
~gate = Bus.audio(s, 2);
~k5 = Bus.control;

~controlSynth = {Out.kr(~k5, LFNoise0.kr(4))}.play;

~delaySyn = {Out.ar(0, AllpassC.ar(In.ar(~delay, 2), 2, [0.65, 1.15], 10))}.play(~controlSyn, addAction:\addAfter);

~modSyn = {Out.ar(~delay, In.ar(~mod,2) * SinOsc.ar(In.kr(~k5)*500 + 1100))}.play(~delaySyn, addAction: \addBefore);

~gateSyn = {Out.ar([0, ~mod], In.ar(~gate,2) * max(0, In.kr(~k5)))}.play(~modSyn, addAction: \addBefore);

~pbGroup = Group.before(~controlSyn);

{Out.ar(~gate, Pan2.ar(PlayBuf.ar(1, ~houston, loop:1), 0.5))}.play(~pbGroup);

