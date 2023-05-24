OSCdef.freeAll;

(
OSCdef.new(
	\getPush,
	{
		arg msg;
		msg.postln;
		if(msg[1] == 1)
		{x = Synth(\default)}
		{x.set(\gate, 0)};
	},
	'/1/push1'
);

OSCdef.new(
	\getFader,
	{
		arg msg;
		msg.postln;
		x.set(\amp, msg[1]);
	},
	'/1/fader1'
);
)

s.boot;

x = Synth(\default);

x.set(\gate, 0);

s.sendMsg('/s_new', "default", ~id = s.nextNodeID, 1, 0);

s.sendMsg('/n_free', ~id);

OSCdef.freeAll;

(
OSCdef.new(\self, {
	arg msg;
	msg.postln;
	if(msg[1].isNumber)
	{
		{
			var sig;
			sig = SinOsc.ar(msg[1].clip(20,20000), mul:0.1!2);
			sig = sig * Env.perc.kr(2);
		}.play;
	};
}, '/self');
)

~me = NetAddr.new("10.193.64.53", 57120); //or "127.0.0.1" which always refers to your own computer's IP address

~me.sendMsg('/self', exprand(300,3000));

OSCdef.freeAll;

(
SynthDef.new(\reply, {
	var sig, amp;
	amp = SinOsc.kr(0.25, 3pi/2).exprange(0.02, 0.3);
	SendReply.kr(Impulse.kr(30), '/noiseamp', amp);
	sig = PinkNoise.ar(amp)!2;
	Out.ar(0, sig);
}).add;

Window.closeAll;
w = Window.new.front;
w.alwaysOnTop_(true);
~sl = Slider(w, Rect(20,20,30,200));
)

Synth(\reply);

(
OSCdef.new(\noise, {
	arg msg;
	//msg.postln;
	{~sl.value_(msg[3])}.defer;
}, '/noiseamp').permanent_(true);
)

s.freeAll;

OSCdef.freeAll;

//UserView example

s.boot;

(
SynthDef(\trig, {
	arg trigfreq=2, min=150, max=5000;
	var trig, freq;
	trig = Dust.kr(trigfreq);
	freq = TExpRand.kr(min, max, trig);
	SendReply.kr(trig, '/blip', freq);
}).add;

SynthDef.new(\sine, {
	arg freq=440;
	var sig;
	sig = SinOsc.ar(freq + [0,2], mul:0.1);
	sig = sig * EnvGen.kr(Env.perc, doneAction:2);
	Out.ar(0, sig);
}).add;

OSCdef(\recv, {
	arg msg;
	var freq;
	freq = msg[3].postln;

	Synth(\sine, [\freq, freq]);

	{
		u.drawFunc_({
			Pen.fillColor_(Color.gray(0.2, 0.1));
			Pen.addRect(u.bounds);
			Pen.fill;
			Pen.width_(5);
			Pen.strokeColor_(Color.new(0.2, 0.9, freq.explin(150,5000,1,0)));
			Pen.addArc(
				rrand(0,400)@rrand(0,400),
				freq.expexp(150,5000,300,10),
				0,
				2pi
			);
			Pen.stroke;
		}).refresh;
	}.defer;

}, '/blip');

Window.closeAll;
w = Window.new.front;
w.alwaysOnTop_(true);
u = UserView(w, w.view.bounds)
.background_(Color.gray(0.1))
.clearOnRefresh_(false);
)

~synth = Synth(\trig);

~synth.set(\min, 400, \max, 600, \trigfreq, 10);

~synth.free;

s.quit;

Window.closeAll;