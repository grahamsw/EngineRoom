

(
SynthDef(\rissetBell, {|freq = 400, dur = 10, amp = 0.7|


var amps = [1,0.67, 1, 1,8, 2.67, 1.67, 1.46, 1.33, 1.33, 1, 1.22].normalizeSum * amp;
var durs = [1,0.9, 0.65, 0.55, 0.325, 0.35, 0.25, 0.2, 0.15, 0.1, 0.075] * dur;
var freqs = [0.56, 0.56, 0.92, 0.92, 1.19, 1.7, 2, 2.74, 2, 2.76, 4.07] * freq + [0,1,0,1.7,0,0,0,0,0,0,0];




	var m = Mix.fill(durs.size, {|i|
		//[freqs[i], durs[i], amps[i]].postln;
		SinOsc.ar(freqs[i], 0, EnvGen.kr(Env.perc(releaseTime:durs[i], level:amps[i])))});
	DetectSilence.ar(m, doneAction:2);
	Out.ar(0, m)
}
).add;

)


Synth(\rissetBell)



(
SynthDef(\soprano, {


	| amp = 0.5, fm = 40, fc1 = 400, i1 = 30, i2= 1, fc2 = 800, a2= 0.2|

	var vib = SinOsc.ar(fm, mul: i1 * fm);

	var carrier1 = SinOsc.ar(fc1 + vib, mul: amp);
	var carrier2 = SinOsc.ar(fc2 + vib * i2/i1, mul: amp * a2);

		Out.ar(0, carrier1 + carrier2);

}).add;
)

a = Synth(\soprano);

a.set(\fc1, 1000);
a.set(\fc2, 2000);
a.set(\fm, 100);
a.set(\i1, 10);
a.set(\i2, 20);
a.set(\a2, 0.5);