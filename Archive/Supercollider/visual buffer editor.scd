
(
var buffer = Buffer.alloc(s, 512);
var plotter = Plotter.new("wavetable", 800@300).value_(0!256).editMode_(true).editFunc_(
	{|plotter|
	var signal = plotter.value.as(Signal);
	var wavetable = signal.asWavetable;
	buffer.sendCollection(wavetable, 0);
});
{Out.ar(0, Osc.ar(buffer, 250))}.scope(zoom:1.8);
)