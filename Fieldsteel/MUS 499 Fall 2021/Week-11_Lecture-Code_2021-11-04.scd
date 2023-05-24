(
Window.closeAll;
w = Window.new("window name", Rect(100, 200, 300, 400));
w.alwaysOnTop_(true);
w.front;
)

w.close;

Window.screenBounds;

(
Window.closeAll;
w = Window.new(
	"window name",
	Rect(
		Window.screenBounds.width/2 - 150,
		Window.screenBounds.height/2 - 200,
		300,
		400
	)
);
w.alwaysOnTop_(true);
w.front;
)

w.close;

w.bounds;
w.bounds_(w.bounds.insetBy(30, 30));

(
Window.closeAll;
w = Window.new(
	"window name",
	Rect(
		Window.screenBounds.width/2 - 150,
		Window.screenBounds.height/2 - 200,
		300,
		400
	)
);
w.alwaysOnTop_(true);
w.front;
~sl = Slider.new(w, Rect(40, 20, 30, 150));
~btn = Button.new(w, Rect(100,20,50,30));
~btn.states_([
	["0", Color.blue, Color.red],
	["1", Color.black, Color.white]
])
)

~sl.background_(Color.fromHexString("ceba3d"));
~sl.knobColor_(Color.cyan);

~sl.knobColor;

~sl.value;
~sl.value_(0.9);

~btn.value;

(
Window.closeAll;
w = Window.new(
	"window name",
	Rect(
		Window.screenBounds.width/2 - 150,
		Window.screenBounds.height/2 - 200,
		300,
		400
	)
)
.alwaysOnTop_(true)
.front;

~sl = Slider.new(w, Rect(40, 20, 30, 150))
.action_({
	arg view;
	if(
		~syn.isPlaying,
		{~syn.set(\amp, view.value)};
	);
});

~btn = Button.new(w, Rect(100,20,50,30))
.states_([
	["0", Color.blue, Color.red],
	["1", Color.black, Color.white]
])
.action_({
	arg view;
	if(
		view.value == 1,
		{
			~syn = Synth.new(
				\default, [
					\amp, ~sl.value,
					\freq, ~freqspec.map(~knb.value)
				]
			).register
		},
		{~syn.set(\gate, 0)}
	);
});

~freqspec = \freq.asSpec;

~knb = Knob.new(w, Rect(100, 60, 50, 50))
.action_({
	arg view;
	if(
		~syn.isPlaying,
		{~syn.set(\freq, ~freqspec.map(view.value))}
	);
});
)

~syn = Synth.new(\default);
~syn.free;

~knb.value.linexp(0,1,20,20000);

~freqspec = ControlSpec.new(20, 20000, 'exp');
~freqspec = \freq.asSpec;
Spec.specs.keys.do({ arg n; n.postln });

~freqspec.map(~knb.value);

~btn.value_(0);
~btn.valueAction_(1);
~btn.valueAction_(0);

~knb.valueAction_(0.2);
~sl.valueAction_(0);