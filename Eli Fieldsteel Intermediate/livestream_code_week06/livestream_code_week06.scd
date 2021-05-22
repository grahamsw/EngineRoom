s.boot;

//USE HEADPHONES!! this lecture/code document includes a lot of live microphone sound

{CombN.ar(SoundIn.ar(0), 0.5, [0.5,0.47], 60) * SinOsc.kr(1, [pi/2,3pi/2]).range(-12,0).dbamp}.play;

s.defaultGroup.set(\gate, 0, \fadeTime, 10);

/////////////////////

s.meter;
s.plotTree;

(
//simple mic input SynthDef
SynthDef(\source, {
	var sig;
	sig = SoundIn.ar(0!2);
	sig = sig * \amp.kr(1);
	Out.ar(\out.kr(0), sig);
}).add;
)

(
//setup code for busses, synths, groups
~setup = {
	s.newBusAllocators;
	~fxBus = Bus.audio(s,2);
	s.bind({
		~sourceGrp = Group.new;
		~src = Synth(\source, [\out, ~fxBus], ~sourceGrp);
		~fxGrp = Group.after(~sourceGrp);
	});
};
ServerTree.removeAll;
ServerTree.add(~setup);
)

//press command period to initialize the node tree

(
//basic non-interpolating, non-feedback delay
SynthDef(\del, {
	var sig, del;
	sig = In.ar(\in.kr(0), 2);
	del = DelayN.ar(sig, 1, 1); //max delay time = 1, actual delay time = 1
	sig = sig.blend(del, 0.4);
	sig = sig * \amp.kr(1);
	Out.ar(\out.kr(0), sig);
}).add;
)

~del = Synth(\del, [\in, ~fxBus], ~fxGrp);
~del.free;

(
//extremely large max delay times (or numerous delay synths) will throw memory allocation failure messages
SynthDef(\del, {
	var sig, del;
	sig = In.ar(\in.kr(0), 2);
	del = DelayN.ar(sig, 100, 1);
	sig = sig.blend(del, 0.4);
	sig = sig * \amp.kr(1);
	Out.ar(\out.kr(0), sig);
}).add;
)

~del = Synth(\del, [\in, ~fxBus], ~fxGrp); //will probably fail
~del.free;

//increase memory size to allow larger/more delays
s.options.memSize = 2.pow(20);

//must be rebooted for changes to take effect
s.reboot;

48000 * 4 / 1000 * 2; //kB needed for 1-second stereo delay buffer
48000 * 4 / 1000 * 2 * 100; //kB needed for 100 second stereo delay buffer

(
SynthDef(\del, {
	var sig, del;
	sig = In.ar(\in.kr(0), 2);
	del = DelayN.ar(sig, 1, \del.kr(1));
	sig = sig.blend(del, 0.4);
	sig = sig * \amp.kr(1);
	Out.ar(\out.kr(0), sig);
}).add;
)

~del = Synth(\del, [\in, ~fxBus, \del, 0.25], ~fxGrp);
~del.set(\del, 0.05);
~del.set(\del, 0.5);
~del.set(\del, 1);
~del.set(\del, 1.5); //fails — delay buffer not big enough

2.pow(16)/s.sampleRate; //SC actually allocates a buffer with size = next highest power of 2

//works
~del = Synth(\del, [\in, ~fxBus, \del, 1.3652], ~fxGrp);

//doesn't
~del.set(\del, 1.3654);

(
SynthDef(\del, {
	var sig, del;
	sig = In.ar(\in.kr(0), 2);
	del = DelayN.ar(sig, 4, \del.kr(1));
	sig = sig.blend(del, \mix.kr(0.4));
	sig = sig * \amp.kr(1);
	Out.ar(\out.kr(0), sig);
}).add;
)

(
//delay cluster
s.bind({

	//20 fully "wet" delay effects
	~del = 20.collect({
		arg n;
		Synth(\del, [
			\in, ~fxBus,
			\mix, 1,
			\amp, n.linlin(0,19,-3,-30).dbamp,
			\del, n.lincurve(0,19,0.02,2,2) //experiment with delay times and delay amplitudes
		], ~fxGrp
		);
	});

	//one fully "dry" (bypassed) delay effect
	~del = ~del.add(Synth(\del, [\in, ~fxBus, \mix, 0, \del, 0, \amp, 1], ~fxGrp));

});
)

