(
//spacebar to play/pause animation, esc to abort & close window

var transposition = -5; //semitones

var win, generalView, rampView, rampView2, bufferView, pointerView, randPtr = 25, ptrLags, ptrLags2,
count = 0, count2 = 0, countabs = 0, randAr, animating, speedratio;

speedratio = transposition.midiratio;
Window.closeAll;
animating = false;


//representation of random waveform filled into buffer
randAr = Pbrown(1,79,30,301).asStream.all;

win = Window.new("", Window.screenBounds, false, false).front;
win.view.background_(Color.gray(0.1));
win.view.keyDownAction_({
	arg view, char, mod, uni;

	if(uni == 27, {win.close});
	if(uni == 32, {
		if(
			animating,
			{
				bufferView.animate_(false);
				pointerView.animate_(false);
				rampView.animate_(false);
				rampView2.animate_(false);
			},
			{
				bufferView.animate_(true);
				pointerView.animate_(true);
				rampView.animate_(true);
				rampView2.animate_(true);
			}
		);
		animating = animating.not;
	});
});

StaticText(win, Rect(680,370,80,50))
.font_(Font(Font.defaultSansFace, 24))
.stringColor_(Color.gray(0.5))
.string_("buffer dur")
.align_(\center);

StaticText(win, Rect(310,185,80,50))
.font_(Font(Font.defaultSansFace, 24))
.stringColor_(Color.gray(0.5))
.string_("buffer dur")
.align_(\right);

StaticText(win, Rect(345,370,80,30))
.font_(Font(Font.defaultSansFace, 24))
.stringColor_(Color.gray(0.5))
.string_("0")
.align_(\center);

StaticText(win, Rect(1110,185,80,50))
.font_(Font(Font.defaultSansFace, 24))
.stringColor_(Color.gray(0.5))
.string_("buffer dur")
.align_(\right);

StaticText(win, Rect(1145,370,80,30))
.font_(Font(Font.defaultSansFace, 24))
.stringColor_(Color.gray(0.5))
.string_("0")
.align_(\center);

StaticText(win, Rect(1475,370,80,30))
.font_(Font(Font.defaultSansFace, 24))
.stringColor_(Color.gray(0.5))
.string_("???")
.align_(\center);

StaticText(win, Rect(1260,100,200,60))
.font_(Font(Font.defaultSansFace, 24))
.stringColor_(Color.gray(0.8))
.string_("delay time (sec)")
.align_(\center);

StaticText(win, Rect(440,100,240,60))
.font_(Font(Font.defaultSansFace, 24))
.stringColor_(Color.gray(0.8))
.string_("record pointer position\nin delay buffer")
.align_(\center);

StaticText(win, Rect(300,640,120,48))
.font_(Font(Font.defaultSansFace, 36))
.stringColor_(Color.gray(0.5))
.string_("0 sec")
.align_(\center);

StaticText(win, Rect(1400,610,320,75))
.font_(Font(Font.defaultSansFace, 36))
.stringColor_(Color.gray(0.5))
.string_("buffer dur\n= 1 sec")
.align_(\center);

//record pointer grid axes (background rectangle)
CompositeView.new(
	win,
	Rect(
		Window.screenBounds.width/2-552,
		205,
		307,
		152
	)
)
.background_(Color.gray(0.8));

//record pointer signal visualization
rampView = UserView.new(
	win,
	Rect(
		Window.screenBounds.width/2-550,
		200,
		305,
		155
	)
).background_(Color.gray(0.1));
rampView.clearOnRefresh_(true);
rampView.drawFunc_({

	//draws full ramp in gray
	Pen.strokeColor_(Color.gray(0.3,0.5));
	Pen.width_(6);
	Pen.line(0@155,300@5);
	Pen.stroke;

	//traces ramp in blue, driven by count
	Pen.width_(6);
	Pen.strokeColor_(Color.red(1,0.5));
	Pen.line(0@155,Point(count,155-(count/2)));
	Pen.stroke;
});



//play pointer grid axes (background rectangle)
CompositeView.new(
	win,
	Rect(
		Window.screenBounds.width/2+248,
		205,
		307,
		152
	)
)
.background_(Color.gray(0.8));

//record pointer signal visualization
rampView2 = UserView.new(
	win,
	Rect(
		Window.screenBounds.width/2+250,
		200,
		305,
		155
	)
).background_(Color.gray(0.1));
rampView2.clearOnRefresh_(true);
rampView2.drawFunc_({

	var countdiff;

	//draws full ramp in gray
	Pen.strokeColor_(Color.gray(0.3,0.5));
	Pen.width_(6);
	if(speedratio < 1, {Pen.line(0@155,300@5)});
	if(speedratio > 1, {Pen.line(0@5,300@155)});
	if(speedratio == 1, {Pen.strokeColor_(Color.green(0.7)); Pen.line(0@155,300@155)});
	Pen.stroke;

	//traces ramp in blue, driven by count
	Pen.width_(6);
	Pen.strokeColor_(Color.green(0.7,0.5));

	//if(speedratio < 1, {Pen.line(0@155,Point(count2,155-(count2/2)))});
	//if(speedratio > 1, {Pen.line(0@5,Point(count2,5+(count2/2)))});

	if(speedratio < 1, {countdiff = (count-count2)%300; Pen.line(0@155,Point(countdiff,155-(countdiff/2)))});
	if(speedratio > 1, {countdiff = (count2-count)%300; Pen.line(0@5,Point(countdiff,5+(countdiff/2)))});



	Pen.stroke;
});





StaticText(win, Rect(Window.screenBounds.width/2-100,620,200,48))
.font_(Font(Font.defaultSansFace, 48))
.stringColor_(Color.gray(0.8))
.string_("buffer")
.align_(\center);

//buffer outline (background rectangle)
CompositeView.new(
	win,
	Rect(
		Window.screenBounds.width/2-604,
		Window.screenBounds.height/2-44+200,
		1208,
		88
	)
).background_(Color.gray(0.8));

//buffer visualization
bufferView = UserView.new(
	win,
	Rect(
		Window.screenBounds.width/2-600,
		Window.screenBounds.height/2-40+200,
		1200,
		80
	)
).background_(Color.gray(0.2));
bufferView.clearOnRefresh_(false);


bufferView.drawFunc_({

	Pen.fillColor_(Color.gray(0.2));
	Pen.addRect(Rect(count * 4, 0, 4, 80));
	Pen.fill;
	Pen.strokeColor_(Color.new(0,0.75,1));
	Pen.width_(2);
	Pen.line(
		Point(count * 4,randAr.at(count)),
		Point((count+1) * 4,randAr.at(count+1))
	);
	Pen.stroke;
	count = count + 1;
	count2 = count2 + speedratio;
	countabs = countabs + 1;
	if(
		count >= 300,
		{
			Pen.strokeColor_(Color.gray(0.4));
			randAr.do({
				arg n,i;
				if(i < (randAr.size-1), {
					Pen.line(
						Point(i*4,randAr.at(i)),
						Point((i+1)*4,randAr.at(i+1))
					);
				});
			});
			Pen.stroke;
			randAr = Pbrown(1,79,30,301).asStream.all;
			count = 0;
		}
	);
	if(count2 >=300, {count2 = 0});
});

pointerView = UserView.new(
	win,
	Rect(
		Window.screenBounds.width/2-620,
		Window.screenBounds.height/2+45+200,
		1240,
		120
	)
).background_(Color.clear);

pointerView.clearOnRefresh_(true);

pointerView.drawFunc_({
	var posrec, posdel;

	posrec = count * 4 + 20;
	posdel = count2 * 4 + 20;

	Pen.strokeColor_(Color.red(1,0.5));
	Pen.fillColor_(Color.red(1, 0.5));
	Pen.width_(2);
	Pen.joinStyle_(1);
	Pen.line(
		Point(posrec,20),
		Point(posrec,100)
	);
	Pen.moveTo(Point(posrec-7, 32));
	Pen.lineTo(Point(posrec+7, 32));
	Pen.lineTo(Point(posrec, 20));
	Pen.lineTo(Point(posrec-7, 32));
	Pen.fillStroke;

	Pen.strokeColor_(Color.green(0.7,0.5));
	Pen.fillColor_(Color.green(0.7, 0.5));
	Pen.width_(2);
	Pen.joinStyle_(1);
	Pen.line(
		Point(posdel,20),
		Point(posdel,100)
	);
	Pen.moveTo(Point(posdel-7, 32));
	Pen.lineTo(Point(posdel+7, 32));
	Pen.lineTo(Point(posdel, 20));
	Pen.lineTo(Point(posdel-7, 32));
	Pen.fillStroke;


});

bufferView.frameRate_(60);
rampView.frameRate_(60);
rampView2.frameRate_(60);
pointerView.frameRate_(60);

if(
	animating,
	{
		bufferView.animate_(true);
		pointerView.animate_(true);
		rampView.animate_(true);
		rampView2.animate_(true);
	},
	{
		bufferView.animate_(false);
		pointerView.animate_(false);
		rampView.animate_(false);
		rampView2.animate_(false);
	}
);
)