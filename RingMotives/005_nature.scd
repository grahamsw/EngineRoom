(
// 5: Nature

~nature_005 = {
	var midi_005_nature = [39, 46] ++ [51, 55] ++ [58, 63] ++ [67];
	var durs_005_nature = [5, 1].dup(3).flat ++ [6];

	Pbind(
	    \midinote, Pseq(midi_005_nature, inf),
		\dur, Pseq(durs_005_nature , inf)
	    );
}

)

~nature_005.().play
~clock = TempoClock(1);

~clock.tempo=10

Pdef(\nature, ~nature_005.())
().play

Pdef(\nature).play(~clock,quant:1)

n.(\ctranspose, 12)




SynthDef("harpsichord1", { arg out = 0, freq = 440, amp = 0.1, pan = 0;
    var env, snd;
	env = Env.perc(level: amp).kr(doneAction: 2);
	snd = Pulse.ar(freq, 0.25, 0.75);
	snd = snd * env;
	Out.ar(out, Pan2.ar(snd, pan));
}).add;

(

Pdef( \nature_5,
	Pbind(
		\midinote, Pseq([39, 51, 58, 67], inf),
		\dur, Pseq([1], inf)
	)
);
)

(

Pdef( \nature_6,
	Pbind(
		\midinote, Pseq([39, 47, 34, 37], inf),
		\dur, Pseq([1], inf)
	)
);
)


t = TempoClock(12);

t.tempo = 2


	Pdef(\nature_5).play(t, quant:4)

	Pdef(\nature_6).play(t, quant: 4)


Pdef(\nature_5).stop
(

Pdef( n1,
	Pbind(
		\midinote, Pseq([39, 46] ++ [51, 55] ++ [58, 63] ++ [67], inf),
		\dur, Pseq([5, 1].dup(3).flat ++ [6], inf)
	)
);
)