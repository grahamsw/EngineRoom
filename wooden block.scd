s.boot;

(
SynthDef(\woodBlock, {|freq = 220, amp = 0.1, sustain = 1, bright = 1, pan = 0, out=0|
	var partials = [1, 2.572, 4.644, 6.984, 9.723, 12];
	var sig = Array.fill(6, {|i|
		var i_sig = SinOsc.ar(partials[i]*freq, rrand(0,2pi), (1+(bright*((i/5)-1)))/(i**2.5+1));
		var i_env = EnvGen.kr(Env.perc(0.06/(i+1), sustain/(i+1), amp/2), doneAction: (i==0).asInt * 2);
		i_sig*i_env}).sum;
	Out.ar(out, Pan2.ar(sig, pan));
}).add

)
(
Pdef(\chimes,
	Pbind(
		\instrument, \woodBlock,
		\amp, 0.5,
		\dur, 1.5,
		\midinote, Prand([50], inf),
		\sustain, 3,
		\bright, 2
	)
).play
)

Pdef(\chimes).stop



(
var root = 110;

var height = 300;
var width = 400;
var pitchDictionary = (left: 1, top: 2.572, right: 2.072, bottom: 4.644);  //Based on partials of synth
var energy = (left: 0, top: 0, right: 0, bottom: 0);

var position = Point.new(width/2, height/2);
var velocity = Point.new(rrand(-1.0,1.0),rrand(-1.0,1.0));

var strokeColor = Color.rand;

var w = Window("WindChime", Rect(100, 100, width+240, height+60), false).front;
var u = UserView(w, w.view.bounds.insetBy(120,30));

~elasticity = 0.85;
~dissipation = 0.995;
~speed = 30;

w.background_(Color.white);
u.background_(Color.green(0.9, 0.05));
u.drawFunc = {
	Pen.alpha = 0.5;
	Pen.width = 20;
	Pen.strokeColor = Color.red;

	//Left wall
	if(position.x <= 0, {
		position.x = 1;
		Synth(\woodBlock, [
			\freq, pitchDictionary[\left]*root + (energy[\left]*rrand(-20, 20)),
			\amp, 2*velocity.x,
			\pan, rrand(-0.8,0.8),
			\bright, (position.y-(height/2)).abs / (height/2),
			\sustain, [1, 2, 4].choose]);
		velocity.x = -1 * velocity.x * ~elasticity;
		energy[\left] = energy[\left] + (velocity.x*(1 - ~elasticity));
		Pen.moveTo(0@0);
		Pen.lineTo(0@height);
		Pen.stroke;
	});

	//Right wall
	if(position.x >= width, {
		position.x = width-1;
		Synth(\woodBlock, [
			\freq, pitchDictionary[\right]*root + (energy[\right]*rrand(-40, 40)),
			\amp, velocity.x,
			\pan, rrand(-0.8,0.8),
			\bright, (position.y-(height/2)).abs / (height/2),
			\sustain, [1, 2, 4].choose]);
		velocity.x = -1 * velocity.x * ~elasticity;
		energy[\right] = energy[\right] - (velocity.x*(1 - ~elasticity));
		Pen.moveTo(width@0);
		Pen.lineTo(width@height);
		Pen.stroke;
    });

	//Bottom wall
	if(position.y <= 0, {
		position.y = 1;
		Synth(\woodBlock, [
			\freq, pitchDictionary[\bottom]*root + (energy[\bottom]*rrand(-80, 80)),
			\amp, velocity.y,
			\pan, rrand(-0.8,0.8),
			\bright, (position.x-(width/2)).abs / (width/2),
			\sustain, [0.5, 1, 4].choose]);
		velocity.y = -1 * velocity.y * ~elasticity;
		energy[\bottom] = energy[\bottom] + (velocity.y*(1 - ~elasticity));
		Pen.moveTo(0@0);
		Pen.lineTo(width@0);
		Pen.stroke;
	});

	//Top wall
	if(position.y >= height, {
		position.y = height-1;
		Synth(\woodBlock, [
			\freq, pitchDictionary[\top]*root + (energy[\top]*rrand(-40, 40)),
			\amp, velocity.y,
			\pan, rrand(-0.8,0.8),
			\bright, (position.x-(width/2)).abs / (width/2),
			\sustain, [0.5, 1, 4].choose]);
		velocity.y = -1 * velocity.y * ~elasticity;
		energy[\top] = energy[\top] - (velocity.y*(1 - ~elasticity));
		Pen.moveTo(0@height);
		Pen.lineTo(width@height);
		Pen.stroke;
	});

	//Draw ball
	position.x = position.x + (velocity.x * ~speed);
	position.y = position.y + (velocity.y * ~speed);
	Pen.fillColor = strokeColor;
	Pen.fillOval(Rect.aboutPoint(position, 20, 20));

	//Draw walls with color value mapped to energy
	Pen.width=20;
	Pen.strokeColor = Color.red(alpha: energy[\left].explin(0.001,1,0,1));
	Pen.moveTo(0@0);
	Pen.lineTo(0@height);
	Pen.stroke;
	Pen.strokeColor = Color.red(alpha: energy[\right].explin(0.001,1,0,1));
	Pen.moveTo(width@0);
	Pen.lineTo(width@height);
	Pen.stroke;
	Pen.strokeColor = Color.red(alpha: energy[\top].explin(0.001,1,0,1));
	Pen.moveTo(0@height);
	Pen.lineTo(width@height);
	Pen.stroke;
	Pen.strokeColor = Color.red(alpha: energy[\bottom].explin(0.001,1,0,1));
	Pen.moveTo(0@0);
	Pen.lineTo(width@0);
	Pen.stroke;

	//Dissipate energies
	energy.keysValuesChange({|key, value| value * ~dissipation});
};
u.animate=true;

r=Routine({
	inf.do({
		[12,16].choose.wait;
		if(velocity.rho < 0.5, {
			velocity = velocity*rrand(5.0,8.0);
			strokeColor = Color.rand});

	});
});
r.play;

)