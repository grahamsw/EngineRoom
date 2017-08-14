

(
SynthDef(\cm,
	{
		|f = 440, c = 1, m = 1, a = 100, amp = 0.5|
		Out.ar(0,
			SinOsc.ar(
				f
				+
				SinOsc.ar(
					freq: f * m / c,
					mul: a),
				mul:amp)
		)
}).add;
)

(
var cmSynth = Synth(\cm);

var freq = 2000;
var num = 30;
var w = Window("CM player", Rect(100, 100, 220, 420)).onClose_({cmSynth.free}).front;
var s1 = Array.fill(4, {|i| Slider(w, Rect(i * 50 + 10, 10, 50, 350))});
var nb = Array.fill(4, {|i| NumberBox(w, Rect(i * 50 + 10, 360, 40, 20))});
["freq C", "C", "M", "amp M"].do{|i, j|
	StaticText(w, Rect(j * 50 + 10, 390, 40, 20)).string_(i).align_(\center);};


s1[0].action = {
	|s1|
	var val = s1.value * freq;
	cmSynth.set("f", val);
	nb[0].value = val;
};

nb[0].action = {
	|nb|
	var val = nb.value;
	cmSynth.set("f", val);
	s1[0].value = val;
};

s1[1].action = {
	|s1|
	var val = (s1.value * (num - 1)).asInteger + 1;
	cmSynth.set("c", val);
	nb[1].value = val;
};

nb[1].action = {
	|nb|
	var val = nb.value.asInteger;
	cmSynth.set("c", val);
	s1[1].value = val/num;
};

s1[2].action = {
	|s1|
	var val = (s1.value * (num-1)).asInteger + 1;
	cmSynth.set("m", val);
	nb[2].value = val;
};

nb[2].action = {
	|nb|
	var val = nb.value.asInteger;
	cmSynth.set("m", val);
	s1[2].value = val/num;
};

s1[3].action = {
	|s1|
	var val = s1.value * 10000;
	cmSynth.set("a", val);
	nb[3].value = val;
};

nb[3].action = {
	|nb|
	var val = nb.value;
	cmSynth.set("a", val);
	s1[3].value = val/1000;
};


)


	