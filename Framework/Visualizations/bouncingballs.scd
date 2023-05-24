(
~generate_ball = { |params|
	var ball = (\x: params[\width].rand, \y: params[\height].rand, \xdir: [-1,1].choose , \ydir: [-1,1].choose, \xspeed: params[\ballspeed], \yspeed: params[\ballspeed], \size: 20);
	ball;
};

~generate_balls = { |numballs,params|
	~balls = List();
	numballs.do {|n|
		~balls.add(~generate_ball.(params));
	};
	~balls.postln;
}
)
(
~params = (\width:1800, \height: 1200, \ballspeed: 10);

~generate_balls.(5,~params);
~balls.postln;
w = Window("users", Rect(100, 200, ~params[\width], ~params[\height]));
u = UserView(w, Rect(0, 0, ~params[\width], ~params[\height]));
u.background = Color.black;
u.animate = true;


u.drawFunc = {
	~balls.do { |ball|
		if ( ball[\x] < 0 or: {ball[\x] > ~params[\width]}, {ball[\xdir] = 0 - ball[\xdir]});
		if ( ball[\y] < 0 or: {ball[\y] > ~params[\height]}, {ball[\ydir] = 0 - ball[\ydir]});

		ball[\x] = ball[\x]+ (ball[\xdir] * ball[\xspeed]);
		ball[\y] = ball[\y]+ (ball[\ydir] * ball[\yspeed]);

		Pen.fillColor = Color.white;

		Pen.fillOval(Rect.aboutPoint(Point(ball[\x], ball[\y]), ball[\size], ball[\size]));

	}
};

/*
    Pen.fillColor = Color.red;
    Pen.fillOval(Rect(width/2, height/2, sin(u.frame*0.031)*width/2, sin(u.frame*0.044)*height/2));
    Pen.fillOval(Rect(width/2, height/2, sin(u.frame*0.052)*width/2, sin(u.frame*0.065)*height/2));
    Pen.fillOval(Rect(width/2, height/2, sin(u.frame*0.073)*width/2, sin(u.frame*0.086)*height/2));
*/

w.front;
)
(
~adjust_num_balls = { |num_balls|
	if (num_balls < ~balls.size, {
		(~balls.size - num_balls).do { |n| ~balls.pop;}
		},
	{ (num_balls - ~balls.size).do {|n| ~balls.add(~generate_ball.(~params))}}
	);
};
)
~adjust_num_balls.(7)

~balls.pop
~balls.size