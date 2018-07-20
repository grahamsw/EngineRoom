// Play it with a MIDI keyboard
(
SynthDef(\klng, {
	|freq = 90, amp = 1, gate = 1, out = 0|
	var harms = [2, 3.2, 4.9, 7.1,6,8,10.3, 20, 21];
	var freqs = harms * freq;
	var phs = harms.size.collect{2pi.rand};
	var amps = (harms.size - 2).collect{LFNoise1.kr({60.0.rand}.()).range(0, 0.1)} ++ 0.01 ++ 0.01;
	var rs = Ref([freqs, amps * amp, phs]);
	var env = Env.adsr(0.01, 0.1, 0.3, 2, amp).kr(2, gate);

	var sound = DynKlang.ar(rs) * env;

	Out.ar(out, sound );
}).add;
)


(
MIDIClient.init;
MIDIClient.sources.postln;
MIDIClient.sources[1].postln;

MIDIIn.connect(0,MIDIClient.sources[1])
)


(


 var noteArray = Array.newClear(128);

 MIDIdef.noteOn(\myKeyDown, {
	arg vel, note;
    noteArray[note] = Synth(\klng, [\freq, note.midicps/2, \amp, vel.linlin(0, 127, 0, 1)]);
    ["NOTE ON", note].postln;
 });

 MIDIdef.noteOff(\myKeyUp, {
	arg vel, note;
    noteArray[note].set(\gate, 0);
   ["NOTE OFF", note].postln;
 });
)
