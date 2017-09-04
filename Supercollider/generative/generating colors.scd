(

var window = Window.new("", Rect(50,50, 800,800)).front;

window.drawFunc_({
	80.do({|i|
	80.do({|j|
			var disc = 255;
			var color= Color.new255(255.rand.round(disc), 255.rand.round(disc), 255.rand.round(disc));
			color.postln;

		   Pen.fillColor_(color);
	       Pen.fillRect(Rect(i * 10, j * 10, 10, 10));
			Pen.fillStroke;

		})
	})
})
)

