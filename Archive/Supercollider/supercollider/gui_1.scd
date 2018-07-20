
(
SynthDef(\filterme,{arg freq=1000, rq=0.5;    //make sure there are control arguments to affect!
	Out.ar(0,Pan2.ar(
		BPF.ar(Impulse.ar(LFNoise0.kr(15,500,1000),0.1, WhiteNoise.ar(2)),freq,rq)
	))
}).add;
)

(
var w, slid2d, syn;

w=Window("My Window", Rect(100,300,200,200));
slid2d= Slider2D(w,Rect(5,5,175,175));

syn=Synth(\filterme);	//create synth

slid2d.action_({
	[slid2d.x, slid2d.y].postln;
	syn.set(\freq,100+(10000*slid2d.y),\rq,0.01+(0.09*slid2d.x));  //I'm doing my own linear mapping here rather than use a ControlSpec
});

w.front;

w.onClose={syn.free;};	//action which stops running synth when the window close button is pressed
)


