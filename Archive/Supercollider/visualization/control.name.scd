(
Server.default.waitForBoot({
	fork{
		var synth;
		SynthDef(\controlExample,
			{
				var frequencies = Control.names([\freqs]).kr([100,200,300,400]);
				var sound = Mix.new(SinOsc.ar(frequencies) * 0.1);
				Out.ar(0, sound!2);
		}).add;
		Server.default.sync;

		synth = Synth(\controlExample);
		fork{loop{
			var newFreqs = Array.fill(4, {arg i; rrand(100, 1000)});
			synth.set(\freqs, newFreqs);
			1.wait;
		}};
}});
)
				