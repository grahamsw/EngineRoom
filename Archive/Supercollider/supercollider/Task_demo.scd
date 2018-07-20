(
t = Task({
	loop({
		3.do({
			x.release(0.1);
			x = Synth(\default, [freq:76.midicps]);
			0.5.wait;
			x.release(0.1);
			x = Synth(\default, [freq:73.midicps]);
			0.5.wait;
		});
		"waiting for press".postln;
		nil.yield;
		x.release(0.1);
		x = Synth(\default, [freq:69.midicps]);
		1.wait;
		x.release;
	});
});

w = Window.new("Task Example", Rect(400, 400, 200, 30)).front;
w.view.decorator = FlowLayout(w.view.bounds);
Button.new(w, Rect(0,0, 100, 20)).states_([["Play/Resume", Color.black, Color.clear]]).action_({t.resume(0);});
Button.new(w, Rect(0,0, 40, 20)).states_([["Pause", Color.black, Color.clear]]).action_({t.pause;});
Button.new(w, Rect(0,0, 40, 20)).states_([["Finish", Color.black, Color.clear]]).action_({
t.stop;
	x.release(0.1);
	w.close;
});

)