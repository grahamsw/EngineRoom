~phone = NetAddr.new("192.168.1.8", 8000);
~phone.sendMsg("/1/faderA", 0);
~phone.sendMsg("/1/faderC", 0.5);



(
x = 0;
y = 0;




w = Window.new("", Rect(0,0,500,500)).front;
u =UserView(w, Rect(0,0, 500, 500)).background_(Color.grey(0.75));
u.drawFunc_({
	var width = x.linlin( 0.0, 1.0, 0.0, 250.0);
	var height = y.linlin(0.0, 1.0, 0.0, 250.0);

	Pen.fillColor = Color.red(0.5);
	Pen.addOval(Rect(250, 250, width,height));
	Pen.fill;
});

u.clearOnRefresh_(true);

o = OSCFunc({
	|msg|
	x = msg[1];
	x.postln;
	{u.refresh}.defer;
}, '/1/faderA');
p = OSCFunc({
	|msg|
	//msg.postln;
	y = msg[1];
	y.postln;
	{u.refresh}.defer;
}, '/1/faderB');
)
