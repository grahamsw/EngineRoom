(
{
	var carrier, rate, trigger, modRatio, index, control, env;
	rate = 3;
	trigger = Impulse.kr(rate);
	control = LFNoise0.kr(rate);
	carrier = control.range(36, 84);
	modRatio = control.range(4, 6).round(0.125);
	index = control.range(1, 15).round(1);
	carrier = carrier.midicps;
	carrier.poll(trigger, "carrier");
	index.poll(trigger, "index");
	modRatio.poll(trigger, "modRatio");
	PMOsc.ar(carrier, carrier * modRatio, index);
}.play;
)


(
{
	var trigger, control, scale, offset;
	scale = MouseY.kr(10, 500);
	offset =  MouseX.kr(100, 600);
	trigger = Impulse.kr(10);
	control = SinOsc.ar(5).scope("control");
	control = control * scale + offset;
	control.poll(control, "control");
	SinOsc.ar(abs(control).poll).scope("audio");
}.play
)


(

a = SynthDef(\PMOsc_ex, {
	|left = 10, right = 10, indexLow = 4, indexHigh = 12|
	var pitch, timbre, trigger, env, index, out;
	trigger = Impulse.kr([left, right]);
	pitch = TRand.kr(36, 72, trigger).round(1);
	timbre = LFNoise0.kr(1/20, mul: 0.2, add: 2);
	env = Linen.kr(trigger, releaseTime: 1/[left, right]);
	index = env * indexHigh + indexLow;
	pitch = pitch.midicps;
	out = PMOsc.ar(pitch, pitch * timbre, index, mul:env);
	Out.ar(0, out);
	}
).play;
)

a.set("left", 4);
a.set("right", 5);
a.set("indexLow", 1)
a.set("indexHigh", 4)

(
{
	var freq, harms, amp, trigger;
	trigger = Impulse.kr(10);
	freq = LFNoise0.kr(1/2).exprange(150, 500).round(50).poll(trigger, "freq"); //MouseX.kr(50, 5000, -1).poll(trigger, "freq");
	harms = SinOsc.kr(1).range(1, 9).round(1).poll(trigger, "harms"); //MouseY.kr(1, 50).round(1).poll(trigger, "harms");
	Blip.ar(freq,harms, 0.5);
}.play
)
