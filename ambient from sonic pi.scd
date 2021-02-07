/*


use_synth :hollow
with_fx :reverb, mix: 0.7 do

  live_loop :note1 do
    play choose([:D4,:Fs4]), attack: 6, release: 6
    sleep 8
  end

  live_loop :note2 do
    play choose([:Fs4,:G4]), attack: 4, release: 5
    sleep 10
  end

  live_loop :note3 do
    play choose([:A4, :Cs5]), attack: 5, release: 5
    sleep 11
  end

end

*/

(
~notes =  Dictionary.newFrom(List[\d4, 62, \fs4, 66, \g4, 67, \a4, 69, \cs5, 73]);

SynthDef(\hollow, {
	| out = 0, freq = 440, attack = 6, release = 6, amp = 0.1|
	var sig = SinOsc.ar(freq, mul: amp) + WhiteNoise.ar(amp);
	var env = EnvGen.kr(Env([0,1,0], [attack, release]), doneAction:2);
	sig = BBandPass.ar(sig, freq, 0.1);
	Out.ar(out, sig * env);
}).add;

SynthDef(\reverb, {
	|out = 0, in, mix = 0.9, room = 0.5, damp = 0.5|
	Out.ar(out, FreeVerb.ar(In.ar(in), mix, room, damp));
}).add;

~loop = {
	| note1, note2, attack, release, sleep |
	{
	inf.do({
			var note = [note1, note2].choose.midicps;
		Synth(\hollow, [\out, ~rev, \freq, note, \attack, attack, \release, release]);
		sleep.wait;
	});
}
};
)
(
~rev = Bus.audio(s, 1);


r = Synth(\reverb, [\in, ~rev]);

r.set(\room, 0.2);
r.set(\mix, 0.6);
r.set(\damp, 0.1);

a = ~loop.(~notes[\d4], ~notes[\fs4], 6, 6, 8);
b = ~loop.(~notes[\fs4], ~notes[\g4], 4, 5, 10);
c = ~loop.(~notes[\a4], ~notes[\cs5], 5, 3, 11);
[a, b, c].do{|i| i.fork};
)


(
~pat = (
	| note1, note2, attack, release, sleep |
	Pdef(
		\instrument, \hollow,
		\note
	inf.do({
			var note = [note1, note2].choose.midicps;
		Synth(\hollow, [\freq, note, \attack, attack, \release, release]);
		sleep.wait;
	});
}
};
){ |note11