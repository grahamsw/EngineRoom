(
// SynthDefs
SynthDef(\luce, { | out = 0, freq = 110, amp = 0, mini_param = 24 |
	var snd = Resonz.ar( Saw.ar(freq*2), mini_param, 0.2 );
	Out.ar(out, Pan2.ar(snd, 0, amp));}).add;

SynthDef(\bougie, { | out = 0, freq = 110, amp = 0, mini_param = 440 |
	var snd = Blip.ar(freq!2, mini_param, 0.5) * amp;
	Out.ar( out, snd );}).add;

SynthDef(\invasion, { | out = 0, freq = 110, amp = 0, mini_param = 100 |
	var snd = RLPF.ar( Pulse.ar( [freq,freq*2], 0.5, amp * 0.5 ), mini_param, 0.05, amp * 0.5 );
	Out.ar( out, snd );}).add;

SynthDef(\windy, { | out = 0, freq = 110, amp = 0, mini_param = 24 |
	var snd = BPF.ar(WhiteNoise.ar, freq*mini_param, 0.4, 0.4);
	Out.ar(out, Pan2.ar(snd, 0, amp));}).add;

SynthDef(\pulser, { | out = 0, freq = 110, amp = 0, mini_param = 40 |
	var snd = RLPF.ar( Saw.ar(freq), mini_param, 0.5, 0.2);
	Out.ar(out, Pan2.ar(snd, 0, amp));}).add;

SynthDef(\poussiere, { | out = 0, freq = 110, amp = 0, mini_param = 0.5 |
	var snd = Dust2.ar(mini_param, 1);
	Out.ar(out, Pan2.ar( snd, 0, amp ) );}).add;

SynthDef(\lowvibe, { | out = 0, freq = 110, amp = 0, mini_param = 24 |
	var snd = SinOsc.ar(freq, 0, mini_param).fold2(1) * 0.2;
	Out.ar( out, Pan2.ar( snd, 0, amp * 0.75 ) );}).add;

SynthDef(\lizard, { | out = 0, freq = 110, amp = 0, mini_param = 100 |
	var snd = SyncSaw.ar(freq, mini_param, 0.2);
	Out.ar( out, Pan2.ar( snd, 0, amp * 0.5 ) );}).add;

)

d = Synth(\lowvibe)

d.set(\amp, 0.5)
d.set(\mini_param, 10)

e = Synth(\lizard, [\amp, 0.5])

e.set(\amp, 0.5, \freq, 200, \mini_param, 10)


(
{
    var a;
    a = Line.ar(-2, 2, 0.01);
    a.fold2(-3, 3)
}.plot
)


{ FSinOsc.ar(1000).fold2(Line.kr(0,1,8)) }.scope;