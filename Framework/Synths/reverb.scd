(
SynthDef(\reverb, {
	| in, mix = 0.33, room = 0.5, damp = 0.5, out = 0 |
	Out.ar(out, FreeVerb.ar(In.ar(in, 1), mix: mix, room: room, damp: damp));
}).add;
)