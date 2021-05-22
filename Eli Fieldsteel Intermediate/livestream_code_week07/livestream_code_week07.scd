s.options.memSize = 2.pow(20);
s.reboot;

b = Buffer.read(s, PathName(thisProcess.nowExecutingPath).parentPath ++ "/delay.aiff");

b.play;

(
//Select uses in index to select a signal from an array
SynthDef(\source, {
	var sig;
	sig = Select.ar(\choose.kr(0), [
		SoundIn.ar(0!2),
		PlayBuf.ar(1!2, b, loop:1),
	]);
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

(
SynthDef(\del, {
	var sig, del;
	sig = In.ar(\in.kr(0), 2);
	del = DelayN.ar(sig, 1, \del.kr(0.5));
	sig = sig.blend(del, \mix.kr(0.4));
	Out.ar(\out.kr(0), sig);
}).add;
)

~del = Synth(\del, [\in, ~fxBus], ~fxGrp);
~del.set(\del, 1);

//comb filters
(
SynthDef(\del, {
	var sig, del;
	sig = In.ar(\in.kr(0), 2);
	del = CombN.ar(sig, 1, \del.kr(0.5), \dec.kr(5));
	sig = sig.blend(del, \mix.kr(0.4));
	Out.ar(\out.kr(0), sig);
}).add;
)

~del = Synth(\del, [\in, ~fxBus], ~fxGrp);
~del.set(\del, 1/60);

//allpass filters
(
SynthDef(\del, {
	var sig, del;
	sig = In.ar(\in.kr(0), 2);
	del = AllpassN.ar(sig, 1, \del.kr(0.5), \dec.kr(5));
	sig = sig.blend(del, \mix.kr(0.4));
	Out.ar(\out.kr(0), sig);
}).add;
)

~del = Synth(\del, [\in, ~fxBus], ~fxGrp);
~del.set(\del, 1/50);

//dynamic comb filter delay

//comb filters
(
SynthDef(\del, {
	var sig, del;
	sig = In.ar(\in.kr(0), 2);
	del = CombL.ar(sig, 1, SinOsc.kr(0.1).exprange(0.01, 0.2), \dec.kr(4));
	sig = sig.blend(del, \mix.kr(0.4));
	Out.ar(\out.kr(0), sig);
}).add;
)

~del = Synth(\del, [\in, ~fxBus], ~fxGrp);

///////////////////////////////////////

//reverb effect
(
//schroeder-like reverb
SynthDef(\reverb, {
	var sig, wet, dec = \dec.kr(3);
	sig = In.ar(\in.ir(0), 2);
	wet = DelayN.ar(sig, 0.1, \predel.kr(0.03));
	wet = 6.collect({
		CombC.ar(wet, 0.1, LFNoise1.kr(0.02!2).exprange(0.02,0.1), dec);
	}).sum;
	6.do({
		wet = AllpassC.ar(wet, 0.02, LFNoise1.kr(0.02!2).exprange(0.01,0.02), dec)
	});
	wet = LPF.ar(wet, \lpf.kr(1500));
	sig = sig.blend(wet, \mix.kr(0.35)) * \amp.kr(0.85);
	Out.ar(\out.ir(0), sig);
}).add;
)

~reverb = Synth(\reverb, [\in, ~fxBus], ~fxGrp);
~reverb.free;
~reverb.set(\mix, 0.08);

////////////////////////////////////////

//delay-based realtime harmonizer

(
SynthDef(\delharm, {
	var sig, phs, del, env, rate, maxdel=0.05;
	rate = \n.kr(0).midiratio - 1 / maxdel;
	sig = In.ar(\in.ir(0), 2);
	phs = LFSaw.ar(rate.neg, [1,0]).range(0,maxdel);
	env = SinOsc.ar(rate, [3pi/2,pi/2]).range(0,1).sqrt;
	del = DelayC.ar(sig, maxdel, phs) * env;
	del = del.sum!2 * \amp.kr(0.85);
	Out.ar(\out.ir(0), del);
}).add;
)

~del = Synth(\delharm, [\in, ~fxBus], ~fxGrp);
~del.set(\n, 6);

(
~del = [
	Synth(\delharm, [\in, ~fxBus, \n, -3], ~fxGrp),
	Synth(\delharm, [\in, ~fxBus, \n, 2], ~fxGrp),
	Synth(\delharm, [\in, ~fxBus, \n, 5], ~fxGrp),
];
)

~src.set(\choose, 1);
~src.set(\choose, 0);

/////////////////////////////////////////

//extrapolating:
[-48, -15/16]
[-36, -7/8]
[-24, -3/4]
[-12, -1/2]
[0, 0]
[12, 1]
[24, 3]
[36, 7]
[48, 15]

(
SynthDef(\delharm, {
	var sig, phs, del, env, rate, maxdel=0.05;
	rate = \n.kr(0).midiratio - 1 / maxdel;
	sig = In.ar(\in.ir(0), 2);
	phs = LFSaw.ar(rate.neg, [1,0]).range(0,maxdel);
	env = SinOsc.ar(rate, [3pi/2,pi/2]).range(0,1).sqrt;
	del = DelayC.ar(sig, maxdel, phs) * env;
	del = del.sum!2 * \amp.kr(0.85);
	Out.ar(\out.ir(0), del);
}).add;
)

~del = Synth(\delharm, [\in, ~fxBus], ~fxGrp);
~del.set(\n, -7);

{LFSaw.ar(100, [1,0])}.plot(0.05);
{SinOsc.ar(100,[3pi/2,pi/2]).range(0,1).sqrt}.plot(0.05)

(
x = [
	Synth(\delharm, [\in, ~fxBus, \n, -5], ~fxGrp),
	Synth(\delharm, [\in, ~fxBus, \n, -2], ~fxGrp),
	Synth(\delharm, [\in, ~fxBus, \n, 4], ~fxGrp)
];
)

(
x = [
	Synth(\delharm, [\in, ~fxBus, \n, -2], ~fxGrp),
	Synth(\delharm, [\in, ~fxBus, \n, -4], ~fxGrp),
	Synth(\delharm, [\in, ~fxBus, \n, -6], ~fxGrp),
	Synth(\delharm, [\in, ~fxBus, \n, -8], ~fxGrp),
	Synth(\delharm, [\in, ~fxBus, \n, -10], ~fxGrp),
	Synth(\delharm, [\in, ~fxBus, \n, -12], ~fxGrp),
];
)

(
x = 8.collect({
	Synth(\delharm, [\in, ~fxBus, \n, rrand(-24.0, 24.0), \amp, 0.4], ~fxGrp)
});
)

~src.set(\choose, 1);
~del = Synth(\delharm, [\in, ~fxBus, \n, -4], ~fxGrp);
~del.set(\n, -36);
