
(
p = ProxySpace.push;
~x = {SinOsc.kr(0.4) };
~y = {SinOsc.kr(0.3)};
~z = {SinOsc.ar(~x * ~y  % 0.4 * 500 + 600) * 0.2 };
~z.play;
~x = {SinOsc.kr(0.4)};
~y = {SinOsc.kr(1.3)};

p.clear(2).pop


{LFNoise0.ar(1000) * 0.5}.scope



({100.rand}!10).plot

{Blip.ar(40, LFNoise0.kr(7).exprange(4, 30), 0.3)}.play

{LFNoise0.kr(5).range(2,26)}.plot(10)

SynthDef(\pm, {
	| freq=400, mod=500, ix=7|
	Out.ar(0, PMOsc.ar(freq, mod, ix, 0, 0.5));
}).add

p = Synth(\pm)
p.set(\mod, 415)

(
var w, slid, slid2;

w=Window("My Window", Rect(100,500,200,200));
//A 200 by 100 window appears at screen co-ordinates (100, 500)

slid=Slider(w,Rect(10,10,180,40)); //a basic slider object of size 180 by 40 appears 10 pixels in from the left, and 10 pixels down from the top

slid.action_({
	p.set(\mod, (1 + slid.value) * 300);
}); //this is the callback: the function is called whenever you move the slider. action_ means to set up the slider object to use the function passed in as its argument.

slid2=Slider(w,Rect(10,60,180,40)); //a basic slider object of size 180 by 40 appears 10 pixels in from the left, and 10 pixels down from the top

slid2.action_({
	p.set(\ix, (10 * slid2.value).round(1));
}); //this is the callback: the function is called whenever you move the slider. action_ means to set up the slider object to use the function passed in as its argument.

w.front;
)

{PMOsc.ar(440, Line.ar(400, 500, 20), 7, mul:0.5)}.freqScope


{TRand.kr(100, 1000,Impulse.kr(XLine.kr(1,200, 10)))}.plot(10)

(
{
	var r;
	r = Line.kr(1, 20, 60).plot;
	Blip.ar(
	TRand.kr(100, 1000, Impulse.kr(r)),
		TRand.kr(1, 10, Impulse.kr(r)),
		Linen.kr(Impulse.kr(r),
			0, 0.5, 1/r)
)}.play;
)
{Linen.kr(Impulse.kr(Line.kr(1, 20, 6)),0, 0.5, 1/Line.kr(1, 20, 6))}.plot(7)