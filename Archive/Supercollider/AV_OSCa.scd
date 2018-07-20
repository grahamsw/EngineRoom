(
SynthDef(\cntr, {
	|out = 0, dbGain = 0|
	Out.kr(out, LFNoise2.kr(0.5));
}).add;
)

(

~bus = Bus.control(s, 1);
x = Synth(\cntr, [\out, ~bus]);
y = {SinOsc.ar(In.kr(~bus).linlin(-1, 1, 48, 72).midicps, mul:0.2)}.play;


~bus.scope;



i = 0;
v = 0.0;
w = Window.new("Plotter", Rect(10, 10, 500,500)).front;
u = UserView(w, Rect(0,0, 500, 500)).background_(Color.white);

u.drawFunc_({
	i.postln;
	v.postln;
	Pen.fillColor = Color.red(0.5);
	Pen.addOval(Rect((i%500), v.linlin(-1.0, 1.0, 0, 500.0), 2,2));
	//Pen.addOval(Rect(50, 50, 100, 200));
	Pen.fill;
});
u.clearOnRefresh_(false);

r = {
	inf.do{
		~bus.get({
			|amp|
			v = amp;
			i = i + 1;
		//	i.postln;
			{u.refresh}.defer;
		});
		0.05.wait;
	}
}.fork;
)



(

~ampBus = Bus.control(Server.local);
~audio = Bus.audio(Server.local);
~ampBus.scope;
~audio.scope;
a = {
	var sig = In.ar(~audio);
	var amp = Lag.kr(Amplitude.kr(sig));
	Out.kr(~ampBus, amp);
}.play;

~update  = 0.1;
~dim = 50;
~hue = 0; ~sat = 0.7; ~val = 0.7;

w = Window("tester", Rect(10, 10, 500, 500))
.background_(Color(1,1,1,1)).front;

w.drawFunc = {
	var oo = 250 - (~dim*0.5);
	//oo.postln;
	//~dim.postln;
	Pen.addOval(Rect(oo,oo,~dim, ~dim));
	Pen.color_(Color.hsv(~hue, ~sat, ~val));
	Pen.fill;
};


{
	inf.do {
		~ampBus.get ({ |amp|
			~dim = amp.ampdb.linlin(-60, 0, 10, 500);
			~hue = amp.ampdb.linlin(-60, 0, 0.4, 0);
			~sat = amp.ampdb.linlin(-60, 0, 0.8, 1);
			~val = amp.ampdb.linlin(-60, 0, 0.8, 1);
			{w.refresh}.defer;
		});
		~update.wait;
	}
}.fork;
)



(

x = {
	var sig = SinOsc.ar(mul: MouseY.kr(0.1));
	Out.ar(~audio, sig);
}.play;

x.free;

~buf = Buffer.read(Server.local, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

~update = 0.025;

x = {
	var sig = PlayBuf.ar(1, ~buf, loop:1);
	Out.ar([0, ~audio], sig);
}.play;
)