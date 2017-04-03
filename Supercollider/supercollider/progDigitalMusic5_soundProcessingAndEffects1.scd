{SinOsc.ar([440, 450])}.play

{Pan2.ar(SinOsc.ar(440), [-1, 1])}.play

{Pan2.ar(SinOsc.ar(440!2), [-1, 1]).sum}.play

(
p= {|freqL=440, freqR=440, amp=1, dur=1|
	var pan, ampL, ampR, env, output;
	pan = SinOsc.ar(1/dur, 3pi/2);
	pan = (pan+1)/2;
	ampL = sqrt(1-pan);
	ampR = sqrt(pan);
	env = EnvGen.ar(Env([0,1,1,0], [0.01, dur-0.02, 0.01], \wel), doneAction:2);
	output = SinOsc.ar([freqL, freqR], mul:[ampL, ampR])*env;
}
)


({LinPan2.ar(SinOsc.ar, SinOsc.ar(1/4, 3pi/2))}).play;
p.play(args:[\freqR, 550, \dur, 4]);
// beauty
{Balance2.ar(SinOsc.ar, SinOsc.ar(550), SinOsc.ar(1/4, 3pi/2))}.play;

//crossfade
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

(
SynthDef(\xfademonolooper, {
	|bufnum=0, start=0, end =0, tpose=0, mode=1, fade=0.01|
	var dur, dir, srBuffer, rate, startPos, endPos, trig, trigs, envs, pointer, output;
	dur = abs(end-start)/(2**(tpose/12));
	dir = Select.kr(mode.sign<0, [1,-1]);
	srBuffer = BufSampleRate.ir(bufnum);
	rate = (srBuffer/SampleRate.ir)*(2**(tpose/12))*dir;
	startPos = Select.kr(dir.sign < 0, [start*srBuffer, end*srBuffer]);
	endPos = Select.kr(dir.sign<0, [end*srBuffer, start*srBuffer]);
	trig = Impulse.ar(1/dur);
	trigs = PulseDivider.ar(trig, 2, [0,1]);
	envs = EnvGen.ar(Env([0,1,1,0], [fade, dur-fade, fade], \sin), trigs);
	pointer = Phasor.ar(trigs, rate, startPos, endPos);
	output = Mix.ar((BufRd.ar(1, bufnum, pointer, 0, 4)*envs));
	Out.ar(0, output);
}).add;
)

y = Synth(\xfademonolooper, [\bufnum, b.bufnum, \start, 0, \end, 2, \tpose, 0, \mode, 1, \fade, 0.01]);
y.free; b.close; b.free;