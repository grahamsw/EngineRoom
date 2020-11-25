(
SynthDef(\pattern,
	{
		|out = 0, freq = 220, pan = 0, gate = 1 |
		var ctl = RLPF.ar(Saw.ar(5, 1.0, 2), 25, 0.3);
		var src = SinOsc.ar(ctl * freq) * 0.1;
		var env = EnvGen.kr(Env.adsr, gate, doneAction:2);
		Out.ar(out, Pan2.ar(src * env, pan));
	}
).add;
)

(

e = Pbind(
	\midinote, Pxrand(#[60,61,63, 65, 72], 20),
	\dur, 0.4,
	\pan, Pwhite(-1, 1, 20),
	\instrument, \pattern
)

)

a = Synth(\pattern, [\freq, 400])
e.play


(
b = Bus.control(s, 1);
{Out.kr(b, MouseX.kr(100,1000,1))}.play;
a.map(\freq, b)
)
(
c = Bus.control(s, 1);
{Out.kr(c, MouseY.kr(-1,1))}.play;
a.map(\pan, c)
)



(
SynthDef(\Task,
	{
		| out = 0, freq = 2000 |
		var env = EnvGen.kr(Env.perc, 1.0, 0.2, doneAction:2);
		var source = DynKlank.ar(`[[0.5, 0.8, 1, 1.2, 2,4]*freq, nil, nil], PinkNoise.ar(0.007));
		Out.ar(out, source * env ! 2);
}).add;
)

Synth(\Task);
(
t = Task({
	var freq;
	loop {
		freq = ((1 .. 10) * 220).choose;
		Synth(\Task, [\freq, freq]);
		0.3.wait;
	}
})

)

t.start




(
q = ProxySpace.push(s);

~ctl = {SinOsc.kr(1).range(330, 440)};
~out = { |freq = 220, amp = 0.5|	Ringz.ar(Dust.ar(2,0.4), freq, 0.8) ! 2};

~out.play;

~out.map(\freq, ~ctl);

~ctl = {SinOsc.kr(LFSaw.kr(5, add:2.0)*10) * 220 + 440};
m = ProxyMixer(p)
m.parent.alwaysOnTop_(true)

s.options.dump


(
SynthDef( \midi, {
	|out= 0, midinote = 60, dur = 0.1|
	var source = Blip.ar(midinote.midicps, 4, 0.2);
	var env = EnvGen.kr(Env.perc(0.1, dur), 1.0, doneAction:2);
	Out.ar(out, (source * env) ! 2);
}).add
)
MIDIClient.init;
MIDIIn.connectAll;

(
c = NoteOnResponder({|src, chan, num, vel|
	[num, vel].postln;
	Synth.new(\midi,[\midinote, num, \dur, vel/112]);
});
)

(
SynthDef(\gui, {
	|out = 0, freq = 8, decay = 0.1|

	var in = Formlet.ar(Impulse.ar(freq, 0, 0.4), 800, 0.01, decay);
	Out.ar(out, in ! 2);
}).add;
)

(
a = Synth.newPaused(\gui);
w = Window.new("GUI window", Rect(128, 64, 340, 250));
w.view.decorator = FlowLayout(w.view.bounds);

b= Button.new(w, Rect(50,50,75,24));
b.states = [["Start"], ["Stop"]];
b.action_({ arg butt;
	if(butt.value == 1, {a.run}, {a.run(false)});
});

c = Slider2D.new(w, Rect(50,120, 330, 200));
c.x_(0.5).y_(0.5).action_({|sl|
	a.setn(\freq, [sl.x * 10 + 3, sl.y / 5 + 0.01]);
});
w.front;
)