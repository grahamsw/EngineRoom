// Code Example 8.1

(
w = Window(
	name: "Hello World!",
	bounds: Rect(500, 400, 300, 400),
	resizable: false,
	border: false
).front;
)

w.close;



// Code Example 8.2

(
w = Window(
	"A Centered Window",
	Rect(
		Window.screenBounds.width / 2 - 150,
		Window.screenBounds.height / 2 - 200,
		300,
		400
	)
)
.alwaysOnTop_(true)
.front;
)



// Code Example 8.3

(
w = Window("A Simple Slider", Rect(500, 400, 300, 400))
.alwaysOnTop_(true).front;
x = Slider(w, Rect(40, 40, 40, 320));
)

x.remove; // remove the slider

w.close; // close the window



// Code Example 8.4

(
Window("Layout Management", Rect(100, 100, 250, 500)).front
.layout_(
	VLayout(
		HLayout(Knob(), Knob(), Knob(), Knob()),
		HLayout(Slider(), Slider(), Slider(), Slider()),
		Slider2D(),
		Button()
	)
);
)



// Code Example 8.5

(
~slider = Slider();
w = Window("A Slider", Rect(500, 400, 100, 400)).front
.alwaysOnTop_(true)
.layout_(HLayout(~slider));
)

~slider.visible; // get attribute (returns "true")

~slider.visible = false; // set attribute (make invisible)

// set multiple attributes (visible, non-interactable, and yellow)
~slider.visible_(true).enabled_(false).background_(Color(1, 1, 0));



// Code Example 8.6

s.boot;

(
~amp = 0.3;
~synth = { |amp, on = 0|
	var sig = LFTri.ar([200, 201], mul: 0.1);
	sig = sig * amp.lag(0.1) * on;
}.play(args: [amp: ~amp]);

~slider = Slider()
.value_(~amp)
.action_({ |v|
	~amp = v.value;
	~synth.set(\amp, ~amp);
});

~button = Button()
.states_([
	[ "OFF", Color.gray(0.2), Color.gray(0.8) ],
	[ "ON", Color.gray(0.8), Color.green(0.7) ]
])
.action_({ |btn| ~synth.set(\on, btn.value) });

Window("Amplitude Control", Rect(500, 400, 100, 400))
.layout_(VLayout(~slider, ~button))
.onClose_({ ~synth.release(0.1) })
.alwaysOnTop_(true)
.front;
)

~slider.valueAction_(rrand(0.0, 1.0)); // simulate random user interaction



// Code Example 8.7

(
~freqspec = ControlSpec(100, 2000, \exp);
~freq = ~freqspec.map(0.2);
~synth = { |freq, on = 0|
	var sig = LFTri.ar(freq.lag(0.1) + [0, 1], mul: 0.05);
	sig = sig * on;
}.play(args: [freq: ~freq]);

~slider = Slider()
.value_(0.2)
.action_({ |v|
	~freq = ~freqspec.map(v.value);
	~synth.set(\freq, ~freq);
});

~button = Button()
.states_([
	[ "OFF", Color.gray(0.2), Color.gray(0.8) ],
	[ "ON", Color.gray(0.8), Color.green(0.7) ]
])
.action_({ |btn| ~synth.set(\on, btn.value) });

Window("Frequency Control", Rect(500, 400, 100, 400))
.layout_(VLayout(~slider, ~button))
.onClose_({ ~synth.release(0.1) })
.front;
)



// Code Example 8.8

(
w = Window("Keyboard and Mouse Data").front
.layout_(VLayout(
	StaticText()
	.align_(\center)
	.string_("press keys/click the mouse")
));

w.view.keyDownAction_({ |view, char, mod, uni, keycode, key|
	postln("character:  " ++ char);
	postln("modifiders: " ++ mod);
	postln("unicode:    " ++ uni);
	postln("keycode:    " ++ keycode);
	postln("key:        " ++ key);
	"".postln;
});

w.view.mouseDownAction_({ |view, x, y, mod, button, count|
	postln("x-position:  " ++ x);
	postln("y-position:  " ++ y);
	postln("modifiers:   " ++ mod);
	postln("button ID:   " ++ button);
	postln("click count: " ++ count);
	"".postln;
});
)



