(
{
	var in = RunningSum.rms(SoundIn.ar([0, 1]).sum, 10),
	thresh = MouseX.kr(0, 2),
	trig = in > thresh;
	SendTrig.ar(trig, 0, in);
}.play;
)

OSCresponder(s.addr, "/tr", {
	| ... args |
	args.postln}
).add;