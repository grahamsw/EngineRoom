



(
SynthDef(\RmOctaver, { |in|
	var in, an, freq;
	an = Pitch.kr(in).poll;
	freq = an[0];
	Out.ar(0, SinOsc.ar(freq: freq * 0.5) * in );
}).add;
)

(
b = Bus.audio(s, 1);
Out.ar(b, SoundIn.ar(0))
Synth.new(\RmOctaver, [\in, b])
)


s.freqscope;



