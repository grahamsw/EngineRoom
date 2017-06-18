(
SynthDef("SimpleBlip",
	{
		| midi  = 60, tone = 10, art = 0.125, amp = 0.2, pan = -1 |
		var out, temper;
		out = Pan2.ar(
			Blip.ar(
				midi.midicps,
				tone
			) * EnvGen.kr(Env.perc(0.01, art)),
			pan
		);
		DetectSilence.ar(out, doneAction:2);
		amp = amp - ((midi - 60) * 0.02);
		Out.ar(0, out * amp);
	}
).add;
)


Synth(\SimpleBlip, [\art, 2, \midi, 50, \tone, 3])

(
~inst = [ 0, 0, 0];
~pSeq = [0, 0, 0];
~scaleAdd = [4, 5, 11, nil, 10, 3, 6, nil];

~notes = [ " C", " C#", " D", " Eb", " E", " F", " F#", " G", " Ab", " A", " Bb", " B"];

~rout = Task({
	inf.do({
		| cnt1 |
		var steps, durSeq, harmSeq;
		steps = rrand(6, 12);
		if ( cnt1 % 6 == 0,
			{~scale = ~scale.add(~scaleAdd.wrapAt((cnt1/6).round(1) - 1));}
		);
		"\nIteration: ".post;
		cnt1.post;
		[" (center) ", " (right) ", " (left) "].wrapAt(cnt1).postln;
		if(cnt1%24 == 0,
			{
				~scale = [0, 2, 7, 9];
				3.do({
					|cnt2|
					~pSeq.wrapPut(cnt2, Array.fill(steps, {~scale.choose + [48, 60].choose}))}
				)
			}
		);
		"scale: ".post;
		~scale.postln;

		~pSeq.wrapPut(cnt1,
			Array.fill(steps, {~scale.choose + [48, 60].choose}));
		"MIDI seq: ".post;
		(~pSeq.wrapAt(cnt1)%12).postln;
		"Sequence (notes): ".post;
		~pSeq.wrapAt(cnt1).do (
			{
				|thisItem|
				~notes.at(thisItem%12).post
		});
		"".postln;
		harmSeq = Array.fill(steps, {rrand(1.0, 5.0)});
		durSeq = Array.fill(steps - 1, {rrand(0.01, 0.9)});

		~inst.wrapAt(cnt1).stop;
		~inst.wrapPut(cnt1,
			Task({
				inf.do({
					| cnt3|
					Synth(\SimpleBlip,
						[
						\midi, ~pSeq.wrapAt(cnt1).wrapAt(cnt3),
							\tone, harmSeq.wrapAt(cnt3),
							\art, durSeq.wrapAt(cnt3),
							\amp, rrand(0.1, 0.3),
							\pan, cnt1.wrap(-1, 2)]);
					0.125.wait;
				})
			}).start;
		);
		12.wait;
	})
}).start;
		)

		~rout.stop;

		~inst.at(0).stop;
		~inst.at(1).stop;
		~inst.at(2).stop;







)

			c.add(12)