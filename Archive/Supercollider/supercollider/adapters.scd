
(
SynthDef(\ping,
	{
		|freq = 440 |
		Out.ar(0,
			SinOsc.ar(freq, 0,
				EnvGen.kr(Env.perc(level: 0.1), doneAction:2)));
}).add;

SynthDef(\wham,
	{
		Out.ar(0, BrownNoise.ar( EnvGen.kr(Env.perc(level:0.1), doneAction:2)));
}).add;

)


(
~sound_adapter = {
	|counter, what, count|
	switch(what,
		\max_reached, {Synth(\wham)},
		//\max_reached, {counter.reset},
		\count, {Synth(\ping, [\freq, count.postln * 10 + counter.max_count * 20])}
	)
};
)

(
~make_display =
{
	|counter|
	var window, label, adapter, stagger;
	window = Window("counting to " ++ counter.max_count.asString,
		Rect(stagger = UniqueID.next % 20 * 20 + 400,  stagger, 200, 50));
	label = StaticText(window, window.view.bounds.insetBy(10, 10)).string="poo";
	adapter = {
		|counter, what, count|
		{label.string = counter.current_count.asString}.defer;
	};

	counter.addDependant(adapter);
	window.onClose = {counter.removeDependant(adapter);};
	window.front;
};
)







~counters = (6, 11 .. 26) collect: Counter2.new(_);
~counters.do(_.addDependant(~sound_adapter));
~counters.do(~make_display.(_))
(
~count = {loop
	{
		~counters.do(_.count1);
		0.25.wait;
	}
}.fork;
)
~count.stop