// Code Example 8.9

(
MIDIIn.connectAll;

w = Window("MIDI Control").front
.layout_(VLayout(
	StaticText().align_(\center)
	.string_("press a key on your MIDI controller"),

	~numbox = NumberBox().align_(\center)
	.enabled_(false)
	.font_(Font("Arial", 40));
));

MIDIdef.noteOn(\recv, { |vel, num| { ~numbox.value_(num) }.defer });
)



// Code Example 8.10

(
~button = Button()
.states_([[ "Click Me", Color.white, Color(0.5, 0.5, 1) ]])
.action_({ |btn|
	btn.enabled_(false);
	Routine({
		var val = 1;
		while({ val > 0.5 }, {
			btn.states_([
				[
					"Cooling down...",
					Color.white,
					Color(val, val, 1)
				]
			]);
			val = val - 0.01;
			0.05.wait;
		}
		);
		btn.enabled_(true);
		btn.states_([
			[
				"Click Me",
				Color.white,
				Color(val, val, 1)
			]
		]);
	}).play(AppClock);
});
w = Window("Cooldown Button", Rect(100, 100, 300, 75)).front
.layout_(VLayout(~button));
)



// Code Example 8.11

(
u = UserView().background_(Color.gray(0.2))
.drawFunc_({
	Pen.width_(2) // set Pen characteristics
	.strokeColor_(Color(0.5, 0.9, 1))
	.addArc(100 @ 100, 50, 0, 2pi) // construct a circle
	.stroke; // render the circle (draw border, do not fill)

	Pen.fillColor_(Color(0.9, 1, 0.5)) // set Pen characteristics
	.addRect(Rect(230, 90, 120, 70)) // construct a rectangle
	.fill; // render the rectangle (fill, do not draw border)

	Pen.width_(6)
	.fillColor_(Color(0.2, 0.8, 0.2))
	.moveTo(90 @ 250) // construct a triangle, line-by-line
	.lineTo(210 @ 320).lineTo(90 @ 320).lineTo(90 @ 250)
	.fillStroke; // render the triangle (fill and draw border)

	Pen.width_(2)
	.strokeColor_(Color(1, 0.5, 0.2));
	8.do({
		Pen.line(280 @ 230, 300 @ 375);
		Pen.stroke;
		Pen.translate(10, -5); // 'translate' modifies what Pen perceives as its origin by a horizontal/vertical shift. You can imagine translation as shifting the paper underneath a pen.
	});
});
w = Window("Pen", Rect(100, 100, 450, 450))
.front.layout_(HLayout(u));
)



// Code Example 8.12

(
var win, uv, inc = 0;
win = Window("Tunnel Vision", Rect(100, 100, 400, 400)).front;

uv = UserView(win, win.view.bounds)
.background_(Color.black)
.drawFunc_({ |v|
	// draw transparency layer
	Pen.fillColor_(Color.gray(0, 0.05))
	.addRect(v.bounds)
	.fill;

	// green color gets brighter as arcs get "closer"
	Pen.width_(10)
	.strokeColor_(Color.green(inc.linlin(0, 320, 0.2, 1)))

	// draw random arc segments with increasing radii
	.addArc(
		200 @ 200,
		inc.lincurve(0, 320, 0, 320, 6),
		rrand(0, 2pi),
		rrand(pi/2, 2pi)
	).stroke;

	inc = (inc + 5) % 320;	// counter increases by 5 each frame
					// and resets to zero when it reaches 320
})
.clearOnRefresh_(false)
.frameRate_(30)
.animate_(true);
)