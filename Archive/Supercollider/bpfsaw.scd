(
SynthDef(\bpfsaw, {
	|atk = 2, sus=0, rel=3, c1=1, c2=(-1), freq=500, detune=0.2, pan=0, cfhzmin=0.1, cfhzmax=0.3, cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, lsf=200, ldb=0, amp=1, out=0 |
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0], [atk, sus, rel], [c1, 0, c2]), doneAction:2);
	sig = Saw.ar(freq * {LFNoise1.kr(0.5, detune).midiratio}!2);
	sig = BPF.ar(
		sig,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(cfhzmin, cfhzmax)
		).exprange(cfmin, cfmax)}!2,
		{LFNoise1.kr(0.1).exprange(rqmin, rqmax)}!2
	);
	sig = BLowShelf.ar(sig, lsf, 0.5, ldb);
	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\bpfbuf, {
	|atk = 0, sus = 0, rel = 3, c1 = 1, c2 = (-1), buf=0, rate=1, spos=0, freq = 440, rq=1, bpfmix=0, pan=0, amp = 1, out=0|
	var sig, env;
	env = EnvGen.kr(Env([0, 1, 1, 0], [atk, sus, rel], [c1, 0, c2]), doneAction:2);
	sig = PlayBuf.ar(1, buf, rate * BufRateScale.ir(buf), startPos:spos);
	sig = XFade2.ar(sig, BPF.ar(sig, freq, rq, 1/rq.sqrt), bpfmix * 2 - 1);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

~buf = Buffer.read(s, "C:/Users/graha/Documents/dev/EngineRoom/sounds/shakers/Shakers/Shakers_StayOnBeat (8).wav");
(
20.do{
(
Synth(\bpfbuf,
	[
		\buf, ~buf,
	    \atk, 0.2,
		\sus, 1,
		\rel, 1,
		\c1, 0.04,
		\c2, 0.06,
		\bpfmix, 1,
		\freq, (Scale.lydian.degrees + 69).choose.midicps * [1,2].choose,
		\rq, 1/150,
		\rate, 0.4,
				\amp, exprand(2,4)


	]

);
		0.25.wait;
)}

)
thisProcess.nowExecutingPath
(
10.do{
	Synth(
		\bpfsaw,
		[
			\freq, 100,
			\amp, 0.2,
			\sus, 4,
			\detune, 1,
			\cfmin, 50 * 1,
			\cfmax, 50 * 50,
			\rqmin, 0.185,
			\rqmax, 0.1953
		]
	);
};
)
(
~pn = PathName("C:/Users/graha/Documents/dev/EngineRoom");
~pn.entries.do {
	|entry|
	if(entry.isFolder, {entry.folderName.asSymbol.postln});
}
)