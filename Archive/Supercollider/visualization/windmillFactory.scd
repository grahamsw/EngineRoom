(


~windmillFactory = {
	arg position = 0@0, radius = 100, numberOfWings = 5, colors = [Color.red, Color.green];
	var step = if (numberOfWings.odd)
	{
		(2pi / numberOfWings) * (numberOfWings/2).floor;
	}{
		(2pi / numberOfWings) * ((numberOfWings/2) - 1);
	};
	var points = Array.fill(numberOfWings,
		{ |i|
			var x, y;
			x = position.x + (radius * cos(step * i));
			y = position.y + (radius * sin(step * i));
			x@y;
	});

	var windmill = (
		position: position,
		points: points,
		refresh: {|self, newPosition|
			self.position = newPosition;
			self.points = Array.fill(numberOfWings,
				{ |i|
					x = newPosition.x + (radius * cos(step * i));
					y = newPosition.y + (radius * sin(step * i));
					x@y;
			});
		},
		draw: { |self|
			Pen.moveTo(self.points[0]);
			(numberOfWings).do({
				|i|
				var pointA, pointB, pointC;
				pointA = self.points[i];
				pointB = self.points.wrapAt(i + 1);
				pointC = self.points.wrapAt(i + 2);
				Pen.curveTo(pointB, pointC, pointA);
			});
			Pen.fillRadialGradient(self.position, self.position, 0, radius * 1.5, colors[0], colors[1]);
		}
	);
	windmill;
};
)