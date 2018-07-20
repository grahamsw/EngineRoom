(
SynthDef(\mysound,{arg density=100, centrefreq=1000, rq=0.1, amp=0.1;
	var dust, filter;

	//Dust is a stochastic source of impulse clicks, density per second
	dust= Dust.ar(density);

	//the filtering is twofold; shaping the clicks via attack and decay smoothing in Decay2, and then a Band Pass Filter
	filter= BPF.ar(50*Decay2.ar(dust,0.01,0.05),centrefreq, rq);

	Out.ar(0,(filter*amp).dup(2))
}).add
)


(
var w, slid2d, knob, numberbox;
var sound;

//use that SynthDef!
sound= Synth(\mysound);

w= Window("mysound's window",Rect(100,300,300,200));

slid2d= Slider2D(w,Rect(10,10,180,180));

knob= Knob(w,Rect(210,10,80,80));

numberbox= NumberBox(w,Rect(210,110,80,80));

//slid2d.action = {stuff...} is the same as slid2d.action_({stuff...})
slid2d.action = {
	sound.set(\density,slid2d.x*100.0+1,\rq,slid2d.y*0.5+0.01);
};

knob.action={sound.set(\centrefreq,knob.value*2000+500)};

//to let any MIDI control message set the knob position, and trigger the corresponding action
/*
MIDIIn.control={arg src,chan,num,val;
	//defer avoids complaints from the system that the GUI is being updated outside of a safe thread; it pushes the code through to the AppClock (see week 6 of course)
	{knob.value= (val/127.0); knob.action.value;}.defer;
};
*/

numberbox.action={var temp;

temp= numberbox.value.max(0.0).min(1.0);
sound.set(\amp,temp);

numberbox.value = temp;
};

w.front;

w.onClose= {sound.free;};
)

