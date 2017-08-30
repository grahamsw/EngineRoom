(

SynthDef(\impl, {
	|in=0, out=0, dbGain=0|
	var sig = LFNoise0.ar(0.5);
	Out.ar(0, SinOsc.ar(sig.linlin(-1, 1, 48, 72).midicps, mul:0.2));
	SendReply.ar(Impulse.ar(10), '/amp', values:sig);
}).add;
)


(
x = Synth(\impl);

i = 0; v = 0.0;
w = Window.new("", Rect(10,10,500,500)).front;
u = UserView(w, Rect(0,0,500,500)).background_(Color.white(0.75));
u.drawFunc_{
	Pen.fillColor = Color.red(0.5);
	//i.postln;
	Pen.addOval(Rect(i%500, v.linlin(-1.0, 1.0, 0, 500), 2, 2));
	Pen.fill;
};

u.clearOnRefresh_(false);
o = OSCFunc({
	|msg|
	v = msg[3];
	i = i + 1;
	{u.refresh}.defer

}, '/amp');
)