(
//add L/R spatial control via Balance2
SynthDef(\del, {
	var sig, del;
	sig = In.ar(\in.kr(0), 2);
	del = DelayN.ar(sig, 4, \del.kr(1));
	sig = sig.blend(del, \mix.kr(0.4));
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0), \amp.kr(1));
	Out.ar(\out.kr(0), sig);
}).add;
)

(
//each delay panned randomly
s.bind({
	~del = 20.collect({
		arg n;
		Synth(\del, [
			\in, ~fxBus,
			\mix, 1,
			\amp, n.linlin(0,19,-3,-30).dbamp,
			\del, n.lincurve(0,19,0.02,2,2),
			\pan, rrand(-1.0,1.0),
		], ~fxGrp
		);
	});

	~del = ~del.add(Synth(\del, [\in, ~fxBus, \mix, 0, \del, 0, \amp, 1], ~fxGrp));

});
)

//what if we modulate the delay time?

(
//it's bad to use non-interpolating delay ugens with a dynamic delay time
SynthDef(\del, {
	var sig, del;
	sig = In.ar(\in.kr(0), 2);

	//sinusoidally controlled delay
	del = DelayN.ar(sig, 1, SinOsc.kr(0.2).range(0.1,1));
	sig = sig.blend(del, \mix.kr(0.4));
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0), \amp.kr(1));
	Out.ar(\out.kr(0), sig);
}).add;
)

~del = Synth(\del, [\in, ~fxBus, \mix, 0.4], ~fxGrp);

//loading a buffer as alternate sound source
b = Buffer.read(s, "/Users/eli/Documents/Illinois/Teaching/AY 2020-2021/Spring 2021/MUS 499C/Livestream Code/livestream_code_week06/delay.aiff");

b.play;
b.numChannels;
b.duration;
s.sampleRate;

(
//Select uses in index to select a signal from an array
SynthDef(\source, {
	var sig;
	sig = Select.ar(\choose.kr(1), [
		SoundIn.ar(0!2),
		PlayBuf.ar(1!2, b, loop:1),
	]);
	sig = sig * \amp.kr(1);
	Out.ar(\out.kr(0), sig);
}).add;
)

(
//linear-interpolating delay line avoids alias artifacts with dynamic delay times
SynthDef(\del, {
	var sig, del;
	sig = In.ar(\in.kr(0), 2);
	del = DelayL.ar(sig, 1, SinOsc.kr(0.2).range(0.1,1).poll);
	sig = sig.blend(del, \mix.kr(0.4));
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0), \amp.kr(1));
	Out.ar(\out.kr(0), sig);
}).add;
)

~del = Synth(\del, [\in, ~fxBus, \mix, 0.4], ~fxGrp);
~del.set(\mix, 1);
~del.free;

(
//flanger effect
SynthDef(\del, {
	var sig, del;
	sig = In.ar(\in.kr(0), 2);
	del = DelayL.ar(
		sig,
		1/10,
		SinOsc.kr(\delhz.kr(0.2)).range(\delmin.kr(1/1000), \delmax.kr(1/100)).poll;
	);
	sig = sig.blend(del, \mix.kr(0.4));
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0), \amp.kr(1));
	Out.ar(\out.kr(0), sig);
}).add;
)

~del = Synth(\del, [\in, ~fxBus, \mix, 0.4], ~fxGrp);

~del.set(\mix, 1); //listen to only delayed signal — imperceptible pitch shifts

//increase modulator frequency makes pitch shifts more extreme and faster
~del.set(\delhz, 5);

~del.free;

(
//more complex flanger effect — four summed modulated delays
SynthDef(\del, {
	var sig, del;
	sig = In.ar(\in.kr(0), 2);
	del = 4.collect({
		DelayL.ar(
			sig,
			1/10,
			SinOsc.kr(ExpRand(0.1,0.2), Rand(0, 2pi)).range(1/ExpRand(1000,2000), 1/ExpRand(20,100))
		);
	}).sum;
	sig = sig.blend(del, \mix.kr(0.4));
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0), \amp.kr(1));
	Out.ar(\out.kr(0), sig);
}).add;
)

~del = Synth(\del, [\in, ~fxBus, \mix, 0.4], ~fxGrp);
~src.set(\choose, 0); //back to mic signal
~del.free;

s.freeAll;