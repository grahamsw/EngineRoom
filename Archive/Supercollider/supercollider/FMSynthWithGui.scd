(
var w, carrfreqslider, modfreqslider, modindexslider, synth;
var conversion= 2pi/(s.sampleRate); //needed to avoid phase being adjusted too wildly

w=Window("phase modulation via modulation index", Rect(100, 400, 400, 300));
w.view.decorator = FlowLayout(w.view.bounds);

synth= {arg carrfreq=440, modfreq=1, modindex=0;
SinOsc.ar(carrfreq, ( (modfreq*modindex)*conversion*SinOsc.ar(modfreq)),0.25)
}.scope;

carrfreqslider= EZSlider(w, 300@50, "carrfreq", ControlSpec(20, 5000, 'exponential', 10, 440), {|ez|  synth.set(\carrfreq, ez.value)});
w.view.decorator.nextLine;

modfreqslider= EZSlider(w, 300@50, "modfreq", ControlSpec(1, 5000, 'exponential', 1, 1), {|ez|  synth.set(\modfreq, ez.value)});
w.view.decorator.nextLine;

//bigger range since adjusting phase directly and not frequency
modindexslider= EZSlider(w, 300@50, "modindex", ControlSpec(0.0, 100, 'linear', 0.01, 0.0), {|ez|  synth.set(\modindex, ez.value)});

w.onClose = {synth.free;};
w.front;
)


(
var w, carrfreqslider, modfreqslider, moddepthslider, synth;

w = Window("frequency modulation", Rect(100, 400, 400, 300));
w.view. decorator = FlowLayout(w.view.bounds);

synth = {
	| carrfreq = 440, modfreq = 1, moddepth = 0.01|
	SinOsc.ar(carrfreq + (moddepth*SinOsc.ar(modfreq)), 0, 0.25)}.scope;

carrfreqslider = EZSlider(w, 300@50, "carrfreq", ControlSpec(20, 5000, 'exponential', 10, 440), {|ez| synth.set(\carrfreq, ez.value)});
w.view.decorator.nextLine;

modfreqslider = EZSlider(w, 300@50, "modfreq", ControlSpec(1, 5000, 'exponential', 1, 1), {|ez| synth.set(\modfreq, ez.value)});
w.view.decorator.nextLine;

moddepthslider = EZSlider(w, 300@50, "moddepth", ControlSpec(0.01, 5000, 'exponential', 0.01, 0.01), {|ez| synth.set(\moddepth, ez.value)});
w.front;
)


(



var w, carrfreqslider, modfreqslider, modindexslider, synth;

~addSlider = {
	| parToSet = 'freq', label = "label", min = 0, max = 100, warp = 'exponential', default = nil, step = 0|
	var slider;
	//if (default == nil) {default = min};

	slider = EZSlider(w, 300@50, label, ControlSpec(min, max, warp, step, default) {|ez| synth.set(parToSet, ez.value);});
	w.view.decorator.nextLine;
	slider
};
w = Window("frequency modulation via modulation index" , Rect(100, 400, 400, 300));
w.view. decorator = FlowLayout(w.view.bounds);

synth = {
	| carrfreq = 440, modfreq = 1, modindex = 0|
	SinOsc.ar(carrfreq + (modindex*modfreq*SinOsc.ar(modfreq)), 0, 0.25)}.scope;

//carrfreqslider = addSlider(\carrfreq, "carrier freq", 10,440);

carrfreqslider = EZSlider(w, 300@50, "carrfreq", ControlSpec(20, 5000, 'exponential', 10, 440), {|ez| synth.set(\carrfreq, ez.value)});


modfreqslider = EZSlider(w, 300@50, "modfreq", ControlSpec(1, 5000, 'exponential', 1, 1), {|ez| synth.set(\modfreq, ez.value)});
w.view.decorator.nextLine;

modindexslider = EZSlider(w, 300@50, "modindex", ControlSpec(0.0, 10, 'linear', 0.01, 0.0), {|ez| synth.set(\modindex, ez.value)});
w.front;
)

(
{
var modfreq, modindex, conversion;

modfreq= MouseX.kr(1,1000, 'exponential');
modindex=MouseY.kr(0.0,100.0);
conversion= 2pi/(s.sampleRate);

//Phasor is a UGen which will loop around a given interval, in this case 0 to 2pi, taking us around the waveform of the sinusoid; note that all the action is in the phase input
//SinOsc.ar(0, Phasor.ar(0,440*conversion,0,2pi)+( (modfreq*modindex)*conversion*SinOsc.ar(modfreq)), 0.25)

//simpler alternative
	SinOsc.ar(440, ( (modfreq*modindex)*conversion*SinOsc.ar(modfreq)), 0.25)
}.scope
)
{Mix(Saw.ar([440,443,467],0.1))}.scope