Server.default = s = Server.local;
s.boot;

(
f = Platform.resourceDir +/+ "sounds/a11wlk01.wav";
b = Buffer.read(s, f);

SynthDef("playbuf", {|out = 0, bufnum=0, rate=1, trigger=1, startPos = 0, loop =1|
	Out.ar(out,
		Pan2.ar(PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum)*rate, trigger, BufFrames.ir(bufnum)*startPos, loop), 0.0)
		)
}).add;
)


Synth(\playbuf, [\out, 0, \bufnum, b.bufnum, \rate, 0.5]);

(
var w, rateslid, trigslid, startposslid, loopslid, a;

a=Synth(\playbuf, [\out, 0, \bufnum, b.bufnum]);

w=Window("PlayBuf Example",Rect(10,200,300,150));

w.front;

//control positioning of new GUI elements so I don't have to think too hard about it
w.view.decorator= FlowLayout(w.view.bounds);

//James' shortcut slider class
//250@24 means a Point of size 250 by 24
//|ez| is the same as arg ez;  - the EZSlider object is being passed into the callback action function
rateslid= EZSlider(w, 250@24, "Rate", ControlSpec(0.5, 10, 'exponential', 0.1), {|ez| a.set(\rate,ez.value)}, 1);

trigslid= EZSlider(w, 250@24, "Trigger", ControlSpec(0, 1, 'lin', 1), {|ez| a.set(\trigger,ez.value)}, 1);

startposslid= EZSlider(w, 250@24, "StartPos", ControlSpec(0.0, 1.0, 'lin', 0.01), {|ez| a.set(\startPos,ez.value)}, 0);

loopslid= EZSlider(w, 250@24, "Loop", ControlSpec(0, 1, 'lin', 0.1), {|ez| a.set(\loop,ez.value)}, 1);

w.onClose_({a.free;});
)

(
//this loads into a buffer the default sound that comes with SuperCollider
//.read brings in the whole sound at once
b = Buffer.read(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav");

//using Mouse to scrub through- X position is normalised position 0 to 1 phase through the source file
SynthDef("bufrd",{ arg out=0,bufnum=0;
	Out.ar(out,
		Pan2.ar(BufRd.ar(1, bufnum, K2A.ar(BufFrames.ir(b.bufnum)*MouseX.kr(0.0,1.0)).lag(MouseY.kr(0.0,1.0))),0.0)
	)
}).play(s);
)

Synth(\bufrd, [\out, 0, \bufnum, b.bufnum, \rate, 0.5]);



(
//Prepare to stream. You can use a big file for streaming: replace the filename here with one valid for your machine. Note that dragging and dropping a file into the SC text editor posts the full path of that file as text for you to use in your code.
b=Buffer.cueSoundFile(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav",0, 1);
)

SynthDef(\diskin,{Out.ar(0,DiskIn.ar(1, b.bufnum))}).play(s);